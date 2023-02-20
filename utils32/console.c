#include "../drivers32/screen.h"

#include "../lib32/BGL.h"
#include "../lib32/GUI.h"
#include "../lib32/string.h"

#include "console.h"

static TWindow Form1;

#define MAX_ROWS_C 25
#define MAX_COLS_C 80

size_t console_row;
size_t console_column;
uint32 console_CC;
uint32 console_BC;
uint32* console_buffer;

char hello[] = "DOORS TERMINAL";



// Консоль
void ProcConsole(){
    //Form1.caption = "LINES";
    Form1.x = 50;
    Form1.y = 20;
    Form1.width = 560+6;//140+6;
    Form1.height = 200 + 17+2+1;//80 + 17+2+1;
    Form1.BC = STANDART;

    DrawWindow(Form1);

    console_initialize();
}


// Инициализация консоли
void console_initialize(void){
    console_row = 0;
    console_column = 0;
    console_CC = 0xF4CA16;//COLOR_YELLOW;
    console_BC = 0x000000;//COLOR_BLACK;
    console_buffer = (uint32*)(GRAPHIC_ADDRESS + (Form1.y + 18)*BITMAP_WIDTH + Form1.x + 2);//(0xA0000 + (Form1.y + 18)*BITMAP_WIDTH + Form1.x + 2);

    SetColor(console_BC);
    struct tPoint p[4];

    p[0].x = Form1.x + 2;
    p[0].y = Form1.y + 17;

    p[1].x = Form1.x + Form1.width - 3;
    p[1].y = Form1.y + 17;

    p[2].x = Form1.x + Form1.width - 3;
    p[2].y = Form1.y + Form1.height - 2;

    p[3].x = Form1.x + 2;
    p[3].y = Form1.y + Form1.height - 2;

    FillPoly(4, p);


    cons_prints(hello, strlen(hello));
    printprompt();

    /*char pro[] = "TOR";
    cons_prints(pro, strlen(pro));*/
}


// Прокрутка терминала
void console_scroll(){
    for(int k = 0; k < 8; k++){
    for(int i = 0; i < MAX_ROWS_C*8; i++){
        for(int m = 0; m < Form1.width - 3; m++){
                console_buffer[i*BITMAP_WIDTH + m] = console_buffer[(i + 1)*BITMAP_WIDTH + m];
        }
        for(int m = 0; m < Form1.width - 4; m++){
                //PutPixel(Form1.x + 2 + m, y + i, console_BC);
                console_buffer[(Form1.height - 3 - 17)*BITMAP_WIDTH + m] = console_BC;
        }
        //console_row--;
    }
    }
    console_row = MAX_ROWS_C - 1;
}


//
void console_putentryat(char c, uint32 color, size_t x, size_t y){
    SetColor(console_BC);
    struct tPoint p[4];

    p[0].x = Form1.x + 3 + x*7;
    p[0].y = Form1.y + 18 + y*8;

    p[1].x = Form1.x + 3 + x*7 + 7;
    p[1].y = Form1.y + 18 + y*8;

    p[2].x = Form1.x + 3 + x*7 + 7;
    p[2].y = Form1.y + 18 + y*8 + 8;

    p[3].x = Form1.x + 3 + x*7;
    p[3].y = Form1.y + 18 + y*8 + 8;

    FillPoly(4, p);

    SetColor(color);
    char str[2] = {c,'\0'};
    TextOutgl(str, Form1.x + 3 + x*7, Form1.y + 19 + y*8, 1);
}


//
void console_putchar(char c){
    if(c == '\n' || c == '\r'){
        console_column = 0;
        console_row++;
        //console_putentryat('Z', console_CC, console_row, console_column);
        if(console_row == MAX_ROWS_C)
            console_scroll();
        return;
    }
    else if(c == '\t'){
        console_column += 4;
        return;
    }
    else if(c == '\b'){
        if(console_column){
            console_putentryat(' ', console_CC, console_column--, console_row);
            console_putentryat(' ', console_CC, console_column, console_row);
        }
        return;
    }

    console_putentryat(c, console_CC, console_column, console_row);
    if(++console_column == MAX_COLS_C){
        console_column = 0;
        if(++console_row == MAX_ROWS_C){
            console_row = 0;
        }
    }
}


//
void console_write(const char* data, size_t size){
    for(size_t i = 0; i < size; i++)
        console_putchar(data[i]);
}


//
int cons_putchar(int ic){
    char c = (char)ic;
    console_write(&c, sizeof(c));

    return ic;
}


//
int get_console_row(void){
    return console_row;
}


//
int get_console_col(void){
    return console_column;
}


//
void cons_prints(const char* data, size_t data_length){
    for(size_t i = 0; i < data_length; i++)
        cons_putchar((int)((const unsigned char*)data)[i]);
}


//
void mov_cursor(int row, int col){
    console_putentryat('Y', console_CC, row, col);
}


// Печатает приглашение ввода
void printprompt(void){
    char prompt[] = "\n>";
    cons_prints(prompt, strlen(prompt));
    //(console_row, console_column);
}
