
; Показывает системное время #################################################
;Увеличение  счетчика
; по адресу 0000:046Ch,
; проверка его на переполнение.

Clock:
        push fs
        push ds
        push 0
        pop ds
        push 0
        pop fs

        mov        al,0Bh               ; CMOS OBh - управляющий регистр В
        out        70h,al               ; порт 70h - индекс CMOS
        in         al,71h               ; порт 71h - данные CMOS
        and        al,11111011b         ; обнулить бит 2 (форма чисел - BCD)
        out        71h,al               ; и записать обратно
        ;mov        al,32h               ; CMOS 32h - две старшие цифры года
        ;mov dx,0060
        ;call       print_cmos           ; вывод на экран
        ;mov        al,9                 ; CMOS 09h - две младшие цифры года
        ;mov dx,0062
        ;call       print_cmos
        ;mov        al,8                 ; CMOS 08h - текущий месяц
        ;mov dx,0064
        ;call       print_cmos
        ;mov        al,7                 ; CMOS 07h - день
        ;mov dx,0066
        ;call       print_cmos
        mov        al,4                 ; CMOS 04h - час
        mov dx,0x014A
        ; часовой пояс +4 ------------------------------------------------
        out        70h,al               ; послать AL в индексный порт CMOS
        in         al,71h               ; прочитать данные
        ;add al,4            ;часовой пояс +4
        ;aaa
        push       ax
        ;mov al,ah
        shr        al,4                 ; выделить старшие четыре бита
        add        al,'0'               ; добавить ASCII-код цифры 0
        call to_show_time               ; вывести на экран
        inc dx
        pop        ax
        and        al,0Fh               ; выделить младшие четыре бита
        add        al,30h               ; добавить ASCII-код цифры 0
        call to_show_time               ; вывести на экран
        ;------------------------------------------------------------------
        mov dx,0x014C
        mov al,[plots_time]
        call to_show_time
        mov        al,2                 ; CMOS 02h - минута
        mov dx,0x014D
        call       print_cmos
        ;mov        al,0h                ; CMOS 00h - секунда
        ;mov dx,0072
        ;call       print_cmos

        pop ds
        pop fs
        ret


; процедура print_cmos ########################################################
; выводит на экран содержимое ячейки CMOS с номером в AL
; считает, что число, читаемое из CMOS, находится в формате BCD
print_cmos:
        out        70h,al               ; послать AL в индексный порт CMOS
        in         al,71h               ; прочитать данные
        push       ax
        shr        al,4                 ; выделить старшие четыре бита
        add        al,'0'               ; добавить ASCII-код цифры 0
        call to_show_time               ; вывести на экран
        inc dx
        pop        ax
        and        al,0Fh               ; выделить младшие четыре бита
        add        al,30h               ; добавить ASCII-код цифры 0
        call to_show_time               ; вывести на экран
        ret


; Вывести на экран ##########################################################
char_time			DB "@",0
plots_time          DB ":",0

to_show_time:
        push	si
        mov		[char_time],al
        lea		si,[char_time]
    ;Print
	mov ah,5
	mov al,0x2F
	call Print
        pop		si
        ret


