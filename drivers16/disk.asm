absoluteSector   db 0
absoluteHead     db 0
absoluteTrack    db 0
SekPerTrack      dw 0x003F
HedPerCyl        dw 0x00FF
SecPerClust      dw 0x40
BytesPerSector   dw 0x200
;StartingLBA      EQU 0x7DC7
disk_error_msg   db "Disk read error!",0
boot_drive       EQU 0x7C02

; Чтение сектора LBA ##########################################
ReadSect:
    pusha

main_read:
    push ax ;Начальный сектор LBA
    push bx ;Буфер записи
    push cx ;Количество секторов

    ;LBA to CHS
    call LBACHS

    ; Читаем сектор
    mov	ah,0x02
	mov	al,1;cl   ; читает секторов
	mov	ch,[absoluteTrack] ; номер дорожки
	mov	cl,[absoluteSector]   ; номер сектора
	mov	dh,[absoluteHead] ; номер головки
	mov dl,[boot_drive ] ;0x80 boot_drive
	int	0x13

    jc	disk_error

    pop cx
    pop bx
    pop ax
    add bx, word [BytesPerSector]
    inc ax
    loop main_read

    popa
    mov ah,0  ;Возвращает код ошибки
    ret

disk_error:
	; Вывод строки
	lea		si,[disk_error_msg]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int     0x21

    pop cx
    pop bx
    pop ax
    popa
    mov ah,1  ;Возвращает код ошибки
	ret


;CHS to LBA #################################################################
;LBA = (cluster - 2) * sectors per cluster
ClusterLBA:
    sub ax,0x0002
    xor cx,cx
    mov cl, byte [SecPerClust]
    mul cx
    add ax,0x0080;word[StartingLBA] ;StartingLBA
    add ax,word [BPB_ADDRESS+0xB+3]
    add ax,word [BPB_ADDRESS+0xB+11]
    add ax,word [BPB_ADDRESS+0xB+11]
    add ax,32
    ret


; LBA to CHS ################################################################
;absolute sector 	= 	(logical sector / sectors per track) + 1
;absolute head   	= 	(logical sector / sectors per track) MOD number of heads
;absolute track 	= 	 logical sector / (sectors per track * number of heads)
LBACHS:
    xor dx,dx
    div word [SekPerTrack]    ;Sectors per track
    inc dl
    mov [absoluteSector],dl

    xor dx,dx
    div word [HedPerCyl]      ;Heads per cylinder
    mov [absoluteHead],dl

    mov [absoluteTrack],al
    ret


