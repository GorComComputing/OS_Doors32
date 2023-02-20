; БИБЛИОТЕКА ВВОДА 16-битного ядра

command_int			times 128 DB 0	; Командная строка (128 символов)
char_int    DB 0,0

; Ввод строки с эхом ###################################################################
Input:
				mov		ax,cs
				mov		es,ax
				lea		di,[command_int]
				mov		cx,128
				xor		ax,ax
				rep		stosb

				lea		di,[command_int]
				mov		bh,[cs:mainy16]
				mov		bl,[cs:mainx16]
				xor		cx,cx
inp1:			push	cx
				xor		ax,ax
				int		16h
				pop		cx
				cmp		al,13		; Enter
				je		ipEnter
				cmp		al,8
				je		ipBackSpace	; BackSpace
				or		al,al
				je		inp1

				mov		[cs:di],al
                    mov		[char_int],al

				inc		di
				inc		cx
				cmp		cx,126
				jne		inp2
				dec		di
				dec		cx
inp2:			push	di
				mov		byte [cs:di],0
				;mov		[cs:mainy16],bh
				;mov		[cs:mainx16],bl
                    lea		si,[char_int]
				;lea		si,[cs:command_int]
				push	cx
				call	Write
				pop		cx
				pop		di
				jmp		inp1
				; Заглушка для задержки ввода
				;xor		ax,ax
				;int		16h
ipEnter:
                ret
ipBackSpace:
                    push dx
                    push ax
                wln_send_enter_08:
                    mov dx,03FDh
                    in al,dx
                    test al,20h
                    jz wln_send_enter_08

                    mov al,0x08
                    mov dx,03F8h
                    out dx,al ;посылает байт

                wln_send_enter_20:
                    mov dx,03FDh
                    in al,dx
                    test al,20h
                    jz wln_send_enter_20

                    mov al,0x20
                    mov dx,03F8h
                    out dx,al ;посылает байт

                wln_send_enter_08_2:
                    mov dx,03FDh
                    in al,dx
                    test al,20h
                    jz wln_send_enter_08_2

                    mov al,0x08
                    mov dx,03F8h
                    out dx,al ;посылает байт

                    pop ax
                    pop dx


                push	si
				lea		si,[command_int]
				cmp		si,di
				pop		si
				je		inp1
				dec		di
				push	di
				;push    bx
				mov		byte [cs:di],0
                    mov		bl,[cs:mainx16]
                    dec bl
                    ;mov		[cs:mainx16],bl
				mov		[cs:mainy16],bh
				mov		[cs:mainx16],bl
				;lea		si,[cs:command_int]
				;call	Write
				lea		si,[cs:space]
				call	Write
				mov		[cs:mainy16],bh
				mov		[cs:mainx16],bl
				;lea		si,[cs:command_int]
				;call	Write
				;pop		bx
				pop     di
				dec		cx
				jmp		inp1

