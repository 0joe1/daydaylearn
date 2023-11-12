        core_code_seg_sel      equ  0x38
        core_data_seg_sel      equ  0x30
        sys_routine_seg_sel    equ  0x28
        video_ram_seg_sel      equ  0x20
        core_stack_seg_sel     equ  0x18
        mem_0_4_gb_seg_sel     equ  0x08

;---------------------------------------------------------------
        core_length     dd core_end

        sys_routine_seg dd section.sys_routine.start

        core_data_seg   dd section.core_data.start

        core_code_seg   dd section.core_code.start

        core_entry      dd start
                        dw core_code_seg_sel

;===============================================================
        [bits 32] ;别忘这个标志
SECTION sys_routine vstart=0
;---------------------------------------------------------------
put_hex_dword:
        pushad
        push ds

        mov ax,core_code_seg_sel
        mov ds,ax

        mov ebx,bin_hex
        mov ecx,8
    .xlt:
        rol edx,4
        mov eax,edx
        and eax,0x0000000f
        xlat

        push ecx
        mov cl,al
        call put_char
        pop ecx

        loop .xlt

        pop ds
        popad
        retf
;---------------------------------------------------------------
;输入：DS:EBX=串地址
put_string:
        push ecx
    .getc:
        mov cl,[ebx]
        or cl,cl
        jz .exit
        call put_string
        inc ebx
        jmp .getc

    .exit
        pop ecx
        retf
;---------------------------------------------------------------
put_char:
        pushad

        mov dx,0x3d4
        mov al,0x0e
        out dx,al
        inc dx
        in al,dx
        mov ah,al

        dec dx
        mov al,0x0f
        out dx,al
        inc dx
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
        push es
        mov eax,video_ram_seg_sel
        mov es,eax
        shl bx,1
        mov [es:bx],cl
        pop es

        shr bx,1
        inc bx

    .roll_screen:
        cmp bx,2000
        jl .set_cursor

        mov eax,video_ram_seg_sel
        mov ds,eax
        mov es,eax
        cld
        mov esi,0xa0
        mov edi,0x00
        mov ecx,1920
        rep movsd
        mov bx,3840
        mov ecx,80
    .cls:
        mov word[es:bx],0x0720
        add bx,2
        loop .cls

        pop es
        pop ds

        mov bx,1920

    .set_cursor:
        mov dx,0x3d4
        mov al,0x0e
        out dx,al
        inc dx
        mov al,bh
        out dx,al
        dec dx
        mov al,0x0f
        out dx,al
        inc dx
        mov al,bl
        out dx,al

        popad
        ret
;---------------------------------------------------------------
;eax(逻辑扇区号) ds:ebx(目标缓冲区地址)
read_hard_disk_0:
        push eax
        push ecx
        push edx

        push eax
        mov dx,0x1f2
        mov al,1
        out dx,al

        ;0-7
        inc dx
        pop eax
        out dx,al

        ;8-15
        inc dx
        shr al,8
        out dx,al

        ;16-23
        inc dx
        shr al,8
        out dx,al

        ;24-27
        inc dx
        shr al,8
        or al,0xe0
        out dx,al

        inc dx
        mov al,0x20
        out dx,al

    .waits:
        in al,dx
        and al,0x88
        cmp al,0x80
        jnz .waits

        mov ecx,512
        mov dx,0x1f0  ;从磁盘读的端口是0x1f0
    .readw:
        in ax,dx
        mov [ebx],ax  ;除了使用al外，还可以使用ax
        add ebx,2
        loop .readw

        pop edx
        pop ecx
        pop eax

        retf
;---------------------------------------------------------------
;分配内存 ecx(希望分配的字节数)
allocate_memory:
        push ds
        push eax
        push ebx

        mov eax,core_data_seg_sel
        mov ds,eax

        mov eax,[ram_alloc]
        add eax,ecx

        mov ecx,[ram_alloc]

        mov ebx,eax
        and ebx,0xfffffffc
        add ebx,4
        test eax,0x00000003
        cmovnz eax,ebx

        mov [ram_alloc],eax

        pop ebx
        pop eax
        pop ds

        retf
;---------------------------------------------------------------
;eax(线性基地址) ebx(段界限) ecx(属性)
;返回 edx:eax=描述符
make_seg_descriptor:
        mov edx,eax
        shl eax,16
        or ax,bx

        and edx,0xffff0000
        rol edx,8
        bswap edx

        xor bx,bx
        or edx,ebx
        or edx,ecx

        retf
;---------------------------------------------------------------
;edx:eax=描述符
;输出cx=描述符的选择子
set_up_gdt_descriptor:
        push eax
        push ebx
        push edx

        push ds
        push es

        mov ebx,core_data_seg_sel
        mov ds,ebx

        sgdt [pgdt]

        mov ebx,mem_0_4_gb_seg_sel
        mov es,ebx

        mov ecx,[pgdt+0x02]
        movzx ebx,word [pgdt]
        inc bx                 ;可能是0x0000ffff
        add ecx,ebx

        mov [es:ecx],eax
        mov [es:ecx+4],edx

        add word[pgdt],8
        lgdt [pgdt]

        mov ax,[pgdt]
        xor dx,dx
        mov bx,8
        div bx
        mov cx,ax
        shl cx,3

        pop es
        pop ds

        pop edx
        pop ebx
        pop eax

        retf

;===============================================================
SECTION core_data vstart=0
        pgdt        dw 0
                    dd 0

        ram_alloc   dd 0x00100000

        salt:
        salt_1      db '@PrintString'
                    times 256-($-salt_1) db 0
                    dd put_string
                    dw sys_routine_seg_sel

        salt_2      db '@ReadDiskData'
                    times 256-($-salt_2) db 0
                    dd read_hard_disk_0
                    dw sys_routine_seg_sel

        salt_3      db '@PrintDwordAsHexString'
                    times 256-($-salt_3) db 0
                    dd put_hex_dword
                    dw sys_routine_seg_sel

        salt_4      db 'TerminateProgram'
                    times 256-($-salt_4) db 0
                    dd return_point
                    dw core_code_seg_sel

        salt_item_len equ $-salt_4
        salt_items    equ ($ - salt)/salt_item_len

        message_1  db 'Now we are in protect mode '
                   db 0x0d,0x0a
                   db 'And the core has been loaded',0x0d,0x0a,0

        message_5  db ' Loading user program...',0

        do_status  db 'Done.',0x0d,0x0a,0

        message_6  db 0x0d,0x0a,0x0d,0x0a,0x0d,0x0a
                   db ' User program terminated,control returned',0

        bin_hex    db '0123456789ABCDEF'

        core_buf times 2048 db 0

        esp_pointer dd 0  

        cpu_brnd0  db 0x0d,0x0a,' ',0
        cpu_brand times 52 db 0
        cpu_brnd1  db 0x0d,0x0a,0x0d,0x0a,0
;===============================================================
SECTION core_code vstart=0
;---------------------------------------------------------------
;input:  esi（起始逻辑扇区号）
;output: ax （指向用户程序头部的选择子）
load_relocate_program:

        push ebx

        mov eax,core_data_seg_sel
        mov ds,eax

        mov eax,esi
        mov ebx,core_buf
        call sys_routine_seg_sel:read_hard_disk_0

        mov eax,[core_buf]
        mov ebx,eax
        and ebx,0xfffffe00
        add ebx,512
        test eax,0x00000111
        cmovnz eax,ebx

        mov ecx,eax
        call sys_routine_seg_sel:allocate_memory
        mov ebx,ecx
        push ebx

        xor edx,edx
        mov ecx,512
        div ecx
        mov ecx,eax

        mov eax,mem_0_4_gb_seg_sel
        mov ds,eax
        mov eax,esi

    .b1:
        call sys_routine_seg_sel:read_hard_disk_0
        inc eax
        loop .b1

        ;头部段描述符
        pop edi                    ;edi=加载的程序的首地址
        mov eax,edi
        mov ebx,[edi+0x04]
        dec ebx
        mov ecx,0x00409200
        call sys_routine_seg_sel:make_seg_descriptor
        call sys_routine_seg_sel:set_up_gdt_descriptor
        mov [edi+0x04],cx

        ;代码段
        mov eax,edi
        add eax,[edi+0x14]
        mov ebx,[edi+0x18]
        dec ebx
        mov ecx,0x00409800
        call sys_routine_seg_sel:make_seg_descriptor
        call sys_routine_seg_sel:set_up_gdt_descriptor
        mov [edi+0x14],cx

        ;数据段
        mov eax,edi
        add eax,[edi+0x1c]
        mov ebx,[edi+0x20]
        dec ebx
        mov ecx,0x00409200
        call sys_routine_seg_sel:make_seg_descriptor
        call sys_routine_seg_sel:set_up_gdt_descriptor
        mov [edi+0x1c],cx

        ;堆栈段
        mov ecx,[edi+0x0c]
        mov ebx,0x000fffff
        sub ebx,ecx
        mov eax,0x1000
        mul dword [edi+0x0c]
        mov ecx,eax
        call sys_routine_seg_sel:allocate_memory
        add ecx,eax
        mov ecx,0x00c09600
        call sys_routine_seg_sel:make_seg_descriptor
        call sys_routine_seg_sel:set_up_gdt_descriptor
        mov [edi+0x1c],cx

        ;重定位SALT
        mov eax,core_data_seg_sel
        mov ds,eax
        mov eax,[edi+0x04]
        mov es,eax

        ;edi=程序加载首地址
        cld
        mov ecx,[es:0x24]
        mov edi,0x28
    .b2
        push ecx
        push edi

        mov ecx,salt_items
        mov esi,salt
    .b3
        push ecx
        push esi
        push edi

        mov ecx,256
        repe movsd
        jnz .b4
        mov eax,[esi]
        mov [es:edi-256],eax
        mov ax,[esi+4]
        mov [es:esi-252],ax

    .b4
        pop ecx
        pop esi
        pop edi
        add esi,salt_item_len
        loop .b3

        pop ecx
        pop edi
        add edi,256
        loop .b2


        pop es
        pop ds

        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx

        ret

;---------------------------------------------------------------
start:
        mov ecx,core_data_seg_sel
        mov ds,ecx

        mov ebx,message_1
        call sys_routine_seg_sel:put_string
        hlt

        ;显示处理器品牌信息(没有查看处理器是否支持,是反面典例)
        mov eax,0x80000002
        cpuid
        mov [cpu_brand + 0x00],eax
        mov [cpu_brand + 0x04],ebx
        mov [cpu_brand + 0x08],ecx
        mov [cpu_brand + 0x0c],edx

        mov eax,0x80000003
        cpuid
        mov [cpu_brand + 0x10],eax
        mov [cpu_brand + 0x14],ebx
        mov [cpu_brand + 0x18],ecx
        mov [cpu_brand + 0x1c],edx

        mov eax,0x80000004
        cpuid
        mov [cpu_brand + 0x20],eax
        mov [cpu_brand + 0x24],ebx
        mov [cpu_brand + 0x28],ecx
        mov [cpu_brand + 0x2c],edx

        mov ebx,cpu_brnd0
        call sys_routine_seg_sel:put_string
        mov ebx,cpu_brand
        call sys_routine_seg_sel:put_string
        mov ebx,cpu_brnd1
        call sys_routine_seg_sel:put_string

        mov ebx,message_5
        call sys_routine_seg_sel:put_string
        mov esi,50
        call load_relocate_program

        mov [esp_pointer],esp

        mov ds,ax

        jmp far [0x10]

return_point:
        mov eax,core_data_seg_sel
        mov ds,eax

        mov eax,core_data_seg_sel
        mov ss,eax
        mov esp,[esp_pointer]

        mov ebx,message_6
        call sys_routine_seg_sel:put_string

        hlt

;---------------------------------------------------------------
SECTION core_trail
core_end:
