;声明常数(用户程序起始逻辑扇区号 100)
app_lba_start equ 100

SECTION mbr align=16 vstart=0x7c00
        ;准备一下先,设置堆在 0x0000 ~ 0xFFFF
        mov ax,0
        mov ss,ax
        mov sp,ax

        ;指定es、ds在phy_base指定的地方
        mov ax,[phy_base]
        mov dx,[phy_base+0x02]
        mov bx,16
        div bx
        mov ds,ax
        mov es,ax

        ;读取用户段起始部分到 DS:0x0000
        xor di,di
        mov si,app_lba_start
        xor bx,bx
        call read_hard_disk

        ;计算大小并读取剩余扇区
        mov ax,[0]
        mov dx,[2]
        mov bx,512
        div bx
        mov cx,ax
        cmp dx,0 ;看看有没有余数
        jnz @1
        dec cx ;已经读了一个扇区，如果没整除要+1正好抵消不用减
    @1:
        cmp cx,0
        jz direct

        push ds ;等下要改变ds且现在的ds以后还要用，所以先存起来
    @2:
        inc si
        xor bx,bx

        mov ax,ds
        add ax,0x20
        mov ds,ax  ;对数据段寄存器执行加法操作是不合法的

        call read_hard_disk
        loop @2

        pop ds

        ;用户程序入口点代码段重定位
    direct:
        mov ax,[0x06] ;0x06~0x08
        mov dx,[0x08] ;0x08~0x0a
        call cal_segment_base
        mov [0x06],ax

        ;类似地，处理段定位表
        mov cx,[0x0a]
        mov bx,0x0c   ;bx里存偏移量，不用加中括号
    handle_tbl:
        mov ax,[bx]
        mov dx,[bx+0x02]
        call cal_segment_base
        mov [bx],ax
        add bx,4
        loop handle_tbl

        ;转移到用户程序
        jmp far [4]

;----------------------------------------------------------------
;从硬盘读取一个扇区的数据 read_hard_disk
;DI:SI = 起始逻辑扇区号
;DS:BX = 把读取的程序放在哪里
read_hard_disk:
        ;准备下
        push ax
        push bx
        push cx
        push dx

        ;指定想读的磁盘的位置和量
        mov dx,0x1f2
        mov al,1
        out dx,al

        mov ax,si
        inc dx  ;0x1f3  0~7位
        out dx,al

        mov al,ah
        inc dx  ;0x1f4  8~15位 
        out dx,al

        mov ax,di
        inc dx  ;0x1f5  16~23位
        out dx,al

        mov al,ah
        or al,0xe0
        inc dx  ;0x1f6  24~27位
        out dx,al

        ;等待硬盘准备好
        inc dx  ;0x1f7
        mov al,0x20
        out dx,al
    .wait:
        in al,dx
        and al,0x88
        cmp al,0x08
        jnz .wait

        ;读
        mov cx,256
        mov dx,0x1f0
    .read:
        in ax,dx
        mov [ds:bx],ax ;这边ds加得有点多余
        add bx,2
        loop .read

        ;返回了
        pop dx
        pop cx
        pop bx
        pop ax ;注意，弹出的顺序要与塞入的顺序相反

        ret
;-----------------------------------------------------------------
;输入DX:AX 共20位，其中DX存放4位
;得到AX
cal_segment_base:
        push dx

        add ax,[cs:phy_base]
        adc dx,[cs:phy_base+0x02]

        shr ax,4
        shl dx,12
        or ax,dx

        pop dx
        ret

;声明用户程序的地址
phy_base dd 0x10000

times (510-($-$$)) db 0
db 0x55,0xaa
