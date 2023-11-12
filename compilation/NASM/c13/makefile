OBJS_BIN=c13_mbr.bin c13_core.bin c13.bin


#image: ${OBJS_BIN} 定义了一个名为image的目标，依赖于OBJS_BIN，
#表示要生成一个名为c13.img的磁盘映像文件，并将c13.bin写入该磁盘映像中。
image: ${OBJS_BIN}
#创建一个大小为30MB的全0磁盘映像文件。
	dd if=/dev/zero of=boot.img bs=512 count=61440
#c13_mbr.bin文件写入c13.img磁盘映像文件的第一个扇区。
	dd if=c13_mbr.bin of=boot.img bs=512 count=1 conv=notrunc
#c13_core.bin文件写入c13.img磁盘映像文件的第二个扇区。
	dd if=c13_core.bin of=boot.img bs=512 seek=1 conv=notrunc
#diskdata.txst文件写入第100个扇区
	dd if=diskdata.txt of=boot.img bs=512 seek=100 conv=notrunc
#@-表示忽略删除过程中出现的错误。
	@-rm -rf *.bin	

#表示将以.asm为扩展名的汇编源文件编译为以.bin为扩展名的二进制文件。
%.bin:%.asm
	nasm $^ -o $@ 

#定义了一个名为run的目标，依赖于OBJS_BIN，表示要运行程序。
run: ${OBJS_BIN}
	make image
	/home/username/bochs2.6/bin/bochs -f bochsrc.disk


clean:
	rm -rf *.img  *.out *.lock *.bin 

.PHONY:clean image
