先安装其他需要的东西：

sudo apt install build-essential

sudo apt-get install libghc-x11-dev

sudo apt-get install xorg-dev

下载Bochs，获得解压包

解压，命令：tar -zxvf bochs-2.6.8.tar.gz

为即将要安装的bochs创建一个空目录，mkdir bochs

可以是

/usr/local/bochs/share/bochs

~/apps/bochs 

 ~/bin/bochs等等



这主要取决于软件的默认安装路径是否已经在系统环境变量中:

1. 如果安装到系统默认目录如/usr/local或/opt,这些路径通常已在PATH中,所以不需要配置。
2. 如果安装到自定义目录如用户主目录或独立目录,就需要修改PATH变量才能在命令行使用。



推荐的软件路径布局方式如下:

/opt - 用于存放主流大型软件的默认安装路径

/usr/local - 系统自己编译安装的软件路径

/home/user/apps - 用户自己安装的软件路径

/home/user/bin - 用户自己软件的执行命令路径



进入解压后的bochs-2.6.8文件夹 cd bochs-2.6.8

配置bochs的config文件，编译，安装

./configure --prefix=安装bochs的目录 --enable-debugger --enable-disasm --enable-iodebug --enable-x86-debugger --with-x --with-x11 LDFLAGS='-pthread'

make

make install



touch bochsrc.disk，在其中写下配置信息

```
megs : 32

romimage: file=bochs安装路径/share/bochs/BIOS-bochs-latest
vgaromimage: file=bochs安装路径/share/bochs/VGABIOS-lgpl-latest

# 选择启动磁盘，我这里是选择以硬盘启动
# 如果你想按照软盘启动的话则boot: floppy
boot: disk

# 设置日志文件输出路径
log: bochs.out

# 关闭鼠标
mouse: enabled=0

#指定键盘映射
keyboard:keymap=bochs安装路径/share/bochs/keymaps/x11-pc-us.map

#配置ATA控制器和设备
ata0:enabled=1,ioaddr1=0x1f0,ioaddr2=0x3f0,irq=14
ata0-master: type=disk, path="hd60M.img", mode=flat,cylinders=121,heads=16,spt=63

```



编译 nasm -o test mbr.s

然后写makefile

```
OBJS_BIN=c05_mbr.bin

.PHONY:
#image: ${OBJS_BIN} 定义了一个名为image的目标，依赖于OBJS_BIN，
#表示要生成一个名为c05.img的磁盘映像文件，并将c05.bin写入该磁盘映像中。
image: ${OBJS_BIN}
#创建一个大小为30MB的全0磁盘映像文件。
	dd if=/dev/zero of=c05_mbr.img bs=512 count=61440
#c05.bin文件写入c05.img磁盘映像文件的第一个扇区。
	dd if=c05_mbr.bin of=c05_mbr.img bs=512 count=1 conv=notrunc
#@-表示忽略删除过程中出现的错误。
	@-rm -rf *.bin	

#表示将以.asm为扩展名的汇编源文件编译为以.bin为扩展名的二进制文件。
%.bin:%.asm
	nasm $^ -o $@ 

#定义了一个名为run的目标，依赖于OBJS_BIN，表示要运行程序。
run: ${OBJS_BIN}
	make image
	bochs -f bochsrc.disk


clean:
	rm -rf *.img  *.out *.lock *.bin 
```



