// Ядро Doors
asm ("call _start \n ret");		// Точка входа в ядро

#include "kernel.h"
#include "memory.h"
#include "low_level.h"

#include "../drivers32/screen.h"
#include "../drivers32/keyboard.h"

#include "../lib32/BGL.h"
#include "../lib32/GUI.h"
#include "../lib32/string.h"

#include "../utils32/flag.h"
#include "../utils32/Lady.h"
#include "../utils32/console.h"


char c[] = "Xello! \nGOR.COM Test...\n";
char d[] = "FORM\n";
int her;
char s[] = "This is a test list...!   \n";
char s2[] = "This is a test list2 qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq1234567891\n";

extern size_t terminal_row;
extern size_t terminal_column;

// Главная функция ядра
void start(void){
//	uint16* video_memory = (uint16*)VGA_ADDRESS;

	//video_memory[0] = 0x4F01;
	//video_memory[1] = 0x4F;

	//while(1);

//	clear_screen();



//	video_memory[0] = vga_entry(c[0], COLOR_WHITE, COLOR_RED);
//	for(int i = 1; c[i] != 0; i++)
//		video_memory[i] = vga_entry(c[i], COLOR_WHITE, COLOR_BLUE);

    //asm ("int $0x01 \n");
    //asm ("movb	$0x4F,(0xB8000)");//(0x98000)");
    //asm ("movb	$0x01,(0xB8000)");
    //asm ("mov	byte [0xb8000+2+1-0x20000],0x4F");

    //uint16* adr = (uint16*)(her);
    //uint16* adr2 = (uint16*)0x20000;
    //*adr2 = (uint16)adr;

    //return;

//    print_char('R', 5, 1, 0x1F);
//    print(c);
//    memory_copy((uint8*)(get_screen_offset(5, 1) + VGA_ADDRESS), (uint8*)(get_screen_offset(10, 10) + VGA_ADDRESS), 10);


    //print_char('D', 79, 24, 0x1F);



//    print_at(d, 78, 24);
//return;
//    terminal_initialize();
    //terminal_row = 10;
    //terminal_column = 10;

    //prints(c, strlen(c));
    //prints(d, strlen(d));

    //for(int i = 0; i < 22; i++)
    //    prints(s, strlen(s));
    //prints(s2, strlen(s2));







    //DrawDesktop(0x0080C0);//(uint8)0x35);

//return;

    //DrawTaskbar(0, BITMAP_HEIGHT - 28, BITMAP_WIDTH - 1, 24+5, 0x30B410);//0x46);

//return;
    //ProcFlag();





    /*char str[6] = "HELLO";
    TextOutgl(str, 200, 150, 1);*/

    //char *buff;
    //strcpy(&buff[strlen(buff)], ””);

    ProcConsole();



    char *buff;
    strcpy(&buff[strlen(buff)], d);
    memset(&buff[0], 0, sizeof(buff));




    while(1){
        uint8 byte;
        while (byte = scan()) {
            if (byte == 0x1c) {
                char cmd_basic[] = "BASIC";
                char cmd_lady[] = "LADY";
                char cmd_exit[] = "EXIT";
                char cmd_a20[] = "A20";
                char cmd_reset[] = "RESET";
                char cmd_flag[] = "FLAG";
                if (strlen(buff) > 0 && strcmp(buff, cmd_basic)==0){//strcmp(buff, "EXIT") == 0){ memcmp(buff, exit, sizeof(buff))
                    char pro[] = "\nHELLO";
                    cons_prints(pro, strlen(pro));
                }
                else if (strlen(buff) > 0 && strcmp(buff, cmd_lady)==0){//strcmp(buff, "EXIT") == 0){ memcmp(buff, exit, sizeof(buff))
                    LadyBitmap(100, 30, 50, 50, 2);
                }
                else if (strlen(buff) > 0 && strcmp(buff, cmd_exit)==0){//strcmp(buff, "EXIT") == 0){ memcmp(buff, exit, sizeof(buff))
                    asm ("int $0x01 \n");
                    return;
                }
                else if (strlen(buff) > 0 && strcmp(buff, cmd_a20)==0){//strcmp(buff, "EXIT") == 0){ memcmp(buff, exit, sizeof(buff))
                    char *a20_buf = (char*)0xFEFFFFF; //0xA0000;
                    *a20_buf = 'H';
                    if (*a20_buf == 'H') {
                        char a20_suc[] = "\nSUCC";
                        cons_prints(a20_suc, strlen(a20_suc));
                    }
                    else{
                        char a20_fail[] = "\nFAIL";
                        cons_prints(a20_fail, strlen(a20_fail));
                    }
                }
                else if (strlen(buff) > 0 && strcmp(buff, cmd_reset)==0){//strcmp(buff, "EXIT") == 0){ memcmp(buff, exit, sizeof(buff))
                    // Перезагрузка компьютера
                    asm ("int $0x00 \n");
                }
                else if (strlen(buff) > 0 && strcmp(buff, cmd_flag)==0){//strcmp(buff, "EXIT") == 0){ memcmp(buff, exit, sizeof(buff))
                    ProcFlag();
                }
                printprompt();
                memset(&buff[0], 0, sizeof(buff));
                break;
            } else {
                char c = normalmap[byte];
                if(islower(c)) c = c - 0x20;
                char *s;
                s = ctos(s, c);


                cons_prints(s, strlen(s));
                if(c != '\b')
                    strcpy(&buff[strlen(buff)], s);
            }
        }


    }
}












