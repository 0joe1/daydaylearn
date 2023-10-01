;用户程序头部段
SECTION header align=16 vstart=0
    program_length dd program_end

    code_entry dw start
               dd section.app_code_1.start

    realloc_tbl_len dw (header_end - code_1_segment)/4

    code_1_segment dd section.app_code_1.start
    code_2_segment dd section.app_code_2.start
    data_1_segment dd section.data_1.start
    data_2_segment dd section.data_2.start
    stack_segment  dd section.stack.start

    header_end:

;=============================================================
SECTION app_code_1 align=16 vstart=0
;put string  接受DX:BX
put_string:
        mov cl,[bx]
        cmp cl,0
        jz .exit
        call put_char
        inc bx
        jmp put_string

    .exit:
        ret

put_char: ;输入cl，将其打印出来
        push ax
        push bx
        push cx
        push dx
        push ds
        push es

        mov dx,0x3d4
        mov al,0x0e
        out dx,al
        mov dx,0x3d5
        in al,dx
        mov bh,al

        mov dx,0x3d4
        mov al,0x0f
        out dx,al
        mov dx,0x3d5 ;忘记改成数据端口了，找你找得我好辛苦啊QAQ
        in al,dx
        mov bl,al

        cmp cl,0x0d
        jnz .put_0a
        mov ax,bx
        mov bl,80
        div bl
        mul bl
        mov bx,ax
        jmp .set_cursor

    .put_0a:
        cmp cl,0x0a
        jnz .put_other
        add bx,80
        jmp .roll_screen

    .put_other:
        mov ax,0xb800
        mov ds,ax    ;这里其实用附加段es指比较好
        shl bx,1     ;别忘记还有显示属性，所以bx对应位置应该乘2
        mov [bx],cl
        shr bx,1
        inc bx

    .roll_screen:
        cmp bx,2000
        jl .set_cursor

        mov ax,0xb800
        mov ds,ax
        mov es,ax
        cld
        mov cx,1920
        mov si,160
        xor di,di
        rep movsw

        mov bx,3840
        mov cx,80
    .cls:
        mov word[bx],0x0720
        add bx,2
        loop .cls

        mov bx,1920

    .set_cursor:
        mov al,0x0e
        mov dx,0x3d4
        out dx,al
        mov dx,0x3d5
        mov al,bh
        out dx,al

        mov al,0x0f
        mov dx,0x3d4
        out dx,al
        mov dx,0x3d5
        mov al,bl
        out dx,al

        pop es
        pop ds
        pop dx
        pop cx
        pop bx
        pop ax

        ret ;连ret 都能忘，真是服了我自己了
;--------------------------------------------------------------
;start
start:
        ;设置自己的堆栈和数据段
        mov ax,[stack_segment]
        mov ss,ax
        mov sp,stack_end ;栈大小自定义为256,所以这里不写0（写0是2的16次应该）

        mov ax,[data_1_segment]
        mov ds,ax

        ;显示第一段信息
        mov bx,msg0
        call put_string

        ;利用push和retf跳转到代码段2
        push word[es:code_2_segment]
        mov ax,begin
        push ax
        retf

        ;显示第二段信息
continue:
        mov ax,[es:data_2_segment]
        mov ds,ax

        mov bx,msg1
        call put_string

        ;在此地无限循环
        jmp $

;=============================================================
;代码段2
SECTION app_code_2 align=16 vstart=0
;利用push和retf跳转回去
begin:
    push word[es:code_1_segment]
    mov ax,continue
    push ax
    retf

;=============================================================
;数据段1
SECTION data_1  align=16 vstart=0
    msg0: db 'He wishes for the Cloths of Heaven '
          db 0x0d,0x0a
          db 'by W.B.Yeats'
          db 0x0d,0x0a,0x0d,0x0a
          db 'Had I the heavens embroidered cloths,'
          db 0x0d,0x0a
          db 'Enwrought with golden and silver light,'
          db 0x0d,0x0a
          db 'The blue and the dim and the dark cloths'
          db 0x0d,0x0a
          db 'of night and light and the half-light,'
          db 0x0d,0x0a
          db 'I would spread the cloths under your feet.'
          db 0x0d,0x0a
          db 'But I, being poor, have only my dreams;'
          db 0x0d,0x0a
          db 'I have spread my dreams under your feet,'
          db 0x0d,0x0a
          db 'Tread softly because you tread on my dreams.'
          db 0x0a,0x0d,0x0d,0x0a
          db 0


;=============================================================
;数据段2
SECTION data_2  align=16 vstart=0
    msg1: db 'The above content is written by LinZhouyi'
          db 0x0d,0x0a
          db '2023.10.1'
          db 0
;=============================================================
;栈段 大小为256字节
SECTION stack  align=16 vstart=0
        resb 256
stack_end:

;程序末尾
SECTION trail align=16
program_end:
