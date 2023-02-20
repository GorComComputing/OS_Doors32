; A20
[bits 16]
    [org 0x100]
    jmp start_program

error_message DB "Parameter not defined!",0

ctable          DB "STATUS",0
                DW doGetA20
                DB "ENABLE",0
                DW doSetA20
                DB "DISABLE",0
                DW doDisA20
                DB 0




; A20 #############################################################################
start_program:

doCommand:
				lea		di,[ctable]
dCmd3:
                lea		si,[0x0081]
                ;call Skip_spaces    ; ���������� �������
dCmd0:

                mov		al,[di]
				cmp		al,[si]
				jne		dCmd1		; ������� �� ��������

				cmp al,0            ; ���� ����� ������
				je		dCmd2		; ����� �������, ������� ��������

				inc		di
				inc		si
				jmp		dCmd0

dCmd1:			; ������� �� ��������
                cmp al,0            ; ���� ������
				jne	pass_Cmd1		; ����� �������, ������� ��������

                cmp byte [si],0x20  ; ���� ������
				je		dCmd2		; ����� �������, ������� ��������

				cmp byte [si],0x0D  ; ���� (Enter)
				je		dCmd2		; ����� �������, ������� ��������
pass_Cmd1:
                inc		di
				cmp		byte [di],0
				jne		pass_Cmd1
				inc		di
				inc		di
				inc		di
				cmp		byte [di],0
				je		dCmd4       ; ���� ������� �����������, �������� ����� COM-����
				jmp		dCmd3		; ��������� ��������� �������
dCmd2:			; ����� �������, ������� ��������
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
                ;call	Skip_spaces    ; ���������� �������
				;pop		di
				mov		di,[di]


				call	di
				ret


dCmd4:
                ;WriteLn
                lea		si,[error_message]		; ����� ��������� �� ������
				mov     ah,8
                mov     bh,0x74
				int 0x21

                jmp end_program







end_program:
				; ����� �� ���������
				mov bh,0
				int 20h


; �������� ������ A20 #######################################################################
a20_str_en	DB "A20 Enable",0
a20_str_dis	DB "A20 Disable",0

doGetA20:
    ; ����� ���� ����������
    ;mov     al,0xD0
    ;out     0x64,al
    ;call    wait_output

    ;in  al,0x60
    ;push ax
    ;call wait_input

    ;mov, al,0xD1
    ;out 0x64,al
    ;call wait_input

    ;pop ax
    ;or al,02
    ;out 0x60,al

    ;test al,2
    ;jz a20_enable
    ;jmp a20_disable

    ; �������� ������ A20 � AL
    mov ax,0x2402
    int 0x15

    cmp AL,01
    jz  a20_enable
    cmp AL,00
    jz  a20_disable

a20_enable:
	lea		si,[a20_str_en]
	;WriteLn
    mov     ah,0
    int     0x21

    ; ����� �� ���������
	jmp end_program

a20_disable:
	lea		si,[a20_str_dis]
	;WriteLn
    mov     ah,0
    int     0x21

    ; ����� �� ���������
	jmp end_program



; �������� �������� ����������� ����������
wait_input:
    in  al,0x64
    test al,2
    jnz wait_input
    ret
wait_output:
    in  al,0x64
    test al,1
    jnz wait_output
    ret


; �������� A20 #######################################################################
doSetA20:
    ; Enable A20
    mov ax,0x2401
    int 0x15

    mov al,0xD1
    out 0x64,al
    mov al,0xDF
    out 0x60,al

    ;mov     al,0xD0
    ;out     0x64,al
    ;call    wait_output

    ;in  al,0x60
    ;push ax
    ;call wait_input

    ;mov al,0xD1
    ;out 0x64,al
    ;call wait_input

    ;pop ax
    ;or al,02
    ;out 0x60,al

    call doGetA20



    ; ����� �� ���������
	jmp end_program


; ��������� A20 #######################################################################
doDisA20:
    ; ��������� A20 � AL
    mov ax,0x2400
    int 0x15

    mov al,0xD1
    out 0x64,al
    mov al,0xDD
    out 0x60,al

    ;mov     al,0xD0
    ;out     0x64,al
    ;call    wait_output

    ;in  al,0x60
    ;push ax
    ;call wait_input

    ;mov al,0xD1
    ;out 0x64,al
    ;call wait_input

    ;pop ax
    ;and al,1101b
    ;out 0x60,al

    call doGetA20

    ; ����� �� ���������
	jmp end_program
