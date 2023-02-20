; Оработчики команд Shell
[bits 16]
    [org 0x2000]
    jmp doShell

null			DB 0
plots			DB ".........",0	; для команды Help
entr			DB "$ ",0		; Приглашение для ввода
string0			DB "DOORS v.1.0 (c) 2022-2023 Gor.Com",0
string1			DB "Type 'help' for help.",0
string			DB "GOR.COM DOORS",0
status_string   DB "A:/",0
loading			DB "Kernel 16-bit loaded",0
error_message	DB "Error!",0
command			times 128 DB 0	; Командная строка (128 символов)

Label_DOORS
DB ".........................................................................."
DB "..............##.......................#####.......######................."
DB "...........###...##...................#.....##....#......##..............."
DB "..........#........#.................#........#...#........#.............."
DB ".........#..........#...............#.......##.....######................."
DB ".........#..........#..............#########.............##..............."
DB "........#..........#..####..#######...##...................#.............."
DB "........#.......###.##...#.#....###.....##....#............#.............."
DB ".......#.....###....#....##.....##.............##.........#..............."
DB ".......######......######.#...##.#........#.......########................"
DB "...........................###............................................"
DB "..........................................................................",0


ctable          DB "HELP",0,"..Show this help screen",0
				DW doHelp
				DB "CLS",0,"...Clear screen",0
				DW doCLS
				DB "DIR",0,"...Show directory",0
				DW doDIR
				DB "RESET",0,".Restart",0
				DW doReset
				DB "DUMP",0,"..Show memory and registers",0
				DW doDump
				DB "INFO",0,"..Debug information",0
				DW doInfo
				DB "OFF",0,"...Power Off",0
				DW doOff
				DB 0

                ; Подключаем библиотеки
                %include "lib16\string.asm"

;############################################################################
doShell:
    ; Очистка экрана
	mov ah,4
	int 0x21

    ; Вывод рамки
	mov ah,3
	int 0x21

	; Установить курсор
	mov ah,6
	mov dx,0x0200;0x0500
	int 0x21

	call init_COM

	;call doAutoexec


	;Print
	lea		si,[string]
	mov		dx,0222h	; Координаты
	mov ah,5
	mov al,0x70
	int 0x21

	;Print
	;lea		si,[loading]
	;mov		dx,0503h	; Координаты
	;mov ah,5
	;mov al,0x70
	;int 0x21

	;WriteLn
	;lea		si,[Label_DOORS]
	;mov     ah,0
	;int     0x21

    ;WriteLn
	lea		si,[string0]
	mov     ah,0
	int     0x21

	;WriteLn
	lea		si,[string1]
	mov     ah,0
	int     0x21

Return_from_program:
;---------------------------------------

    ; Вывод строки статуса
	lea	si,[status_string]
	mov ah,7
	int 0x21

	; Выводим приглашение ко вводу - $ и ждем ввод строки
opros:
    ;Write
	lea		si,[entr]
	mov     ah,1
	int     0x21

opr1:
    ;Input
    lea	di,[command]
    mov ah,2
    int 0x21
	; Сделать все введенные символы в командной строке заглавными
	lea		di,[command]
	call	UpperString
	; Проверяем на пустую строку ввода
	mov		al,[command]
	or		al,al
	je		opr1
	; Выполняем введенную команду
	call	doCommand
    ; Бесконечный цикл
	jmp		opros


; Пропускает все пробелы ######################################################
Skip_spaces:
				cmp		byte [si],' '
				jne		skip_complete
skip_spaces_2:
				inc		si				; инкремент SI, если пробел
				jmp		Skip_spaces

skip_complete:
				ret


; Выполнение команды ####################################################################
ImageName_shell DB "XXXXXXXXCOM",0
FILE_SEG_shell EQU 0x2000
FILE_ADDR_shell EQU 0x0100

doCommand:
				lea		di,[ctable]
dCmd3:
                lea		si,[command]
                call Skip_spaces    ; пропускаем пробелы
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
                cmp al,0         ; если пробел
				jne	pass_Cmd1		; Конец команды, команда опознана

                cmp byte [si],0x20         ; если пробел
				je		dCmd2		; Конец команды, команда опознана
pass_Cmd1:
                inc		di
				cmp		byte [di],0
				jne		dCmd1
				inc		di
				inc		di
				inc		di
				cmp		byte [di],0
				je		dCmd4       ; Если команды закончились, пытаемся найти COM-файл
				jmp		dCmd3		; Проверяем следующую команду
dCmd2:			; конец команды, команда опознана
                inc		di
				cmp		byte [di],0
				jne		dCmd2
				inc		di
				push	di
				push si
				;WriteLn
				lea		si,[null]
				mov     ah,0
                int     0x21

                pop si
                call	Skip_spaces    ; пропускаем пробелы
				pop		di
				mov		di,[di]


				call	di
				ret
dCmd4:

    ;push si

    ;WriteLn
    lea		si,[null]
    mov     ah,0
    int     0x21

    lea di,[ImageName_shell]
    lea	si,[command]
    call Skip_spaces    ; пропускаем пробелы
    mov	cx,8
    rep movsb

    ;push si

    ; Дополняем имя пробелами
    lea di,[ImageName_shell]
    mov cx,8
count8:
    cmp byte [di],0x20
    je  end_count
    cmp byte [di],0
    jne no_replace
    mov byte [di],0x20
no_replace:
    inc di
    loop count8
    jmp done_count

end_count:
    mov byte [di],0x20
    inc di
    loop end_count

done_count:



    ; Читаем файл
    mov si,ImageName_shell
    mov dx,FILE_SEG_shell
    mov bx,FILE_ADDR_shell
    ;FileRead
    mov ah,0x20
    int 0x21
    cmp ah,1
    je dCmd5  ; Файл не найден

    push FILE_SEG_shell
    pop es

    ;pop si

    ;push si
    lea si,[command]
    call Skip_spaces    ; пропускаем пробелы

pass_name:
    cmp byte [si],0
    je end_param_copy_di
    cmp byte [si],' '
    je done_name
    inc si
    jmp pass_name
done_name:
    call Skip_spaces    ; пропускаем пробелы


end_param_copy_di:
    push si
    lea di,[es:0x0081]
loop_param_copy:
    cmp byte [si],0
    je end_param_copy
    ;call Skip_spaces    ; пропускаем пробелы
    movsb
    ;inc si
    ;inc di
    jmp loop_param_copy

end_param_copy:
    mov byte [es:di],0x0D

    pop di
    sub si,di
    inc si
    mov ax,si
    mov byte [es:0x0080],al

    push FILE_SEG_shell
    pop ds
    push FILE_SEG_shell
    pop ss
    push FILE_SEG_shell
    pop fs
    push FILE_SEG_shell
    pop gs


    xor ax,ax
    mov word [es:0xFFFE],ax
    mov ax,0x20CD
    mov word [es:0x0000],ax
    mov ax,cs;-------------------------
    mov word [es:0x0016],ax


    ;mov ax,ss;-------------------------
    ;mov word [es:0x0018],ax
    ;mov ax,sp;-------------------------
    ;mov word [es:0x001A],ax
    ;mov ax,bp;-------------------------
    ;mov word [es:0x001C],ax

    mov	bp,0xFFFE	; Устанавливаем адрес стека
    mov	sp,bp

    jmp FILE_SEG_shell:FILE_ADDR_shell

dCmd5:
				ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Страничка помощи #####################################################################
doHelp:
				lea		di,[ctable]
doHelp0:		mov		si,di
				push	di
				mov		al,[di]
				or		al,al
				je		doHelp3
				;Write
				mov ah,1
				int 0x21
				lea		si,[plots]
				;Write
				mov ah,1
				int 0x21
				pop		di
doHelp1:		inc		di
				cmp		byte [di],0
				jne		doHelp1
				inc		di
				push	di
				mov		si,di
				;Write
				mov ah,1
				int 0x21
				lea		si,[null]
				;WriteLn
				mov ah,0
				int 0x21
				pop		di
doHelp2:		inc		di
				cmp		byte [di],0
				jne		doHelp2
				inc		di
				inc		di
				inc		di
				jmp		doHelp0
doHelp3:		pop	di
				ret


; Очистка экрана #######################################################################
doCLS:
				;CLS
				mov     ah,3
                int     0x21
				ret


; Перезагрузка #######################################################################
doReset:
    ;Reset
    mov ah,0xFF
    int 0x21
    ret


; Показывает содержимое директории #######################################################################
; Directory of A:/
; .             <DIR>            01-09-2022 19:08
; ..            <DIR>            01-09-2022 19:08
; DOCS          <DIR>            01-09-2022 19:08
; COMPILE TXT              1,450 01-09-2022 19:08
; COMPILE TXT          1,474,560 01-09-2022 19:08
; COMPILE TXT              1,450 01-09-2022 19:08
;     5 File(s)        1,479,913 Bytes.
;     4 Dir(s)       262,479,913 Bytes free.
doDIR:
    ;DirShow
    mov ah,0x21
    int 0x21
    ret


; Выводит на экран содержимое памяти и регистры ###############################
Dump_error_str DB "Address not defined!",0

doDump:
                push fs
                push ds
                pop fs

                cmp byte [si],0
                je error_dump_null

				call 	atoi        ;Преобразует строку в HEX
				push ax             ; Адрес сегмента


				inc 	si 			;next char
				call Skip_spaces    ; пропускаем пробелы
				call	atoi
				push ax             ; Адрес смещения
				;mov 	 ax,0x0000

				inc 	si 			;next char
				call Skip_spaces    ; пропускаем пробелы
				call	atoi
				mov		cx,ax       ; количество строк

				pop ax
				pop bx

loop_dump:							; цикл вывода дампа
				call 	PRINT_LINE 	; выводим строку 16 байт на экран
				add ax, 10h ; прибавляем к адресу 17 байт для вывода следующей строки
				loop	loop_dump

                pop fs
    ret

error_dump_null:
    lea		si,[Dump_error_str]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int     0x21
    pop fs
    ret



; Преобразует строку в HEX ###################################################################
atoi:
				mov 	ax,0	;для результата
				mov 	bx,0 	;для символа
atoi_start:
				mov 	bl,[si] ;получаем текущий символ
				cmp 	bl,20h 	;конец строки
				je 		end_atoi
				cmp 	bl,0 	;конец строки
				je 		end_atoi

				cmp		bl,30h	; если
				jnge	at1
				cmp		bl,39h	; если
				jg		at1
				sub 	bl,30h	; digit
				jmp		next_mul
at1:
				cmp		bl,41h	; если
				jnge	at2
				cmp		bl,46h	; если
				jg		at2
				sub 	bl,37h	; ABCDEF
				jmp		next_mul
at2:
				cmp		bl,61h	; если
				jnge	at3
				cmp		bl,66h	; если
				jg		at3
				sub 	bl,57h	; abcdef
				jmp		next_mul
at3:
				call	ErrorMsg
				ret
next_mul:
				mov		dx,10h
				mul		dx

				add 	ax,bx 	;and add the new digit
				inc 	si 		;next char
				jmp 	atoi_start
end_atoi:
				ret


; Вывод сообщения об ошибке ##############################################################################
ErrorMsg:
				push	si
				lea		si,[error_message]		; Вывод сообщения об ошибке
				;WriteLn
				mov     ah,8
                mov     bh,0x74
				int 0x21
				pop		si
				ret


; вывод на экран строки из 16-ти байт
; ax — адрес выводимого 16-ти байтного дампа
PRINT_LINE:
				push 	ax
				push 	cx
				push 	si
				push	ax
				mov     ax,bx
				call 	PRINT_WORD
				lea		si,[address_line]	; Выводим строку ":"
				;Write
                mov ah,1
				int 0x21
                pop ax
                push ax
				call 	PRINT_WORD			; контрольноый вывод наашего адреса на экран

				mov 	al, 0B3h ; символ пробела для разделения байтов на экране
				call 	to_show ; выводим пробел на экран

				pop		ax
				mov 	si,ax
				push	ax
				mov 	cx, 0x0F ; регистр cx — счётчик цикла, загружаем число 16

loop1:
                push ds
                push bx
                pop ds
				lodsb           ;копирует один байт из памяти по адресу DS:SI в AL
				pop ds

				call 	PRINT_BYTE
				mov 	al, 20h ; символ пробела для разделения байтов на экране
				call 	to_show ; выводим пробел на экран
				loop 	loop1 	; повторяем цикл 16 раз, в команде loop регистр cx = cx — 1

                ; Последний байт выводится без пробела
				push ds
                push bx
                pop ds
				lodsb           ;копирует один байт из памяти по адресу DS:SI в AL
				pop ds

				call 	PRINT_BYTE


				mov 	al, 0B3h ; символ пробела для разделения байтов на экране
				call 	to_show ; выводим пробел на экран

				pop		ax
				mov 	si,ax
				mov 	cx, 10h ; регистр cx — счётчик цикла, загружаем число 16

loop2:
				push ds
                push bx
                pop ds
				lodsb           ;копирует один байт из памяти по адресу DS:SI в AL
				pop ds

				cmp		al,0
				jz		print_point
				call 	to_show
				jmp		jmp_loop
print_point:
				mov		al,'.'
				call 	to_show
jmp_loop:
				loop 	loop2 	; повторяем цикл 16 раз, в команде loop регистр cx = cx — 1

				;call	Enter_line		; перевод строки
				pop 	si
				pop 	cx
				pop 	ax
				ret


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


;########################################################################
to_show:
				push	si
				mov		[fs:char],al
				lea		si,[fs:char]
				;Write
                mov ah,1
				int 0x21
				pop		si
				ret


; Перевод строки #########################################################
Enter_line:
				push	si
				lea		si,[null]		;переводим строку
				;WriteLn
				mov ah,0
				int 0x21
				pop		si
				ret

char			DB "@",0
address_line	DB ":",0


; Отладочная информация ####################################################
peek_return_from_program	DB " - Return from program",0

doInfo:
    lea		di,[Return_from_program]
    mov		ax,di
    call	PRINT_WORD
    lea		si,[peek_return_from_program]
    ;WriteLn
    mov     ah,0
    int     0x21

    ret


; Завершение работы ####################################################
doOff:
    ; APM ---------------------
    mov ax,0x5301
    xor bx,bx
    int 0x15

    ; Try to set apm version (to 1.2).
    mov ax,0x530e
    xor bx,bx
    mov cx,0x0102
    int 0x15

    ; Turn off the system with APM
    mov ax,0x5307
    mov bx,0x0001
    mov cx,0x0003
    int 0x15

    ret


; Инициализация COM-порта ########################################################
init_COM:
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

    ; порт управления линией
    mov al,00001011b ; DTR, RTS, OUT1, OUT2
    mov dx,03FCh
    out dx,al

    mov al,0;00000111b
    mov dx,03FAh
    out dx,al

    ; Размаскируем прерывание COM1
    cli
    xor ax,ax
    in al,0x21
    and al,11101111b
    jmp $+2
    jmp $+2
    out 0x21,al
    sti

    ; Разрешаем прерывание при получении
    mov al,0x1
    mov dx,03F9h
    out dx,al

    ret


; Autoexec ##################################################################
ImageName_autoexec DB "AUTOEXECBAT",0
FILE_SEG_autoexec EQU 0x2000
FILE_ADDR_autoexec EQU 0x0100

doAutoexec:

    ; Читаем файл
    mov si,ImageName_autoexec
    mov dx,FILE_SEG_autoexec
    mov bx,FILE_ADDR_autoexec
    ;FileRead
    mov ah,0x20
    int 0x21
    cmp ah,1
    je dCmd5  ; Файл не найден



opros_autoexec:




	; Сделать все введенные символы в командной строке заглавными
	lea		di,[command]
	call	UpperString
	; Проверяем на пустую строку ввода
	mov		al,[command]
	or		al,al
	je		opros_autoexec
	; Выполняем введенную команду
	call	doCommand
    ; Бесконечный цикл
    ;cmp
	jmp		opros_autoexec


    ret










