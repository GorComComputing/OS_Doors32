#ifndef CONSOLE_H
#define CONSOLE_H

void ProcConsole();
void console_initialize(void);
void console_scroll();
void console_putentryat(char c, uint32 color, size_t x, size_t y);
void console_putchar(char c);
void console_write(const char* data, size_t size);
int cons_putchar(int ic);
void cons_prints(const char* data, size_t data_length);

void mov_cursor(int row, int col);
void printprompt(void);

#endif

