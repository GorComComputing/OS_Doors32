StartingLBA EQU 0x0080
Cluster DW 0
FAT_OK	DB "FAT OK",0
FAT_ER_BPB	DB "Partition disk not read!",0
FAT_ER_ROOT	DB "Root directory not read!",0
FAT_ER_FAT	DB "FAT not read!",0
FAT_ER_FIND	DB "File not found!",0
FAT_ER_FILE	DB "File not read!",0
FAT_SEG EQU 0x1000
FAT_ADDR EQU 0x0000

BPB_ADDRESS EQU 0x8F00
ROOT_ADDRESS EQU 0x9100


; Чтение файла ################################################################
FileRead:
        push bx
        push dx
        push si

    ; Читаем Boot Sector Partition 1
    mov ax,StartingLBA
    mov cx,0x0001        ; число секторов
    mov	bx,BPB_ADDRESS
    ;ReadSect
    int 0x25
    cmp ah,00
    jne FAILURE_BPB

    ; Размер корневого каталога
    mov ax,32   ;32 байта на запись
    mul word [BPB_ADDRESS+0xB+6]
    div word [BPB_ADDRESS+0xB]
    xor cx,cx
    mov cl,al

    ;call	PRINT_WORD

    ; Начало корневого каталога
    xor ax,ax
    mov al,byte [BPB_ADDRESS+0xB+5]
    mul word [BPB_ADDRESS+0xB+11]
    ;call	PRINT_WORD
    add ax,word [BPB_ADDRESS+0xB+3]
    add ax,StartingLBA

    ;call	PRINT_WORD

    ; Читаем Корневой каталог
    mov	bx,ROOT_ADDRESS
    ;ReadSect
    int 0x25
    cmp ah,00
    jne FAILURE_ROOT

LOAD_FAT:
    ; Получаем размер FAT
    xor ax,ax
    mov al,byte [BPB_ADDRESS+0xB+5]
    mul word [BPB_ADDRESS+0xB+11]
    mov cx,ax

    ; Начало FAT
    mov ax,word [BPB_ADDRESS+0xB+3]
    add ax,StartingLBA

    ; Читаем FAT
    push es
    push FAT_SEG    ; читаем в следующий сегмент
    pop es
    mov cx,50;110;word [BPB_ADDRESS+0xB+11]        ; число секторов
    mov	bx,FAT_ADDR
    ;ReadSect
    int 0x25
    pop es              ; восстанавливаем es
    cmp ah,00
    jne FAILURE_FAT

    pop si
    mov dx,si

    ;add ax,112

    ; Читаем FAT
    ;push word 0x2000    ; читаем в следующий сегмент
    ;pop es
    ;mov cx,10;word [BPB_ADDRESS+0xB+11]        ; число секторов
    ;mov	bx,[FAT_ADDR];0x9300
    ;ReadSect
    ;int 0x25

LoadFile:
    ; Поиск файла в Корневом каталоге
    mov cx,word [BPB_ADDRESS+0xB+6]
    mov di,ROOT_ADDRESS
loop_find:
    push cx
    mov cx,11
    mov si,dx
        push ds
        push fs
        pop ds
    push di
    rep cmpsb
    pop di
        pop ds

    pop cx
    je  LOAD_IMAGE
    add di,32
    loop loop_find
    jmp FAILURE_FIND

LOAD_IMAGE:
    ; Сохраняем стартовый кластер найденного файла
    mov dx,[di+0x001A]
    mov word [Cluster],dx

    ;mov ax,word [Cluster]
    ;call	PRINT_WORD

    ; Читаем кластер файла
        pop dx ;FILE_SEG
        pop bx ;FILE_ADDR
    push es
    push dx;FILE_SEG    ; читаем в следующий сегмент
    pop es
    mov ax,word [Cluster]
        push bx
    call ClusterLBA
        pop bx
    xor cx,cx
    mov cl,39;10;byte [BPB_ADDRESS+0xB+2]
    ;ReadSect
    int 0x25
    cmp ah,00
    jne FAILURE_FILE
    pop es

    mov ah,0 ; Признак успеха
    ret

FAILURE_BPB:
	lea		si,[FAT_ER_BPB]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int     0x21
    mov ah,1 ; Признак ошибки

    pop si
    pop dx
    pop bx
    ret

FAILURE_ROOT:
	lea		si,[FAT_ER_ROOT]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int     0x21
    mov ah,1 ; Признак ошибки

    pop si
    pop dx
    pop bx
    ret

FAILURE_FAT:
	lea		si,[FAT_ER_FAT]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int     0x21
    mov ah,1 ; Признак ошибки

    pop si
    pop dx
    pop bx
    ret

FAILURE_FIND:
	lea		si,[FAT_ER_FIND]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int     0x21
    mov ah,1 ; Признак ошибки

    pop dx
    pop bx
    ret

FAILURE_FILE:
	lea		si,[FAT_ER_FILE]
	;WriteLn
    mov     ah,8
    mov     bh,0x74
    int     0x21
    pop es
    mov ah,1 ; Признак ошибки
    ret


; Показать содержимое директории ################################################################
; Directory of A:/
; .             <DIR>            01-09-2022 19:08
; ..            <DIR>            01-09-2022 19:08
; DOCS          <DIR>            01-09-2022 19:08
; COMPILE TXT              1,450 01-09-2022 19:08
; COMPILE TXT          1,474,560 01-09-2022 19:08
; COMPILE TXT              1,450 01-09-2022 19:08
;     5 File(s)        1,479,913 Bytes.
;     4 Dir(s)       262,479,913 Bytes free.

DirShow_FILE_NAME DB "XXXXXXXX",0
DirShow_EXT       DB "XXX",0
DirShow_ATTR      DB 0
DirShow_TIME      DW 0
DirShow_DATE      DW 0
DirShow_SIZE      DD 0
;space   DB 0x20
plot    DB ".",0
plot2    DB "..",0
DirShowLable      DB "Directory of A:/",0

DirShow:
    ;WriteLn
    lea		si,[DirShowLable]
    mov     ah,0
    int     0x21
    ;WriteLn
    lea		si,[plot]
    mov     ah,0
    int     0x21
    ;WriteLn
    lea		si,[plot2]
    mov     ah,0
    int     0x21

    ; Читаем Boot Sector Partition 1
    mov ax,StartingLBA
    mov cx,0x0001        ; число секторов
    mov	bx,BPB_ADDRESS
    ;ReadSect
    int 0x25
    cmp ah,00
    jne FAILURE_BPB

    ; Размер корневого каталога
    mov ax,32   ;32 байта на запись
    mul word [BPB_ADDRESS+0xB+6]
    div word [BPB_ADDRESS+0xB]
    xor cx,cx
    mov cl,al

    ;call	PRINT_WORD

    ; Начало корневого каталога
    xor ax,ax
    mov al,byte [BPB_ADDRESS+0xB+5]
    mul word [BPB_ADDRESS+0xB+11]
    ;call	PRINT_WORD
    add ax,word [BPB_ADDRESS+0xB+3]
    add ax,StartingLBA

    ;call	PRINT_WORD

    ; Читаем Корневой каталог
    mov	bx,ROOT_ADDRESS
    ;ReadSect
    int 0x25
    cmp ah,00
    jne FAILURE_ROOT

    ; Поиск файла в Корневом каталоге
    mov cx,word [BPB_ADDRESS+0xB+6]
    sub cx,3
    mov si,ROOT_ADDRESS+0x60



loop_show_dir:
    cmp byte [si],0xE5
    jne cmp_zero
    add si,32
    jmp pass_loop_dir

cmp_zero:
    cmp byte [si],0x00
    jne do_loop_dir
    add si,32
    jmp pass_loop_dir

do_loop_dir:
    push cx

    ; Читаем имя файла
    lea di,[DirShow_FILE_NAME]
    lea	si,[si+0x0]
    mov	cx,8
    rep movsb

    ; Читаем расширение файла
    lea di,[DirShow_EXT]
    lea	si,[si+0]
    mov	cx,3
    rep movsb
    ; Читаем аттрибуты файла
    mov ah,byte [si+0]
    mov byte [DirShow_ATTR],ah
    inc si
    ; Читаем время файла
    mov ax,word [si+10]
    mov word [DirShow_TIME],ax
    add si,12
    ; Читаем дату файла
    mov ax,word [si+0]
    mov word [DirShow_DATE],ax
    add si,2
    ; Читаем размер файла
    lea di,[DirShow_SIZE]
    lea	si,[si+2]
    mov	cx,4
    rep movsb

    push si

    ;Отображаем на экране информацию о файле
    ;Write
    lea		si,[DirShow_FILE_NAME]
    mov     ah,1
    int     0x21
    ;Write
    lea		si,[plot]
    mov     ah,1
    int     0x21
    ;WriteLn
    lea		si,[DirShow_EXT]
    mov     ah,0
    int     0x21

    pop si
    pop cx
pass_loop_dir:
    loop loop_show_dir



;DirShow_ATTR      DB 0
;DirShow_TIME      DW 0
;DirShow_DATE      DW 0
;DirShow_SIZE      DD 0



    ret
