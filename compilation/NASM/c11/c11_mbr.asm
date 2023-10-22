;设置段和段指针,指定sp=0x7c00
mov ax,cs
mov ss,ax
mov sp,0x7c00

;计算ds:bx指向gdt_base
mov ax,[cs:0x7c00+gdt_base]
mov dx,[cs:0x7c00+gdt_base+2]
mov bx,16
div bx
mov ds,ax
mov bx,dx

;空描述符
mov dword [bx],0x0000000
mov dword [bx+4],0x0000000 ;要加上偏移bx

;代码段，512字节
mov dword[bx+0x08],0x7c0001ff
mov dword[bx+0x0c],0x00409800

;显示缓冲区 0xb8000~0xbffff
mov dword[bx+0x10],0x8000ffff
mov dword[bx+0x14],0x0040920b

;堆栈段,段界限为0x7a00
mov dword[bx+0x18],0x00007a00
mov dword[bx+0x1c],0x00409600

;初始化 gdtr
mov word[cs:0x7c00+gdt_size],31
lgdt [cs:0x7c00+gdt_size]

;打开A20
in al,0x92           ;应该把它读出来然后修改而非直接写入
or al,0000_0010B
out 0x92,al

cli ;保护模式的中断模式未建立，先禁止

;设置 PE 位
mov eax,cr0
or eax,1
mov cr0,eax

jmp word 0x0008:flush ;已经进入保护模式了，应该填写段选择子
;在屏幕上显示 protect mode OK
[bits 32]
flush:
    mov ax,0x10  ;程序员从第零个开始，所以是第二个
    mov es,ax
    mov byte[es:0x00],'p'
    mov byte[es:0x02],'r'
    mov byte[es:0x04],'t'
    mov byte[es:0x06],'e'
    mov byte[es:0x08],'c'
    mov byte[es:0x0a],'t'
    mov byte[es:0x0c],' '
    mov byte[es:0x0e],'m'
    mov byte[es:0x10],'o'
    mov byte[es:0x12],'d'
    mov byte[es:0x14],'e'
    mov byte[es:0x16],' '
    mov byte[es:0x18],'O'
    mov byte[es:0x1a],'K'

;压栈，ebp检测如果相同则显示，否则停机
mov ebp,esp
push byte '.' ;需要指定大小
sub ebp,4
cmp ebp,esp
jnz ghalt
pop ax
mov [es:0x1c],al

ghalt:
hlt

;-------------------------------------------------------------
;gdt 的大小和物理地址
        gdt_size dw 0
        gdt_base dd 0x00007e00

times (510 - ($-$$)) db 0
                     db 0x55,0xaa
