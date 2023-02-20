#ifndef SCREEN_H
#define SCREEN_H

//Для графики/////////////////////////////////////////////////////////////////
//#define GRAPHIC_ADDRESS 0x51000000//0xA0000  Батя
//#define GRAPHIC_ADDRESS 0xE0000000//-0x20000//0xA0000  Мой реальный комп
//#define GRAPHIC_ADDRESS 0xFD000000//0xA0000    QEMU
#define GRAPHIC_ADDRESS 0xD0000000//-0x20000//0xA0000  Мой реальный комп
#define BITMAP_WIDTH 1280//320//800 //960    // Размеры экрана
#define BITMAP_HEIGHT 1024//200//600 //480
#define SIZE BITMAP_WIDTH*BITMAP_HEIGHT  // Размер видеобуфера
#define GETMAX_X BITMAP_WIDTH - 1 // Координаты последней точки
#define GETMAX_Y BITMAP_HEIGHT - 1
//////////////////////////////////////////////////////////////////////////////

//Для текста//////////////////////////////////////////////////////////////////
#define MAX_ROWS 25
#define MAX_COLS 80
// Байт-аттрибут для схемы по умолчанию
#define WHITE_ON_BLACK 0x0f
// Порты экрана
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

#define VGA_ADDRESS 0xB8000//-0x20000
#define BUFSIZE 2200
//////////////////////////////////////////////////////////////////////////////

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;

typedef unsigned int size_t;



#define NULL 0

enum vga_color {
	COLOR_BLACK = 0,
	COLOR_BLUE = 1,
	COLOR_GREEN = 2,
	COLOR_CYAN = 3,
	COLOR_RED = 4,
	COLOR_MAGENTA = 5,
	COLOR_BROWN = 6,
	COLOR_LIGHT_GREY = 7,
	COLOR_DARK_GREY = 8,
	COLOR_LIGHT_BLUE = 9,
	COLOR_LIGHT_GREEN = 10,
	COLOR_LIGHT_CYAN = 11,
	COLOR_LIGHT_RED = 12,
	COLOR_LIGHT_MAGENTA = 13,
	COLOR_YELLOW = 14,
	COLOR_WHITE = 15,
};


static inline uint8 make_color(enum vga_color fg, enum vga_color bg);
static inline uint16 make_vgaentry(char c, uint8 color);
void terminal_initialize(void);
void terminal_scroll();
void terminal_putentryat(char c, uint8 color, size_t x, size_t y);
void terminal_putchar(char c);
void terminal_write(const char* data, size_t size);
int putchar(int ic);
void prints(const char* data, size_t data_length);
int printf(const char* format, ...);
int get_terminal_row(void);
int get_terminal_col(void);


int get_screen_offset(int col, int row);
void print_char(char character, int col, int row, char attribute_byte);
int get_cursor();
void set_cursor(int offset);
void print_at(char* message, int col, int row);
void print(char* message);
void clear_screen();
int handle_scrolling(int cursor_offset);

uint16 vga_entry(unsigned char ch, uint8 fore_color, uint8 back_color);
void clear_screen();
void move_cursor();

void FillLB(int start, int count, uint32 value); //char
uint32 GetPixelgl(int x, int y);

#endif

