asm ("call _start \n ret");

void start(void){
asm ("movb $0x0E,%ah"
     "movb 'H',%al"
     "int $0x10"
     "movb $0,%ah"
     "int $0x16"

     );
    return;
}


	/*mov ah,0x0e
    mov al,'E'
    int 0x10*/
