#ifndef __BSOD_DEBUG_H
#define __BSOD_DEBUG_H

#ifdef __cplusplus
extern "C" {
#endif

void lcd_pinmux_gpio(void);
void lcd_send_cmd(unsigned char);
void lcd_send_data(unsigned short);

void lcd_init();
void lcd_bsod(const char *fmt, ...) __attribute__((noreturn));

void dbg_show_noblock(unsigned short text_color, unsigned short background_color, const char *fmt, ...);

void xlog_clear();
void xlog(const char *fmt, ...);
#define XLOG(format, ...) xlog("%s:%d:%s " format, __FILE__, __LINE__, __func__, ##__VA_ARGS__)

#ifdef __cplusplus
}
#endif

#endif
