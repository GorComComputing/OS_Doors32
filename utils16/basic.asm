; Интерпретатор BASIC
[bits 16]
    [org 0x100]
    jmp doBasic

vars			EQU 8E00h;7E00h	; Переменные (a-z)
running			EQU 8E7Eh;7E7Eh	; Указатель на строчку, которая сейчас выполняется
;line			EQU 8A80h;7E80h	; Строчка программы, которую напечатал программист
program			EQU 8F00h;7F00h	; Указатель на буфер для исходника программы
;stack			EQU 0FF00h	; Адрес стека
max_line		EQU 1000	; Максимальное количество строчек в программе
max_length		EQU 20		; Максимальная длина строчки программы
max_size		EQU max_line*max_length



statements		DB 3,"new"
				DW start_bas
				DB 4,"list"
				DW list_handler
				DB 3,"run"
				DW run_handler
				DB 5,"print"
				DW print_handler
				DB 5,"input"
				DW input_handler
				DB 2,"if"
				DW if_handler
				DB 4,"goto"
				DW goto_handler
				DB 3,"cls"
				DW cls_handler
				DB 4,"help"
				DW help_handler
				DB 4,"dump"
				DW dump_handler
				DB 4,"peek"
				DW peek_handler
				DB 4,"poke"
				DW poke_handler
				DB 4,"load"
				DW load_handler
				DB 0
EXIT_CMD		DB "exit"

basic1			DB "BASIC v.1.0 (c) 2022 Gor.Com",0
basic_status    DB "BASIC",0
entr_bas		DB ">",0		; Приглашение для ввода ">"
entr2_bas		DB "?",0		; Приглашение для ввода "?"
error_message	DB "Error!",0
address_line	DB ": ",0
char			DB "@",0
command_bas		times 128 DB 0	; Командная строка (128 символов)
null			DB 0

; BASIC #############################################################################
doBasic:
				call	Initialization	; Инициализация
; Главный цикл интерпретатора
main_loop_bas:
				xor		ax,ax			; Обнуляем счетчик команд
				mov		[running],ax	;

				lea		si,[entr_bas]	; Выводим приглашение ко вводу ">" и ждем ввод строки
				;Write
                    ;push si
				mov ah,1
				int 0x21
                    ;pop si
				;Input
                    ;push di
                lea	di,[command_bas]
                mov ah,2
				int 0x21
                    ;pop di

				lea 	si,[command_bas]
				call	Dec_str_to_number	; Строчка начинается с числа?
				or		ax,ax			; (в AX число, если есть)
				je		no_save			; если нет, не сохраняем и выполняем сразу.
				call	Find_address	; Вычисляем адрес, куда сохранить строчку
				xchg	ax,di			; Помещаем адрес из AX в DI
				mov		cx,max_length	; читаем 20 символов в строке
				rep		movsb			; Сохраняем введенную строчку в программу

				call	Enter_line		;переводим строку
				jmp		main_loop_bas

no_save:								; Интерактивная обработка
				; Проверяем на команду EXIT
				push	si
				mov		cx,0004				; Количество символов в команде EXIT (4)
				lea		di,[EXIT_CMD]		; Указатель на строку "exit"
				rep		cmpsb				; и сравниваем символ за символом
				pop		si
				jne		no_exit
				call	Enter_line		;переводим строку

				; Выход из программы
				mov bh,0
				int 20h

no_exit:								; Если не EXIT
				call	Enter_line		;переводим строку
				call	execute_statement
				jmp		main_loop_bas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if_handler:
				call	process_expr
				or		ax,ax
				je		to_ret
execute_statement:
				call	Skip_spaces			; Пропускаем пробелы
				cmp		byte [si],0Dh	; Если пустая строка, то завершаем выполнение строки
				je		to_ret				;

				lea		di,[statements]		; Указатель на таблицу команд
next_entry:
				mov		cl,[di]				; Количество символов в команде
				mov		ch,0
				test	cx,cx				; Если 0, то достигнут конец таблицы,
				je		to_get_var			; значит это переменная

				push	si					; Сохраняем адрес введенной строки в стеке

				inc		di					; Переводим указатель на имя команды в таблице
				rep		cmpsb				; и сравниваем символ за символом
				jne		no_equal			; Если не совпала, проверяем следующую команду в таблице

				pop		ax					; в AX адрес строки ввода
				call	Skip_spaces			; Пропускаем пробелы, перемещаем указатель на операнды

				jmp		word [di]		; Передаем управление обработчику команды
no_equal:
				add		di,cx				; Перемещаем указатель к следующей команде в таблице
				inc		di					;
				inc		di					;
				pop		si					;
				jmp		next_entry			;
to_get_var:
				call	get_var
				push	ax
				lodsb
				cmp		al,'='
				je		assign2
output_error:
				call	ErrorMsg				; Вывод сообщения об ошибке
				jmp		main_loop_bas
to_ret:
				ret
assign2:
				call	process_expr	; Вычисляем введенное выражение
				pop		di
				stosw					; Сохраняем результат в переменную
				ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_var:
				lodsb
get_var_2:
				and		al,1Fh
				add		al,al
				mov		ah,7Eh
				jmp		Skip_spaces





output_number:
				xor		dx,dx
				mov		cx,10
				div		cx
				or		ax,ax
				push	dx
				je		to_output_char
				call	output_number
to_output_char:
				pop		ax
				add		al,'0'
				jmp		output_char
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Выполнение команды RUN и GOTO
run_handler:
				xor		ax,ax
				jmp		to_goto
goto_handler:
				call	process_expr
to_goto:
				call	Find_address
				cmp		word [running],0
				je		to_next_line
				mov		[running],ax
				ret
to_next_line:
				push	ax
				pop		si
				add		ax,max_length
				mov		[running],ax
				call	execute_statement
				mov		ax,[running]
				cmp		ax,program+max_size
				jne		to_next_line
				ret


; Вынимаем номер из строки и помещаем его в AX (SI указывает на строку)
Dec_str_to_number:
				xor		bx,bx
to_next_digit:
				lodsb
				sub		al,'0'
				cmp		al,10
				cbw
				xchg	ax,bx
				jnc		not_digit
				mov		cx,10
				mul		cx
				add		bx,ax
				jmp		to_next_digit
not_digit:
				dec		si
				ret


; По номеру вычисляет адрес строки в исходнике
Find_address:
				mov		cx,max_length	; в AX хранится номер строки
				mul		cx				; умножаем его на длину строки (20)
				add		ax,program		; прибавляем адрес первой строки программы
				ret						; в AX возвращает адрес


; Обработчик оператора PRINT
print_handler:
				lodsb
				cmp		al,0Dh			; Если PRINT без аргумента,
				je		new_line		; то переводим строку
				cmp		al,'"'			; Если ", то читаем символ за символом
				jne		no_quote
next_char1:
				lodsb
				cmp		al,'"'
				je		to_semicolon
				call	output_char
				cmp		al,0Dh
				jne		next_char1
				ret
no_quote:
				dec		si
				call	process_expr	; вычисляем выражение
				call	output_number	; выводим число
to_semicolon:
				lodsb
				cmp		al,';'			; Проверяем на ;
				jne		new_line
				ret

output_char:
				cmp		al,0Dh
				jne		to_show
new_line:
				call	Enter_line		;переводим строку
				ret
to_show:
				push	si
				mov		[char],al ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; без[]
				lea		si,[char]
				;Write
                    push si
                mov ah,1
				int 0x21
                    pop si
				;call	Write
				pop		si
				ret


; Обработчик оператора INPUT
input_handler:
				call	get_var			; Вычисляет адрес переменной
				push	ax				; Сохраняет его в стек

				; Выводим приглашение ко вводу "?" и ждем ввод строки
				push	si
				lea		si,[entr2_bas]
				;Write
                    push si
                mov ah,1
				int 0x21
                    pop si
				;call	Write
				pop		si
				push	si
				;Input
                    ;push di-------------------
                lea	di,[command_bas]
                mov ah,2
				int 0x21
                    ;pop di----------------------
				;call	Input
				pop		si

				; Присваиваем в переменную
				call	process_expr	; Вычисляем введенное выражение
				pop		di
				stosw					; Сохраняем результат в переменную

				call	Enter_line		; переводим строку

				ret


; Обработчик оператора "="
assign:
				call	process_expr	; Вычисляем введенное выражение
				pop		di
				stosw					; Сохраняем результат в переменную
				ret


; Выполнение команды LIST
list_handler:
				xor		ax,ax			; Сбрасываем в 0 номер текущей строки в программе
next_line:
				push	ax				; Сохраняем номер строки в стеке
				call	Find_address	; Вычисляем адрес, откуда считывать программу
				xchg	ax,si
				cmp		byte [si],0Dh	; Проверка на пустую строку
				je		empty_line
				pop		ax
				push	ax
				call	output_number	; Выводим номер строки
next_char:
				lodsb
				call	output_char		; Выводим посимвольно строку, пока не конец строки (0Dh)
				cmp		al,0Dh
				je Ln
				cmp		al,00h
				je Ln
				jmp		next_char
Ln:
                call Enter_line

empty_line:
				pop		ax				; Если строка пустая, увеличиваем счетчик строк AX
				inc		ax
				cmp		ax,max_line
				jne		next_line		; Если достигли максимальной строки, завершаем вывод
				ret


; Инициализация интерпретатора
Initialization:
                ; Вывод строки статуса
                lea	si,[basic_status]
                mov ah,7
                int 0x21

				; Вывод строки
				lea		si,[basic1]		; Вывод строки приветствия
				;WriteLn
                    ;push si
				mov ah,0
				int 0x21
                    ;pop si
start_bas:
				cld						; Флаг направления DF = 0, чтобы строки обрабатывались слева направо
				mov		di,program		; Буфер исходника программы, заполняем символом 0Dh (Enter)
				mov		al,0Dh			;
				mov		cx,max_size		;
				rep		stosb			;
				ret


; Пропускает все пробелы
Skip_spaces:
				cmp		byte [si],' '
				jne		skip_complete
skip_spaces_2:
				inc		si				; инкремент SI, если пробел
				jmp		Skip_spaces

skip_complete:
				ret


; Перевод строки
Enter_line:
				push	si
				lea		si,[null]		;переводим строку
				;WriteLn
                    ;push si
				mov ah,0
				int 0x21
                    ;pop si
				pop		si
				ret


; Вывод сообщения об ошибке
ErrorMsg:
				push	si
				lea		si,[error_message]		; Вывод сообщения об ошибке
				;WriteLn
                    ;push si
				mov     ah,8
                mov     bh,0x74
				int 0x21
                    ;pop si
				pop		si
				ret


; Очистка экрана
cls_handler:
				;CLS
                    pusha
				mov     ah,3
                int     0x21
                    popa
				ret


; Справка о командах Basic
help_handler:
				lea		si,[basic1]		; Вывод строки приветствия
				;WriteLn
                    ;push si
                mov     ah,0
                int     0x21
                    ;pop si
				ret


; Выводит дамп памяти
dump_handler:
				call 	atoi        ;Преобразует строку в HEX
				push 	ax
				inc 	si 			;next char
				call	atoi
				;call 	PRINT_WORD
				mov		cx,ax
				pop 	ax

				;mov		cx,2
loop_dump:							; цикл вывода дампа
				call 	PRINT_LINE 	; выводим строку 16 байт на экран
				add ax, 10h ; прибавляем к адресу 17 байт для вывода следующей строки
				loop	loop_dump
				ret


; Преобразует строку в HEX
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


; вывод на экран строки из 16-ти байт
; ax — адрес выводимого 16-ти байтного дампа
PRINT_LINE:
				push 	ax
				push 	cx
				push 	si
				push	ax
				call 	PRINT_WORD			; контрольноый вывод наашего адреса на экран
				lea		si,[address_line]	; Выводим строку ": "
				;Write
                    push si
                mov ah,1
				int 0x21
                    pop si

				pop		ax
				mov 	si,ax
				push	ax
				mov 	cx, 10h ; регистр cx — счётчик цикла, загружаем число 16
loop1:
				lodsb
				call 	PRINT_BYTE
				mov 	al, 20h ; символ пробела для разделения байтов на экране
				call 	to_show ; выводим пробел на экран
				loop 	loop1 	; повторяем цикл 16 раз, в команде loop регистр cx = cx — 1

				mov 	al, 0B3h ; символ пробела для разделения байтов на экране
				call 	to_show ; выводим пробел на экран

				pop		ax
				mov 	si,ax
				mov 	cx, 10h ; регистр cx — счётчик цикла, загружаем число 16
loop2:
				lodsb
				cmp		al,0
				jz		print_point
				call 	to_show
				jmp		jmp_loop
print_point:
				mov		al,'.'
				call 	to_show
jmp_loop:
				loop 	loop2 	; повторяем цикл 16 раз, в команде loop регистр cx = cx — 1

				call	Enter_line		; перевод строки

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


; Вычисление выражения
process_expr:
				call	expr2_left
next_sub_add:
				cmp		byte [si],'-'
				je		to_op_sub
				cmp		byte [si],'+'
				jne		to_ret2
				push	ax
				call	expr2_right

				pop		cx
				add		ax,cx
				jmp		next_sub_add
to_op_sub:
				push	ax
				call	expr2_right
				pop		cx
				xchg	ax,cx
				sub		ax,cx
				jmp		next_sub_add

expr2_right:
				inc		si
expr2_left:
				call	expr3_left
next_div_mul:
				cmp		byte [si],'/'
				je		to_op_div
				cmp		byte [si],'*'
				jne		to_ret2

				push	ax
				call	expr3_right

				pop		cx
				imul	cx
				jmp		next_div_mul
to_op_mul:
				push	ax
				call	expr3_right
				pop		cx
				imul	cx
				jmp		next_div_mul
to_op_div:
				push	ax
				call	expr3_right
				pop		cx
				xchg	ax,cx
				cwd
				idiv	cx
				jmp		next_div_mul

expr3_right:
				inc		si
expr3_left:
				call	Skip_spaces
				lodsb
				cmp		al,'('
				jne		not_par
				call	process_expr
				cmp		byte [si],')'
				jne		output_error_2
				jmp		skip_spaces_2

output_error_2:
				call	ErrorMsg				; Вывод сообщения об ошибке
				jmp		main_loop_bas

not_par:
				cmp		al,40h
				jnc		yes_var
				dec		si

				call	Dec_str_to_number
				jmp		Skip_spaces
yes_var:
				call	get_var_2
				xchg	ax,bx
				mov		ax,[bx]
to_ret2:
				ret


; Обработчик оператора PEEK (читать байт из памяти)
peek_handler:
				lodsb
				cmp		al,0			; Если PEEK без аргумента,
				je		serv_peek		; то выводим служебный адрес

				call 	atoi        ;Преобразует строку в HEX
				mov 	si,ax
				lodsb
				call 	PRINT_BYTE
				call	Enter_line
				ret

;peek_color		DB " - Color",0
peek_entr_bas	DB " - Enter basic",0
;peek_entr	    DB " - Enter DOORS",0
;peek_doHelp	    DB " - do Help DOORS",0
;peek_doSQLite   DB " - do SQLite",0
peek_program    DB " - program Basic",0
peek_vars       DB " - vars Basic",0
;peek_doWin      DB " - do Win",0
;peek_doVESA     DB " - do VESA",0
;peek_doFAT      DB " - do FAT",0
;peek_WriteLn    DB " - do WriteLn",0
;peek_Write      DB " - do Write",0
;peek_int20h_r   DB " - int20h_r",0

serv_peek:
				;lea		di,[color16]
				;mov		ax,di
				;call	PRINT_WORD
                ;lea		si,[peek_color]
                ;WriteLn
                ;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				lea		di,[entr_bas]
				mov		ax,di
				call	PRINT_WORD
				lea		si,[peek_entr_bas]
				;WriteLn
				    push si
				mov     ah,0
                int     0x21
                    pop si
				;call	WriteLn

				;lea		di,[entr]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_entr]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				;lea		di,[doHelp]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_doHelp]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				;lea		di,[doSQLite]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_doSQLite]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				lea		di,[8B00h]
				mov		ax,di
				call	PRINT_WORD
				lea		si,[peek_program]
				;WriteLn
				    push si
				mov     ah,0
                int     0x21
                    pop si
				;call	WriteLn

				lea		di,[8A00h]
				mov		ax,di
				call	PRINT_WORD
				lea		si,[peek_vars]
				;WriteLn
				    push si
				mov     ah,0
                int     0x21
                    pop si
				;call	WriteLn

				;lea		di,[doWin]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_doWin]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				;lea		di,[doVESA]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_doVESA]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				;lea		di,[DiskReadFAT]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_doFAT]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				;lea		di,[WriteLn]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_WriteLn]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				;lea		di,[Write]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_Write]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si

				;lea		di,[int20h_r]
				;mov		ax,di
				;call	PRINT_WORD
				;lea		si,[peek_int20h_r]
				;WriteLn
				;    push si
				;mov     ah,0
                ;int     0x21
                ;    pop si


				ret


; Обработчик оператора POKE (записать байт в память)
poke_handler:
				call 	atoi        ;Преобразует строку в HEX
				push 	ax
				inc 	si 			;next char
				call	atoi
				mov		dl,al
				pop 	ax
				mov 	di,ax
				mov		[di],dl
				ret


; Обработчик оператора LOAD (JMP -передача управления по адресу)
load_handler:
				call 	atoi        ;Преобразует строку в HEX
				jmp		ax
				ret

