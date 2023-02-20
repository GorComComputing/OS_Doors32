; Музыка
[bits 16]
    [org 0x100]
    jmp doMelody

error_message DB "Melody not defined!",0

; Star Wars
notes DW  392, 392, 392, 311, 466, 392, 311, 466, 392,
      DW  587, 587, 587, 622, 466, 369, 311, 466, 392,
      DW  784, 392, 392, 784, 739, 698, 659, 622, 659,
      DW  415, 554, 523, 493, 466, 440, 466,
      DW  311, 369, 311, 466, 392, 0

longs DW  1, 1, 1, 1, 0, 1, 1, 1, 3,
      DW  1, 1, 1, 1, 0, 1, 1, 0, 3,
      DW  1,  1,  0,1, 1, 0, 0, 0, 3,
      DW  0, 1, 1, 0, 0, 0, 3,
      DW  0, 1, 1, 0, 3, 0


; Бетховен к Элизе
elis1 DW  98, 92, 98, 92, 98, 73, 87, 77, 65,
      DW  0xffff, 36, 48, 65, 73, 0xffff, 48, 61, 73,
      DW  77, 0xffff, 48, 97, 92, 97, 92, 97, 73,
      DW  87, 77, 65, 0xffff, 38, 48, 65,
      DW  73, 0xffff, 48, 77, 73, 65, 0

elis2 DW  1, 1, 1, 1, 1, 1, 1, 1, 3,
      DW  1, 1, 1, 1, 3, 1, 1, 1, 1,
      DW  3,  1,  1,1, 1, 1, 1, 1, 1,
      DW  1, 1, 3, 1, 1, 1, 1,
      DW  3, 1, 1, 1, 1, 3, 0

mtable          DB "STARWARS",0
                DW notes
                DW longs
                DB "ELISA",0
                DW elis1
                DW elis2
                DB 0

;#########################################################################
doMelody:
                cmp byte [0x0081],'1'
                je doElisa
                cmp byte [0x0081],'2'
                je doStarWars
                jmp dCmd4

				lea		di,[mtable]
dCmd3:
                lea		si,[0x0081]
dCmd0:
                mov		al,[di]
				cmp		al,[si]
				jne		dCmd1		; Команда не опознана

				;cmp al,0            ; если конец строки
				;je		dCmd2		; Конец команды, команда опознана

				inc		di
				inc		si
				jmp		dCmd0

dCmd1:			; Команда не опознана
                cmp al,0         ; если пробел
				jne	pass_Cmd1		; Конец команды, команда опознана

                cmp byte [si],0x20         ; если пробел
				je		dCmd2		; Конец команды, команда опознана

				cmp byte [si],0x0D         ; если пробел
				je		dCmd2		; Конец команды, команда опознана
pass_Cmd1:
                inc		di
				inc		di
				inc		di
				inc		di
				inc		di
				cmp		byte [di],0
				je		dCmd4       ; Если команды закончились, пытаемся найти COM-файл
				jmp		dCmd3		; Проверяем следующую команду

dCmd4:
                lea		si,[error_message]		; Вывод сообщения об ошибке
				;WriteLn
				mov     ah,8
                mov     bh,0x74
				int 0x21

                jmp end_melody



dCmd2:			; конец команды, команда опознана

				inc		di

				lea si,word [di]
				inc di
				inc di
                lea di,word [di]
;--------------------------------------------------------
Elisa_status	DB "Beethoven",0
doElisa:
                ; Вывод строки статуса
                lea	si,[Elisa_status]
                mov ah,7
                int 0x21

                lea si,word [elis1]
                lea di,word [elis2]
                jmp play_melody

StarWars_status	DB "Star Wars",0
doStarWars:
                ; Вывод строки статуса
                lea	si,[StarWars_status]
                mov ah,7
                int 0x21

                lea si,word [notes]
                lea di,word [longs]
                jmp play_melody

;-------------------------------------------------------


play_melody:
        cmp word [si],0
        je end_melody
        mov bx,word [di]     ;длительность
            shl bx,12
            add bx,0x0FFF
        push di
        mov di,word [si]     ;частота звука
            cmp di,0xFFFF
            je pass_mul
            mov ax,di
            mov dx,4
            mul dx
            mov di,ax
pass_mul:
        ;Speaker
        mov ax,0xFE00
        int 0x21
        pop di
        inc si
        inc si
        inc di
        inc di

        ;Пауза задается высокой частотой
        push di
        ;Speaker
        mov di,0xFFFF     ;частота звука
        mov bx,7000       ;длительность
        mov ax,0xFE00
        int 0x21
        pop di

        jmp play_melody

end_melody:
        ; Выход из программы
        mov bh,0
        int 20h
