
fs_open	= 0x8025b78c;
fs_read	= 0x8025bb84;
fs_write = 0x8025bca8;
fs_lseek = 0x8025bdc8;
fs_close = 0x8025bf08;

fs_access = 0x8025ba1c;

fs_fstat = 0x8025bab4;
fs_stat  = 0x8025bad8;
fs_mkdir = 0x8025b8e8;

fs_opendir  = 0x8025b85c;
fs_closedir = 0x8025bf24;
fs_readdir  = 0x8025be6c;

fs_sync = 0x8025b664;

/* TDS2 */
osal_tds2_cache_flush	= 0x80049214;
os_disable_interrupt	= 0x802901cc;
os_enable_interrupt		= 0x802901f4;

os_get_tick_count = 0x802bf944;

dly_tsk	= 0x802beefc;

/* drivers */
get_vp_init_low_lcd_para	= 0x8016fa38;
switch_lcd_or_tv	= 0x8016fafc;

vpo_ioctl	= 0x80227094;

osddrv_open	= 0x80227748;
osddrv_close	= 0x80227828;
osddrv_3x_create_region	= 0x80227f3c;
osddrv_3x_region_write	= 0x80228834;
osddrv_scale	= 0x80228b58;

dev_get_by_id	= 0x80228e30;

st7789v_caset_raset	= 0x8025041c;
st7789v_ramwr	= 0x802504c0;

/* libretro frontend */
run_osd_region_write	= 0x8030b58c;
run_screen_write	= 0x8030b608;
run_sound_advance	= 0x8030b718;

retro_video_refresh_cb		= 0x8030c960;
retro_audio_sample_batch_cb	= 0x8030c9e8;
retro_input_poll_cb			= 0x8030cc20;
retro_input_state_cb 		= 0x8030cd10;
retro_environment_cb		= 0x8030cd54;

run_emulator	= 0x8030d008;
run_gba			= 0x8030e4bc;

/* .data */
RAMSIZE	= 0x806f5e84;
/* using errno */
g_errno	= 0x806f6470;

g_snd_task_flags	= 0x806f7634;

g_retro_game_info	= 0x80ad8e18;

gfn_state_load	= 0x806f8fac;
gfn_state_save	= 0x806f9008;

gfn_retro_get_region	= 0x806f8fe4;
gfn_get_system_av_info	= 0x806f8ff4;
gfn_retro_load_game		= 0x806f9014;
gfn_retro_unload_game	= 0x806f901c;
gfn_retro_run	= 0x806f902c;
gfn_frameskip	= 0x806f9028;

g_run_file_size	= 0x806f8e9c;
gp_buf_64m	= 0x806f8ed0;

/* HiChip's hardware wired to LCD for UARTless debug.c */
PINMUXL	= 0xb88004a0;
PINMUXT	= 0xb8800500;
GPIOLCTRL	= 0xb8800044;
GPIOTCTRL	= 0xb8800344;
