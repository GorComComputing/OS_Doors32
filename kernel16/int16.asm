;���������� ��������� ������ #########################################################################
[bits 16]


;COM1 #######################################################################
int0�h_r:
    pusha

recv:
    mov dx,03FDh
    in al,dx
    test al,1
    jz recv

    mov dx,03F8h
    in al,dx

    mov ah,05
    mov ch,0
    mov cl,al
    int 0x16



    ;push ax

    ;mov dx,word [0x041C]
    ;mov ax,0x400
    ;add ax,dx
    ;mov di,ax
    ;pop ax
    ;mov byte [di],al
    ;inc di
    ;xor al,al
    ;mov byte [di],al

        ;call PRINT_BYTE

    ;cmp dx,0x043D
    ;jne inc_buf

    ;mov dx,0x041E
    ;mov [0x041C],dx

    ;jmp end_int

;inc_buf:
    ;inc dl
    ;inc dl
    ;mov byte [0x041C],dl

;end_int:
    ; ����� �� ����������
    mov   al,20h
    out   20h,al    ;�������
    out   0A0h,al   ;�������



    popa
    iret


;���������� ������ ###########################################################
int1�h_r:
    pusha

    ; ���������� ��������� �����
    call Clock

    popa
    iret


; ���������� ��������� #######################################################
int20h_r:
    mov ax,word [ds:0x0016]
	mov	ds, ax		; ��������������� ������������ ��������
	mov	es, ax	    ;
	mov	fs, ax	    ;
	mov	gs, ax	    ;

	mov ax,0x9000
	mov ss,ax
	mov	bp,0xFFFF	; ������������� ����� �����
	mov	sp,bp

	cmp bh,0
	jne restore_console
    jmp 0x0000:0x2584   ; ��� �������������� �������
restore_console:
    jmp 0x0000:0x2000   ; � ��������������� �������

    iret

;#############################################################################
int21h_r:
    ; ������� 0 - ����� ������ � ��������� � ������ ������������ ############
    ; ����  : si = ������
    cmp     ah,0
    je      int21h_00h
    ; ������� 1 - ����� ������ � ������ ������������ #######################
    ; ����  : si = ������
    cmp     ah,1
    je      int21h_01h
    ; ������� 2 - ���� ������ � ���� ########################################
    ; ����  : di = ����� ����� 128 ����
    cmp     ah,2
    je      int21h_02h
    ; ������� 3 - ������� ������ ������� ############################################
    cmp     ah,3
    je      int21h_03h
    ; ������� 4 - ������� ����� ������ ############################################
    cmp     ah,4
    je      int21h_04h
    ; ������� 5 - ����� ������ � ��������� ������������ #######################
    ; ����  : si = ������
    ;       : dx = ����������
    cmp     ah,5
    je      int21h_05h
    ; ������� 6 - ���������� ���������� ������� ������� #######################
    ; ����  : dx = ����������
    cmp     ah,6
    je      int21h_06h
    ; ������� 7 - ������� ��������� ������ ###################################
    ; ����  : si = ������
    cmp     ah,7
    je      int21h_07h
    ; ������� 8 - ����� ������ � ��������� � ������ ������������ (����) ############
    ; ����  : si = ������
    ;       : bh = ����
    cmp     ah,8
    je      int21h_08h
    ; ������� 9 - ����� ������ � ������ ������������ (����) #######################
    ; ����  : si = ������
    ;       : bh = ����
    cmp     ah,9
    je      int21h_09h
    ; ������� 20 - ��������� ����  ###########################################
    ; ����  : si = ��� �����
    ;       : bx = ����� ��������
    ;       : dx = ����� ��������
    cmp     ah,0x20
    je      int21h_20h
    ; ������� 21 - �������� ����������  ###########################################
    cmp     ah,0x21
    je      int21h_21h
    ; ������� FD - ������� � ���������� �����  ###########################################
    ; ����  :
    ;       :
    cmp     ah,0xFD
    je      int21h_FDh
    ; ������� FE - ���� Speaker  ###########################################
    ; ����  : di = ������� �����
    ;       : bx = ������������
    cmp     ah,0xFE
    je      int21h_FEh
    ; ������� FF - ������������� ���������  ###########################################
    cmp     ah,0xFF
    je      int21h_FFh
    iret


int21h_00h:
    pusha
    push fs
    push ds
    push es
    push ds
    pop fs
    push cs
    pop ds
    push cs
    pop es
    call WriteLn
    pop es
    pop ds
    pop fs
    popa
    iret


int21h_01h:
    pusha
    push fs
    push ds
    push es
    push ds
    pop fs
    push cs
    pop ds
    push cs
    pop es
    call Write
    pop es
    pop ds
    pop fs
    popa
    iret

int21h_02h:
    ;pusha
    ;push ss

    ;push es
    ;push cs
    push di
    push di
    push gs
    push fs
    push ds
    push es
    push ds
    pop gs
    push cs
    pop ds
    push cs
    pop es
    push cs
    pop fs


    call	Input




    pop es
    pop ds
    pop fs
    pop gs


    pop di
    ;pop ds
    ;pop es
    push cs
    pop ds


    ;lea		di,[command_int]
    mov		cx,128
    xor		ax,ax
    rep		stosb
    pop di



    lea		si,[command_int]
    mov		cx,128
    rep movsb
    push es
    pop ds


    ;pop ss
    ;popa
    ;mov di,[command]
    ;push cs
    ;pop es
    iret


int21h_03h:
    pusha
    ;push fs
    push ds
    ;push es
    ;push ds
    ;pop fs
    push cs
    pop ds
    ;push cs
    ;pop es

    mov		ch,[windowy16]
    mov		cl,[windowx16]
    dec		cl
    mov		dh,[windowHx16]
    inc		dh
    mov		dl,[windowWx16]
    inc		dl
    inc		dl
    mov		ax,0600h
    mov		bh,[color16]
    int		10h
    mov		byte [mainx16],0
    mov		byte [mainy16],0

    ; ����� �����
    mov		cx,0101h
	mov		dx,164Dh
	call 	Ramka

    ;pop es
    pop ds
    ;pop fs
    popa
    iret


int21h_04h:
    call CLS
    iret


int21h_05h:
    pusha
    push fs
    push ds
    push es
    push ds
    pop fs
    push cs
    pop ds
    push cs
    pop es
    call Print
    pop es
    pop ds
    pop fs
    popa
    iret


int21h_06h:
    pusha
    ;push fs
    push ds
    ;push es
    ;push ds
    ;pop fs
    push cs
    pop ds
    ;push cs
    ;pop es

    ;mov		ch,[windowy16]
    ;mov		cl,[windowx16]
    ;dec		cl
    ;mov		dh,[windowHx16]
    ;inc		dh
    ;mov		dl,[windowWx16]
    ;inc		dl
    ;inc		dl
    ;mov		ax,0600h
    ;mov		bh,[color16]
    ;int		10h
    mov		byte [mainx16],dl
    mov		byte [mainy16],dh
    push    dx
    push    dx

    mov ax,14
    mov dx,03D4h
    out dx,al

    pop dx
    mov al,dh;25           ; ���������� Y
    mov dx,03D5h
    out dx,al

    mov ax,15
    mov dx,03D4h
    out dx,al

    pop dx
    mov al,dl;80           ; ���������� X
    mov dx,03D5h
    out dx,al

    ; ����� �����
    ;mov		cx,0101h
	;mov		dx,164Dh
	;call 	Ramka

    ;pop es
    pop ds
    ;pop fs
    popa
    iret


int21h_07h:
    pusha
    push fs
    push ds
    push es
    push ds
    pop fs
    push cs
    pop ds
    push cs
    pop es
    call StatusString
    pop es
    pop ds
    pop fs
    popa
    iret


int21h_08h:
    pusha
    push fs
    push ds
    push es
    push ds
    pop fs
    push cs
    pop ds
    push cs
    pop es

    xor cx,cx
    mov ch,[color16]
    push cx
    mov [color16],bh
    call WriteLn
    pop cx
    mov [color16],ch

    pop es
    pop ds
    pop fs
    popa
    iret


int21h_09h:
    pusha
    push fs
    push ds
    push es
    push ds
    pop fs
    push cs
    pop ds
    push cs
    pop es

    xor cx,cx
    mov ch,[color16]
    push cx
    mov [color16],bh
    call Write
    pop cx
    mov [color16],ch

    pop es
    pop ds
    pop fs
    popa
    iret


; ��������� ���� ##############################################################
int21h_20h:
    ;pusha
    push fs
    push ds
    push es

    push ds
    pop fs

    push cs
    pop ds
    push cs
    pop es

    call    FileRead

    pop es
    pop ds
    pop fs
    ;popa
    iret


; �������� ���������� ##############################################################
int21h_21h:
    pusha
    call DirShow
    popa
    iret


; ������� � ���������� ����� ##############################################################
%include "kernel16\gdt.asm"
%include "kernel16\idt.asm"
%include "kernel16\int32.asm"


; ��������� �������� ��� �������� � �������� �����
real_ss DW 0
real_es DW 0
real_bp DW 0
real_sp DW 0
real_ds DW 0
real_fs DW 0
real_gs DW 0

ImageName_k32text DB "K32TEXT SYS",0
FILE_SEG_k32text EQU 0x3000
FILE_ADDR_k32text EQU 0x0000

ImageName_k32data DB "K32DATA SYS",0
FILE_SEG_k32data EQU 0x4000
FILE_ADDR_k32data EQU 0x0000


int21h_FDh:
    push fs
    push ds
    push es

        push cs
        pop ds

    push ds
    pop fs

    ;push cs
    ;pop ds
    push cs
    pop es

    ; ������ ����
    mov si,ImageName_k32text
    mov dx,FILE_SEG_k32text
    mov bx,FILE_ADDR_k32text
    ;FileRead
    mov ah,0x20
    int 0x21
    cmp ah,1
    je file_not_find  ; ���� �� ������

    ; ������ ����
    mov si,ImageName_k32data
    mov dx,FILE_SEG_k32data
    mov bx,FILE_ADDR_k32data
    ;FileRead
    mov ah,0x20
    int 0x21
    cmp ah,1
    je file_not_find  ; ���� �� ������

    ;DEBUG-----------------------------------------------------
    ;mov ah,0
    ;int 0x16
    ;-----------------------------------------------------

    ; �������� �������� ����� A20
    mov ax,0x2401
    int 0x15

    mov al,0xD1
    out 0x64,al
    mov al,0xDF
    out 0x60,al

    ; �������������� ����� �������� � R-Mode:
	mov	word [R_Mode_segment],cs
	lea	ax,init_real
	mov	word [R_Mode_offset],ax

    ; set 0x811B VESA 1280x1024 16M color vidmem=0xFD000000
    ; set 0x8118 VESA 1024x768  16M color vidmem=0xFD000000
    ; set 0x8112 VESA 640x480   16M color vidmem=0xFD000000
    mov ax,0x4F02
    mov bx,0x811B
    int 0x10

; ������������ � ���������� ����� #########################################
	cli

	; ����������������� ���������� ����������
	mov al,20h
	call new_8259A

	lidt    [idt_descriptor]

	lgdt	[gdt_descriptor]

	; ��������� �������� ��� �������� � �������� �����
	mov     word [real_ss],ss
    mov     word [real_es],es
    mov	    word [real_bp],bp
	mov	    word [real_sp],sp
	mov	    word [real_ds],ds
	mov	    word [real_fs],fs
	mov	    word [real_gs],gs

    mov	eax,cr0
	or	eax,0x1
	mov	cr0,eax

	jmp	CODE_SEG:init_pm

[bits 32]
init_pm:

	mov	ax,DATA_SEG
	mov	ds,ax
	mov	ss,ax
	mov	es,ax
	mov	fs,ax
	mov	gs,ax

	xor ax,ax
	lldt ax

	mov	ebp,0x90000;-0x20000     ; ����� �����
	mov	esp,ebp

	;ltr [tss_main_descriptor]

	;sti

	int 0x01

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call	0x30000;0x10000;0x30000-0x20000;0x1000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    int 0x01

    ; ������� � �������� �����
    cli

    ; ����������������� ���������� ����������
	mov al,08h
	call new_8259A

	; ������ ������� ���������
	mov	ax,DATA_SEG_REAL
	mov	ds,ax
	mov	ss,ax
	mov	es,ax
	mov	fs,ax
	mov	gs,ax
    jmp	CODE_SEG_REAL:set_shadow_reg

set_shadow_reg:
	mov eax,cr0
	and eax,0FFFFFFFEh
	mov cr0,eax

	                ;jmp far
                db	0eah
R_Mode_offset	dw	0	; �������� R_Mode_offset � R_Mode_segment
R_Mode_segment	dw	0

[bits 16]
init_real:

    ; ��������������� ���������� ��������
    mov     ss,word [real_ss]
    mov     es,word [real_es]
    mov	    bp,word [real_bp]
	mov	    sp,word [real_sp]
	mov	    ds,word [real_ds]
	mov	    fs,word [real_fs]
	mov	    gs,word [real_gs]

    lidt [idt_descriptor_real]

    sti

    ;DEBUG--------------------------------
    mov ax,0
    int 0x16
    ;-------------------------------------

    ; set 80x25 16 color
    mov	ax,03h
    int	10h


    ;DEBUG--------------------------------
    mov ax,0x0903
    mov bx,0x001F
    mov cx,1
    int 0x10

    mov ax,0
    int 0x16
    ;-------------------------------------

file_not_find:
    ; ���������� ���������
    ;mov bh,1
    ;int 0x20


    pop es
    pop ds
    pop fs

    iret

; ����������������� ���������� ����������###################################
; � al - �������� ������ �������� �������
new_8259A:
    push ax
    mov al,00010001b
    out 20h,al  ;ICW1 � ���� 20h
    jmp $+2
    jmp $+2     ; ��������, ����� ������ ���������� ����������
    pop ax
    out 21h,al  ;ICW2 � ���� 20h - ����� ������� �����
    jmp $+2
    jmp $+2     ; ��������, ����� ������ ���������� ����������
    mov al,00000100b
    out 21h,al  ;ICW3 - ������� ������������ � ������ 2
    jmp $+2
    jmp $+2     ; ��������, ����� ������ ���������� ����������
    mov al,00000001b
    out 21h,al  ;ICW4 - EOI ������ ��������� ������������
    ret


; ���� Speaker ##############################################################
int21h_FEh:
    pusha
    ;mov di,500     ;������� �����
    ;mov bx,20000   ;������������
    mov al,0b6H
    out 43H,al
    mov dx,0014H
    mov ax,4f38H
    div di
    out 42H,al
    mov al,ah
    out 42H,al
    in al,61H
    mov ah,al
    or al,3
    out 61H,al
l1_16:     mov cx,2801H
l2_16:     loop l2_16
    dec bx
    jnz l1_16
    mov al,ah
    out 61H,al
    popa
    iret


; ������������� ��������� ##############################################################
int21h_FFh:
    ; �������� ��� �������

    ; ������ 1
    ;JMP 0xFFFF:0000

    ; ������ 2
    mov al,0xFE
    out 0x64,al
    iret


; ������ ������ � ����� LBA
int25h_r:
    call    ReadSect
    iret


; ���������� ������ �� ���� LBA
int26h_r:

    iret

