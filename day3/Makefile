.PHONY: all run

all: haribote.vfd
run: haribote.img
	qemu-system-i386.exe -m 32 -vga std -fda $^

# for files
ipl.bin: ipl.asm
	nasm $^ -o $@
head.bin: asmhead.asm
	nasm $^ -o $@
func.o: func.asm
	nasm -f elf $^ -o $@
bootpack.o: bootpack.c
	gcc $^ -nostdlib -march=i386 -m32 -fno-pie -c -o $@
haribote.sys: bootpack.o head.bin func.o
	ld -o boot.bin -e hrmain -m elf_i386 --oformat binary bootpack.o func.o
	cat head.bin boot.bin > $@
haribote.img: ipl.bin haribote.sys
	## [-f] fix img size
	## [-C] ?? see manpage...
	## [-B] boot sector
	## [-i filename ::] access to image file
	mformat -f 1440 -C -B ipl.bin -i $@ ::
	## write system file to fd
	mcopy haribote.sys -i $@ ::
haribote.vfd: haribote.img
	qemu-img.exe convert $^ $@	



