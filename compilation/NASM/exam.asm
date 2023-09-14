section .data
    msg db "Hello, world!", 0Ah ; 字符串常量，包括换行符

section .text
    global _start

_start:
    ; 1. 调用 write 系统调用输出字符串到控制台
    mov rax, 1              ; 系统调用号 1 表示 write
    mov rdi, 1              ; 第一个参数为文件描述符，1 表示标准输出
    mov rsi, msg            ; 第二个参数为字符串地址
    mov rdx, 14             ; 第三个参数为字符串长度
    syscall                 ; 调用系统调用

    ; 2. 调用 exit 系统调用退出程序
    mov rax, 60             ; 系统调用号 60 表示 exit
    xor rdi, rdi            ; 第一个参数为退出状态码，0 表示正常退出
    syscall                 ; 调用系统调用
