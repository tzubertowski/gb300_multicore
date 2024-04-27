/* Copyright (C) 2023 Nikita Burnashev

Permission to use, copy, modify, and/or distribute this software
for any purpose with or without fee is hereby granted.

THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND! */

#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <stdint.h>
#include <stdbool.h>

#include <sys/types.h> // fixes inttypes.h for libretro

#include "libretro.h"
#include "file/config_file.h"

#include "debug.h" // GPIO LCD routines must remain there for BSOD compactness
#include "stockfw.h"
#include "video_sf2000.h"

// better with ge_gma_get_region_info in init TODO
#define MENU_WIDTH	640
#define MENU_HEIGHT	480

// please redefine if some core outputs wider or taller
#define MAX_WIDTH	MENU_WIDTH
#define MAX_HEIGHT	MENU_HEIGHT

// some are only used once, a temporary structure is more appropriate TODO
static enum {
	DISABLED,
	FAST,
	ROTATE // currently applicable ONLY to SF2000's screen FIXME
} tearing_fix = DISABLED;

static enum VPO_RGB_CLOCK rgb_clock = VPO_RGB_CLOCK_9M;
static unsigned h_total_len = 477, v_total_len = 326; // 9 MHz / 477 / 326 = 57.88 Hz

static enum {
	STOCK,
	CORE_PROVIDED,
	FULL_SCREEN,
	SQUARE_PIXELS,
	CUSTOM
} scaling_mode = CORE_PROVIDED;
static double g_ratio = 4.0 / 3.0;

static bool g_filtered = true;

static double g_ntsc_underscan = 0.94;

static void config_load(config_file_t *conf)
{
	const struct config_entry_list *e;

	if (!conf) return;

	e = config_get_entry(conf, "sf2000_tearing_fix");
	if (e) {
		if (strcasecmp(e->value, "disabled") == 0)
			tearing_fix = DISABLED;
		else if (strcasecmp(e->value, "fast") == 0)
			tearing_fix = FAST;
		else if (strcasecmp(e->value, "rotate") == 0)
			tearing_fix = ROTATE;
	}

	e = config_get_entry(conf, "sf2000_rgb_clock");
	if (e) {
		if (strcasecmp(e->value, "6.6 MHz") == 0)
			rgb_clock = VPO_RGB_CLOCK_6_6M;
		else if (strcasecmp(e->value, "9 MHz") == 0)
			rgb_clock = VPO_RGB_CLOCK_9M;
	}
	config_get_uint(conf, "sf2000_h_total_len", &h_total_len);
	config_get_uint(conf, "sf2000_v_total_len", &v_total_len);

	e = config_get_entry(conf, "sf2000_scaling_mode");
	if (e) {
		if (strcasecmp(e->value, "stock") == 0)
			scaling_mode = STOCK;
		else if (strcasecmp(e->value, "core-provided") == 0)
			scaling_mode = CORE_PROVIDED;
		else if (strcasecmp(e->value, "full screen") == 0)
			scaling_mode = FULL_SCREEN;
		else if (strcasecmp(e->value, "square pixels") == 0)
			scaling_mode = SQUARE_PIXELS;
		else if (strcasecmp(e->value, "custom") == 0)
			scaling_mode = CUSTOM;
	}
	e = config_get_entry(conf, "sf2000_scaling_custom");
	if (e) {
		if (strchr(e->value, ':') != NULL) {
			unsigned num = 1, denom = 1;

			sscanf(e->value, "%u : %u", &num, &denom);
			g_ratio = 1.0 * num / denom;
		}
		else g_ratio = strtod(e->value, NULL);
	}

	config_get_bool(conf, "sf2000_scaling_filtered", &g_filtered);
	config_get_double(conf, "sf2000_ntsc_underscan", &g_ntsc_underscan);
}

// all the scaling code assumes the screen to NOT be rotated
static void scale_to_ratio(enum tvsystem tvsys, struct osdrect *pr, uint16_t *ph_mul, uint16_t *pv_mul, double ratio)
{
	const unsigned screen_width = *ph_mul, screen_height = *pv_mul;
	unsigned scaled_width, scaled_height;
	scaled_width = round(screen_height * ratio * ((tvsys == NTSC) ? g_ntsc_underscan : 1));

	if (scaled_width < screen_width) {
		// center the unscaled osdrect
		pr->u_left = (screen_width - scaled_width) / 2 * pr->u_width / scaled_width;
		*ph_mul = scaled_width;
		if (tvsys == NTSC) {
			scaled_height = screen_height * g_ntsc_underscan;
			pr->u_top = (screen_height - scaled_height) / 2 * pr->u_height / scaled_height;
			pr->u_top++;
			*pv_mul = scaled_height;
		}
	}
	else { // scaled_height <= screen_height
		scaled_height = round(screen_width / ratio * ((tvsys == NTSC) ? g_ntsc_underscan : 1));
		pr->u_top = (screen_height - scaled_height) / 2 * pr->u_height / scaled_height;
		*pv_mul = scaled_height;
		if (tvsys == NTSC) {
			pr->u_top++;
			scaled_width = screen_width * g_ntsc_underscan;
			pr->u_left = (screen_width - scaled_width) / 2 * pr->u_width / scaled_width;
			*ph_mul = scaled_width;
		}
	}
}

static void scale_equally(enum tvsystem tvsys, struct osdrect *pr, uint16_t *ph_mul, uint16_t *pv_mul, bool filtered)
{
	const unsigned screen_width = *ph_mul, screen_height = *pv_mul;
	unsigned ratio, scaled_width, scaled_height;

	if (filtered) {
		scale_to_ratio(tvsys, pr, ph_mul, pv_mul, 1.0 * pr->u_width / pr->u_height);
		return;
	}
	// special case for unfiltered integer scaling
	if (screen_width * pr->u_height < screen_height * pr->u_width)
		ratio = screen_width / pr->u_width;
	else
		ratio = screen_height / pr->u_height;
	scaled_width = pr->u_width * ratio;
	scaled_height = pr->u_height * ratio;
	pr->u_left = (screen_width - scaled_width) / 2 * pr->u_width / scaled_width;
	pr->u_top = (screen_height - scaled_height) / 2 * pr->u_height / scaled_height;
	*ph_mul = scaled_width;
	*pv_mul = scaled_height;
}

static HANDLE m_osd_dev;

static void recreate_region(enum tvsystem tvsys, uint16_t width, uint16_t height)
{
	struct osdrect r = { 0, 0, width, height };
	struct osdpara para = { .e_mode = OSD_HD_RGB565 };
	struct osd_scale_param scale_param = {
		.tv_sys = tvsys, .h_div = width, .v_div = height
	};

	if (tvsys == RGB_LCD && tearing_fix == ROTATE) {
		r.u_width = height;
		r.u_height = width;
	}
	// magic numbers? CVBS output dimensions are defined by the driver, tho
	if (tvsys == RGB_LCD) {
		scale_param.h_mul = 320;
		scale_param.v_mul = 240;
	}
	else {
		scale_param.h_mul = 720;
		scale_param.v_mul = tvsys == NTSC ? 480 : 576;
	}
	if (r.u_width != MENU_WIDTH || r.u_height != MENU_HEIGHT) {
		if (scaling_mode == CORE_PROVIDED || scaling_mode == CUSTOM)
			scale_to_ratio(tvsys, &r, &scale_param.h_mul, &scale_param.v_mul, g_ratio);
		else if (scaling_mode == SQUARE_PIXELS)
			scale_equally(tvsys, &r, &scale_param.h_mul, &scale_param.v_mul, g_filtered);
	}
	if (tvsys == RGB_LCD && tearing_fix == ROTATE) {
		uint16_t tmp_swap = scale_param.h_mul;
		scale_param.h_mul = scale_param.v_mul;
		scale_param.v_mul = tmp_swap;

		tmp_swap = r.u_left;
		r.u_left = r.u_top;
		r.u_top = tmp_swap;
		r.u_width = width;
		r.u_height = height;
	}
#ifdef VIDEO_SF2000_DEBUG
	xlog("rect left %u top %u width %u height %u\n",
		r.u_left, r.u_top,
		r.u_width, r.u_height
	);
	xlog("scale h_div %u v_div %u h_mul %u v_mul %u\n",
		scale_param.h_div, scale_param.v_div,
		scale_param.h_mul, scale_param.v_mul
	);
#endif

	osddrv_close(m_osd_dev);
	osddrv_open(m_osd_dev, &para);
	dly_tsk(20); // wait at least one full frame

	osddrv_3x_create_region(m_osd_dev, 0, &r, &para);
	osddrv_scale(m_osd_dev, OSD_SET_SCALE_MODE,
		g_filtered ? OSD_SCALE_FILTER : OSD_SCALE_DUPLICATE
	);
	osddrv_scale(m_osd_dev, OSD_SCALE_WITH_PARAM, (uintptr_t)&scale_param);
}

static void region_write(const void *buf,
	uint16_t width, uint16_t height, uint16_t pixel_pitch)
{
	struct osd_vscr vscr = { 0, 0, pixel_pitch, height, buf };
	struct osdrect r = { 0, 0, width, height };

	vscr.b_color_mode = OSD_HD_RGB565;
	osddrv_3x_region_write(m_osd_dev, 0, &vscr, &r);
}

static HANDLE m_vpo_dev;

static enum tvsystem get_cur_tvsys(void)
{
	enum tvsystem tvsys;

	vpo_ioctl(m_vpo_dev, VPO_IO_GET_OUT_MODE, (uintptr_t)&tvsys);
	return tvsys;
}

static uint16_t cur_width = MENU_WIDTH, cur_height = MENU_HEIGHT, *rot_buf;

static void hooked_run_osd_region_write(const void *buf,
	uint16_t width, uint16_t height, uint16_t pixel_pitch)
{
	if (get_cur_tvsys() == RGB_LCD && tearing_fix == ROTATE) {
		const uint16_t *row = buf; // assume OSD_HD_RGB565 FIXME
		unsigned x, y;

		// different screens may also require different scan order FIXME
		for (y = height; y > 0; y--) {
			const uint16_t *src = row;
			uint16_t *dst = rot_buf + y - 1; // column
			for (x = width; x > 0; x--) {
				*dst = *src++;
				dst += height; // rot_buf pixel pitch
			}
			row += pixel_pitch;
		}
		buf = rot_buf;
		pixel_pitch = height; // swap width <-> height
		height = width;
		width = pixel_pitch; // in rot_buf only
	}
	if (cur_width != width || cur_height != height) {
		cur_width = width;
		cur_height = height;
		recreate_region(get_cur_tvsys(), width, height);
	}
	region_write(buf, width, height, pixel_pitch);
}

// patch rationale: joy_task switching to TV and back asynchronously
// (and annotating all of vp_init_info for 0x82 ioctl seems overkill)
static void patch__get_vp_init_low_lcd_para(uint16_t rgb_clock,
	uint16_t h_total_len, uint16_t v_total_len,
	uint16_t h_active_len, uint16_t v_active_len)
{
	uint16_t *pfn = (void *)&get_vp_init_low_lcd_para;

	os_disable_interrupt(); // avoid mode switch inbetween

	pfn[0x50 / sizeof pfn[0]] = rgb_clock;
	pfn[0x58 / sizeof pfn[0]] = v_total_len;
	pfn[0x60 / sizeof pfn[0]] = h_total_len;
	pfn[0x68 / sizeof pfn[0]] = v_active_len;
	pfn[0x70 / sizeof pfn[0]] = h_active_len; // used for lcd_width, too

	__builtin___clear_cache(pfn, &switch_lcd_or_tv);

	os_enable_interrupt();
}

#define MIPS_LI_A1 (9 << 26 | 5 << 16 | 0 << 21) // addiu a1, $0

static void patch__st7789v_caset_raset(uint16_t cols, uint16_t rows)
{
	uint32_t *pfn = (void *)&st7789v_caset_raset;

	os_disable_interrupt(); // patch rationale: called in a VSync GPIO ISR!

	pfn[0x44 / sizeof pfn[0]] = MIPS_LI_A1 | cols >> 8 & 255;
	pfn[0x50 / sizeof pfn[0]] = MIPS_LI_A1 | cols & 255;

	// this one was actually addu a1, $0, $0 hence the full instruction
	pfn[0x80 / sizeof pfn[0]] = MIPS_LI_A1 | rows >> 8 & 255;
	pfn[0x8c / sizeof pfn[0]] = MIPS_LI_A1 | rows & 255;

	__builtin___clear_cache(pfn, &st7789v_ramwr);

	os_enable_interrupt();
}

#define MIPS_J (2 << 26)

static void patch__run_screen_write(void *pregion_write)
{
	uint32_t *pfn = (void *)&run_screen_write;
	extern void run_sound_advance(void *, unsigned); // happens to be next fn

	os_disable_interrupt(); // avoid screen writes inbetween

	pfn[0xc0 / sizeof pfn[0]] = MIPS_J |
		(uint32_t)pregion_write >> 2 & ((1 << 26) - 1);

	__builtin___clear_cache(pfn, &run_sound_advance);

	os_enable_interrupt();
}

static void lcd_memory_data_access_ctl(uint8_t data)
{
	os_disable_interrupt(); // avoid the VSync GPIO ISR messing pinmux

	lcd_pinmux_gpio();

	lcd_send_cmd(0x36); // MADCTL
	lcd_send_data(data);

	os_enable_interrupt();
}

inline static void apply_rgb_timings(void)
{
	if (get_cur_tvsys() == RGB_LCD)
		switch_lcd_or_tv(1, RGB_LCD);
}

inline static void swap_region_width_height(void)
{
	if (get_cur_tvsys() == RGB_LCD)
		recreate_region(RGB_LCD, cur_height, cur_width);
}

void video_options(config_file_t *conf)
{
	struct retro_system_av_info info;

	config_load(conf);

	if (scaling_mode == CORE_PROVIDED) {
		retro_get_system_av_info(&info);
		if (info.geometry.aspect_ratio <= 0.1f)
			g_ratio = 1.0 * info.geometry.base_width / info.geometry.base_height;
		else
			g_ratio = info.geometry.aspect_ratio;
	}

	m_osd_dev = dev_get_by_id(HLD_DEV_TYPE_OSD, 0);
	m_vpo_dev = dev_get_by_id(HLD_DEV_TYPE_DIS, 0);

	if (tearing_fix == DISABLED) {
		patch__get_vp_init_low_lcd_para(VPO_RGB_CLOCK_6_6M,
			444, 304, 320, 240
		);
		apply_rgb_timings();
	}
	else if (tearing_fix == FAST) {
		patch__get_vp_init_low_lcd_para(rgb_clock,
			h_total_len, v_total_len, 320, 240
		);
		apply_rgb_timings();
	}
	else if (tearing_fix == ROTATE) {
		patch__get_vp_init_low_lcd_para(rgb_clock,
			v_total_len, h_total_len, 240, 320
		);
		apply_rgb_timings();

		patch__st7789v_caset_raset(240, 320);
		lcd_memory_data_access_ctl(0); // frame memory writes == scan order

		swap_region_width_height(); // also clears garbled "Loading..."

		rot_buf = malloc(MAX_WIDTH * MAX_HEIGHT * sizeof rot_buf[0]);
	}

	if (tearing_fix == ROTATE || scaling_mode != STOCK) {
		patch__run_screen_write(&hooked_run_osd_region_write);
	}
}

void video_cleanup(void)
{
	if (tearing_fix == ROTATE || scaling_mode != STOCK) {
		patch__run_screen_write(&run_osd_region_write);
	}

	if (tearing_fix != ROTATE) return; // that's all folks! fast patch stays
	tearing_fix = FAST; // ROTATE affects region's scaling

	patch__get_vp_init_low_lcd_para(rgb_clock,
		h_total_len, v_total_len, 320, 240
	);
	apply_rgb_timings();

	patch__st7789v_caset_raset(320, 240);
	lcd_memory_data_access_ctl(0x28); // 0x28 for gb300
	// fixable by parsing m_st7789v_init

	swap_region_width_height(); // second time thus cancels out

	free(rot_buf);
}
