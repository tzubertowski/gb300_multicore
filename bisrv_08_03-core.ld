
fs_open	= 0x802aa134;
fs_read	= 0x802aa52c;
fs_write = 0x802aa650;
fs_lseek = 0x802aa770;
fs_close = 0x802aa8b0;

fs_access = 0x802aa3c4;

fs_fstat = 0x802aa45c;
fs_stat  = 0x802aa480;
fs_mkdir = 0x802aa290;

fs_opendir  = 0x802aa204;
fs_closedir = 0x802aa8cc;
fs_readdir  = 0x802aa814;

fs_sync = 0x802aa00c;

/* TDS2 */
osal_tds2_cache_flush	= 0x80049214;
os_disable_interrupt	= 0x802deb74;
os_enable_interrupt		= 0x802deb9c;

os_get_tick_count = 0x8030e2ec;

dly_tsk	= 0x8030d8a4;

/* drivers */
get_vp_init_low_lcd_para	= 0x801be3f0;
switch_lcd_or_tv	= 0x801be4b4;

vpo_ioctl	= 0x80275278;

osddrv_open	= 0x802760f0;
osddrv_close	= 0x802761d0;
osddrv_3x_create_region	= 0x802768e4;
osddrv_3x_region_write	= 0x802771dc;
osddrv_scale	= 0x80277500;

dev_get_by_id	= 0x802777d8;

st7789v_caset_raset	= 0x8029edc4; /* st7789v_320_240_caset_raset */
st7789v_ramwr	= 0x8029ee68;

/* libretro frontend */
run_osd_region_write	= 0x8035ac28;
run_screen_write	= 0x8035aca4; /* dispFlip */
run_sound_advance	= 0x8035adb4; /* sound_driver_play */

retro_video_refresh_cb		= 0x8035c1d4;
retro_audio_sample_batch_cb	= 0x8035c25c;
retro_input_poll_cb			= 0x8035c4b4;
retro_input_state_cb 		= 0x8035c5a4;
retro_environment_cb		= 0x8035c5e8;

run_emulator	= 0x8035c89c;
run_gba			= 0x8035de78;

/* .data */
RAMSIZE	= 0x80c591bc;

g_errno	= 0x80c599a0;

g_snd_task_flags	= 0x80c5ab64;

g_retro_game_info	= 0x80c5acec;

gfn_state_load	= 0x80c5ffb8;
gfn_state_save	= 0x80c60010;

gfn_retro_get_region	= 0x80c5ffec;
gfn_get_system_av_info	= 0x80c5fffc;
gfn_retro_load_game		= 0x80c6001c;
gfn_retro_unload_game	= 0x80c60024;
gfn_retro_run	= 0x80c60034;
gfn_frameskip	= 0x80c60030;

g_run_file_size	= 0x80c5feac;
gp_buf_64m	= 0x80c60028;

/* HiChip's hardware wired to LCD for UARTless debug.c */
PINMUXL	= 0xb88004a0;
PINMUXT	= 0xb8800500;
GPIOLCTRL	= 0xb8800044;
GPIOTCTRL	= 0xb8800344;
