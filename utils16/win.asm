; Загрузчик для DOORS 32-bit
; Переход в защищенный режим
[bits 16]
    [org 0x100]
    jmp doWin

%include "kernel16\gdt.asm"
%include "kernel16\idt.asm"
%include "kernel16\int32.asm"


; Сохраняем регистры для возврата в реальный режим
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



doWin:

    ; Читаем файл
    mov si,ImageName_k32text
    mov dx,FILE_SEG_k32text
    mov bx,FILE_ADDR_k32text
    ;FileRead
    mov ah,0x20
    int 0x21
    cmp ah,1
    je file_not_find  ; Файл не найден

    ; Читаем файл
    mov si,ImageName_k32data
    mov dx,FILE_SEG_k32data
    mov bx,FILE_ADDR_k32data
    ;FileRead
    mov ah,0x20
    int 0x21
    cmp ah,1
    je file_not_find  ; Файл не найден

    ;DEBUG-----------------------------------------------------
    ;mov ah,0
    ;int 0x16
    ;-----------------------------------------------------

    ; Включаем адресную линию A20
    mov ax,0x2401
    int 0x15

    mov al,0xD1
    out 0x64,al
    mov al,0xDF
    out 0x60,al

    ; Подготавливаем адрес возврата в R-Mode:
	mov	word [R_Mode_segment],cs
	lea	ax,init_real
	mov	word [R_Mode_offset],ax

    ; set 0x811B VESA 1280x1024 16M color vidmem=0xFD000000
    ; set 0x8118 VESA 1024x768  16M color vidmem=0xFD000000
    ; set 0x8112 VESA 640x480   16M color vidmem=0xFD000000
    ;mov ax,0x4F02
    ;mov bx,0x811B
    ;int 0x10

; Переключение в защищенный режим #########################################
	cli

	; Перепрограммируем контроллер прерываний
	mov al,20h
	call new_8259A

	lidt    [idt_descriptor]

	lgdt	[gdt_descriptor]

	; Сохраняем регистры для возврата в реальный режим
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

	mov	ebp,0x90000-0x20000     ; Адрес стека
	mov	esp,ebp

	;ltr [tss_main_descriptor]

	sti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call	0x10000;0x10000;0x30000-0x20000;0x1000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Возврат в реальный режим
    cli

    ; Перепрограммируем контроллер прерываний
	mov al,08h
	call new_8259A

    ; Замена теневых регистров
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
R_Mode_offset	dw	0	; Значения R_Mode_offset и R_Mode_segment
R_Mode_segment	dw	0

[bits 16]
init_real:

    ; Восстанавливаем сегментные регистры
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
    ; Завершение программы
    mov bh,1
    int 0x20



; Перепрограммируем контроллер прерываний###################################
; в al - значение нового базового вектора
new_8259A:
    push ax
    mov al,00010001b
    out 20h,al  ;ICW в порт 20h
    jmp $+2
    jmp $+2     ; задержка, чтобы успела отработать аппаратура
    pop ax
    out 21h,al  ;ICW2 в порт 20h - новый базовый номер
    jmp $+2
    jmp $+2     ; задержка, чтобы успела отработать аппаратура
    mov al,00000100b
    out 21h,al  ;ICW3 - ведомый подключается к уровню 2
    jmp $+2
    jmp $+2     ; задержка, чтобы успела отработать аппаратура
    mov al,00000001b
    out 21h,al  ;ICW4 - EOI выдает программа пользователя
    ret




