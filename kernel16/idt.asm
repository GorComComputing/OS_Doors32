; IDT
idt_start:

int00h:
	dw new_int00h    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int01h:
	dw new_int01h    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int02h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int03h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int04h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int05h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int06h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int07h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int08h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int09h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int0Ah:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int0Bh:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int0Ch:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int0Dh:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int0Eh:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int0Fh:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int10h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int11h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int12h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int13h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int14h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int15h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int16h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int17h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int18h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int19h:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int1Ah:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int1Bh:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int1Ch:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int1Dh:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int1Eh:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int1Fh:
	dw dummy    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2

int20h:
	dw new_int20h    ;offset 1
	dw CODE_SEG ;selector CS
	db 0        ;no use
	db 8eh      ;type attr
    dw 0        ;offset 2




idt_end:


; IDT descriptor
idt_descriptor:
	dw idt_end - idt_start - 1
	dd idt_start; + 0x20000

; IDT descriptor REAL
idt_descriptor_real:
	dw 3FFh
	dd 0
