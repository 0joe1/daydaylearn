jmp near start
;声明内容
calculate db '1+2+3+...+1000='
;设置附加段和数据段
start:
    mov ax,0x7c0 ;佛了，这儿又写错了
    mov ds,ax
    mov ax,0xb800
    mov es,ax

    ;显示字符串
    mov cx,(start-calculate)
    mov si,calculate
    mov di,0
    show:
        mov al,[si]    ;这里只取一个字节，所以是 al
        mov [es:di],al ;mov不能两者都是内存单元
        inc di
        mov byte [es:di],0x07
        inc di
        inc si ;别忘了移动si
        loop show

    ;在ax计算相加之和
    xor ax,ax
    xor dx,dx ;计算之前先清零
    mov cx,1000
    @a:
        add ax,cx
        adc dx,0
        loop @a

    ;计算累加和的数位并压到栈里
    xor cx,cx ;cx用来计数
    mov ss,cx ;MOV指令中立即数不能直接传送给段寄存器（CS、DS、SS、ES）和IP
    mov sp,cx

    mov bx,10
    @s:
        inc cx
        div bx
        or dl,0x30
        push dx
        xor dx,dx
        cmp ax,0
        jne @s

    ;显示
    xor ax,ax
    @p:
        pop ax
        mov ah,0x02
        mov word [es:di],ax
        add di,2
        loop @p

jmp near $

;声明空白和末尾
times (510 - ($-$$)) db 0
db 0x55,0xaa

