; A20
[bits 16]
    [org 0x100]
    jmp start_program

error_message DB "Parameter not defined!",0

ctable          DB "STATUS",0
                DW doGetA20
                DB "ENABLE",0
                DW doSetA20
                DB "DISABLE",0
                DW doDisA20
                DB 0




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


; Получить статус A20 #######################################################################
a20_str_en	DB "A20 Enable",0
a20_str_dis	DB "A20 Disable",0

doGetA20:
    ; Через порт клавиатуры
    ;mov     al,0xD0
    ;out     0x64,al
    ;call    wait_output

    ;in  al,0x60
    ;push ax
    ;call wait_input

    ;mov, al,0xD1
    ;out 0x64,al
    ;call wait_input

    ;pop ax
    ;or al,02
    ;out 0x60,al

    ;test al,2
    ;jz a20_enable
    ;jmp a20_disable

    ; получить статус A20 в AL
    mov ax,0x2402
    int 0x15

    cmp AL,01
    jz  a20_enable
    cmp AL,00
    jz  a20_disable

a20_enable:
	lea		si,[a20_str_en]
	;WriteLn
    mov     ah,0
    int     0x21

    ; Выход из программы
	jmp end_program

a20_disable:
	lea		si,[a20_str_dis]
	;WriteLn
    mov     ah,0
    int     0x21

    ; Выход из программы
	jmp end_program



; ожидание действия контроллера клавиатуры
wait_input:
    in  al,0x64
    test al,2
    jnz wait_input
    ret
wait_output:
    in  al,0x64
    test al,1
    jnz wait_output
    ret


; Включить A20 #######################################################################
doSetA20:
    ; Enable A20
    mov ax,0x2401
    int 0x15

    mov al,0xD1
    out 0x64,al
    mov al,0xDF
    out 0x60,al

    ;mov     al,0xD0
    ;out     0x64,al
    ;call    wait_output

    ;in  al,0x60
    ;push ax
    ;call wait_input

    ;mov al,0xD1
    ;out 0x64,al
    ;call wait_input

    ;pop ax
    ;or al,02
    ;out 0x60,al

    call doGetA20



    ; Выход из программы
	jmp end_program


; Выключить A20 #######################################################################
doDisA20:
    ; Выключить A20 в AL
    mov ax,0x2400
    int 0x15

    mov al,0xD1
    out 0x64,al
    mov al,0xDD
    out 0x60,al

    ;mov     al,0xD0
    ;out     0x64,al
    ;call    wait_output

    ;in  al,0x60
    ;push ax
    ;call wait_input

    ;mov al,0xD1
    ;out 0x64,al
    ;call wait_input

    ;pop ax
    ;and al,1101b
    ;out 0x60,al

    call doGetA20

    ; Выход из программы
	jmp end_program
