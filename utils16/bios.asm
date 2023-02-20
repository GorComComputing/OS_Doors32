; BIOS information
[bits 16]
    [org 0x100]
    jmp start_program

error_message DB "Parameter not defined!",0

ctable          DB "S",0
                DW doBIOS
                DB 0

null			DB 0
space           DB " ",0




; BIOS information #############################################################################
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


; Информация из BIOS #######################################################################
date_BIOS	DB "ROM BIOS date ",0
com1_addr	DB "COM1 ",0
com2_addr	DB "COM2 ",0
com3_addr	DB "COM3 ",0
com4_addr	DB "COM4 ",0

lpt1_addr	DB "LPT1 ",0
lpt2_addr	DB "LPT2 ",0
lpt3_addr	DB "LPT3 ",0
;lpt4_addr	DB "LPT4 ",0

PCI_not_found DB "PCI not supported",0
PCI_sign    DB "XXXX",0
PCI_bus_num DB " bus number ",0
Ethernet_not DB "Ethernet not found",0
Bad_register DB "Bad register number",0
line DB "------------",0

not_found	DB "not found",0
bytes           DB " bytes",0

OX              DB "0x",0
point           DB ".",0


base_addr_info EQU 0x8F00

doBIOS:

    ; Выводим дату BIOS ----------------------------------------------
    lea		si,[date_BIOS]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0xF000
    pop ds
    lea		si,[0xFFF5]
	;WriteLn
    mov     ah,0
    int     0x21
    pop ds

    ; Проверка COM 1 ----------------------------------------------
    lea		si,[com1_addr]
	;Write
    mov     ah,1
    int     0x21

    ;push ds
    ;push 0
    ;pop ds
    ;mov	si,0x0400
    ;cmp word [si],0
    ;je print_not_found
    ;pop ds

    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov	si,0x0400
    mov ax,[si]
    pop ds
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Проверка COM 2 ----------------------------------------------
    lea		si,[com2_addr]
	;Write
    mov     ah,1
    int     0x21

    ;push ds
    ;push 0
    ;pop ds
    ;mov	si,0x0402
    ;cmp word [si],0
    ;je print_not_found
    ;pop ds

    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov	si,0x0402
    mov ax,[si]
    pop ds
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Проверка COM 3 ----------------------------------------------
    lea		si,[com3_addr]
	;Write
    mov     ah,1
    int     0x21

    ;push ds
    ;push 0
    ;pop ds
    ;mov	si,0x0404
    ;cmp word [si],0
    ;je print_not_found
    ;pop ds

    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov	si,0x0404
    mov ax,[si]
    pop ds
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Проверка COM 4 ----------------------------------------------
    lea		si,[com4_addr]
	;Write
    mov     ah,1
    int     0x21

    ;push ds
    ;push 0
    ;pop ds
    ;mov	si,0x0406
    ;cmp word [si],0
    ;je print_not_found
    ;pop ds

    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov	si,0x0406
    mov ax,[si]
    pop ds
    call PRINT_WORD

    lea		si,[null]
	;WriteLn
    mov     ah,0
    int     0x21

    ; Проверка LPT 1 ----------------------------------------------
    lea		si,[lpt1_addr]
	;Write
    mov     ah,1
    int     0x21

    ;push ds
    ;push 0
    ;pop ds
    ;mov	si,0x0408
    ;cmp word [si],0
    ;je print_not_found
    ;pop ds

    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov	si,0x0408
    mov ax,[si]
    pop ds
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Проверка LPT 2 ----------------------------------------------
    lea		si,[lpt2_addr]
	;Write
    mov     ah,1
    int     0x21

    ;push ds
    ;push 0
    ;pop ds
    ;mov	si,0x040A
    ;cmp word [si],0
    ;je print_not_found
    ;pop ds

    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov	si,0x040A
    mov ax,[si]
    pop ds
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Проверка LPT 3 ----------------------------------------------
    lea		si,[lpt3_addr]
	;Write
    mov     ah,1
    int     0x21

    ;push ds
    ;push 0
    ;pop ds
    ;mov	si,0x040C
    ;cmp word [si],0
    ;je print_not_found
    ;pop ds

    lea		si,[OX]
	;Write
    mov     ah,1
    int     0x21

    push ds
    push 0
    pop ds
    mov	si,0x040C
    mov ax,[si]
    pop ds
    call PRINT_WORD

    lea		si,[space]
	;WriteLn
    mov     ah,0
    int     0x21


    ; Проверка PCI BIOS ----------------------------------------------
    mov ax,0xB101
    int 0x1A

    cmp ah,0
    jne not_PCI

    push cx
    push bx
    ; Выводим сигнатуру PCI
    mov [PCI_sign],edx
    lea		si,[PCI_sign]
	;Write
    mov     ah,1
    int     0x21

    ; Выводим версию PCI
    pop ax
    push ax
    shr ax,8

    call PRINT_BYTE

    lea		si,[point]
	;Write
    mov     ah,1
    int     0x21

    pop ax
    call PRINT_BYTE

    ; Выводим номер последней шины PCI (нумерация с нуля, поэтому inc)
    lea		si,[PCI_bus_num]
	;Write
    mov     ah,1
    int     0x21

    pop ax
    ;inc ax
    call PRINT_BYTE

    lea		si,[null]
	;WriteLn
    mov     ah,0
    int     0x21


    mov dx,0x00
    call PCI_FOUND
    mov dx,0x01
    call PCI_FOUND
    mov dx,0x02
    call PCI_FOUND
    mov dx,0x03
    call PCI_FOUND
    mov dx,0x04
    call PCI_FOUND
    mov dx,0x05
    call PCI_FOUND
    mov dx,0x06
    call PCI_FOUND
    mov dx,0x07
    call PCI_FOUND
    mov dx,0x08
    call PCI_FOUND
    mov dx,0x09
    call PCI_FOUND
    mov dx,0x0A
    call PCI_FOUND

    ;mov dx,0x0B
    ;call PCI_FOUND
    ;mov dx,0x0C
    ;call PCI_FOUND
    ;mov dx,0x0D
    ;call PCI_FOUND
    ;mov dx,0x0E
    ;call PCI_FOUND
    ;mov dx,0x0F
    ;call PCI_FOUND
    ;mov dx,0x10
    ;call PCI_FOUND
    ;mov dx,0x11
    ;call PCI_FOUND
    ;mov edx,0xFF
    ;call PCI_FOUND






    ; Выход из программы
	jmp end_program




;--------------------------------------------------------
PCI_FOUND:
    mov ecx,0
    push cx
    push dx

count_pci:
    ; Ищем сетевую карту PCI
    mov ax,0xB103
    ;mov ecx,0x020000
    pop cx
    pop si
    shl ecx,16
    ;mov si,1
    int 0x1A
    jc  Ethernet_not_found
    inc si
    push si
    push cx
    mov ax,bx
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Получить идентификатор изготовителя сетевой карты PCI
    mov ax,0xB109
    mov di,0
    int 0x1A
    jc  Bad_register_number
    mov ax,cx
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Получить идентификатор устройства сетевой карты PCI
    mov ax,0xB109
    mov di,2
    int 0x1A
    jc  Bad_register_number
    mov ax,cx
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Получить базовый адрес сетевой карты PCI
    mov ax,0xB10A
    mov di,0x10
    int 0x1A
    jc  Bad_register_number
    mov eax,ecx
    push eax
    push eax
    shr eax,16
    call PRINT_WORD
    pop eax
    call PRINT_WORD

    lea		si,[space]
	;Write
    mov     ah,1
    int     0x21

    ; Получить mac-адрес сетевой карты PCI
    pop edx
    push edx
    in  al,dx
    call PRINT_BYTE
    pop edx
    inc dx
    push edx
    in  al,dx
    call PRINT_BYTE
    pop edx

    inc dx
    push edx
    in  al,dx
    call PRINT_BYTE
    pop edx

    inc dx
    push edx
    in  al,dx
    call PRINT_BYTE
    pop edx

    inc dx
    push edx
    in  al,dx
    call PRINT_BYTE
    pop edx
    inc dx
    in  al,dx
    call PRINT_BYTE




    lea		si,[null]
	;WriteLn
    mov     ah,0
    int     0x21






    xor ecx,ecx
    jmp count_pci



Bad_register_number:
    lea	si,[Bad_register]
    ;WriteLn
    mov     ah,0
    int     0x21

    ; Выход из программы
	jmp end_program


Ethernet_not_found:
    lea	si,[line];Ethernet_not
    ;WriteLn
    mov     ah,0
    int     0x21

    ret


not_PCI:
    ;pop ds
    lea	si,[PCI_not_found]
    ;WriteLn
    mov     ah,0
    int     0x21

    ; Выход из программы
	jmp end_program


print_not_found:
    pop ds
    lea	si,[not_found]
    ;WriteLn
    mov     ah,0
    int     0x21

    ; Выход из программы
	jmp end_program







;---------------------------------------------------------------------------
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






