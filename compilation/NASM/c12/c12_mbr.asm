        ;设置堆栈
        mov ax,cs
        mov ss,ax
        mov sp,0x7c00

        ;DS:EBX 指向gdt
        mov eax,[cs:0x7c00+pdgt+2]
        xor edx,edx
        mov ebx,16
        div ebx
        mov ds,eax
        mov ebx,edx

        ;空描述符
        mov dword[ebx+0x00],0x00
        mov dword[ebx+0x04],0x00      ;每个描述符表8个字节

        ;0-4GB 的数据段
        mov dword[ebx+0x08],0x0000ffff
        mov dword[ebx+0x0c],0x00cf9200

        ;代码段，大小512B
        mov dword[ebx+0x10],0x7c0001ff
        mov dword[ebx+0x14],0x00409800

        ;代码段的别名，便于修改
        mov dword[ebx+0x18],0x7c0001ff
        mov dword[ebx+0x1c],0x00409200

        ;栈段，0x00006c00 ~ 0x00007c00
        mov dword[ebx+0x20],0x7c00fffe
        mov dword[ebx+0x24],0x00cf9600

        ;加载 gdt
        mov word[cs:0x7c00+pdgt],39
        lgdt [cs:0x7c00+pdgt]

        ;进入保护模式
        in al,0x92
        or al,0x02
        out 0x92,al

        cli
        mov eax,cr0
        or eax,1
        mov cr0,eax

        jmp dword 0x0010:flush
        ;ds 指向代码段的别名描述符
        [bits 32]
    flush:
        mov eax,0x18
        mov ds,eax

        ;es,fs,gs 数据段选择子
        mov eax,0x08
        mov es,eax
        mov fs,eax
        mov gs,eax

        ;栈段,esp=0
        mov eax,0x20
        mov ss,eax
        xor esp,esp

        ;用es定位显示 P.M.  ok
        mov dword[es:0xb8000],0x072e0750
        mov dword[es:0xb8004],0x072e074d
        mov dword[es:0xb8008],0x07200720
        mov dword[es:0xb800c],0x076b076f  ;是0xb8000，不是0xb800

        ;开始冒泡排序
        mov ecx,pdgt-string-1
    @1:
        mov ebx,string
        push ecx
    @2:
        mov ah,[ebx]
        mov al,[ebx+1]
        cmp ah,al ;cmp不允许两个都是内存单元
        jge @3
        xchg ah,al
    @3:
        mov word[ebx],ax
        inc ebx
        loop @2

        pop ecx
        loop @1

        ;第二行开始展示 string
        mov ecx,pdgt-string
        xor ebx,ebx
        mov ah,0x07
    output:
        mov al,[string+ebx]
        mov [es:0xb80a0+ebx*2],ax
        inc ebx
        loop output

        hlt
;-----------------------------------------------------------------
;要排序的string
string db 'jksahfibsckxdwezgl5293412'

;-----------------------------------------------------------------
;pdgt 大小与地址0x00007e00
pdgt    dw 0
        dd 0x00007e00

times 510-($-$$) db 0
                 db 0x55,0xaa
