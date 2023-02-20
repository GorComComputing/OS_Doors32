; СУБД SQLite для DOORS
[bits 16]
    [org 0x100]
    jmp doSQLite

quitFLG_sql		DB 0				; Флаг выхода из SQLite
sql_entr		DB "db > ",0		; Приглашение для ввода
sqlite1     	DB "SQLite v.1.0 (c) 2022 Gor.Com",0
sqlite_status	DB "SQLite",0
error1_sql		DB "Unrecognized command!",0
nullSQL			DB 0
plotsSQL		DB ".........",0	; для команды Help

ctable_sql		DB ".EXIT",0,"Exit from SQLite",0
				DW doQuit_SQLite
				DB ".HELP",0,"Show this help screen",0
				DW doHelp_SQLite
				DB ".CLS",0,".Clear screen",0
				DW doCLS
				DB 0

command		times 128 DB 0	; Командная строка (128 символов)


; SQLite #############################################################################
doSQLite:

                ; Вывод строки статуса
                lea	si,[sqlite_status]
                mov ah,7
                int 0x21

				;WriteLn
				lea	si,[sqlite1]
				mov ah,0
				int 0x21

				; Выводим приглашение ко вводу - db> и ждем ввод строки
opros_sql:
                ;Write
                lea	si,[sql_entr]
                mov ah,1
				int 0x21

opr_sql1:
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
				je		opr_sql1
				; Выполняем введенную команду
				call	doCommand_SQLite
				mov		al,[quitFLG_sql]
				or		al,al
				je		opros_sql

				; Выход из программы
				mov bh,0
				int 20h

; Выполнение команды SQLite ###############################################################
doCommand_SQLite:
				lea		di,[ctable_sql]
dCmd3_sql:		lea		si,[command]
dCmd0_sql:		mov		al,[si]
				cmp		al,[di]
				jne		dCmd1_sql		; Команда не опознана
				or		al,al
				je		dCmd2_sql		; Конец команды, команда опознана
				inc		di
				inc		si
				jmp		dCmd0_sql
dCmd1_sql:		inc		di
				cmp		byte [di],0
				jne		dCmd1_sql
				inc		di
				inc		di
				inc		di
				cmp		byte [di],0
				je		dCmd4_sql
				jmp		dCmd3_sql		; Проверяем следующую команду
dCmd2_sql:		inc		di
				cmp		byte [di],0
				jne		dCmd2_sql
				inc		di
				push	di
				;WriteLn
				lea		si,[nullSQL]
				mov     ah,0
                int     0x21
				pop		di
				mov		si,[di]
				call	si
				ret
dCmd4_sql:
                ;WriteLn
                lea		si,[nullSQL]
                mov     ah,0
                int     0x21
				;WriteLn
				lea		si,[error1_sql]
				mov     ah,8
                mov     bh,0x74
                int     0x21
				ret


; Очистка экрана #######################################################################
doCLS:
				;CLS
				mov     ah,3
                int     0x21
				ret


; Выход из SQLite #######################################################################
doQuit_SQLite:
				mov		byte [quitFLG_sql],1
				ret


; Страничка помощи #####################################################################
doHelp_SQLite:
				lea		di,[ctable_sql]
doHelp0_sql:	mov		si,di
				push	di
				mov		al,[di]
				or		al,al
				je		doHelp3_sql
				;Write
				mov ah,1
				int 0x21
				;Write
				lea		si,[plotsSQL]
				mov ah,1
				int 0x21
				;Write
				pop		di
doHelp1_sql:	inc		di
				cmp		byte [di],0
				jne		doHelp1_sql
				inc		di
				push	di
				;Write
				mov		si,di
				mov ah,1
				int 0x21
				;Write
				lea		si,[nullSQL]
				mov ah,0
				int 0x21
				;WriteLn
				pop		di
doHelp2_sql:	inc		di
				cmp		byte [di],0
				jne		doHelp2_sql
				inc		di
				inc		di
				inc		di
				jmp		doHelp0_sql
doHelp3_sql:	pop	di
				ret

    %include "lib16\string.asm"



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






