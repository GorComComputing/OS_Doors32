; PM
[bits 16]
    [org 0x100]
    jmp doPM

; PM #############################################################################
doPM:


                ;--------------------------------------------------
				mov ah,0xFD
				int 0x21

                ;ret
				; Завершение программы
                mov bh,1
                int 0x20
                ;--------------------------------------------------



