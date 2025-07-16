#ifndef __STOCKFW_H
#define __STOCKFW_H

#include <stdbool.h>
#include <stdint.h>

#define FS_O_RDONLY     0x0000
#define FS_O_WRONLY     0x0001
#define FS_O_RDWR       0x0002
#define FS_O_APPEND     0x0008
#define FS_O_CREAT      0x0100
#define FS_O_TRUNC      0x0200

typedef int BOOL;
typedef uintptr_t HANDLE;

int fs_open(const char *path, int oflag, int perms);
int fs_close(int fd);
int64_t fs_lseek(int fd, int64_t offset, int whence);
ssize_t fs_read(int fd, void *buf, size_t nbyte);
ssize_t fs_write(int fd, const void *buf, size_t nbyte);

extern size_t fw_fread(void *ptr, size_t size, size_t count, FILE *stream);

extern int fs_access(const char *path, int mode);

extern int fs_stat(const char *path, void *sbuf);
extern int fs_fstat(int fd, void *sbuf);
extern int fs_sync(const char *path);
extern int fs_mkdir(const char *path, int mode);

extern int fs_opendir(const char *path);
extern int fs_closedir(int fd);
extern ssize_t fs_readdir(int fd, void *buffer);

extern void osal_tds2_cache_flush(void *buf, unsigned sz);
extern void os_disable_interrupt(void);
extern void os_enable_interrupt(void);

extern int dly_tsk(unsigned ms);

extern uint32_t os_get_tick_count(void);

extern HANDLE dev_get_by_id(uint32_t, uint16_t);

extern int run_emulator(int load_state);
extern void run_gba(const char *filename, int load_state);

extern void retro_video_refresh_cb(const void *data, unsigned width, unsigned height, size_t pitch);
extern size_t retro_audio_sample_batch_cb(const int16_t *data, size_t frames);
extern void retro_input_poll_cb(void);
extern int16_t retro_input_state_cb(unsigned port, unsigned device, unsigned index, unsigned id);
extern bool retro_environment_cb(unsigned cmd, void *data);

/* .data */

struct retro_system_av_info;
struct retro_game_info;

extern unsigned RAMSIZE;

extern int (* gfn_state_load)(const char *);
extern int (* gfn_state_save)(const char *);

extern unsigned (* gfn_retro_get_region)(void);
extern void (* gfn_get_system_av_info)(struct retro_system_av_info *info);
extern bool (* gfn_retro_load_game)(const struct retro_game_info *game);
extern void (* gfn_retro_unload_game)(void);
extern void (* gfn_retro_run)(void);
extern void (* gfn_frameskip)(BOOL flag);

extern int g_snd_task_flags;

extern struct retro_game_info g_retro_game_info;
extern const unsigned g_run_file_size;
extern void * gp_buf_64m;

extern uint32_t g_joy_task_state;
extern uint32_t g_joy_state;

#endif
