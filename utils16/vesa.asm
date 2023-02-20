; VESA status
[bits 16]
    [org 0x100]
    jmp start_program

error_message DB "Parameter not defined!",0

ctable          DB "STATUS",0
                DW doVESA
                DB 0

null			DB 0
space           DB " ",0




; A20 #############################################################################
start_program:

doCommand:
				lea		di,[ctable]
dCmd3:
                lea		si,[0x0081]
                ;call Skip_spaces    ; пропускаем пробелы
dCmd0:

                mov		al,[di]
				cmp		al,[si]
				jne		dCmd1		; Команда не опознана

				cmp al,0            ; если конец строки
				je		dCmd2		; Конец команды, команда опознана

				inc		di
				inc		si
				jmp		dCmd0

dCmd1:			; Команда не опознана
                cmp al,0            ; если пробел
				jne	pass_Cmd1		; Конец команды, команда опознана

                cmp byte [si],0x20  ; если пробел
				je		dCmd2		; Конец команды, команда опознана

				cmp byte [si],0x0D  ; если (Enter)
				je		dCmd2		; Конец команды, команда опознана
pass_Cmd1:
                inc		di
				cmp		byte [di],0
				jne		pass_Cmd1
				inc		di
				inc		di
				inc		di
				cmp		byte [di],0
				je		dCmd4       ; Если команды закончились, пытаемся найти COM-файл
				jmp		dCmd3		; Проверяем следующую команду
dCmd2:			; конец команды, команда опознана
                inc		di
				;cmp		byte [di],0
				;jne		dCmd2
				;inc		di
				;push	di
				;push si
				;WriteLn
				;lea		si,[null]
				;mov     ah,0
                ;int     0x21

                ;pop si
                ;call	Skip_spaces    ; пропускаем пробелы
				;pop		di
				mov		di,[di]


				call	di
				ret


dCmd4:
                ;WriteLn
                lea		si,[error_message]		; Вывод сообщения об ошибке
				mov     ah,8
                mov     bh,0x74
				int 0x21

                jmp end_program







end_program:
				; Выход из программы
				mov bh,0
				int 20h


; Информация о VESA #######################################################################
VESA_str_OK	    DB "VESA OK",0
VESA_str_ER	    DB "VESA not supported!",0
bytes           DB " bytes ",0
VESA_811B_ER	DB "0x811B not supported! (1280x1024 16M color)",0
VESA_811B_OK	DB "0x811B (1280x1024 16M color) ",0
VESA_811B_24bit	DB "24-bit ",0
VESA_811B_32bit	DB "32-bit ",0
OX              DB "0x",0
LBA_ok          DB " LBA",0
LBA_err         DB " not LBA",0
port6845        DB "port ",0

base_addr_info EQU 0x8F00

doVESA:

    push es
    mov ax,0
    mov es,ax
    mov ax,0x4F00
    mov di,base_addr_info
    int 0x10
    pop es

    cmp ax,0x4F
    jne VESA_err

    ; Выводим сигнатуру VESA
    push ds
    push 0
    pop ds
    lea		si,[base_addr_info]
	;Write
    mov     ah,1
    int     0x21
    pop ds

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Выводим номер версии VESA
    push ds
    push 0
    pop ds
    mov al,byte[base_addr_info+5]
    pop ds
    call PRINT_BYTE

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Наименование микросхемы видеоконтроллера
    push ds
    push 0
    pop ds
    mov		si,[base_addr_info+6]
    push 0xC000
    pop ds
	;Write
    mov     ah,1
    int     0x21
    pop ds

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Выводим объем видеопамяти
    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    ;xor eax,eax
    mov ax,word [base_addr_info+0x12]
    pop ds
    mov bx,0xFFFF
    mul bx
    push ax
    ;shr eax,16
    mov ax,dx
    call PRINT_WORD
    pop ax
    call PRINT_WORD

    lea		si,[bytes]
	;Write
    mov     ah,1
    int     0x21

    ; Порт видеоконтроллера
    lea		si,[port6845]
	;Write
    mov     ah,1
    int     0x21

    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov ax,word [0x0463]
    pop ds
    call PRINT_WORD

    lea		si,[null]
	;WriteLn
    mov     ah,0
    int     0x21


    ; Поддерживается ли видеорежим 0x811B VESA 1280x1024 16M color
    mov ax,0
    mov es,ax
    mov ax,0x4F01
    mov cx,0x811B
    mov di,0x8F00
    int 0x10

    cmp ax,0x4F
    jne VESA_811B_err

    push ds
    push 0
    pop ds
    mov	ah,[base_addr_info]
    pop ds
    test ah,00000001b
    jz VESA_811B_err

    ; Режим 0x811B поддерживается
	lea		si,[VESA_811B_OK]
	;Write
    mov     ah,1
    int     0x21

    ; Бит на пиксель
    push ds
    push 0
    pop ds
    mov	si,base_addr_info+0x25

    cmp byte [si],0
    je print24bit
    cmp byte [si],8
    je print32bit

after_bits:
    ; Выводим адрес видеопамяти
    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov	ax,[base_addr_info+0x2A]
    pop ds
    call PRINT_WORD
    push ds
    push 0
    pop ds
    mov	ax,[base_addr_info+0x28]
    pop ds
    call PRINT_WORD


    ; Поддерживается ли LBA
    push ds
    push 0
    pop ds
    mov	ah,[base_addr_info]
    pop ds
    test ah,10000000b
    jnz print_LBA_ok

    ; Режим 0x811B поддерживается
	lea		si,[LBA_err]
	;WriteLn
    mov     ah,0
    int     0x21

    ; Выход из программы
	jmp end_program

print_LBA_ok:
    ; Режим 0x811B поддерживается
	lea		si,[LBA_ok]
	;WriteLn
    mov     ah,0
    int     0x21

    ; Выход из программы
	jmp end_program

print24bit:
    pop ds
    lea		si,[VESA_811B_24bit]
	;Write
    mov     ah,1
    int     0x21
    jmp after_bits

print32bit:
    pop ds
    lea		si,[VESA_811B_32bit]
	;Write
    mov     ah,1
    int     0x21
    jmp after_bits




VESA_811B_err:
	lea		si,[VESA_811B_ER]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int 0x21

    ; Выход из программы
	jmp end_program


VESA_err:
	lea		si,[VESA_str_ER]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int 0x21

    ; Выход из программы
	jmp end_program



; вывод слова на экран
; ax — выводимое слово
PRINT_WORD:
				push	ax
				mov 	al, ah
				call 	PRINT_BYTE	; выводим старший байт
				pop 	ax
				call 	PRINT_BYTE 	; выводим младший байт
				ret


; вывод байта на экран
; al — выводимый байт
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


; перевод 4-ёх бит в 16-тиричный символ и вывод на экран
; al — выводимый байт
PRINT_DIGIT:
				push	ax
				pushf
				cmp 	al, 0Ah
				jae 	m1 ; если al больше или равно 10, то переход
				add 	al, 30h ; складываем с кодом символа «0» (48дес)
				jmp 	m2
m1:
				add 	al, 37h ; складываем с кодом символа «7» (55дес). Если al = 10, то 55 + 10 = 65 — код выводимого символа «A»
m2:
				xor 	ah, ah ; ah = 0, равносильно 1-му выводимому символу
				call 	to_show
				popf
				pop 	ax
				ret



to_show:
				push	si
				mov		[char],al ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; без[]
				lea		si,[char]
				;Write
                    ;push si
                mov ah,1
				int 0x21
                    ;pop si
				pop		si
				ret

char			DB "@",0






