#include "../drivers32/screen.h"
#include "BGL.h"
#include "math.h"

uint32 CC; // Текущий цвет
uint32 BC; // Цвет заднего фона

struct tXbuf YXbuf[GETMAX_Y];


char charA[] = \
    " pppp  "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pppppp "
    "pp  pp "
    "pp  pp "
    ;//7x7
char charB[] = \
    "ppppp  "
    "pp  pp "
    "pp  pp "
    "ppppp  "
    "pp  pp "
    "pp  pp "
    "ppppp  "
    ;//7x7
char charC[] = \
    " pppp  "
    "pp  pp "
    "pp  pp "
    "pp     "
    "pp  pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char charD[] = \
    "ppppp  "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "ppppp  "
    ;//7x7
char charE[] = \
    "pppppp "
    "pp     "
    "pp     "
    "ppppp  "
    "pp     "
    "pp     "
    "pppppp "
    ;//7x7
char charF[] = \
    "pppppp "
    "pp     "
    "pp     "
    "ppppp  "
    "pp     "
    "pp     "
    "pp     "
    ;//7x7
char charG[] = \
    " pppp  "
    "pp  pp "
    "pp  pp "
    "pp     "
    "pp ppp "
    "pp  pp "
    " pppp  "
    ;//7x7
char charH[] = \
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pppppp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    ;//7x7
char charI[] = \
    " pppp  "
    "  pp   "
    "  pp   "
    "  pp   "
    "  pp   "
    "  pp   "
    " pppp  "
    ;//7x7
char charJ[] = \
    "   ppp "
    "    pp "
    "    pp "
    "    pp "
    "pp  pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char charK[] = \
    "pp  pp "
    "pp  pp "
    "pp pp  "
    "pppp   "
    "pp pp  "
    "pp  pp "
    "pp  pp "
    ;//7x7
char charL[] = \
    "pp     "
    "pp     "
    "pp     "
    "pp     "
    "pp     "
    "pp     "
    "pppppp "
    ;//7x7
char charM[] = \
    "p   p  "
    "pp pp  "
    "ppppp  "
    "p p p  "
    "p   p  "
    "p   p  "
    "p   p  "
    ;//7x7
char charN[] = \
    "pp  pp "
    "pp  pp "
    "ppp pp "
    "pppppp "
    "pp ppp "
    "pp  pp "
    "pp  pp "
    ;//7x7
char charO[] = \
    " pppp  "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char charP[] = \
    "ppppp  "
    "pp  pp "
    "pp  pp "
    "ppppp  "
    "pp     "
    "pp     "
    "pp     "
    ;//7x7
char charQ[] = \
    " pppp  "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    " pppp  "
    "   ppp "
    ;//7x7
char charR[] = \
    "ppppp  "
    "pp  pp "
    "pp  pp "
    "ppppp  "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    ;//7x7
char charS[] = \
    " pppp  "
    "pp  pp "
    "pp     "
    " pppp  "
    "    pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char charT[] = \
    "pppppp "
    "  pp   "
    "  pp   "
    "  pp   "
    "  pp   "
    "  pp   "
    "  pp   "
    ;//7x7
char charU[] = \
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char charV[] = \
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    " p  p  "
    " pppp  "
    "  pp   "
    ;//7x7
char charW[] = \
    "p    p "
    "p    p "
    "p    p "
    "p pp p "
    "p pp p "
    " pppp  "
    " p  p  "
    ;//7x7
char charX[] = \
    "pp  pp "
    "pp  pp "
    " pppp  "
    "  pp   "
    " pppp  "
    "pp  pp "
    "pp  pp "
    ;//7x7
char charY[] = \
    "pp  pp "
    "pp  pp "
    "pp  pp "
    " pppp  "
    "  pp   "
    "  pp   "
    "  pp   "
    ;//7x7
char charZ[] = \
    "pppppp "
    "    pp "
    "   pp  "
    "  pp   "
    " pp    "
    "pp     "
    "pppppp "
    ;//7x7
char charSpace[] = \
    "       "
    "       "
    "       "
    "       "
    "       "
    "       "
    "       "
    ;//7x7
char charLine[] = \
    "       "
    "       "
    "       "
    " ppppp "
    "       "
    "       "
    "       "
    ;//7x7
char charBolshe[] = \
    "  p    "
    "   p   "
    "    p  "
    "     p "
    "    p  "
    "   p   "
    "  p    "
    ;//7x7
char char0[] = \
    " pppp  "
    "pp  pp "
    "pp  pp "
    "pp ppp "
    "ppp pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char char1[] = \
    " pp    "
    "ppp    "
    " pp    "
    " pp    "
    " pp    "
    " pp    "
    "pppp   "
    ;//7x7
char char2[] = \
    " pppp  "
    "pp  pp "
    "    pp "
    "   ppp "
    " ppp   "
    "pp     "
    "pppppp "
    ;//7x7
char char3[] = \
    " pppp  "
    "pp  pp "
    "    pp "
    "  ppp  "
    "    pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char char4[] = \
    "pp  pp "
    "pp  pp "
    "pp  pp "
    "pp  pp "
    " ppppp "
    "    pp "
    "    pp "
    ;//7x7
char char5[] = \
    "pppppp "
    "pp     "
    " ppp   "
    "    pp "
    "pp  pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char char6[] = \
    " pppp  "
    "pp  pp "
    "pp     "
    "ppppp  "
    "pp  pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char char7[] = \
    "pppppp "
    "    pp "
    "   pp  "
    "  pp   "
    "  pp   "
    "  pp   "
    "  pp   "
    ;//7x7
char char8[] = \
    " pppp  "
    "pp  pp "
    "pp  pp "
    " pppp  "
    "pp  pp "
    "pp  pp "
    " pppp  "
    ;//7x7
char char9[] = \
    " pppp  "
    "pp  pp "
    "pp  pp "
    " ppppp "
    "    pp "
    "pp  pp "
    " pppp  "
    ;//7x7


// Очистить экран
void ClearDevice(){
    FillLB(0, SIZE, BC);
}


// Устанавливает текущий цвет
void SetColor(uint32 Color){
    CC = Color;
}


// Устанавливает цвет заднего фона
void SetBackColor(uint32 Color){
    BC = Color;
}

/*
// Точка
void PutPixel(int x, int y, char Color){
    FillLB((BITMAP_WIDTH*(y) + x), 1, Color);
}
*/

// Точка
void PutPixel(int x, int y, uint32 Color){
    FillLB((BITMAP_WIDTH*(y) + x), 1, Color);
}


// Линия Брезенхема с PutPixel (там умножение)
void LinePP(int x1, int y1, int x2, int y2){
    int dx = abs(x2-x1);
    int dy = abs(y2-y1);
        int x;
        int y;
        int xend;
        int yend;
        int inc1;
        int inc2;
        int d;
        int s;
    if(dx > dy){
        if(x1 < x2){
            x = x1; xend = x2; y = y1;
            if(y2 >= y1) s = 1; else s = -1;
        }
        else {
            x = x2; xend = x1; y = y2;
            if(y2 >= y1) s = -1; else s = 1;
        }
        inc1 = 2*(dy - dx);
        inc2 = 2*dy;
        d = 2*dy - dx;
        PutPixel(x, y, CC);
        while(x < xend){
            x++;
            if(d > 0){
                d += inc1;
                y += s;
            }
            else{
                d += inc2;
            }
            PutPixel(x, y, CC);
        }
    }
    else{
        if(y1 < y2){
            y = y1; yend = y2; x = x1;
            if(x2 >= x1) s = 1; else s = -1;
        }
        else {
            y = y2; yend = y1; x = x2;
            if(x2 >= x1) s = -1; else s = 1;
        }
        inc1 = 2*(dx - dy);
        inc2 = 2*dx;
        d = 2*dx - dy;
        PutPixel(x, y, CC);
        while(y < yend){
            y++;
            if(d > 0){
                d += inc1;
                x += s;
            }
            else{
                d += inc2;
            }
            PutPixel(x, y, CC);
        }
    }
}


//  Горизонтальная линия
void HLine(int x1, int y, int x2){
    if(x1 < x2)
        FillLB(BITMAP_WIDTH*y + x1, x2 - x1 + 1, CC);
    else
        FillLB(BITMAP_WIDTH*y + x2, x1 - x2 + 1, CC);
}


// Окружность Брезенхема
void Circle(int xc, int yc, int R){
    int x = 0;
    int y = R;
    int d = 3 - 2*R;
    Pixel8(xc, yc, 0, R);
    while(x < y){
        if(d < 0)
            d = d + 4*x + 6;
        else{
            d = d + 4*(x - y) + 10;
            y--;
        }
        x++;
        Pixel8(xc, yc, x, y);
    }
}


// Для окружности, рисует 8 точек
void Pixel8(int xc, int yc, int x, int y){
    PutPixel(xc + x, yc + y, CC);
    PutPixel(xc - x, yc + y, CC);
    PutPixel(xc + x, yc - y, CC);
    PutPixel(xc - x, yc - y, CC);

    PutPixel(xc + y, yc + x, CC);
    PutPixel(xc - y, yc + x, CC);
    PutPixel(xc + y, yc - x, CC);
    PutPixel(xc - y, yc - x, CC);
}


// Выводит спрайт
void DrawBitmap(char monster[], int xstart, int ystart, int sizeX, int sizeY, int scale){
    int x = xstart;
    int y = ystart;

    for(int i = 0; i < sizeY; i++){
        for(int scaleY = scale; scaleY > 0; scaleY--){
        for(int j = 0; j < sizeX; j++){
            if(monster[i*sizeX + j] == 'p'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, CC);
                if(scaleX > 1) x++;
                }
            }
            else{
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, BC);
                if(scaleX > 1) x++;
                }
            }
        }
        x = xstart;
        if(scaleY > 1) y++;
        }
    }
}


// Выводит спрайт с прозрачным фоном
void DrawBitmapTransparent(char monster[], int xstart, int ystart, int sizeX, int sizeY, int scale){
    int x = xstart;
    int y = ystart;

    for(int i = 0; i < sizeY; i++){
        for(int scaleY = scale; scaleY > 0; scaleY--){
        for(int j = 0; j < sizeX; j++){
            if(monster[i*sizeX + j] == 'p'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, CC);
                if(scaleX > 1) x++;
                }
            }
            else{
                for(int scaleX = scale; scaleX > 0; scaleX--){
                //PutPixel(x + j, y + i, BC);
                if(scaleX > 1) x++;
                }
            }
        }
        x = xstart;
        if(scaleY > 1) y++;
        }
    }
}


// Вывод текста на экран
void TextOutgl(char* str, int x, int y, int scale){
    for(int i = 0; str[i] != 0; i++){
        if(str[i] == 'A') DrawBitmapTransparent(charA, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'B') DrawBitmapTransparent(charB, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'C') DrawBitmapTransparent(charC, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'D') DrawBitmapTransparent(charD, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'E') DrawBitmapTransparent(charE, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'F') DrawBitmapTransparent(charF, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'G') DrawBitmapTransparent(charG, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'H') DrawBitmapTransparent(charH, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'I') DrawBitmapTransparent(charI, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'J') DrawBitmapTransparent(charJ, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'K') DrawBitmapTransparent(charK, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'L') DrawBitmapTransparent(charL, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'M') DrawBitmapTransparent(charM, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'N') DrawBitmapTransparent(charN, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'O') DrawBitmapTransparent(charO, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'P') DrawBitmapTransparent(charP, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'Q') DrawBitmapTransparent(charQ, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'R') DrawBitmapTransparent(charR, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'S') DrawBitmapTransparent(charS, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'T') DrawBitmapTransparent(charT, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'U') DrawBitmapTransparent(charU, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'V') DrawBitmapTransparent(charV, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'W') DrawBitmapTransparent(charW, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'X') DrawBitmapTransparent(charX, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'Y') DrawBitmapTransparent(charY, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == 'Z') DrawBitmapTransparent(charZ, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == ' ') DrawBitmapTransparent(charSpace, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '-') DrawBitmapTransparent(charLine, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '>') DrawBitmapTransparent(charBolshe, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '0') DrawBitmapTransparent(char0, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '1') DrawBitmapTransparent(char1, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '2') DrawBitmapTransparent(char2, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '3') DrawBitmapTransparent(char3, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '4') DrawBitmapTransparent(char4, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '5') DrawBitmapTransparent(char5, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '6') DrawBitmapTransparent(char6, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '7') DrawBitmapTransparent(char7, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '8') DrawBitmapTransparent(char8, x+7*i*scale, y, 7, 7, scale);
        if(str[i] == '9') DrawBitmapTransparent(char9, x+7*i*scale, y, 7, 7, scale);
    }
}


// Заполнение построчной растровой разверткой Ньюмена-Скрула
void FillPoly(int n, struct tPoint p[]){
    // отражаем точки по Y
    /*for(int i = 0; i < n; i++)
        p[i].y = p[i].y;//BITMAP_HEIGHT -*/

    // находим верхнюю и нижнюю  границы
    int ymin = p[0].y;
    int ymax = ymin;
    for(int i = 0; i <= n - 1; i++){//////////////////
        if(p[i].y < ymin)
            ymin = p[i].y;
        else if(p[i].y > ymax)
            ymax = p[i].y;
    }
    //printf("ymin: %d ymax: %d\n", ymin, ymax);

    for(int y = ymin; y <= ymax; y++)////////////////
    //for(int y = 0; y <= GETMAX_Y; y++)
        YXbuf[y].m = 0; // заполняем сначала нулями
        //printf("YXbuf[%d].m: %d\n", y, YXbuf[y].m);



    // обход контура
    int i1 = n - 1;
    for(int i2 = 0; i2 <= n - 1; i2++){////////////
        if(p[i1].y != p[i2].y){
            //LinePP(p[i1].x, p[i1].y, p[i2].x, p[i2].y);
            Edge(p[i1].x, p[i1].y, p[i2].x, p[i2].y); // растровая развертка ребра
        }
        i1 = i2;
    }

    // закраска
    for(int y = ymin; y <= ymax; y++){/////////////////
        Sort(YXbuf[y]);
        for(int i = 0; i < YXbuf[y].m; i += 2)
            HLine(YXbuf[y].x[i], y, YXbuf[y].x[i + 1]);
    }
}


// Растровая развертка ребра ЦДА
void Edge(int x1, int y1, int x2, int y2){
    int y;
    int yend;
    float xf;
    float k = (float)(x2 - x1)/(float)(y2 - y1);
    if(y1 < y2) {y = y1; yend = y2; xf = x1;}
    else {y = y2; yend = y1; xf = x2;}
    while(y < yend){
       y++;
       xf += k;
       YXbuf[y].m++;
       YXbuf[y].x[YXbuf[y].m-1] = xf;//round(xf);
    }
}


// Сортировка вставками
void Sort(struct tXbuf a){
    int y;
    int j;
    for(int i = 1; i < a.m; i++){//////////////
        y = a.x[i];
        j = i - 1;
        while((j >= 0) && (y < a.x[j])){
            a.x[j + 1] = a.x[j];
            j--;
        }
        a.x[j + 1] = y;
    }
}

