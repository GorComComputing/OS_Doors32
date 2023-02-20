absoluteSector   db 0
absoluteHead     db 0
absoluteTrack    db 0
SekPerTrack      dw 0x003F
HedPerCyl        dw 0x00FF
SecPerClust      dw 0x40
BytesPerSector   dw 0x200

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
	mov dl,[boot_drive] ;0x80
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

    ;DEBUG--------------------------------
	mov ah,0x0e
    mov al,'E'
    int 0x10
    pop cx
    pop bx
    pop ax
    popa
    mov ah,1  ;Возвращает код ошибки
	ret
	;jmp $
	;-------------------------------------

;CHS to LBA #################################################################
;LBA = (cluster - 2) * sectors per cluster
ClusterLBA:
    sub ax,0x0002
    xor cx,cx
    mov cl, byte [SecPerClust]
    mul cx
    add ax,0x0080;word [StartingLBA]
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


; Чтение через FAT 16  ##########################################################
ImageName DB "KERNEL16SYS"
Cluster DW 0
BPB_ADDRESS EQU 0x7E00
ROOT_ADDRESS EQU 0x8000
FAT_SEG EQU 0x1000
FAT_ADDR EQU 0x0000
FILE_ADDR EQU 0x500

DiskReadFAT:

    ; Читаем Boot Sector Partition 1
    mov ax,0x0080;word [StartingLBA]
    mov cx,0x0001        ; число секторов
    mov	bx,BPB_ADDRESS
    call    ReadSect
    cmp ah,00
    jne FAILURE_BPB


    ; Размер корневого каталога
    mov ax,32   ;32 байта на запись
    mul word [BPB_ADDRESS+0xB+6]
    div word [BPB_ADDRESS+0xB]
    xor cx,cx
    mov cl,al

    ; Начало корневого каталога
    xor ax,ax
    mov al,byte [BPB_ADDRESS+0xB+5]
    mul word [BPB_ADDRESS+0xB+11]
    add ax,word [BPB_ADDRESS+0xB+3]
    add ax,0x0080;word [StartingLBA]

    ; Читаем Корневой каталог
    mov	bx,ROOT_ADDRESS
    call    ReadSect
    cmp ah,00
    jne FAILURE_ROOT


    ; Получаем размер FAT
    xor ax,ax
    mov al,byte [BPB_ADDRESS+0xB+5]
    mul word [BPB_ADDRESS+0xB+11]
    mov cx,ax

    ; Начало FAT
    mov ax,word [BPB_ADDRESS+0xB+3]
    add ax,0x0080;word [StartingLBA]

    ; Читаем FAT
    push es
    push FAT_SEG    ; читаем в следующий сегмент
    pop es
    mov cx,110;word [BPB_ADDRESS+0xB+11]        ; число секторов
    mov	bx,FAT_ADDR
    call    ReadSect
    pop es              ; восстанавливаем es
    cmp ah,00
    jne FAILURE_FAT

    ;add ax,112

    ; Читаем FAT
    ;push word 0x2000    ; читаем в следующий сегмент
    ;pop es
    ;mov cx,10;word [BPB_ADDRESS+0xB+11]        ; число секторов
    ;mov	bx,[FAT_ADDR];0x9300
    ;call    ReadSect

LoadFile:
    ;xor ecx,ecx
    ;push    ecx

    ;push    bx
    ;push    bp

    ; Поиск файла в Корневом каталоге
    mov cx,word [BPB_ADDRESS+0xB+6]
    mov di,ROOT_ADDRESS
loop_find:
    push cx
    mov cx,11
    mov si,ImageName
    push di
    rep cmpsb
    pop di
    pop cx
    je  LOAD_IMAGE
    add di,32
    loop loop_find
    jmp FAILURE_FIND
    ;jmp disk_error

LOAD_IMAGE:
    ; Сохраняем стартовый кластер найденного файла
    mov dx,[di+0x001A]
    mov word [Cluster],dx

    ; Читаем кластер файла
    mov ax,word [Cluster]
    call ClusterLBA
    xor cx,cx
    mov cl,59;byte [BPB_ADDRESS+0xB+2]
    mov	bx,FILE_ADDR
    call    ReadSect
    cmp ah,00
    jne FAILURE_FILE

    ret

FAILURE_BPB:
    ;DEBUG--------------------------------
	mov ah,0x0e
    mov al,'B'
    int 0x10
	jmp $
	;-------------------------------------

FAILURE_ROOT:
    ;DEBUG--------------------------------
	mov ah,0x0e
    mov al,'R'
    int 0x10
	jmp $
	;-------------------------------------

FAILURE_FAT:
    ;DEBUG--------------------------------
	mov ah,0x0e
    mov al,'F'
    int 0x10
	jmp $
	;-------------------------------------

FAILURE_FIND:
    ;DEBUG--------------------------------
	mov ah,0x0e
    mov al,'D'
    int 0x10
	jmp $
	;-------------------------------------

FAILURE_FILE:
    ;DEBUG--------------------------------
	mov ah,0x0e
    mov al,'I'
    int 0x10
	jmp $
	;-------------------------------------







