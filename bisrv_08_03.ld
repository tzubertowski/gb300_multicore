/* libc */
strcat	= 0x801b4dd4;
strncmp	= 0x801b4e70;
strncpy	= 0x801b4f48;
strchr	= 0x801b5018;
strrchr	= 0x801b50a8;
strstr	= 0x801b50c8;
strcasecmp	= 0x801b511c;
strncasecmp	= 0x801b519c;
memchr	= 0x801b51fc;
tolower	= 0x801b5378;
toupper	= 0x801b5398;
isalnum	= 0x801b53b8;
isalpha	= 0x801b53d0;
isascii	= 0x801b53e8;
iscntrl	= 0x801b53f0;
isdigit	= 0x801b5408;
isgraph	= 0x801b5420;
islower	= 0x801b5438;
isprint	= 0x801b5450;
ispunct	= 0x801b5468;
isspace	= 0x801b5480;
isupper	= 0x801b5498;
isxdigit	= 0x801b54b0;
toascii	= 0x801b54c8;
_tolower	= 0x801b54d0;
_toupper	= 0x801b54d8;
isnan	= 0x801b5518;
isinf	= 0x801b5564;
strtol	= 0x801b55b4;
strtoul	= 0x801b57a4;

sbrk    = 0x8028fd20;	/* TODO: exposing and using sbrk might be dangerous? */

malloc	= 0x8028ffe0;
free	= 0x80290bf0;
realloc	= 0x80290cb4;
calloc	= 0x80290f6c;

vsnprintf	= 0x80292a00;
sprintf	= 0x80292ab4;
vprintf	= 0x80292b5c;
printf	= 0x80292b9c;
snprintf	= 0x80292bc4;
vsprintf	= 0x80292be4;
rand	= 0x80292c94;
memcpy	= 0x80292d48;
memset	= 0x80292f78;
memcmp	= 0x80293058;
memmove	= 0x802930bc;
strcpy	= 0x80293188;
strcmp	= 0x802931c8;
strlen	= 0x8029320c;
atoi	= 0x80293234;
time	= 0x802934dc;
localtime	= 0x80293724;
vsscanf	= 0x80294af8;
sscanf	= 0x80294b38;

/* these are actually fs_ variants but ABI is the same */
open	= 0x802aa134;
read	= 0x802aa52c;
write	= 0x802aa650;
lseek	= 0x802aa770;
close	= 0x802aa8b0;

fs_access = 0x802aa3c4;

fs_fstat = 0x802aa45c;
fs_stat  = 0x802aa480;
fs_mkdir = 0x802aa290;

fs_opendir  = 0x802aa204;
fs_closedir = 0x802aa8cc;
fs_readdir  = 0x802aa814;

fs_sync = 0x802aa00c;

strdup	= 0x802b1268; /* only needed for vfs it seems */
fclose	= 0x802b131c;
fflush	= 0x802b148c; /* actually __fflush but sufficiently close */
fopen	= 0x802b1900;
fw_fread = 0x802b1abc; /* ali_fread */
fseeko	= 0x802b1c28;
ftell	= 0x802b2340; /* ali_ftell */
ftello	= 0x802b235c;
fwrite	= 0x802b26d0; /* ali_fwrite */
fgets	= 0x802b15e8;

/* TDS2 */
osal_tds2_cache_flush	= 0x80049214;
os_disable_interrupt	= 0x802deb74;
os_enable_interrupt	= 0x802deb9c;

dly_tsk	= 0x8030d8a4;

os_get_tick_count = 0x8030e2ec;

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

st7789v_caset_raset	= 0x8029edc4;
st7789v_ramwr	= 0x8029ee68;

/* libretro frontend */
run_osd_region_write	= 0x8035ac28;
run_screen_write	= 0x8035aca4; /* dispFlip */
run_sound_advance	= 0x8035adb4; /* sound_driver_play */

retro_video_refresh_cb	= 0x8035c1d4; /* DrawFrame */
retro_audio_sample_batch_cb	= 0x8035c25c; /* PlayFrame */
retro_input_poll_cb	= 0x8035c4b4; /* joystick_poll */
retro_input_state_cb	= 0x8035c5a4; /* joystick_input */
retro_environment_cb	= 0x8035c5e8; /* environment */

run_emulator	= 0x8035c89c; /* Load_Proc2 */
run_gba			= 0x8035de78; /* GpspLoad */

/* .rodata */

_ctype_	= 0x809f52fc;

/* .data */
RAMSIZE	= 0x80c591bc;

g_errno	= 0x80c599a0; /* errno */

g_snd_task_flags	= 0x80c5ab64; /* Soundplayflag */

g_retro_game_info	= 0x80c5acec; /* game */

gfn_state_load	= 0x80c5ffb8; /* _load_state */
gfn_state_save	= 0x80c60010; /* _save_state */

gfn_retro_get_region	= 0x80c5ffec; /* _retro_get_region */
gfn_get_system_av_info	= 0x80c5fffc; /* _get_system_av_info */
gfn_retro_load_game		= 0x80c6001c; /* _retro_load_game */
gfn_retro_unload_game	= 0x80c60024; /* _retro_deinit */
gfn_retro_run	= 0x80c60034; /* _retro_run */
gfn_frameskip	= 0x80c60030; /* _SetFrameSkip */

g_run_file_size	= 0x80c5feac;
gp_buf_64m	= 0x80c60028; /* gp_rom_mem_buffer */

/* HiChip's hardware wired to LCD for UARTless debug.c */
PINMUXL	= 0xb88004a0;
PINMUXT	= 0xb8800500;
GPIOLCTRL	= 0xb8800044;
GPIOTCTRL	= 0xb8800344;