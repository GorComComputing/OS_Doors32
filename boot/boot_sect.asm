; Загрузчик Doors boot-sector
	[org 0x7C00]
	jmp Start

boot_drive	db 0		 ; Диск, с которого загрузился MBR

Start:
    xor	ax, ax		    ; ds=0
	mov	ds, ax
	mov	byte [boot_drive],dl	; Диск, с которого загрузился MBR
Start_from_PM:
	mov ax,0x9000
	mov ss,ax
	mov	bp,0xFFFF	; Устанавливаем адрес стека
	mov	sp,bp

	xor	ax, ax		; ds=0
	mov	ds, ax		;
	mov	es, ax	    ;

    call DiskReadFAT

	jmp 0x500

%include "boot\disk.asm"

times 	446-($-$$) db 0
;MBR
;Partition 1 Information (1BEh)
db  0x00    ;Set to 80h if this partition is active  00
db  0x02    ;Partition's starting head
dw  0x0003  ;Partition's starting sector and track
db  0x0E    ;Partition's ID number
db  0xFE    ;Partition's ending head
dw  0xE77F  ;Partition's ending sector and track
StartingLBA dd  0x00000080;Starting LBA
dd  0x0077A000;Partition's length in sectors
;Partition 2 Information (1CEh)
times 	16 db 0
;Partition 3 Information (1DEh)
times 	16 db 0
;Partition 4 Information (1EEh)
times 	16 db 0
;Boot Signature AA55h (1FEh)
dw	0xAA55



