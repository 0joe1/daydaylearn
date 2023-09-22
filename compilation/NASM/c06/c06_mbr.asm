jmp near start
;声明 Label offset: 声明存放 number 的地方
Label db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07, \
         'o',0x07,'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
number db 0,0,0,0,0

;开始：设置数据段和附加段的基地址
start:
mov ax,0x7c0 ;不是7c00,注意！！！
mov ds,ax
mov ax,0xb800
mov es,ax

;将原来的转移到 di 所指的地方(显示Label offset)
cld
mov cx,(number-Label)/2
mov si,Label
mov di,0
rep movsw

;计算
mov ax,number

mov bx,4 ;这个初始化得写外面，不然 bx 根本没在减少呀
loop:
xor dx,dx
mov cx,10
div cx
mov [number+bx],dl
dec bx
jns loop

;显示
mov bx,number
mov cx,5 ;这个同理
show:
mov al,[bx]
inc bx
add al,0x30
mov ah,0x04
mov [es:di],ax
add di,2
loop show

mov word [es:di],0x0144

jmp near $

;声明空洞0 和 0x55aa
times (510-($-$$)) db 0
db 0x55,0xaa
