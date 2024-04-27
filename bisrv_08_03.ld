/* libc */
strcat	= 0x80165fd4;
strncmp	= 0x80166070;
strncpy	= 0x80166148;
strchr	= 0x80166218;
strrchr	= 0x801662a8;
strstr	= 0x801662c8;
strcasecmp	= 0x8016631c;
strncasecmp	= 0x8016639c;
memchr	= 0x801663fc;
tolower	= 0x80166578;
toupper	= 0x80166598;
isalnum	= 0x801665b8;
isalpha	= 0x801665d0;
isascii	= 0x801665e8;
iscntrl	= 0x801665f0;
isdigit	= 0x80166608;
isgraph	= 0x80166620;
islower	= 0x80166638;
isprint	= 0x80166650;
ispunct	= 0x80166668;
isspace	= 0x80166680;
isupper	= 0x80166698;
isxdigit	= 0x801666b0;
toascii	= 0x801666c8;
_tolower	= 0x801666d0;
_toupper	= 0x801666d8;
isnan	= 0x80166718;
isinf	= 0x80166764;
strtol	= 0x801667b4;
strtoul	= 0x801669a4;

sbrk    = 0x8024198c;	/* TODO: exposing and using sbrk might be dangerous? */

malloc	= 0x80241c4c;
free	= 0x8024285c;
realloc	= 0x80242920;
calloc	= 0x80242bd8;

vsnprintf	= 0x8024466c;
sprintf	= 0x80244720;
vprintf	= 0x802447c8;
printf	= 0x80244808;
snprintf	= 0x80244830;
vsprintf	= 0x80244850;
rand	= 0x80244900;
memcpy	= 0x802449b4;
memset	= 0x80244be4;
memcmp	= 0x80244cc4;
memmove	= 0x80244d28;
strcpy	= 0x80244df4;
strcmp	= 0x80244e34;
strlen	= 0x80244e78;
atoi	= 0x80244ea0;
time	= 0x80245148;
localtime	= 0x80245390;
vsscanf	= 0x80246764;
sscanf	= 0x802467a4;

/* these are actually fs_ variants but ABI is the same */
open	= 0x8025b78c;
read	= 0x8025bb84;
write	= 0x8025bca8;
lseek	= 0x8025bdc8;
close	= 0x8025bf08;

fs_access = 0x8025ba1c;

fs_fstat = 0x8025bab4;
fs_stat  = 0x8025bad8;
fs_mkdir = 0x8025b8e8;

fs_opendir  = 0x8025b85c;
fs_closedir = 0x8025bf24;
fs_readdir  = 0x8025be6c;

fs_sync = 0x8025b664;

strdup	= 0x802628c0; /* only needed for vfs it seems */
fclose	= 0x80262974;
fflush	= 0x80262ae4; /* actually __fflush but sufficiently close */
fopen	= 0x80262f58;
fw_fread = 0x80263138;
fseeko	= 0x80263280;
ftell	= 0x802fc2c4;
ftello	= 0x802639b4;
fwrite	= 0x80263c60;
fgets	= 0x80262c40;

/* TDS2 */
osal_tds2_cache_flush	= 0x800491e8;
os_disable_interrupt	= 0x802901cc;
os_enable_interrupt	= 0x802901f4;

dly_tsk	= 0x802beefc;

os_get_tick_count = 0x802bf944;

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

retro_video_refresh_cb	= 0x8030c960;
retro_audio_sample_batch_cb	= 0x8030c9e8;
retro_input_poll_cb	= 0x8030cc20;
retro_input_state_cb	= 0x8030cd10;
retro_environment_cb	= 0x8030cd54;

run_emulator	= 0x8030d008;
run_gba			= 0x8030e4bc;

/* .rodata */

_ctype_	= 0x80660d34;

/* .data */
RAMSIZE	= 0x806f5e84;

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
gp_buf_64m	= 0x806f9020;

/* HiChip's hardware wired to LCD for UARTless debug.c */
PINMUXL	= 0xb88004a0;
PINMUXT	= 0xb8800500;
GPIOLCTRL	= 0xb8800044;
GPIOTCTRL	= 0xb8800344;