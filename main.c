/* Copyright (C) 2023 Nikita Burnashev

Permission to use, copy, modify, and/or distribute this software
for any purpose with or without fee is hereby granted.

THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND! */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libretro.h"
#include "core_api.h"
#include "stockfw.h"
#include "debug.h"

static void init_once();
static void full_cache_flush();

static int state_stub(const char *path) {
	return 1;
}

#define MAXPATH 255
static char *corefile = NULL;
static char *romfile = NULL;
static char *tmpbuffer = NULL;

#define MIPS_J(pfunc)    (2 << 26) | (uint32_t)pfunc >> 2 & ((1 << 26) - 1)
#define MIPS_JAL(pfunc)  (3 << 26) | (uint32_t)pfunc >> 2 & ((1 << 26) - 1)

#define PATCH_J(target, hook)    *(uint32_t*)(target) = MIPS_J(hook)
#define PATCH_JAL(target, hook)  *(uint32_t*)(target) = MIPS_JAL(hook)

bool parse_filename(const char *file_path, const char**corename, const char **filename)
{
	char* s = strncpy(tmpbuffer, file_path, MAXPATH);
	*corename = s;

	char* p = strchr(s, ';');
	if (!p) return false;
	*(p++) = 0;

	char* pp = strrchr(s, '/');
	if (!pp) return false;
	*(pp++) = 0;

	*corename = pp;
	*filename = p;

	char* p2 = strrchr(p, '.');
	if (!p2) return false;
	*(p2) = 0;

	return true;
}

void load_and_run_core(const char *file_path, int load_state)
{
	init_once();

	xlog("l: run file=%s\n", file_path);

	// the expected template for file_path is - [corename];[rom filename].gba
	const char *corename;
	const char *filename;
	if (!parse_filename(file_path, &corename, &filename)) {
		xlog("file not MC stub: calling run_gba\n");
		dbg_show_noblock(0x00, "\n STOCK\n\n %s\n\n ", file_path); // black
		run_gba(file_path, load_state);
		return;
	}

	// this will show a loading screen when loading a rom.
	// it will act as an indicator that a custom core and not a stock emulator is running.
	dbg_show_noblock(0x7800,"\n MULTICORE\n\n %s\n\n %s \n\n ", corename, filename); // red

	void *core_load_addr = (void*)0x87000000;

	FILE *pf;
	size_t core_size;

	/* wait for the sound thread to exit, replicated in all run_... functions */
	g_snd_task_flags = g_snd_task_flags & 0xfffe;
	while (g_snd_task_flags != 0) {
		dly_tsk(1);
	}

	/* FIXME! all of it!! */
	RAMSIZE = 0x87000000;

	snprintf(corefile, MAXPATH, "/mnt/sda1/cores/%s/core_87000000", corename);
	snprintf(romfile, MAXPATH, "/mnt/sda1/ROMS/%s/%s", corename, filename);

	xlog("corefile=%s\n", corefile);
	xlog("romfile=%s\n", romfile);

	pf = fopen(corefile, "rb");
	if (!pf) {
		xlog("Error opening corefile\n");
		return;
	}

	fseeko(pf, 0, SEEK_END);
	core_size = ftell(pf);
	fseeko(pf, 0, SEEK_SET);
	fw_fread(core_load_addr, 1, core_size, pf);
	fclose(pf);

	xlog("l: core loaded\n");

	full_cache_flush();

	xlog("l: cache flushed\n");

	// address of the core entry function resides at the begining of the loaded core
	core_entry_t core_entry = core_load_addr;

	// the entry function clears core's .bss and return the core's exported api
	struct retro_core_t *core_api = core_entry();

	/* TODO */

	gfn_state_load = state_stub;
	gfn_state_save = state_stub;

	core_api->retro_set_video_refresh(retro_video_refresh_cb);
	core_api->retro_set_audio_sample_batch(retro_audio_sample_batch_cb);
	core_api->retro_set_input_poll(retro_input_poll_cb);
	core_api->retro_set_input_state(retro_input_state_cb);
	core_api->retro_set_environment(retro_environment_cb);

	xlog("l: retro_init\n");
	core_api->retro_init();

	g_retro_game_info.path = romfile;
	g_retro_game_info.data = gp_buf_64m;
	g_retro_game_info.size = g_run_file_size;

	gfn_retro_get_region	= core_api->retro_get_region;
	gfn_get_system_av_info	= core_api->retro_get_system_av_info;
	gfn_retro_load_game		= core_api->retro_load_game;
	gfn_retro_unload_game	= core_api->retro_unload_game;
	gfn_retro_run			= core_api->retro_run;

	xlog("l: run_emulator(%d)\n", load_state);
	run_emulator(load_state);

	xlog("l: retro_deinit\n");
	core_api->retro_deinit();
}

/* FIXME gets repetitive but we really need this $ra (in lib.c, too) */

void hook_sys_watchdog_reboot(void)
{
	unsigned ra;
	asm volatile ("move %0, $ra" : "=r" (ra));
	lcd_bsod("assert at 0x%08x", ra);
}

void hook_exception_handler(unsigned code)
{
	unsigned ra;
	asm volatile ("move %0, $ra" : "=r" (ra));
	lcd_bsod("exception %d at 0x%08x", code, ra);
}

static void clear_bss()
{
	extern void *__bss_start;
	extern void *_end;

    void *start = &__bss_start;
    void *end = &_end;

	memset(start, 0, end - start);
}

static void init_once()
{
	static bool first_call = true;
	if (!first_call)
		return;

	first_call = false;

	clear_bss();
	lcd_init();

#if defined(CLEAR_LOG_ON_BOOT)
	xlog_clear();
#endif

	corefile = malloc(MAXPATH);
	romfile = malloc(MAXPATH);
	tmpbuffer = malloc(MAXPATH);
}

static void full_cache_flush()
{
	unsigned idx;

	// Index_Writeback_Inv_D
	for (idx = 0x80000000; idx <= 0x80004000; idx += 16) // all of D-cache
		asm volatile("cache 1, 0(%0); cache 1, 0(%0)" : : "r"(idx));

	asm volatile("sync 0; nop; nop");

	// Index_Invalidate_I
	for (idx = 0x80000000; idx <= 0x80004000; idx += 16) // all of I-cache
		asm volatile("cache 0, 0(%0); cache 0, 0(%0)" : : "r"(idx));

	asm volatile("nop; nop; nop; nop; nop"); // ehb may be nop on this core
}
