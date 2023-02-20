//  Драйвер экрана
#include "screen.h"
#include "../kernel32/kernel.h"
#include "../kernel32/memory.h"
#include "../kernel32/low_level.h"

#include "../lib32/string.h"

static uint16* const VGA_MEMORY = (uint16*)VGA_ADDRESS;//0xB8000;
size_t terminal_row;
size_t terminal_column;
uint8 terminal_color;
uint16* terminal_buffer;

uint32 cur_x = 20;  // Позиция курсора
uint32 cur_y = 3;


// Создает байт цвета для 16 цветов
static inline uint8 make_color(enum vga_color fg, enum vga_color bg){
    return fg | bg << 4;
}


// Создает символ с цветом (2 байта)
static inline uint16 make_vgaentry(char c, uint8 color){
    uint16 c16 = c;
    uint16 color16 = color;
    return c16 | color16 << 8;
}


// Инициализация терминала
void terminal_initialize(void){
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = make_color(COLOR_LIGHT_GREY, COLOR_BLACK);
    terminal_buffer = VGA_MEMORY;
    for(size_t y = 0; y < MAX_ROWS; y++){
        for(size_t x = 0; x < MAX_COLS; x++){
            const size_t index = y*MAX_COLS + x;
            terminal_buffer[index] = make_vgaentry(' ', terminal_color);
        }
    }
}


// Прокрутка терминала
void terminal_scroll(){
    for(int i = 0; i < MAX_ROWS; i++){
        for(int m = 0; m < MAX_COLS; m++){
            terminal_buffer[i*MAX_COLS + m] = terminal_buffer[(i + 1)* MAX_COLS + m];
        }
        terminal_row--;
    }
    terminal_row = MAX_ROWS - 1;
}


//
void terminal_putentryat(char c, uint8 color, size_t x, size_t y){
    const size_t index = y*MAX_COLS + x;
    terminal_buffer[index] = make_vgaentry(c, color);
}


//
void terminal_putchar(char c){
    if(c == '\n' || c == '\r'){
        terminal_column = 0;
        terminal_row++;
        if(terminal_row == MAX_ROWS)
            terminal_scroll();
        return;
    }
    else if(c == '\t'){
        terminal_column += 4;
        return;
    }
    else if(c == '\b'){
        terminal_putentryat(' ', terminal_color, terminal_column--, terminal_row);
        terminal_putentryat(' ', terminal_color, terminal_column, terminal_row);
        return;
    }

    terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
    if(++terminal_column == MAX_COLS){
        terminal_column = 0;
        if(++terminal_row == MAX_ROWS){
            terminal_row = 0;
        }
    }
}


//
void terminal_write(const char* data, size_t size){
    for(size_t i = 0; i < size; i++)
        terminal_putchar(data[i]);
}


//
int putchar(int ic){
    char c = (char)ic;
    terminal_write(&c, sizeof(c));
    return ic;
}


//
void prints(const char* data, size_t data_length){
    for(size_t i = 0; i < data_length; i++)
        putchar((int)((const unsigned char*)data)[i]);
}


//
/*int printf(const char* format, ...){
    va_list parameters;
    va_start(parameters, format);

    int written = 0;
    size_t amount;
    int rejected_bad_specifier = 0;

    while(*format != '\0'){
        if(*format != '%'){
            print_c:
                amount = 1;
                while(format[amount] && format[amount] != '%')
                    amount++;
                prints(format, amount);
                format += amount;
                written += amount;
                continue;
        }

        const char* format_begun_at = format;

        if(*(++format) == '%')
            goto print_c;

        if(rejected_bad_specifier){
            incomprehensible_conversion:
                rejected_bad_specifier = 1;
                format = format_begun_at;
                goto print_c;
        }

        if(*format == 'c'){
            format++;
            char c = (char)va_arg(parameters, int );  //char promotes to int
           prints(&c, sizeof(c));
        }
        else if(*format == 's'){
            format++;
            const char* s = va_arg(parameters, const char*);
            prints(s, strlen(s));
        }
        else{
            goto incomprehensible_conversion;
        }
    }
    va_end(parameters);
    return written;
}*/


//
int get_terminal_row(void){
    return terminal_row;
}


//
int get_terminal_col(void){
    return terminal_column;
}


// Перемещает курсор
void move_cursor(){
	unsigned short temp;
	temp = cur_y*80 + cur_x;

	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, temp >> 8);
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, temp);

	//uint16* video_memory = (uint16*)VGA_ADDRESS;
    //video_memory[cur_x] = 0x4241;
}


uint16 vga_entry(unsigned char ch, uint8 fore_color, uint8 back_color){
	uint16 ax = 0;
	uint8 ah = 0;
	uint8 al = 0;
	ah = back_color;
	ah <<= 4;
	ah |= fore_color;
	al = ch;
	ax = ah;
	ax <<= 8;
	ax |= al;

	//asm ("int $0x01 \n");

	return ax;
}


// Очистка экрана
/*void clear_screen(){
    uint16* video_memory = (uint16*)VGA_ADDRESS;

	for(int i = 0; i < 80*25; i++)
        video_memory[i] = vga_entry(' ', WHITE, BLACK);

	cur_x = 0;
	cur_y = 0;
	move_cursor();
}*/


// Печатает символ в позиции курсора
void print_char(char character, int col, int row, char attribute_byte){
	// Указатель на начало видеопамяти
	unsigned char *video_memory = (unsigned char*) VGA_ADDRESS;
	// если атрибут = 0, присвоим стиль по умолчанию
	if (!attribute_byte)
		attribute_byte = WHITE_ON_BLACK;

	// получим смещение в видеопамяти
	int offset;
	if(col >= 0 && row >= 0)
		offset = get_screen_offset(col, row);
	else // иначе используем текущую позицию курсора
		offset = get_cursor();

    // символ новой строки
	if(character == '\n'){
		int rows = offset/(2*MAX_COLS);
		offset = get_screen_offset(79, rows);
	}
	else{ // иначе записываем символ и атрибут в видеопамять по смещению
		video_memory[offset] = character;
		video_memory[offset+1] = attribute_byte;
	}

	// увеличиваем смещение на 2 байта
	offset += 2;
	// делаем скролинг, если ушли за нижнюю границу
	offset = handle_scrolling(offset);
	// обновим позицию курсора
	set_cursor(offset);
}


// Получаем из координат смещение в видеопамяти
int get_screen_offset(int col, int row){
	return (row*80 + col)*2;
}


// Получить позицию курсора
int get_cursor(){
    // регистр используется в качестве индекса для выбора внутренних регистров
    // reg 14: старший байт смещения курсора
    // reg 15: младший байт смещения курсора
    // как только внутренний регистр выбран, мы можем прочитаь или записать байт в регистр данных
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    // умножаем на 2, чтобы преобразовать позицию на экране в ячейки памяти
    return offset*2;
}


// Установить позицию курсора
void set_cursor(int offset){
    // Преобразовать смещение ячейки в смещение символа.
    // Это похоже на get_cursor, только теперь мы пишем
    // байты в эти внутренние регистры устройства.
	offset /= 2;
	port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)offset);
}


// печатает строку в указанную позицию
// если col и row = -1, печатает строку в позицию курсора
void print_at(char* message, int col, int row){
	// Изменяем курсор, если col и row больше нуля
	if(col >= 0 && row >= 0)
		set_cursor(get_screen_offset(col, row));

	int i = 0;
	// Печатаем каждый символ
	while(message[i] != 0)
		print_char(message[i++], -1, -1, WHITE_ON_BLACK);
}


// печатает строку в позицию курсора
void print(char* message){
	print_at(message, -1, -1);
}


// Очистка экрана
void clear_screen(){
	int row = 0;
	int col = 0;
	// Заполняем пробелами видеопамять
	for(row = 0; row < MAX_ROWS; row++)
		for(col = 0; col < MAX_COLS; col++)
			print_char(' ', col, row, WHITE_ON_BLACK);

	// Перемещаем курсор на начало
	set_cursor(get_screen_offset(0,0));
}


// Прокрутка экрана
int handle_scrolling(int cursor_offset){
    // если курсор на экране, вернем то же значение
    if(cursor_offset < MAX_ROWS*MAX_COLS*2)
        return cursor_offset;

    // сдвигаем строки вверх
    for(int i = 1; i < MAX_ROWS; i++)
        memory_copy((uint8*)(get_screen_offset(0, i) + VGA_ADDRESS), (uint8*)(get_screen_offset(0, i - 1) + VGA_ADDRESS), MAX_COLS*2);


    // очищаем последнюю строку
    /*uint8* last_line = (uint8*)0xB8780;//(uint8*)(get_screen_offset(30, 24) + VGA_ADDRESS);
    for(int i = 34; i < 39; i++){
        last_line[i++] = 0x32;
        last_line[i] = 0x1F;
    }*/



	uint16* video_memory = (uint16*)(get_screen_offset(0, 24) + VGA_ADDRESS);
	for(int i = 0; i < MAX_COLS; i++)
		video_memory[i] = vga_entry('3', COLOR_WHITE, COLOR_BLUE);



    // устанавливаем смещение на начало последней строки
    //cursor_offset = ((int)(get_screen_offset(10, 10)));//cursor_offset - 2*MAX_COLS;
    return get_screen_offset(0, 24);//cursor_offset;
}

/*
// Заполняет видеобуфер
void FillLB(int start, int count, char value){
    uint8* video_memory = (uint8*)GRAPHIC_ADDRESS;
    for(int i = start; i <= start+count-1; i++)
        video_memory[i] = value;
}*/


// Заполняет видеобуфер
void FillLB(int start, int count, uint32 value){
    uint32* video_memory = (uint32*)GRAPHIC_ADDRESS;
    for(int i = start; i <= start+count-1; i++)
        video_memory[i] = value;
}


// Получает цвет пикселя
uint32 GetPixelgl(int x, int y){
    uint32* video_memory = (uint32*)GRAPHIC_ADDRESS;
    return video_memory[y*BITMAP_WIDTH + x];
}


































