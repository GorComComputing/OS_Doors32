%include "kernel16\gdt.asm"
%include "kernel16\idt.asm"
%include "kernel16\int32.asm"

pm_landed	db 'PM LANDED!',0

Start_from_PM EQU 0x7C08

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


; Переключение в защищенный режим ###############################
switch_to_pm:
	cli

	; Перепрограммируем контроллер прерываний
	mov al,20h
	call new_8259A

	lidt    [idt_descriptor]

	lgdt	[gdt_descriptor]

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

	mov	ebp,0x90000     ; Адрес стека
	mov	esp,ebp


	;ltr [tss_main_descriptor]


	sti



	VIDEO_ADDRESS0 equ 0xb8000+80*2*0+1*2
	mov	edx,VIDEO_ADDRESS0 	; адрес видеопамяти
	; Вывод строки PM LANDED!
	mov	ebx,pm_landed
	call	print_string_pm
	jmp behind_print_string


; 32 битный вывод на экран ######################################
print_string_pm:
	pusha

print_sring_pm_loop:
	mov	al,[ebx]
	mov	ah,0x04		        ;RED_ON_BLACK

	cmp	al,0
	je	print_string_pm_done

	mov	[edx],ax

	add	ebx,1
	add	edx,2

	jmp	print_sring_pm_loop

print_string_pm_done:
	popa
	ret
behind_print_string:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call	0x1000
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

	jmp	0:init_real

[bits 16]
init_real:

    mov ax,0x1000
	mov ss,ax
	mov	bp,0xE000;0x9000	; Устанавливаем адрес стека
	mov	sp,bp

	xor	ax, ax		; Setup segments to insure they are 0. Remember that
	mov	ds, ax		; we have ORG 0x7c00. This means all addresses are based
	mov	es, ax	    ; from 0x7c00:0. Because the data segments are within the same
                    ; code segment, null em.

    lidt [idt_descriptor_real]

    ;mov ax,0xb000
	;push ax
	;pop es

	;mov	al,'V'
	;mov	ah,0x04		        ;RED_ON_BLACK

	;mov	[es:0x8002],ax

    sti

    ; set 80x25 16 color
    mov	ax,03h
    int	10h

    jmp 0:Start_from_PM
[bits 16]

