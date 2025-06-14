#ifndef __CORE_API_H
#define __CORE_API_H

struct retro_core_t
{
   void (*retro_init)(void);
   void (*retro_deinit)(void);
   unsigned (*retro_api_version)(void);
   void (*retro_get_system_info)(struct retro_system_info*);
   void (*retro_get_system_av_info)(struct retro_system_av_info*);
   void (*retro_set_environment)(retro_environment_t);
   void (*retro_set_video_refresh)(retro_video_refresh_t);
   void (*retro_set_audio_sample)(retro_audio_sample_t);
   void (*retro_set_audio_sample_batch)(retro_audio_sample_batch_t);
   void (*retro_set_input_poll)(retro_input_poll_t);
   void (*retro_set_input_state)(retro_input_state_t);
   void (*retro_set_controller_port_device)(unsigned, unsigned);
   void (*retro_reset)(void);
   void (*retro_run)(void);
   size_t (*retro_serialize_size)(void);
   bool (*retro_serialize)(void*, size_t);
   bool (*retro_unserialize)(const void*, size_t);
   void (*retro_cheat_reset)(void);
   void (*retro_cheat_set)(unsigned, bool, const char*);
   bool (*retro_load_game)(const struct retro_game_info*);
   bool (*retro_load_game_special)(unsigned, const struct retro_game_info*, size_t);
   void (*retro_unload_game)(void);
   unsigned (*retro_get_region)(void);
   void *(*retro_get_memory_data)(unsigned);
   size_t (*retro_get_memory_size)(unsigned);
};

typedef struct retro_core_t *(*core_entry_t)(void);

#ifdef DBLCHERRY_SAVE
//Custom functions manually added do doublecherry's libretro.h
//It's hacky, but is the best we can do for now ...
int retro_dblchry_emulated_count();
size_t retro_dblchry_get_sram_size(int slot);
void *retro_dblchry_get_sram_ptr(int slot);
#endif

#endif
