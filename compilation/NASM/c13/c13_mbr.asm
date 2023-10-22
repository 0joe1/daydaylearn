        core_base_address equ 0x00040000 ;常数，内核加载的起始内存地址
        core_start_sector equ 0x00000001 ;常数，内核的起始逻辑扇区号

        mov ax,cs
        mov ss,ax
        mov esp,0x7c00

        mov eax,[cs:0x7c00+pdgt+0x02]
        xor edx,edx
        mov ebx,16
        div ebx
        mov ds,eax
        mov ebx,edx

        ;空描述符
        mov dword[ebx:0x00],0x00000000
        mov dword[ebx:0x04],0x00000000

        ;0-4GB数据段
        mov dword[ebx:0x08],0x0000ffff
        mov dword[ebx:0x0c],0x00cf9200

        ;初始代码段描述符
        mov dword[ebx:0x10],0x7c0001ff
        mov dword[ebx:0x14],0x00409800

        ;初始堆栈段描述符
        mov dword[ebx:0x18],0x7c00fffe
        mov dword[ebx:0x1c],0x00cf9600

        ;显示缓冲区描述符
        mov dword[ebx:0x20],0x80007fff
        mov dword[ebx:0x24],0x0040920b

        mov word [cs:0x7c00+pgdt],39
        lgdt [cs:0x7c00+pgdt]

        in al,0x92
        or al,0x02
        out 0x92,al

        cli
        mov eax,cr0
        or eax,0x01
        mov cr0,eax

        jmp dword 0x0010:flush

        [bits 32]
    flush:
        mov eax,0x0008
        mov ds,eax

        mov eax,0x0018
        mov ss,eax
        xor esp,esp

        mov edi,core_base_address
        mov eax,core_start_sector
        mov ebx,edi
        call read_hard_disk_0

        mov eax,[ebx]
        xor edx,edx
        mov ecx,512
        div ecx

        or edx,edx
        jnz @1
        dec eax
    @1:
        or eax,eax  ;这个不能放前面，防止刚好读一个的漏网之鱼
        jz setup
        mov ecx,eax
        mov eax,core_start_sector ;刚才eax拿去用了，需要重新赋值
        inc eax
    @2:
        call read_hard_disk_0
        inc eax
        loop @2

    setup:
        mov esi,[0x7c00+pdgt+0x02]

        ;公共例程段描述符
        mov eax,[edi+0x04]
        mov ebx,[edi+0x08]
        sub ebx,eax
        dec ebx
        mov ecx,0x00409800
        call make_gdt_descripter
        mov [esi+0x28],eax
        mov [esi+0x2c],edx

        ;核心数据段描述符
        mov eax,[edi+0x0c]
        mov ebx,[edi+0x10]
        sub ebx,eax
        dec ebx
        mov ecx,0x00409200
        call make_gdt_descripter
        mov [esi+0x30],eax
        mov [esi+0x34],edx

        ;核心代码段描述符
        mov eax,[edi+0x0c]
        mov ebx,[edi+0x00]
        sub ebx,eax
        dec ebx
        mov ecx,0x00409800
        call make_gdt_descripter
        mov [esi+0x38],eax
        mov [esi+0x3c],edx

        mov word[0x7c00+pgdt],63

        lgdt [0x7c00+pgdt]

        jmp far [edi+0x10]

;----------------------------------------------------------------
;从硬盘读取一个逻辑扇区
;EAX=逻辑扇区号
;DS:EBX=目标缓冲区地址
;返回：EBX=EBX+512
read_hard_disk_0:

        push eax
        push edx
        push ecx

        push eax
        mov dx,0x1f2
        mov al,1
        out dx,al
        pop eax

        ;0~7
        inc dx
        out dx,al

        ;8~15
        shr eax,8
        inc dx
        out dx,al

        ;16~23
        shr eax,8
        inc dx
        out dx,al

        ;24~27
        shr eax,8
        or al,0xe0
        inc dx
        out dx,al

        inc dx       ;0x1f7
        mov al,0x20
        out dx,al

    .waits:
        in al,dx
        and al,0x88
        cmp al,0x08
        jnz .waits

        mov cx,256
        mov dx,0x1f0
    .readw
        in ax,dx
        mov [ebx],ax
        add ebx,2
        loop .readw

        pop ecx
        pop edx
        pop eax

        ret
;----------------------------------------------------------------
;构造描述符
;输入段基地址(eax) 段界限(ebx) 属性(ecx)
;返回：edx:eax=完整的描述符
make_gdt_descripter:
        mov edx,eax
        shl eax,16
        or eax,bx

        or edx,0xffff0000
        rol edx,8
        bswap edx

        xor bx,bx
        or edx,ebx

        or edx,ecx

        ret
;----------------------------------------------------------------
        pgdt  dw 0
              dd 0x00007e00 ;GDT的物理地址
;----------------------------------------------------------------
        times 510-($-$$) db 0
                         db 0x55,0xaa

