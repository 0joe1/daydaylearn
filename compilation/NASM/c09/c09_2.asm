;============================================================
SECTION header vstart=0
    program_len  dd program_end

    code_entry   dw start
                 dd section.code.start
    realloc_tbl_len dw (realloc_end - realloc_begin)/4

    realloc_begin:
    code_segment dd section.code.start
    data_segment dd section.data.start
    stack_segment dd section.stack.start
    realloc_end:
;============================================================
SECTION code align=16 vstart=0
    start:
        ;准备
        mov ax,[stack_segment]
        mov ss,ax
        mov sp,stack_pointer
        mov ax,[data_segment]
        mov ds,ax

        mov cx,msg_end - message
        mov bx,message

        ;打印数据段里的东西
    print:
        mov ah,0x0e
        mov al,[bx]
        int 0x10
        inc bx
        loop print

        ;读取输入并输出
    rdp:
        mov ah,0x00
        int 0x16
        mov ah,0x0e
        int 0x10
        jmp rdp

;============================================================
SECTION data align=16 vstart=0
    message db 'Hello,friend',0x0d,0x0a
            db 'This simple program is to demonstrate'
            db 'The Bios interrupt',0x0d,0x0a
            db 'Now press any key ...'
    msg_end:

;============================================================
SECTION stack align=16 vstart=0
        resb 256
stack_pointer:

;============================================================
SECTION trail
program_end:
