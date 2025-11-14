#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdarg.h>
#include <reent.h>

#include "libretro.h"
#include "file/file_path.h"
#include "file/config_file.h"

#include "core_api.h"
#include "debug.h"
#include "stockfw.h"
#include "video_sf2000.h"

#define MIPS_J(pfunc)    (2 << 26) | (uint32_t)pfunc >> 2 & ((1 << 26) - 1)
#define MIPS_JAL(pfunc)  (3 << 26) | (uint32_t)pfunc >> 2 & ((1 << 26) - 1)

#define PATCH_J(target, hook)    *(uint32_t*)(target) = MIPS_J(hook)
#define PATCH_JAL(target, hook)  *(uint32_t*)(target) = MIPS_JAL(hook)

void save_srm(const char slot);
void load_srm(const char slot);

bool wrap_retro_load_game(const struct retro_game_info* info);
void wrap_retro_unload_game(void);

struct retro_game_info saved_game_info;

// Patch pause menu to always return 0 
int dummy_run_emulator_menu(void) {
	save_srm(0); // Save before loading the pause menu (incase of crashes + replace savesrm hotkey)
	unsigned int run_emulator_menu_response = run_emulator_menu();
	if (run_emulator_menu_response == 1) { // Replace quit button with reset core since quit button is broken when using the menu core
		wrap_retro_unload_game();
		wrap_retro_load_game(&saved_game_info);
	}
	return 0;
}

// Hotkeys
#define HOTKEYSAVESRM 0x9008 // press L + R + Start
#define HOTKEYSAVESTATE 0x9400 // press L + R + X
#define HOTKEYLOADSTATE 0x9800 // press L + R + Y
#define HOTKEYINCREASESTATE 0x9020 // press L + R + Right
#define HOTKEYDECREASESTATE 0x9080 // press L + R + LEFT

#define MAXPATH 	255
#define SYSTEM_DIRECTORY	"/mnt/sda1/bios"
#define SAVE_DIRECTORY		"/mnt/sda1/saves"
#define CONFIG_DIRECTORY	"/mnt/sda1/configs"

static config_file_t *s_core_config = NULL;
static void config_load();
static void config_free();
static bool config_get_var(struct retro_variable *var);

static retro_audio_buffer_status_callback_t	audio_buff_status_cb;

static void wrap_retro_set_environment(retro_environment_t cb);
static bool wrap_environ_cb(unsigned cmd, void *data);

static size_t mono_mix_audio_batch_cb(const int16_t *data, size_t frames);
static void mono_mix_audio_sample_cb(int16_t left, int16_t right);

static void wrap_retro_init(void);
static void wrap_retro_deinit(void);
static void wrap_retro_run(void);

static void log_cb(enum retro_log_level level, const char *fmt, ...);

static const char *s_game_filepath = NULL;
static int state_load(const char *frontend_state_filepath);
static int state_save(const char *frontend_state_filepath);

static uint16_t* s_rgb565_convert_buffer = NULL;
static void enable_xrgb8888_support();
static void convert_xrgb8888_to_rgb565(void* buffer, unsigned width, unsigned height, size_t stride);

static void wrap_video_refresh_cb(const void *data, unsigned width, unsigned height, size_t pitch);
static void xrgb8888_video_refresh_cb(const void *data, unsigned width, unsigned height, size_t pitch);
static bool g_xrgb888 = false;
static int16_t wrap_input_state_cb(unsigned port, unsigned device, unsigned index, unsigned id);

static bool g_show_fps = false;
static void frameskip_cb(BOOL flag);
static bool g_per_state_srm = false;
static bool g_per_core_srm = false;
static bool g_enable_savestate_hotkeys = true;
static bool g_enable_save_srm_hotkey = true;
static bool g_enable_osd = true;
static bool g_osd_small_messages = false;

static void dummy_retro_run(void);

static int *fw_fps_counter_enable = (int *)0x80c5abcc;	// displayfps
static int *fw_fps_counter = (int *)0x80c5abc8;
static char *fw_fps_counter_format = (char *)0x809fb9ec;	// "%2d/%2d"
static void fps_counter_enable(bool enable);

#define KEYMAP_SIZE 12

// Forward declarations to fix implicit declaration warnings
void build_game_config_filepath(char *filepath, size_t size, const char *game_filepath, const char *library_name);
void config_add_file(const char *filepath);

static bool gb_temporary_osd = false;

struct retro_core_t core_exports = {
   .retro_init = wrap_retro_init,
   .retro_deinit = wrap_retro_deinit,
   .retro_api_version = retro_api_version,
   .retro_get_system_info = retro_get_system_info,
   .retro_get_system_av_info = retro_get_system_av_info,
   .retro_set_environment = wrap_retro_set_environment,
   .retro_set_video_refresh = retro_set_video_refresh,
   .retro_set_audio_sample = retro_set_audio_sample,
   .retro_set_audio_sample_batch = retro_set_audio_sample_batch,
   .retro_set_input_poll = retro_set_input_poll,
   .retro_set_input_state = retro_set_input_state,
   .retro_set_controller_port_device = retro_set_controller_port_device,
   .retro_reset = retro_reset,
   .retro_run = wrap_retro_run,
   .retro_serialize_size = retro_serialize_size,
   .retro_serialize = retro_serialize,
   .retro_unserialize = retro_unserialize,
   .retro_cheat_reset = retro_cheat_reset,
   .retro_cheat_set = retro_cheat_set,
   .retro_load_game = wrap_retro_load_game,
   .retro_load_game_special = retro_load_game_special,
   .retro_unload_game = wrap_retro_unload_game,
   .retro_get_region = retro_get_region,
   .retro_get_memory_data = retro_get_memory_data,
   .retro_get_memory_size = retro_get_memory_size,
};

// Make a directory if it doesn't exist
int create_dir(const char *path) {
	if (fs_access(path, 0) != 0) {
		xlog("filepath: creating %s\n", path);
        fs_mkdir(path, 0755);
    }
}

// Loads the keymap configuration for the game.
void load_keymap(const char *s_game_filepath)
{
	struct retro_system_info sysinfo;
	retro_get_system_info(&sysinfo);

	char kmp_filepath[MAXPATH];

	char basename[MAXPATH];
	fill_pathname_base(basename, s_game_filepath, sizeof(basename));
	path_remove_extension(basename);

	// Rom keymap
	snprintf(kmp_filepath, sizeof(kmp_filepath), "%s/%s/keymaps/%s.kmp", CONFIG_DIRECTORY, sysinfo.library_name, basename);
	xlog("Checking keymap in %s...\n", kmp_filepath);

	// if ROM keymap doesn't exist load Core keymap
	if (fs_access(kmp_filepath, 0) != 0) {
		snprintf(kmp_filepath, sizeof(kmp_filepath), "%s/%s/%s.kmp", CONFIG_DIRECTORY, sysinfo.library_name, sysinfo.library_name);
		xlog("Checking keymap in %s...\n", kmp_filepath);
	}

	// if Core keymap doesn't exist load Multicore keymap
	if (fs_access(kmp_filepath, 0) != 0) {
		snprintf(kmp_filepath, sizeof(kmp_filepath), "%s/multicore.kmp", CONFIG_DIRECTORY);
		xlog("Checking keymap in %s...\n", kmp_filepath);
	}

	// if no keymap, just return
	if (fs_access(kmp_filepath, 0) != 0) return;

	uint32_t keymap[KEYMAP_SIZE];
	FILE *h_file = NULL;
	h_file = fopen(kmp_filepath, "rb");

	size_t elements_read = fread(keymap, sizeof(uint32_t), KEYMAP_SIZE, h_file);
	fclose(h_file);

    set_keymap(keymap, 8);
	xlog("Keymap file %s loaded\n", kmp_filepath);
}

void build_srm_filepath(char *filepath, size_t size, const char *game_filepath, const char *extension, size_t extension_size) {
	char basename[MAXPATH];
	char directory[MAXPATH] = SAVE_DIRECTORY;
	fill_pathname_base(basename, game_filepath, sizeof(basename));
	path_remove_extension(basename);
	create_dir(directory); // Make sure SAVE_DIRECTORY exists 

	if(g_per_core_srm){
		struct retro_system_info sysinfo;
		retro_get_system_info(&sysinfo);
		snprintf(directory, size, "%s/%s", SAVE_DIRECTORY, sysinfo.library_name);
		create_dir(directory);	// Make sure SAVE_DIRECTORY/sysinfo.library_name exists 
	}

	snprintf(filepath, size, "%s/%s.%s", directory, basename, extension);
}

#ifdef DBLCHERRY_SAVE
void save_srm(const char slot){
	int count = retro_dblchry_emulated_count();
	for(int i = 0; i < count; i++){
		save_srm_id(slot, i);
	}
}
void save_srm_id(const char slot, int position){
	char ram_filepath[MAXPATH];
	char ext[9];
	if(position == 0){
		snprintf(ext, 5, "srm%c", slot);
	}else{
		if(slot == 0){
			snprintf(ext, 9, "srm_%d", position + 1);
		}else{
			snprintf(ext, 9, "srm_%d_%c", position + 1, slot);
		}
	}
	build_srm_filepath(ram_filepath, sizeof(ram_filepath), s_game_filepath, ext, 8);
	xlog("save_srm: file=%s\n", ram_filepath);
	size_t save_size = retro_dblchry_get_sram_size(position);
	if(save_size == 0)
		return;
	FILE *ram_file = fopen(ram_filepath, "wb");
	if (!ram_file)
		return;
	fwrite(retro_dblchry_get_sram_ptr(position), save_size, 1, ram_file);
	fclose(ram_file);
	fs_sync(ram_filepath);
}
void load_srm(const char slot){
	int count = retro_dblchry_emulated_count();
	for(int i = 0; i < count; i++){
		load_srm_id(slot, i);
	}
}
void load_srm_id(const char slot, int position){
	size_t save_size = retro_dblchry_get_sram_size(position);
	char ram_filepath[MAXPATH];
	char ext[9];
	if(position == 0){
		snprintf(ext, 5, "srm%c", slot);
	}else{
		if(slot == 0){
			snprintf(ext, 9, "srm_%d", position + 1);
		}else{
			snprintf(ext, 9, "srm_%d_%c", position + 1, slot);
		}
	}
	build_srm_filepath(ram_filepath, sizeof(ram_filepath), s_game_filepath, ext, 8);
	xlog("load_srm: file=%s\n", ram_filepath);
	FILE *ram_file = fopen(ram_filepath, "rb");
	if (!ram_file)
		return;
	fseeko(ram_file, 0, SEEK_END);
	size_t ram_file_size = ftell(ram_file);
	fseeko(ram_file, 0, SEEK_SET);
	if(ram_file_size < save_size){
		save_size = ram_file_size;
	}
	if(save_size == 0){
		fclose(ram_file);
		return;
	}
	fread(retro_dblchry_get_sram_ptr(position), 1, save_size, ram_file);
	fclose(ram_file);
}
#endif

#ifndef DBLCHERRY_SAVE
void save_srm(const char slot){
	char ram_filepath[MAXPATH];
	char ext[5];
	snprintf(ext, 5, "srm%c", slot);
	build_srm_filepath(ram_filepath, sizeof(ram_filepath), s_game_filepath, ext, 4);
	xlog("save_srm: file=%s\n", ram_filepath);
	size_t save_size = retro_get_memory_size(RETRO_MEMORY_SAVE_RAM);
	if(save_size == 0)
		return;
	FILE *ram_file = fopen(ram_filepath, "wb");
	if (!ram_file)
		return;
	fwrite(retro_get_memory_data(RETRO_MEMORY_SAVE_RAM), save_size, 1, ram_file);
	fclose(ram_file);
	fs_sync(ram_filepath);
}
void load_srm(const char slot){
	size_t save_size = retro_get_memory_size(RETRO_MEMORY_SAVE_RAM);
	char ram_filepath[MAXPATH];
	char ext[5];
	snprintf(ext, 5, "srm%c", slot);
	build_srm_filepath(ram_filepath, sizeof(ram_filepath), s_game_filepath, ext, 4);
	xlog("load_srm: file=%s\n", ram_filepath);
	FILE *ram_file = fopen(ram_filepath, "rb");
	if (!ram_file)
		return;
	fseeko(ram_file, 0, SEEK_END);
	size_t ram_file_size = ftell(ram_file);
	fseeko(ram_file, 0, SEEK_SET);
	if(ram_file_size < save_size){
		save_size = ram_file_size;
	}
	if(save_size == 0){
		fclose(ram_file);
		return;
	}
	fread(retro_get_memory_data(RETRO_MEMORY_SAVE_RAM), 1, save_size, ram_file);
	fclose(ram_file);
}
#endif

static uint32_t g_osd_time = 0;
static uint32_t slot_delay_time = 0;
static int slot_state = 0;
char osd_message[MAXPATH];

// Show osd message
int show_osd_message(const char *message) {
	if (g_enable_osd) {
		gb_temporary_osd = true;
		if (!g_show_fps) *fw_fps_counter_enable = 1; // Don't change fps if fps is enabled
		sprintf(fw_fps_counter_format, message);
		g_osd_time = os_get_tick_count();
	}
}

void wrap_retro_run(void) {
	// Disable the osd message after 2 seconds
	if (gb_temporary_osd) {
		if (os_get_tick_count() - g_osd_time > 1000) {
			if (!g_show_fps) *fw_fps_counter_enable = 0; // Don't change fps if fps is enabled
			gb_temporary_osd = false;
		}
	}

	// Do not use retro_input_state_cb to avoid key remapping issues
	if (g_joy_task_state == HOTKEYSAVESRM || g_joy_task_state == HOTKEYSAVESTATE || g_joy_task_state == HOTKEYLOADSTATE 
		|| g_joy_task_state == HOTKEYINCREASESTATE || g_joy_task_state == HOTKEYDECREASESTATE) {
		g_joy_state = 0; //Reset g_joy_state to avoid button presses
		if ((g_joy_task_state == HOTKEYSAVESRM || g_joy_task_state == HOTKEYSAVESTATE || g_joy_task_state == HOTKEYLOADSTATE)
    		&& (os_get_tick_count() - g_osd_time > 1000)) { // Use osd delay to prevent spamming hotkeys
			if ((g_joy_task_state == HOTKEYSAVESRM) && (g_enable_save_srm_hotkey)) { // Save SRM Hotkey
				save_srm(0);
				g_osd_small_messages ? sprintf(osd_message, "S:SRM") : sprintf(osd_message, "Save: SRM");
			} else if ((g_joy_task_state == HOTKEYSAVESTATE) && (g_enable_savestate_hotkeys)) { // Save SRM state
				state_save("");
				g_osd_small_messages ? sprintf(osd_message, "S:%d", slot_state) : sprintf(osd_message, "Save: %d", slot_state);
			} else if ((g_joy_task_state == HOTKEYLOADSTATE) && (g_enable_savestate_hotkeys)) { // Load SRM state
				state_load("");
				g_osd_small_messages ? sprintf(osd_message, "L:%d", slot_state) : sprintf(osd_message, "Load: %d", slot_state);
			}
			show_osd_message(osd_message);
		}

		if (((g_joy_task_state == HOTKEYINCREASESTATE || g_joy_task_state == HOTKEYDECREASESTATE)  // Increase or Decrease state
    	&& (os_get_tick_count() - slot_delay_time > 100))  // Delay so it isn't too fast
    	&& g_enable_savestate_hotkeys) { // Hotkey setting enabled
			if (g_joy_task_state == HOTKEYINCREASESTATE) { 	
				if (slot_state < 9) {
					slot_state += 1;
				} else {
					slot_state = 0;
				}
			} else if (g_joy_task_state == HOTKEYDECREASESTATE) { 	
				if (slot_state > 0) {
					slot_state -= 1;
				} else {
					slot_state = 9;
				}
			}
			g_osd_small_messages ? sprintf(osd_message, "SLT:%d", slot_state) : sprintf(osd_message, "Slot: %d", slot_state);
			show_osd_message(osd_message);
			slot_delay_time = os_get_tick_count();
		}
	}

	retro_run(); 
}

void wrap_retro_unload_game(void){
	save_srm(0);
	retro_unload_game();
}

static void clear_bss()
{
	extern void *__bss_start;
	extern void *_end;

    void *start = &__bss_start;
    void *end = &_end;

	memset(start, 0, end - start);

	// xlog("clear_bss: start=%p end=%p\n", &__bss_start, &_end);
}

// call_ctors currently is not being used since __libc_init_array will handle that instead.
// but leave it here for now if there would be a need to debug a crash during the static init phase.
static void call_ctors()
{
	typedef void (*func_ptr) (void);
	extern func_ptr __init_array_start;
	extern func_ptr __init_array_end;

	xlog("call_ctors: start=%p end=%p\n", &__init_array_start, &__init_array_end);

	// call ctors from last to first
	for (func_ptr *pfunc = &__init_array_end - 1; pfunc >= &__init_array_start; --pfunc) {
		xlog("pfunc=%p func=%p\n", pfunc, *pfunc);
		(*pfunc)();
	}
}

// TODO: need a place to call dtors as well. maybe when retro_deinit is called?
static void call_dtors()
{
	typedef void (*func_ptr) (void);
	extern func_ptr __fini_array_start;
	extern func_ptr __fini_array_end;

	// dtors are called in reverse order of ctors
	for (func_ptr *pfunc = &__fini_array_start; pfunc < &__fini_array_end; ++pfunc) {
		(*pfunc)();
	}
}

// __core_entry__ must be placed at a known location in the binary (at the beginning)
// so that when the loader actually loads the binary into mem address 0x87000000,
// then __core_entry__ will be the first function there for the loader to call.
struct retro_core_t *__core_entry__(void) __attribute__((section(".init.core_entry")));

struct retro_core_t *__core_entry__(void)
{
	// https://gitlab.com/kobily/sf2000_multicore/-/commit/328bce4173316a6ea0afe4c360ee4f3d5b951c19 condensed to core's side
	// with $gp value fetched from _start
	os_disable_interrupt();
	*(unsigned *)0x80049744 = *(unsigned *)0x80001270; // lui	$gp
	*(unsigned *)0x80049748 = *(unsigned *)0x80001274; // addiu	$gp
	__builtin___clear_cache((void *)0x80049744, (void *)0x8004974c);

	// Patch Pause Menu
	PATCH_JAL(0x8035cc84, dummy_run_emulator_menu);
	__builtin___clear_cache((void *)0x8035cc84, (void *)0x8035cc84+4);

	os_enable_interrupt();
	clear_bss();

	extern void __sinit (struct _reent *);
	extern void __libc_init_array (void);

	_REENT_INIT_PTR(_REENT);
	__sinit(_REENT);
	__libc_init_array();

	xlog("libc initialized\n");

	return &core_exports;
}

bool wrap_retro_load_game(const struct retro_game_info* info)
{
	memcpy(&saved_game_info, info, sizeof(struct retro_game_info)); // Save the retro_game_info incase we want to reset

	bool ret;
	struct retro_system_info sysinfo;
	retro_get_system_info(&sysinfo);

	xlog("core=%s-%s need_fullpath=%d exts=%s\n", sysinfo.library_name, sysinfo.library_version, sysinfo.need_fullpath, sysinfo.valid_extensions);

	// no need to strcpy, because info->path string should be valid during the execution of the game
	s_game_filepath = info->path;

	char config_game_filepath[MAXPATH];
	build_game_config_filepath(config_game_filepath, sizeof(config_game_filepath), s_game_filepath, sysinfo.library_name);

	// load per game options
	config_add_file(config_game_filepath);

	// setup load/save state handlers
	gfn_state_load = state_load;
	gfn_state_save = state_save;

	gfn_frameskip = NULL;

	// install custom input handler to filter out all requests for non-joypad devices
	retro_set_input_state(wrap_input_state_cb);

	// intercept audio output to mix stereo into mono
	retro_set_audio_sample(mono_mix_audio_sample_cb);
	retro_set_audio_sample_batch(mono_mix_audio_batch_cb);

	// if core wants to load the content by itself directly from files, then let it
	if (sysinfo.need_fullpath)
	{
		xlog("core loads content directly from file\n");
		ret = retro_load_game(info);
	}
	else
	{
		// otherwise load the content into a temp buffer and pass it to the core

		FILE *hfile = fopen(info->path, "rb");
		if (!hfile) {
			xlog("[core] Error opening rom file=%s\n", info->path);
			return false;
		}

		fseeko(hfile, 0, SEEK_END);
		long size = ftell(hfile);
		fseeko(hfile, 0, SEEK_SET);

		void *buffer = malloc(size);

		fread(buffer, 1, size, hfile);
		fclose(hfile);

		struct retro_game_info gameinfo;
		gameinfo.path = info->path;
		gameinfo.data = buffer;
		gameinfo.size = size;

		xlog("game loaded into temp buffer. size=%u\n", size);

		ret = retro_load_game(&gameinfo);

		free(buffer);
	}

	if (!ret)
	{
		xlog("retro_load_game failed\n");
		gfn_retro_run = dummy_retro_run;
	}
	else
	{
		xlog("retro_load_game ok\n");

		// load keymap
		load_keymap(s_game_filepath);

		video_options(s_core_config);

		// show FPS?
		config_get_bool(s_core_config, "sf2000_show_fps", &g_show_fps);
		fps_counter_enable(g_show_fps);

		// per state srm?
		config_get_bool(s_core_config, "sf2000_per_state_srm", &g_per_state_srm);

		// Hotkey settings
		config_get_bool(s_core_config, "sf2000_enable_savestate_hotkeys", &g_enable_savestate_hotkeys);
		config_get_bool(s_core_config, "sf2000_enable_save_srm_hotkey", &g_enable_save_srm_hotkey);
		config_get_bool(s_core_config, "sf2000_enable_osd", &g_enable_osd);
		config_get_bool(s_core_config, "sf2000_osd_small_messages", &g_osd_small_messages);

		// per core srm?
		config_get_bool(s_core_config, "sf2000_per_core_srm", &g_per_core_srm);
		
		// make sure the first two controllers are configured as gamepads
		retro_set_controller_port_device(0, RETRO_DEVICE_JOYPAD);
		retro_set_controller_port_device(1, RETRO_DEVICE_JOYPAD);

		load_srm(0);
	}

	return ret;
}

void wrap_retro_set_environment(retro_environment_t cb)
{
	retro_set_environment(wrap_environ_cb);
}

bool wrap_environ_cb(unsigned cmd, void *data)
{
	switch (cmd)
	{
		case RETRO_ENVIRONMENT_GET_LOG_INTERFACE:
		{
			struct retro_log_callback *cb = (struct retro_log_callback*)data;
			cb->log = log_cb;
			return true;
		}

		case RETRO_ENVIRONMENT_SET_MESSAGE:
		case RETRO_ENVIRONMENT_SET_MESSAGE_EXT:
		{
			const struct retro_message *msg = (const struct retro_message*)data;
			log_cb(RETRO_LOG_INFO, "[Environ]: SET_MESSAGE: %s\n", msg->msg);
			return true;
		}

		case RETRO_ENVIRONMENT_GET_SYSTEM_DIRECTORY:
		{
			const char *dir = SYSTEM_DIRECTORY;
			*(const char**)data = dir;
			log_cb(RETRO_LOG_INFO, "[Environ]: SYSTEM_DIRECTORY: \"%s\"\n", dir);
			return true;
		}

		case RETRO_ENVIRONMENT_GET_SAVE_DIRECTORY:
		{
			const char *dir = SAVE_DIRECTORY;
			*(const char**)data = dir;
			log_cb(RETRO_LOG_INFO, "[Environ]: SAVE_DIRECTORY: \"%s\"\n", dir);
			return true;
		}

		case RETRO_ENVIRONMENT_GET_CAN_DUPE:
			*(bool*)data = true;
			log_cb(RETRO_LOG_INFO, "[Environ]: GET_CAN_DUPE: true\n");
			return true;

		case RETRO_ENVIRONMENT_GET_VARIABLE:
		{
			struct retro_variable *var = (struct retro_variable*)data;
			bool ret = config_get_var(var);
			log_cb(RETRO_LOG_INFO, "[Environ]: GET_VARIABLE: %s=%s\n", var->key, ret ? var->value : "");
			return ret;
		}

		case RETRO_ENVIRONMENT_SET_MEMORY_MAPS:
		{
			log_cb(RETRO_LOG_INFO, "[Environ]: SET_MEMORY_MAPS\n");
			break;
		}

		case RETRO_ENVIRONMENT_SET_GEOMETRY:
		{
			const struct retro_game_geometry *geom = (const struct retro_game_geometry*)data;
            log_cb(RETRO_LOG_INFO, "[Environ]: SET_GEOMETRY: %ux%u, Aspect: %.3f.\n",
				geom->base_width, geom->base_height, geom->aspect_ratio);
			break;
		}

		case RETRO_ENVIRONMENT_SET_PIXEL_FORMAT:
		{
			enum retro_pixel_format fmt = *(enum retro_pixel_format*)data;
			if (fmt == RETRO_PIXEL_FORMAT_XRGB8888)
			{
				enable_xrgb8888_support();
				return true;
			}
			break;
		}

		case RETRO_ENVIRONMENT_SET_AUDIO_BUFFER_STATUS_CALLBACK:
		{
			struct retro_audio_buffer_status_callback *buff_status_cb = (struct retro_audio_buffer_status_callback*)data;
			if (buff_status_cb)
			{
				audio_buff_status_cb = buff_status_cb->callback;
				gfn_frameskip = frameskip_cb;
			}
			else
				gfn_frameskip = NULL;

			xlog("support for auto frameskipping %s\n", buff_status_cb ? "enabled" : "disabled" );
			return true;
		}
	}
	return retro_environment_cb(cmd, data);
}

void log_cb(enum retro_log_level level, const char *fmt, ...)
{
#if DEBUG_XLOG == 1
	char buffer[500];

	va_list args;
	va_start(args, fmt);
	vsnprintf(buffer, sizeof(buffer), fmt, args);
	va_end(args);

	switch (level)
	{
		case RETRO_LOG_DEBUG:
			xlog("[core][DEBUG] %s", buffer);
			break;

		case RETRO_LOG_INFO:
			xlog("[core][INFO] %s", buffer);
			break;

		case RETRO_LOG_WARN:
			xlog("[core][WARN] %s", buffer);
			break;

		case RETRO_LOG_ERROR:
			xlog("[core][ERROR] %s", buffer);
			break;

		default:
			break;
	}
#endif
}


char build_state_filepath(char *state_filepath, size_t size, const char *game_filepath, const char *frontend_state_filepath)
{
//	"/mnt/sda1/ROMS/pce/Alien Crush.pce"	->
//	"/mnt/sda1/saves/savestates/[core]/Alien Crush.state[slot]"
	struct retro_system_info sysinfo;
	retro_get_system_info(&sysinfo);

	// last char is the save slot number
	char save_slot = frontend_state_filepath[strlen(frontend_state_filepath) - 1];

	if (strlen(frontend_state_filepath) == 0) save_slot = slot_state + '0'; //To convert integer to char only 0 to 9 will be converted. 

	if (strlen(frontend_state_filepath) != 0) { 
		char frontend_state_directory[MAXPATH];
		strcpy(frontend_state_directory, frontend_state_filepath);
		char *last_slash = strrchr(frontend_state_directory, '/');
		*last_slash = '\0';
		create_dir(frontend_state_directory); // Make sure frontend_state_filepath directory exists
	}

	char basename[MAXPATH];
	char directory[MAXPATH];
	fill_pathname_base(basename, game_filepath, sizeof(basename));
	path_remove_extension(basename);
	create_dir(SAVE_DIRECTORY); // Make sure SAVE_DIRECTORY exists
	if(g_per_core_srm){
		snprintf(directory, size, "%s/%s", SAVE_DIRECTORY, sysinfo.library_name);
		create_dir(directory); // Make sure SAVE_DIRECTORY/sysinfo.library_name exists
	} else {
		snprintf(directory, size, "%s/savestates", SAVE_DIRECTORY);
		create_dir(directory); // Make sure SAVE_DIRECTORY/savestates exists
		strcat(directory, "/");
		strcat(directory, sysinfo.library_name);
		create_dir(directory); // Make sure SAVE_DIRECTORY/savestates/sysinfo.library_name exists
	}
	snprintf(state_filepath, size, "%s/%s.state%c", directory, basename, save_slot);
	return save_slot;
}

int state_load(const char *frontend_state_filepath)
{
	char state_filepath[MAXPATH];
	char slot = build_state_filepath(state_filepath, sizeof(state_filepath), s_game_filepath, frontend_state_filepath);
	xlog("state_load: file=%s\n", state_filepath);

	FILE *file = fopen(state_filepath, "rb");
	if (!file)
		return 0;

	fseeko(file, 0, SEEK_END);
	size_t size = ftell(file);
	fseeko(file, 0, SEEK_SET);

	void *data = malloc(size);

	fread(data, 1, size, file);
	fclose(file);

	retro_unserialize(data, size);

	free(data);

	if(g_per_state_srm){
		load_srm(slot);
	}
	return 1;
}

int state_save(const char *frontend_state_filepath)
{
	char state_filepath[MAXPATH];
	char slot = build_state_filepath(state_filepath, sizeof(state_filepath), s_game_filepath, frontend_state_filepath);
	xlog("state_save: file=%s\n", state_filepath);

	FILE *file = fopen(state_filepath, "wb");
	if (!file)
		return 0;

	size_t size = retro_serialize_size();
	void *data = calloc(size, 1);

	retro_serialize(data, size);

	fwrite(data, size, 1, file);
	fclose(file);

	free(data);

	fs_sync(state_filepath);

	if(g_per_state_srm){
		save_srm(slot);
	}
	return 1;
}

void build_game_config_filepath(char *filepath, size_t size, const char *game_filepath, const char *library_name)
{
	char basename[MAXPATH];
	fill_pathname_base(basename, game_filepath, sizeof(basename));
	path_remove_extension(basename);

	snprintf(filepath, size, "%s/%s/options/%s.opt", CONFIG_DIRECTORY, library_name, basename);
}

void build_core_config_filepath(char *filepath, size_t size)
{
	struct retro_system_info sysinfo;
	retro_get_system_info(&sysinfo);

	snprintf(filepath, size, "%s/%s/%s.opt", CONFIG_DIRECTORY, sysinfo.library_name, sysinfo.library_name);
}

void config_add_file(const char *filepath)
{
	bool ret = config_append_file(s_core_config, filepath);
	xlog("config_load: %s %s\n", filepath, ret ? "loaded" : "not found");
}

void config_load()
{
	s_core_config = config_file_new_alloc();

	// load global multicore options
	config_add_file(CONFIG_DIRECTORY "/multicore.opt");

	char config_filepath[MAXPATH];
	build_core_config_filepath(config_filepath, sizeof(config_filepath));

	// load per core options
	config_add_file(config_filepath);
}

void config_free()
{
	config_file_free(s_core_config);
}

bool config_get_var(struct retro_variable *var)
{
	if (!s_core_config)
		return false;

	const struct config_entry_list *entry = config_get_entry(s_core_config, var->key);
	if (!entry)
		return false;

	var->value = entry->value;
	return true;
}

void wrap_retro_init(void)
{
	config_load();
	retro_init();
}

void wrap_retro_deinit(void)
{
	if (g_show_fps)
		fps_counter_enable(false);
	video_cleanup();
	retro_deinit();
	config_free();

	if (s_rgb565_convert_buffer)
		free(s_rgb565_convert_buffer);
}

size_t mono_mix_audio_batch_cb(const int16_t *data, size_t frames)
{
	// TODO: is data always assumed to be s16bit dual channel buffer?
	for (size_t i=0; i < frames*2; i+=2)
	{
		// for single speaker output, mix to mono both channels into the first channel
		((int16_t*)data)[i] = (data[i] >> 1) + (data[i+1] >> 1);
		// leave the second channel as is because it is not heard anyway
		//((int16_t*)data)[i+1] = 0;
	}

	// NOTE: stock frontend audio_batch_cb always return 0!
	retro_audio_sample_batch_cb(data, frames);
	// return `frames` as if all data was consumed
	return frames;
}

void mono_mix_audio_sample_cb(int16_t left, int16_t right)
{
	int16_t mixed = (left >> 1) + (right >> 1);
	int16_t data[2] = {mixed, right};
	retro_audio_sample_batch_cb(data, 1);
}

void convert_xrgb8888_to_rgb565(void* buffer, unsigned width, unsigned height, size_t stride)
{
	uint32_t* xrgb8888_buffer = (uint32_t*)buffer;
	uint16_t* rgb565_buffer = s_rgb565_convert_buffer;

    for (int y = 0; y < height; y++)
	{
        for (int x = 0; x < width; x++)
		{
            int index = y * stride / sizeof(uint32_t) + x;

            uint32_t xrgbPixel = xrgb8888_buffer[index];

            uint16_t rgb565Pixel = ((xrgbPixel >> 8) & 0xF800) | ((xrgbPixel >> 5) & 0x07E0) | ((xrgbPixel >> 3) & 0x001F);

            rgb565_buffer[index] = rgb565Pixel;
        }
    }
}

void xrgb8888_video_refresh_cb(const void *data, unsigned width, unsigned height, size_t pitch)
{
	convert_xrgb8888_to_rgb565((void*)data, width, height, pitch);

	retro_video_refresh_cb(s_rgb565_convert_buffer, width, height, width * 2);		// each pixel is now 16bit, so pass the pitch as width*2
}

static void enable_xrgb8888_support()
{
	xlog("support for XRGB8888 enabled\n");

	struct retro_system_av_info av_info;
	retro_get_system_av_info(&av_info);

	s_rgb565_convert_buffer = (uint16_t*)malloc(av_info.geometry.max_width * av_info.geometry.max_height * sizeof(uint16_t));

	xlog("created rgb565_convert_buffer=%p width=%u height=%u\n",
		s_rgb565_convert_buffer, av_info.geometry.max_width, av_info.geometry.max_height);

	//retro_set_video_refresh(xrgb8888_video_refresh_cb);
	g_xrgb888 = true;
}

static int16_t wrap_input_state_cb(unsigned port, unsigned device, unsigned index, unsigned id)
{
	if ((port == 0 || port == 1) && (device == RETRO_DEVICE_JOYPAD))
		return retro_input_state_cb(port, device, index, id);
	else
		return 0;
}

static void frameskip_cb(BOOL flag)
{
	audio_buff_status_cb(flag == 1 /*active*/, 0 /*occupancy*/, true /*underrun_likely*/);
}

static void dummy_retro_run(void)
{
	dly_tsk(1);
	//retro_environment_cb(RETRO_ENVIRONMENT_SHUTDOWN, NULL);
}

static void fps_counter_enable(bool enable)
{
	if (enable)
	{
		*fw_fps_counter_enable = 1;
		retro_set_video_refresh(wrap_video_refresh_cb);
	}
	else
	{
		*fw_fps_counter_enable = 0;
		if (g_xrgb888)
			retro_set_video_refresh(xrgb8888_video_refresh_cb);
		else
			retro_set_video_refresh(retro_video_refresh_cb);
	}
}

void wrap_video_refresh_cb(const void *data, unsigned width, unsigned height, size_t pitch)
{
	static uint32_t prev_msec = 0;
	static int count_all = 0;
	static int count_not_skipped = 0;

	uint32_t curr_msec = os_get_tick_count();

	++count_all;
	if (data)
		++count_not_skipped;

	if (curr_msec - prev_msec > 1000)
	{
		// im not sure that using floats math will calc the fps much more accurately
		// float sec = ((curr_msec - prev_msec) / 1000.0f);
		// *fw_fps_counter1 = count_not_skipped / sec;
		// fps_counter2 = count_all / sec;

		sprintf(fw_fps_counter_format, "%2d/%2d", count_not_skipped, count_all);

		prev_msec = curr_msec;
		count_all = 0;
		count_not_skipped = 0;
	}

	if (g_xrgb888)
	{
		convert_xrgb8888_to_rgb565((void*)data, width, height, pitch);
		retro_video_refresh_cb(s_rgb565_convert_buffer, width, height, width * 2);		// each pixel is now 16bit, so pass the pitch as width*2
	}
	else {
		retro_video_refresh_cb(data, width, height, pitch);
	}
}
