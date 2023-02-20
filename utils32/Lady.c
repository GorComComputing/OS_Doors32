#include "../lib32/BGL.h"
#include "../lib32/GUI.h"

#include "Lady.h"

static TWindow Form1;

char bitmap[] = \
    "aaaaaaaaaaaaaaccffffffffffffffffffffffffffffffffff"
    "aaaaaaaaaaaaaaccffffffffffffffffffffffffffffffffff"
    "aaaaaaaaaaaaaaaccfffffffffffffffffffffffffffffffff"
    "aaaaaaaaaaaaaaaacfffffffffffffffffffffffffffffffff"
    "aaaaaaaaaaaaaaaaccffffffffffffffffffffffffffffffff"
    "aaaaaaaaaaaaaaaaacfffffbfbbfffffffffffffffffffffff"
    "ggaaaaaaaaajjaaaaccfffbababaaaffffffffffffffffffff"
    "ggggaaaaaaabjjaaaaccffaaaaaaaaaaaabbffffffffffffff"
    "ggggggaaaaaaabjaaaacffcaaaaaaaaaaaaaabffffffffffff"
    "gggggggaaaaabbbaaaaffffcbbbbbccccccfaaabffffffffff"
    "gggggggaabaaaccaaacffffcccbbaaaaccccffbbbbffffffff"
    "gggggggabbcccccaacffffffcccbbbbbaacccffffbbbffffff"
    "gggggggabccffcaaacffffffccbaaaaabbaaccffffffffffff"
    "hggggggabcfffcaacffffffffcaaajjaaabbaccfffffffffff"
    "hhhggggabcffcaaacffffffffcbbjjjhajaabaccffffffffff"
    "hhhhhggabcfcaaacfffffffffcbbjjjhhahaabaccfffffffff"
    "hhhhhhhabcfcaaacfffffffffbcbbjjjhhhjaabbcccfffffff"
    "hhhhhhhabccaaacfffffffffffccbbbjjjjjjabbbcffffffff"
    "hhhhhhhabccaacfffffffffffffccbbbbbbbbcabbcffffffff"
    "hhhhhhhabbaaacffffffffffffffcccbbbcccccbffffffffff"
    "hhhhhhhabaaacfffffffffffffffffcccfffffffffffffffff"
    "ghhhhhhhaaacffffffffffffffffffffffffffffffffffffff"
    "ghhhhhhhaaacffffffffffffffffffffffffffffffffffffff"
    "gghhhhhhaacfffffffffffffffffffffffffffffffffffffff"
    "gghhhhhhaacfffffffffffffffffffffffffffffffffffffff"
    "gghhhhhhaaacffffffffffffffffffffffffffffffffffffff"
    "gghhhhhhaaaacffbaafffcfffffffffffffffffffffffffffc"
    "gghhhhhhaaaaabbfffaacfffffffffffffffffffffffffffcc"
    "gghhhhhhaaccffcfffffffffffffffffffffffffffffffcccc"
    "ggghhhhhaaaffcfffffffffffffffffffffffffffffffffffc"
    "ggghhhhhaaaafffffffffffffffffffffffffffffffffffffc"
    "ggghhhhhaaaaddffffffffffffffffffffffffffffffffffff"
    "ggghhhhhadaaadddffffffffffffffffffffffffffffffffff"
    "ggghhhhhadddaadddffffffffffffffffffffffffffffffffc"
    "ggghhhhhadddddaadddfffffffffffffffffffffffffffffcc"
    "gghhhhhhaaddddddaaddfffffffffffffffffffffffffffccf"
    "ghhhhhhhaaddddddeeedddfffffffffffffffffffffffffccf"
    "ghhhhhhhaaaddddeeeeeeedfffffffffffffffffffffffccff"
    "ghhhhhhhaaaaadddeeeffffffffffffffffffffffffffccfff"
    "ghhhhhhhaaccaacfffffffffffffffffffffffffffffccffff"
    "ghhhhhhhaccffccffffffffffffffffffffffffffffccfffff"
    "ghhhhhhhaccffffcffffffffffffffffffffffffffccffffff"
    "gghhhhhhaccffffffffffffffffffffffffffffccccfffffff"
    "ggghhhhhhacccffffffffffffffffffffffffcccffffffffff"
    "gggghhhhhaccccffffffffffffffffffcccaaccfffffffffff"
    "agggghhhhhaccccffffffffffffffcccaaaccccfffffffffff"
    "aaggggghhhhaacccffffffffffcccaaabbcccfffffffffffff"
    "aaaggggghhhhhaacccccccccccaaaaaaabbcccffffffffffff"
    "aaaaggggghhhhhhaaaaaaaaaaaaaaaaaabbcccffffffffffff"
    "aaaaaaggggghhhhhhgaaaaaaaaaaaaaaaabccccfffffffffff"
    ;


// Выводит битмап девушки
void LadyBitmap(int xstart, int ystart, int sizeX, int sizeY, int scale){
    //Form1.caption = "LINES";
    Form1.x = 440;
    Form1.y = 400;
    Form1.width = 104;
    Form1.height = 104 + 15;
    Form1.BC = STANDART;
    //Form1.onFocus = true;

    DrawWindow(Form1);

    xstart = Form1.x + 2;
    ystart = Form1.y + 18;

    int x = xstart;
    int y = ystart;

    for(int i = 0; i < sizeY; i++){
        for(int scaleY = scale; scaleY > 0; scaleY--){
        for(int j = 0; j < sizeX; j++){
            if(bitmap[i*sizeX + j] == 'a'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0x201E1C);//(uint8)0x00);
                if(scaleX > 1) x++;
                }
            }
            else if(bitmap[i*sizeX + j] == 'b'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0x5E6368);//(uint8)0x16);
                if(scaleX > 1) x++;
                }
            }
            else if(bitmap[i*sizeX + j] == 'c'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0xADB0B5);//(uint8)0x07);
                if(scaleX > 1) x++;
                }
            }
            else if(bitmap[i*sizeX + j] == 'd'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0x7D0428);//(uint8)0x70);
                if(scaleX > 1) x++;
                }
            }
            else if(bitmap[i*sizeX + j] == 'e'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0xF14A64);//(uint8)0x28);
                if(scaleX > 1) x++;
                }
            }
            else if(bitmap[i*sizeX + j] == 'f'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0xF3EBCC);//(uint8)0x5C);
                if(scaleX > 1) x++;
                }
            }
            else if(bitmap[i*sizeX + j] == 'g'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0x003B8F);//(uint8)0xB2);
                if(scaleX > 1) x++;
                }
            }
            else if(bitmap[i*sizeX + j] == 'h'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0x83A9FA);//(uint8)0x38);
                if(scaleX > 1) x++;
                }
            }
            else if(bitmap[i*sizeX + j] == 'j'){
                for(int scaleX = scale; scaleX > 0; scaleX--){
                PutPixel(x + j, y + i, 0xFEFEFE);//(uint8)0x0F);
                if(scaleX > 1) x++;
                }
            }
        }
        x = xstart;
        if(scaleY > 1) y++;
        }
    }
}
