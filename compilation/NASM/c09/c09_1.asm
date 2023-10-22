;======================================================
SECTION header vstart=0
    program_len:  dd program_end

    code_entry:   dw start
                  dd section.code.start

    realloc_tbl_len  dw (header_end - code_segment)/4 ;是dw不是dd,这里声明一个字

    code_segment dd section.code.start
    data_segment dd section.data.start
    stack_segment dd section.stack.start

    header_end:

;------------------------------------------------------
SECTION code align=16 vstart=0
;处理int 0x70 的过程
new_int_0x70:
        push ax
        push bx
        push es
    .w0
        ;读寄存器A,检测现在是否能读
        mov al,0x0a
        or al,0x80
        out 0x70,al
        in al,0x71
        test al,0x80 ;与and执行后一样，SF、ZF、PF位的状态依计算结果而定
        jnz .w0

        ;读取时间并压入栈中
        mov al,0x00
        or al,0x80  ;每次访问都要阻断NMI的干扰
        out 0x70,al
        in al,0x71
        push ax

        mov al,0x02
        or al,0x80
        out 0x70,al
        in al,0x71
        push ax

        mov al,0x04
        or al,0x80
        out 0x70,al
        in al,0x71
        push ax

        ;读寄存器C顺便解放NMI
        mov al,0x0c
        out 0x70,al
        in al,0x71

        ;显示时间
        mov ax,0xb800
        mov es,ax
        mov bx,160*12 + 36*2

        pop ax
        call bcd_to_ascii
        mov [es:bx],ah
        mov [es:bx+2],al

        mov byte [es:bx+4],':' ;未知源操作数大小，要加byte
        not byte [es:bx+5]

        pop ax
        call bcd_to_ascii
        mov [es:bx+6],ah
        mov [es:bx+8],al

        mov byte [es:bx+10],':'
        not byte [es:bx+11]

        pop ax
        call bcd_to_ascii
        mov [es:bx+12],ah
        mov [es:bx+14],al

        ;发送中断结束信号
        mov al,0x20
        out 0x20,al
        out 0xa0,al

        pop es
        pop bx
        pop ax
        iret
;------------------------------------------------------
;bcd转axcii 输入AL(bcd) 输出AX(ascii)
bcd_to_ascii:
        mov ah,al
        and al,0x0f
        add al,0x30

        shr ah,4
        and ah,0x0f
        add ah,0x30

        ret
;------------------------------------------------------
start:
        ;进行一个准备
        mov ax,[data_segment]
        mov ds,ax
        mov ax,[stack_segment]
        mov ss,ax
        mov sp,stack_pointer

        ;显示初始信息
        mov bx,init_msg
        call put_string

        ;显示安装信息
        mov bx,inst_msg
        call put_string

        ;在向量表中安装中断处理位置
        push es
        cli
        mov ax,0x0000
        mov es,ax
        mov ax,0x70
        mov bl,4
        mul bl
        mov bx,ax

        mov word[es:bx],new_int_0x70
        mov [es:bx+0x02],cs
        pop es

        ;阻断 NMI,设置更新结束中断,BCD24小时制
        mov al,0x0b
        or al,0x80
        out 0x70,al
        mov al,0x12
        out 0x71,al

        ;读取寄存器C
        mov al,0x0c
        out 0x70,al
        in al,0x71

        ;让IMR不阻断
        in al,0xa1
        and al,0xfe
        out 0xa1,al

        ;重新开放中断
        sti

        ;显示信息
        mov bx,done_msg
        call put_string

        mov bx,tips_msg
        call put_string

        ;屏幕12行34列放@
        mov ax,0xb800
        mov es,ax
        mov byte[es:12*160+33*2],'@'

        ;低功耗模式，来了中断反转下@
    wait_int:
        hlt
        not byte[es:12*160+33*2+1]
        jmp wait_int

;------------------------------------------------------
;输出字符串
put_string:
        mov cl,[bx]
        or cl,cl
        jz .exit
        inc bx
        call put_char
        jmp put_string

    .exit
        ret

;------------------------------------------------------
put_char:
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
        mov ah,al

        mov dx,0x3d4
        mov al,0x0f
        out dx,al
        mov dx,0x3d5
        in al,dx
        mov bx,ax

        cmp cl,0x0d
        jnz .put_0a
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
        mov es,ax
        shl bx,1
        mov [es:bx],cl ;在写入其他内容前，显存里全是黑底白字
        shr bx,1
        inc bx

    .roll_screen:
        cmp bx,2000
        jl .set_cursor
        mov ax,0xb800
        mov ds,ax
        mov es,ax
        mov cx,1920
        cld         ;别忘了这
        mov si,0xa0
        mov di,0x00
        rep movsw
        mov bx,3840

    .cls:
        mov word [bx],0x0720
        add bx,2
        cmp bx,4000
        jl .cls
        mov bx,1920

    .set_cursor
        mov dx,0x3d4
        mov al,0x0e
        out dx,al
        mov dx,0x3d5
        mov al,bh
        out dx,al

        mov dx,0x3d4
        mov al,0x0f
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

        ret
;======================================================
;数据段信息
;1.初始信息 2.安装信息 3.安装完成信息 4.提示中断正在工作信息
SECTION data align=16 vstart=0

    init_msg   db 'Starting...',0x0a,0x0d,0
    inst_msg   db 'Install begin ~',0x0a,0x0d,0
    done_msg   db 'Done',0x0d,0x0a,0
    tips_msg   db 'Clock is now working',0

;======================================================
SECTION stack align=16 vstart=0
        resb 256
stack_pointer:
;======================================================
SECTION trail align=16
program_end:
