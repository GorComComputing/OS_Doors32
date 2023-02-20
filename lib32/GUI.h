#ifndef GUI_H
#define GUI_H

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;


typedef struct Window{
    int PID;
    char caption[20];// = "Form 1";
    int x;
    int y;
    int width;
    int height;
    int BC;
    int visible;
    //bool onFocus;
    int (*onCreate)();
    int (*onClose)();
    int (*onFormClick)();
} TWindow;

#define STANDART 0xD8DCC0//0x1F


void DrawDesktop(uint32 BC);
void DrawTaskbar(int x, int y, int sizeX, int sizeY, uint32 BC);
void DrawWindow(TWindow Form);


#endif // GUI_H
