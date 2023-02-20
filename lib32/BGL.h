#ifndef BGL_H
#define BGL_H

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;


typedef struct tPoint{
    int x;
    int y;
} tPoint;

//typedef  struct tPoint tPoly[100];

#define NMAX 100    // количество точек пересечения с контуром
typedef struct tXbuf{
    int m;          // количество точек контура
    int x[NMAX];    // координаты точек контура
} tXbuf;


void ClearDevice();
void SetColor(uint32 Color);
void SetBackColor(uint32 Color);
void PutPixel(int x, int y, uint32 Color); //char
void LinePP(int x1, int y1, int x2, int y2);
void HLine(int x1, int y, int x2);
void Circle(int xc, int yc, int R);
void Pixel8(int xc, int yc, int x, int y);
void DrawBitmap(char monster[], int xstart, int ystart, int sizeX, int sizeY, int scale);
void DrawBitmapTransparent(char monster[], int xstart, int ystart, int sizeX, int sizeY, int scale);
void TextOutgl(char str[], int x, int y, int scale);
void FillPoly(int n, struct tPoint p[]);
void Edge(int x1, int y1, int x2, int y2);
void Sort(struct tXbuf a);


#endif
