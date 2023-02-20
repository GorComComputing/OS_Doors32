#include "GUI.h"
#include "../drivers32/screen.h"
#include "BGL.h"


#define MAX_WINDOW 10
TWindow* mas_window[MAX_WINDOW] = {NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};


// Рабочий стол
void DrawDesktop(uint32 BC){
    SetColor(BC);
    struct tPoint p[4];

    p[0].x = 0;
    p[0].y = 0;

    p[1].x = BITMAP_WIDTH-1;
    p[1].y = 0;

    p[2].x = BITMAP_WIDTH-1;
    p[2].y = BITMAP_HEIGHT-1;

    p[3].x = 0;
    p[3].y = BITMAP_HEIGHT-1;

    FillPoly(4, p);

    /*uint32 beginBMP = *(uint32*)(0xAA00+0x0A);
    uint32* bmpP = (uint32*)(0xAA00 + beginBMP);
    uint32* vid = (uint32*)0xA0000+320*200-29*320;
    while(vid > (char*)(0xA0000))
        *vid-- = *bmpP++;*/


}


// Панель задач
void DrawTaskbar(int x, int y, int sizeX, int sizeY, uint32 BC){
    SetColor(BC);
    struct tPoint p[4];

    p[0].x = x;
    p[0].y = y;

    p[1].x = x + sizeX;
    p[1].y = y;

    p[2].x = x + sizeX;
    p[2].y = y + sizeY;

    p[3].x = x;
    p[3].y = y + sizeY;

    FillPoly(4, p);

    SetColor(0xFFFFFF);//(uint8)0x0F);
    SetBackColor(BC);
    char start[] = "START\0";
    TextOutgl(start, x + 8, y + 8, 1);


    SetColor(0xFFFFFF);//(uint8)0x0F);
    SetBackColor(BC);
    char time[] = "18:34\0";
    TextOutgl(time, x - 42, y + 8, 1);

    SetColor(0xA0DC88);//(uint8)0x4A);
    LinePP(x, y - 1, sizeX + 2, y - 1);
    LinePP(x, y - 1, x, y + sizeY - 2);
    SetColor(0x80C848);//(uint8)0x32);
    LinePP(x+1, y, sizeX + 2, y);
    LinePP(x+1, y, x+1, y + sizeY - 2);
    SetColor(0x089000);//(uint8)0x76);
    LinePP(x+2, y + sizeY - 3, sizeX + 2, y + sizeY - 3);
    LinePP(x + sizeX - 1, y, x+ sizeX - 1, y + sizeY - 3);
    SetColor(0x005C00);//(uint8)0xC1);
    LinePP(x, y + sizeY - 2, sizeX + 2, y + sizeY - 2);
    LinePP(x + sizeX, y - 1, x + sizeX, y + sizeY - 2);




    /*int count = 0;
    for(int id = 0; id < MAX_WINDOW; id++){
        if((mas_window[id] != NULL) && (mas_window[id]->visible == 1)){
            SetColor(0x50A0F8);

            p[0].x = x + 8 + 70 + 70*count;
            p[0].y = y + 2;

            p[1].x = x + 70 + 70 + 70*count;
            p[1].y = y + 2;

            p[2].x = x + 70 + 70 + 70*count;
            p[2].y = y + sizeY - 2;

            p[3].x = x + 8 + 70 + 70*count;
            p[3].y = y + sizeY - 2;

            FillPoly(4, p);

            SetColor(0x0F);
            SetBackColor(0x50A0F8);
            TextOutgl(mas_window[id]->caption, x + 8 + 70 + 70*count + 10, y + 8, 1);

            count++;
        }
    }*/
}


// Окно
void DrawWindow(TWindow Form){
    SetColor(Form.BC);
    struct tPoint p[4];

    p[0].x = Form.x;
    p[0].y = Form.y;

    p[1].x = Form.x + Form.width - 1;
    p[1].y = Form.y;

    p[2].x = Form.x + Form.width - 1;
    p[2].y = Form.y + Form.height;

    p[3].x = Form.x;
    p[3].y = Form.y + Form.height;

    FillPoly(4, p);

    SetColor(0x0055E5);//0x50);
    p[0].x = Form.x + 2;
    p[0].y = Form.y + 2;

    p[1].x = Form.x + Form.width - 2;
    p[1].y = Form.y + 2;

    p[2].x = Form.x + Form.width - 2;
    p[2].y = Form.y + 15 + 2;

    p[3].x = Form.x + 2;
    p[3].y = Form.y + 15 + 2;

    FillPoly(4, p);


    SetColor(0xFFFFFF);//0x0F);
    SetBackColor(0x0055E5);//0x50);
    char caption[] = "WINDOW\0";
    TextOutgl(caption, Form.x + 4, Form.y + 6, 1);

    SetColor(0xF8FCF8);//(uint8)0x0F);
    LinePP(Form.x, Form.y + 1, Form.x + Form.width - 1, Form.y + 1);
    LinePP(Form.x, Form.y + 1, Form.x, Form.y + Form.height);
    SetColor(0xE0E0E0);//(uint8)0x1E);
    LinePP(Form.x+1, Form.y + 2, Form.x + Form.width - 1, Form.y + 2);
    LinePP(Form.x+1, Form.y + 2, Form.x+1, Form.y + Form.height);
    SetColor(0x787C78);//(uint8)0x19);
    LinePP(Form.x+2, Form.y + Form.height - 1, Form.x + Form.width - 1, Form.y + Form.height - 1);
    LinePP(Form.x + Form.width - 2, Form.y + 2, Form.x + Form.width - 2, Form.y + Form.height - 2);
    SetColor(0x000000);//(uint8)0x00);
    LinePP(Form.x, Form.y + Form.height, Form.x + Form.width - 1, Form.y + Form.height);
    LinePP(Form.x + Form.width - 1, Form.y + 1, Form.x + Form.width - 1, Form.y + Form.height - 1);


    /*showBMP(BtnMin, Form.x + Form.width - 2-14*3, Form.y + 1, 14, 14);
    showBMP(BtnMax, Form.x + Form.width - 2-14*2, Form.y + 1, 14, 14);
    showBMP(BtnClose, Form.x + Form.width - 2-14, Form.y, 14, 14);*/
}




