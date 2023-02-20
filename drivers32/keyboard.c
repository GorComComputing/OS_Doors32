#include "keyboard.h"

#include "../kernel32/low_level.h"


//
uint8 scan(void){
    unsigned char brk;
    static uint8 key = 0;
    uint8 scan = port_byte_in(0x60);//inb(0x60);
    brk = scan & 0x80;
    scan = scan & 0x7f;
    if (brk)
        return key = 0;
    else if (scan != key)
        return key = scan;
    else
        return 0;
}
