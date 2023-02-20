; COM-port
[bits 16]
    [org 0x100]
    jmp doStart

null			DB 0
err_recv_msg    DB "Error recv!",0

terminalFLG_sql	DB 0				; Флаг выхода
terminal_hello  DB "Terminal RS-232 (c) 2023 Gor.Com",0
terminal_status	DB "Terminal RS-232",0
terminal_entr   DB "com > ",0		; Приглашение для ввода

command		times 128 DB 0	; Командная строка (128 символов)

recv_byte       DB "@",0
send_byte       DB "@",0

; COM-port #############################################################################
doStart:

                ; Вывод строки статуса
                lea	si,[terminal_status]
                mov ah,7
                int 0x21

				;WriteLn
				lea	si,[terminal_hello]
				mov ah,0
				int 0x21

				; Выводим приглашение ко вводу - db> и ждем ввод строки

                ;Write
                lea	si,[terminal_entr]
                mov ah,1
				int 0x21
opros:
opr:
                ;Input
                ;lea	di,[command]
                ;mov ah,2
				;int 0x21
				xor		ax,ax
				int		16h
				; Сделать все введенные символы в командной строке заглавными
				;lea		di,[command]
				;call	UpperString
				; Проверяем на пустую строку ввода
				;mov		al,[command]
				;or		al,al
				;je		opr
				; Выполняем введенную команду
				call	doCOM
				mov		al,[terminalFLG_sql]
				or		al,al
				je		opros

				; Выход из программы
				mov bh,0
				int 20h




doCOM:
    push ax

    xor ax,ax
;записываем  в LCR режим работы сом порта:
;8 бит всимволе,1 стоп бит, проверка паритета на четность,выдавать 0 в случае обрыва, DLAB=1
    mov al,83h ;записываем в AL значения для регистра LCR
    mov dx,03FBh
    out dx,al  ;записываем данные в регистр UART LCR

;задаем скорость обмена  9600 бит/сек  DIM=00h (старший), DLL=младший
    mov al,0Ch
    mov dx,03F8h
    out dx,al ;запись регистра DLL

    mov al,00h
    mov dx,03F9h
    out dx,al ;запись регистра DIM

;снимаем бит DLAB=1
    mov al,03h ;DLAB=0
    mov dx,03FBh
    out dx,al

    ; Запрещаем прерывания
    ;mov al,0
    ;mov dx,03F9h
    ;out dx,al

    ; порт управления линией
    ;mov al,00001011b ; DTR, RTS, OUT1, OUT2
    ;mov dx,03FCh
    ;out dx,al

    mov al,0;00000111b
    mov dx,03FAh
    out dx,al

recv:
    mov dx,03FDh
    in al,dx
    test al,1
    jz pass_recv

    ;test al,0Eh
    ;jnz err_recv

    ;---------------------
    xor ax,ax
    mov dx,03F8h
    in al,dx
    ;call PRINT_WORD
    mov [recv_byte],al
    lea		si,[recv_byte]
    ;WriteLn
    mov     ah,1
    int     0x21

pass_recv:

;send:
    mov dx,03FDh
    in al,dx
    test al,20h
    jz pass_send

    pop ax

;послать байт 43h в линию связи
    ;xor ax,ax
    ;mov al,43h
    mov dx,03F8h
    out dx,al ;посылает байт

pass_send:

            ;Get status
            ;mov ah,0x03
            ;mov dx,0x00     ;Port number
            ;int 0x14

    ; Get LSR
    ;xor ax,ax
    ;mov dx,03FDh
    ;in al,dx
    ;call PRINT_WORD
    ;lea		si,[null]
    ;WriteLn
    ;mov     ah,0
    ;int     0x21

    ; Get FCR
    ;xor ax,ax
    ;mov dx,03FAh
    ;in al,dx
    ;call PRINT_WORD
    ;lea		si,[null]
    ;WriteLn
    ;mov     ah,0
    ;int     0x21

    ret



err_recv:
    lea		si,[err_recv_msg]
    ;WriteLn
    mov     ah,0
    int     0x21



    ; Выход из программы
    mov bh,0
    int 20h







doCOM2:
    mov ah,0
    mov al,11100011b
    mov dx,0
    int 14h



    mov ah,3
    mov dx,0
    int 14h

    call PRINT_WORD
    lea		si,[null]
    ;WriteLn
    mov     ah,0
    int     0x21


    mov ah,2
    mov dx,0
    int 14h

    call PRINT_WORD
    lea		si,[null]
    ;WriteLn
    mov     ah,0
    int     0x21

    mov ah,1
    mov al,66h
    mov dx,0
    int 14h

    call PRINT_WORD
    lea		si,[null]
    ;WriteLn
    mov     ah,0
    int     0x21

    ; Выход из программы
    mov bh,0
    int 20h



doCOM3:


    xor ax,ax
    mov dx,03FBh
    mov al,52h
    ;out 378h,al
    out dx,al

    xor ax,ax
    mov dx,03FBh
    in al,dx
    ;in al,378h

    call PRINT_WORD
    lea		si,[null]
    ;WriteLn
    mov     ah,0
    int     0x21


    ; Выход из программы
    mov bh,0
    int 20h




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
