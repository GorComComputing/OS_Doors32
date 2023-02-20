
; ���������� ��������� ����� #################################################
;����������  ��������
; �� ������ 0000:046Ch,
; �������� ��� �� ������������.

Clock:
        push fs
        push ds
        push 0
        pop ds
        push 0
        pop fs

        mov        al,0Bh               ; CMOS OBh - ����������� ������� �
        out        70h,al               ; ���� 70h - ������ CMOS
        in         al,71h               ; ���� 71h - ������ CMOS
        and        al,11111011b         ; �������� ��� 2 (����� ����� - BCD)
        out        71h,al               ; � �������� �������
        ;mov        al,32h               ; CMOS 32h - ��� ������� ����� ����
        ;mov dx,0060
        ;call       print_cmos           ; ����� �� �����
        ;mov        al,9                 ; CMOS 09h - ��� ������� ����� ����
        ;mov dx,0062
        ;call       print_cmos
        ;mov        al,8                 ; CMOS 08h - ������� �����
        ;mov dx,0064
        ;call       print_cmos
        ;mov        al,7                 ; CMOS 07h - ����
        ;mov dx,0066
        ;call       print_cmos
        mov        al,4                 ; CMOS 04h - ���
        mov dx,0x014A
        ; ������� ���� +4 ------------------------------------------------
        out        70h,al               ; ������� AL � ��������� ���� CMOS
        in         al,71h               ; ��������� ������
        ;add al,4            ;������� ���� +4
        ;aaa
        push       ax
        ;mov al,ah
        shr        al,4                 ; �������� ������� ������ ����
        add        al,'0'               ; �������� ASCII-��� ����� 0
        call to_show_time               ; ������� �� �����
        inc dx
        pop        ax
        and        al,0Fh               ; �������� ������� ������ ����
        add        al,30h               ; �������� ASCII-��� ����� 0
        call to_show_time               ; ������� �� �����
        ;------------------------------------------------------------------
        mov dx,0x014C
        mov al,[plots_time]
        call to_show_time
        mov        al,2                 ; CMOS 02h - ������
        mov dx,0x014D
        call       print_cmos
        ;mov        al,0h                ; CMOS 00h - �������
        ;mov dx,0072
        ;call       print_cmos

        pop ds
        pop fs
        ret


; ��������� print_cmos ########################################################
; ������� �� ����� ���������� ������ CMOS � ������� � AL
; �������, ��� �����, �������� �� CMOS, ��������� � ������� BCD
print_cmos:
        out        70h,al               ; ������� AL � ��������� ���� CMOS
        in         al,71h               ; ��������� ������
        push       ax
        shr        al,4                 ; �������� ������� ������ ����
        add        al,'0'               ; �������� ASCII-��� ����� 0
        call to_show_time               ; ������� �� �����
        inc dx
        pop        ax
        and        al,0Fh               ; �������� ������� ������ ����
        add        al,30h               ; �������� ASCII-��� ����� 0
        call to_show_time               ; ������� �� �����
        ret


; ������� �� ����� ##########################################################
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


