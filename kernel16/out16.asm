; БИБЛИОТЕКА ВЫВОДА 16-битного ядра

color16			DB 0x70			; Цвет: белый символ на голубом фоне 1Fh
windowx16		DB 3			; Координаты левого верхнего угла голубого экрана вывода
windowy16		DB 2			;
windowHx16		DB 15h			; Размеры рабочей области экрана 74x21 (80x25)
windowWx16		DB 4Ah			;
mainx16			DB 0			; Координаты курсора для Write и WriteLn
mainy16			DB 5			;
space			DB 20h,0


; Очистка экрана ##################################################################
CLS:
	pusha
	push es
	mov	ax,0B800h		; Устанавливаем адрес видеопамяти
	mov es,ax
	mov	dx,0000h            ; Координаты верхнего левого угла
	call	SetVideoAddress
	mov cx,0FA0h        ; Размер видеопамяти
cls_loop:
	mov	ah,[color]		; Цвет
	mov	al,20h  		; Символ
	mov	[es:di],ax		; Копируем символ и атрибут в видеопамять
	inc	di
	inc	di
	loop	cls_loop

    ; Скрыть курсор
    mov ax,14
    mov dx,03D4h
    out dx,al

    mov ax,25           ; Координата Y
    mov dx,03D5h
    out dx,al

    mov ax,15
    mov dx,03D4h
    out dx,al

    mov ax,80           ; Координата X
    mov dx,03D5h
    out dx,al

    pop es
	popa
	ret

; Вывод строки с переносом и общими координатами #####################################
WriteLn:
                pusha
				push	ds
				push    es
				call	Write
				mov		byte [mainx16],0
				mov		al,[mainy16]
				inc		al
				cmp		al,[windowHx16]
				jne		wln
				dec		al
				push	ax
				mov		ch,[windowy16]
				mov		cl,[windowx16]
				dec		cl
				mov		dh,[windowHx16]
				inc		dh
				mov		dl,[windowWx16]
				inc		dl
				inc		dl
				mov		ax,0601h
				mov		bh,[color16]
				int		10h
				pop		ax
wln:

                    push dx
                    push ax
                wln_send_enter_0A:
                    mov dx,03FDh
                    in al,dx
                    test al,20h
                    jz wln_send_enter_0A

                    mov al,0x0A
                    mov dx,03F8h
                    out dx,al ;посылает байт

                wln_send_enter_0D:
                    mov dx,03FDh
                    in al,dx
                    test al,20h
                    jz wln_send_enter_0D

                    mov al,0x0D
                    mov dx,03F8h
                    out dx,al ;посылает байт

                    pop ax
                    pop dx


                mov		[mainy16],al
				mov		dh,[mainy16]
				mov		dl,[mainx16]
				add		dh,[windowy16]
				add		dl,[windowx16]
				xor		bx,bx
				mov		ax,0200h
				int		10h
				pop		es
				pop     ds
				popa
				ret



; Вывод строки с общими координатами #################################################
Write:

				push	ds
				push    es
				mov		ax,0B800h
				mov		es,ax
				call	GetCurrentVideoAddress16
				mov		dl,[mainx16]
				mov		dh,[mainy16]
write1:			mov		ah,[color16]
                ;push ds;;;;;;;;;;;;;;;
				;push cs;;;;;;;;;;;;;;;
				;pop ds;;;;;;;;;;;;;;;;
				;push    ds
				;mov     ds,[StoreDS]
				mov		al,[fs:si]
				;pop ds;;;;;;;;;;;;;;;;
				or		al,al
				je		writeend

				mov		[es:di],ax


                    push dx
                    push ax
                send:
                    mov dx,03FDh
                    in al,dx
                    test al,20h
                    jz send

                    pop ax
                    mov dx,03F8h
                    out dx,al ;посылает байт

                    pop dx

				inc		di
				inc		di
				inc		si
				inc		dl
				cmp		dl,[windowWx16]
				je		wxcarry
				jmp		write1
writeend:		mov		[mainx16],dl
				mov		[mainy16],dh
				add		dh,[windowy16]
				add		dl,[windowx16]
				push	bx
				xor		bx,bx
				mov		ax,0200h
				int		10h
				pop		bx
				pop		es
				pop     ds


				ret
				; Перенос строки
wxcarry:
                    push dx
                    push ax
                send_enter_0A:
                    mov dx,03FDh
                    in al,dx
                    test al,20h
                    jz send_enter_0A

                    mov al,0x0A
                    mov dx,03F8h
                    out dx,al ;посылает байт

                send_enter_0D:
                    mov dx,03FDh
                    in al,dx
                    test al,20h
                    jz send_enter_0D

                    mov al,0x0D
                    mov dx,03F8h
                    out dx,al ;посылает байт

                    pop ax
                    pop dx



                xor		dl,dl
				inc		dh
				push	dx
				call	WindowSetVideoAddress16
				pop		dx
				cmp		dh,[windowHx16]
				jne		write1
				dec		dh
				push	dx
				push	bx
				mov		ch,[windowy16]
				mov		cl,[windowx16]
				dec		cl
				mov		dh,[windowHx16]
				inc		dh
				mov		dl,[windowWx16]
				inc		dl
				inc		dl
				mov		ax,0601h
				mov		bh,[color16]
				int		10h
				call	WindowSetVideoAddress16
				pop		bx
				pop		dx
				dec		bh
				jmp		write1



; Вывод строки ds:di ##################################################################
Print:
	pusha
	push es
	push ax
	mov	ax,0B800h		; Устанавливаем адрес видеопамяти
	mov es,ax
	add	dh,0;[windowy16]	; Прибавляем координаты верхнего левого угла
	add	dl,0;[windowx16]
	call	SetVideoAddress16
	pop ax
	mov	ah,al;[color16]		; Цвет
print1:
	mov	al,[fs:si];ds		; Символ
	or	al,al			; Проверка на 0 - конец строки
	je	prnend
	mov	[es:di],ax		; Копируем символ и атрибут в видеопамять
	inc	di
	inc	di
	inc	si
	jmp	print1
prnend:
    pop es
	popa
	ret


; Вывод рамки #########################################################################
Ramka:
    push es
    mov		ax,0B800h
    mov		es,ax
    or		dl,dl
    je		RamkaEnd
	or		dh,dh
	je		RamkaEnd
	mov		ah,[color16]
	dec		dl
	dec		dh
	xor		bh,bh
	mov		bl,ch
	push	dx
	push    ax
	mov	    dx,160
    mov	    ax,bx
	mul 	dx
	mov 	bx,ax
	pop		ax
	pop     dx
	xor		ch,ch
	shl		cx,1
	add		bx,cx
	mov		di,bx
	push 	di
	mov		al,0C9h	;"+"
	stosw
	mov		al,0CDh	;"-"
	xor		ch,ch
	mov		cl,dl
	rep		stosw
	mov		al,0BBh	;"+"
	stosw
	pop		di
	mov		cl,dh
	xor		ch,ch
Ramka_1:
	add		di,160
	push	di
	push	cx
	mov		al,0BAh	;"|"
	stosw
	mov		al," "
	xor		ch,ch
	mov		cl,dl
	rep		stosw
	mov		al,0BAh	;"|"
	stosw
	pop		cx
	pop		di
	loop	Ramka_1
	add		di,160
	mov		al,0C8h	;"+"
	stosw
	mov		al,0CDh	;"-"
	xor		ch,ch
	mov		cl,dl
	rep		stosw
	mov		al,0BCh	;"+"
	stosw
RamkaEnd:
    pop es

    call StatusString

	ret


status_begin    DB "[",0
status_end      DB "]",0
status_line     times 72 DB 205	; Командная строка (128 символов)
                DB 0
; Строка статуса ############################################################
StatusString:
    pusha
    push si
    push fs
    push ds
    pop fs
    lea		si,[status_line]
	mov		dx,0x1706	; Координаты
	mov al,0x70
	call Print
    lea		si,[status_begin]
	mov		dx,0x1705	; Координаты
	mov al,0x70
	call Print
    pop fs
    pop si
	;lea	si,[status_string]
	push si
	mov cx,1
count_string:
	cmp byte [fs:si],0
	je count_string_end
	inc cx
	inc si
	jmp count_string
count_string_end:
	pop si
	push cx

	;lea		si,[status_string]
	mov	dx,0x1706	; Координаты
	mov al,0x70
	call Print
    pop cx
	push fs
    push ds
    pop fs

    add cl,05
    mov dl,cl
	lea	si,[status_end]
	mov	dh,0x17	; Координаты
	mov al,0x70
	call Print
	pop fs
	popa
	ret


; Получаем текущий адрес в видеопамяти #################################################
GetCurrentVideoAddress16:
	mov	dl,[mainx16]
	mov	dh,[mainy16]

WindowSetVideoAddress16:
	add	dl,[windowx16]
	add	dh,[windowy16]

; Установить адрес видеопамяти #########################################################
SetVideoAddress16:
	push	bx
	xor	bh,bh
	mov	bl,dh
	shl	bx,1
	mov	di,[ScRow+bx]
	xor	dh,dh
	shl	dx,1
	add	di,dx
	pop	bx
	ret


; Получаем текущий адрес в видеопамяти #################################################
GetCurrentVideoAddress:
	mov	dl,[mainx]
	mov	dh,[mainy]

WindowSetVideoAddress:
	add	dl,[windowx]
	add	dh,[windowy]

; Установить адрес видеопамяти #########################################################
SetVideoAddress:
	push	bx
	xor	bh,bh
	mov	bl,dh
	shl	bx,1
	mov	di,[ScRow+bx]
	xor	dh,dh
	shl	dx,1
	add	di,dx
	pop	bx
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
color		DB 0Eh;;;
windowx		DB 0	;;;		 
windowy		DB 0;;;
windowHx	DB 15h
windowWx	DB 4Ah
mainx		DB 0;;;
mainy		DB 5;;;

ScRow 		DW 0;;;
            DW 160
            DW 320
            DW 480
            DW 640
            DW 800
            DW 960
            DW 1120
            DW 1280
            DW 1440
            DW 1600
            DW 1760
            DW 1920
            DW 2080
            DW 2240
            DW 2400
            DW 2560
            DW 2720
            DW 2880
            DW 3040
            DW 3200
            DW 3360
            DW 3520
            DW 3680
            DW 3840

