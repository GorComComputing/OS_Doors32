#include "../lib32/math.h"
#include "../lib32/BGL.h"
#include "../lib32/GUI.h"
#include "flag.h"

static TWindow Form1;

int t = 0;

unsigned char flag[] = \
    "                                                                                                                                 "
    "                                                                                                                                 "
    "                                                                                                                                 "
    "             ppppppppppp      ppppppp      pppppppppp      pppppppppp    ppp     ppp    ppppppppppp    pppppppppp                "
    "             ppppppppppp    ppppppppppp    ppppppppppp    ppppppppppp    ppp     ppp    ppppppppppp    ppppppppppp               "
    "             ppp            ppp     ppp    ppp     ppp    ppp     ppp    ppp     ppp    ppp            ppp     ppp               "
    "             ppp            ppp     ppp    ppp     ppp    ppp     ppp    ppp     ppp    ppp            ppp     ppp               "
    "             ppp            ppp     ppp    ppp     ppp    ppp     ppp    ppp     ppp    ppppppppppp    pppppppppp                "
    "             ppp            ppp     ppp    ppppppppppp    ppppppppppp    ppp     ppp    ppppppppppp    pppppppppp                "
    "             ppp            ppp     ppp    pppppppppp      pppppppppp     pppppppppp    ppp            ppp     ppp               "
    "             ppp            ppp     ppp    ppp                ppp ppp            ppp    ppp            ppp     ppp               "
    "             ppp            ppppppppppp    ppp              ppp   ppp            ppp    ppppppppppp    ppppppppppp               "
    "             ppp             ppppppppp     ppp            ppp     ppp            ppp    ppppppppppp    pppppppppp                "
    "                                                                                                                                 "
    "                                                                                                                                 "
    "                                                                                                                                 "
    "                                                                                                                                 "
    ;


// Рисует флаг
void ProcFlag(){
    //Form1.caption = "LINES";
    Form1.x = 50;
    Form1.y = 300;
    Form1.width = 133+20+20;
    Form1.height = 147 + 17+20+20;
    Form1.BC = 0x000000;
    //Form1.onFocus = true;

    DrawWindow(Form1);


    t += 20;
    if(t > 1000) t = 0;
    FlagF(Form1.x + 20, Form1.y + 18+20, 129, 17, 1, t);  //66
}


// Флаг Горячев
void FlagF(int x, int y, int sizeX, int sizeY, int scale, int t){
    int xstart = x;
    int ystart = y;
    SetBackColor(0x00);
    //ClearDevice();
    SetColor(0x00);

    for(int i = 0; i < sizeY; i++){
        for(int scaleY = scale; scaleY > 0; scaleY--){
        for(int j = 0; j < sizeX; j++){
                if(flag[i*sizeX + j] == 'p'){
                    for(int scaleX = scale; scaleX > 0; scaleX--){
                    //PutPixel((int)(x + j + 5*Sinus(i/12.-3.14/2.0-t)), (int)(y + i + 5*Sinus(j/12.-t)), 0x0E);//0x9FAF00+0x101000*(int)(0x6*(sin(j/24.-t))));
                    PutPixel(x + j, y + i, 0xFFFF00);//0x9FAF00+0x101000*(int)(0x6*(sin(j/24.-t))));
                    if(scaleX > 1) x++;
                    }
                }
                else{
                    for(int scaleX = scale; scaleX > 0; scaleX--){
                    //PutPixel((int)(x + j + 5*Sinus(i/12.-3.14/2.0-t)), (int)(y + i + 5*Sinus(j/12.-t)), 0x04);//0xAF0000+0x100000*(int)(0x6*(sin(j/24.-t))));
                    PutPixel(x + j, y + i, 0xFF0000);//0xAF0000+0x100000*(int)(0x6*(sin(j/24.-t))));
                    if(scaleX > 1) x++;
                    }
                }
                x += 0; //+2
                if(x%2 == 0) y++;
        }
        x = xstart;
        if(scaleY > 1) ystart++;
        y = ystart;
        }
    }
}
