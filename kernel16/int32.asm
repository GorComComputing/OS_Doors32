;Прерывания защищенного режима #########################################################################
[bits 32]

dummy:
    iretd


; Перезагрузка компьютера #######################################################
new_int00h:
    mov al,0xFE
    out 0x64,al
    iretd

; Динамик #########################################################################
new_int01h:
    pusha
    mov di,500      ;частота звука
    mov bx,2000    ;длительность
    mov al,0b6H
    out 43H,al
    mov dx,0014H
    mov ax,4f38H
    div di
    out 42H,al
    mov al,ah
    out 42H,al
    in al,61H
    mov ah,al
    or al,3
    out 61H,al
l1:     mov cx,2801H
l2:     loop l2
    dec bx
    jnz l1
    mov al,ah
    out 61H,al
    popa
    iretd


; Обработчик таймера #########################################################################
new_int20h:
    ;mov	byte [0xb8000+2-0x20000],'H'
    ;mov	byte [0xb8000+2+1-0x20000],0x4F
    iretd

[bits 16]

