        core_code_seg_sel      equ  0x38
        core_data_seg_sel      equ  0x30
        sys_routine_seg_sel    equ  0x28
        video_ram_seg_sel      equ  0x20
        core_stack_seg_sel     equ  0x18
        mem_0_4_gb_seg_sel     equ  0x08

;---------------------------------------------------------------
        core length     dd core_end

        sys_routine_seg dd section.sys_routine.start

        core_data_seg   dd section.core_data.start

        core_code_seg   dd section.core_code.start

        core_entry      dd start
                        dw core_code_seg_sel

;===============================================================
        [bits 32] ;别忘这个标志
SECTION sys_routine vstart=0
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
        mov es,video_ram_seg_sel
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

;===============================================================
SECTION core_data vstart=0
        message_1  db 'Now we are in protect mode '
                   db 0x0d,0x0a
                   db 'And the core has been loaded',0x0d,0x0a,0

        message_5  db ' Loading user program...',0

        core_buf times 2048 db 0

        cpu_brnd0  db 0x0d,0x0a,' ',0
        cpu_brand times 52 db 0
        cpu_brnd0  db 0x0d,0x0a,0x0d,0x0a
;===============================================================
SECTION core_code vstart=0
;---------------------------------------------------------------
load_relocate_program:

        push ebx

        mov eax,core_data_seg_sel
        mov ds,eax

        mov eax,esi
        mov ebx,core_buf
        call sys_routine_seg_sel:read_hard_disk_0

        
;---------------------------------------------------------------
start:
        mov ecx,core_data_seg_sel
        mov ds,ecx

        mov ebx,message_1
        call sys_routine_seg_sel:put_string

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

;---------------------------------------------------------------
SECTION core_trail
core_end:
