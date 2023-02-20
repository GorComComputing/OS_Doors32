; GDT
gdt_start:

gdt_null:
	dd 0x0		;  Нулевой дескриптор (8 байт нулей)
	dd 0x0

gdt_code:
	dw 0xffff
	dw 0x0
	db 0x0 ;----------------
	db 10011010b
	db 11001111b
	db 0x0

gdt_data:
	dw 0xffff
	dw 0x0
	db 0x0 ;----------------
	db 10010010b
	db 11001111b
	db 0x0

gdt_code_real:
	dw 0xffff
	dw 0x0
	db 0x0 ;----------------
	db 10011010b
	db 00000000b;11001111b
	db 0x0

gdt_data_real:
	dw 0xffff
	dw 0x0
	db 0x0 ;----------------
	db 10010010b
	db 00000000b;1111b
	db 0x0

gdt_end:


; GDT descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start; + 0x20000

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
CODE_SEG_REAL equ gdt_code_real - gdt_start
DATA_SEG_REAL equ gdt_data_real - gdt_start
