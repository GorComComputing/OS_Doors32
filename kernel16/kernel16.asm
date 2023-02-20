; Kernel 16-bit
[bits 16]
    [org 0x500]
    jmp Start16

ImageName DB "SHELL   COM"
FILE_SEG EQU 0x0000
FILE_ADDR EQU 0x2000

error_file DB "File SHELL.COM not found. Press any key to reset...",0

Start16:
    ; ������������� ���� ����������
    cli                ; ��������� ����������
    lea     bx,[cs:int0�h_r]     ; ����� ������ ����������� COM1
    mov     [ds:0030h],bx
    mov     [ds:0032h],cs
    lea     bx,[cs:int1�h_r]     ; ����� ������ ����������� ������
    mov     [ds:0070h],bx
    mov     [ds:0072h],cs
    lea     bx,[cs:int20h_r]     ; ����� ������ �����������
    mov     [ds:0080h],bx
    mov     [ds:0082h],cs
    lea     bx,[cs:int21h_r]     ; ����� ������ �����������
    mov     [ds:0084h],bx
    mov     [ds:0086h],cs
    lea     bx,[cs:int25h_r]     ; ����� ������ �����������
    mov     [ds:0094h],bx
    mov     [ds:0096h],cs
    lea     bx,[cs:int26h_r]     ; ����� ������ �����������
    mov     [ds:0098h],bx
    mov     [ds:009Ah],cs
    sti                ; ��������� ����������

    ; ������������� ���������� ��������
    mov ax,0x9000
	mov ss,ax
	mov	bp,0xFFFF	; ������������� ����� �����
	mov	sp,bp

	xor	ax, ax		; ds=0
	mov	ds, ax		;
	mov	es, ax	    ;
	mov	fs, ax	    ;
	mov	gs, ax	    ;

    ; ������ ���� SHELL.COM
    mov si,ImageName
    mov dx,FILE_SEG
    mov bx,FILE_ADDR
    ;FileRead
    mov ah,0x20
    int 0x21
    cmp ah,1
    je file_not_found  ; ���� �� ������

    ; ��������� � SHELL.COM
    jmp FILE_ADDR

file_not_found:
    ;WriteLn
	lea		si,[error_file]
	mov     ah,0
	int     0x21

	;���� ������� ����� �������
	mov     ah,0
	int     0x16

    ;Reset
    mov ah,0xFF
    int 0x21


; ���������� ����������
    %include "kernel16\out16.asm"
    %include "kernel16\in.asm"
    %include "drivers16\disk.asm"
    %include "kernel16\fat16.asm"
    %include "kernel16\int16.asm"
    %include "kernel16\functions.asm"









; ����� ����� �� �����
; ax � ��������� �����
PRINT_WORD:
				push	ax
				mov 	al, ah
				call 	PRINT_BYTE	; ������� ������� ����
				pop 	ax
				call 	PRINT_BYTE 	; ������� ������� ����
				ret


; ����� ����� �� �����
; al � ��������� ����
PRINT_BYTE:
				push 	ax
				mov 	ah, al
				shr		al, 04h
				call 	PRINT_DIGIT
				mov 	al, ah
				and		al, 0Fh
				call 	PRINT_DIGIT
				pop 	ax
				ret


; ������� 4-�� ��� � 16-�������� ������ � ����� �� �����
; al � ��������� ����
PRINT_DIGIT:
				push	ax
				pushf
				cmp 	al, 0Ah
				jae 	m1 ; ���� al ������ ��� ����� 10, �� �������
				add 	al, 30h ; ���������� � ����� ������� �0� (48���)
				jmp 	m2
m1:
				add 	al, 37h ; ���������� � ����� ������� �7� (55���). ���� al = 10, �� 55 + 10 = 65 � ��� ���������� ������� �A�
m2:
				xor 	ah, ah ; ah = 0, ����������� 1-�� ���������� �������
				call 	to_show
				popf
				pop 	ax
				ret



to_show:
				push	si
				mov		[char],al ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ���[]
				lea		si,[char]
				;Write
                    push si
                mov ah,1
				int 0x21
                    pop si
				;call	Write
				pop		si
				ret

char			DB "@",0





