.PHONY: all run

all: helloos.img
run: helloos.img
	qemu-system-i386.exe $^

# for files
ipl.bin: ipl.asm
	nasm $^ -o $@
helloos.img: ipl.bin
	## [-f] fix img size
	## [-C] ?? see manpage...
	## [-B] boot sector
	## [-i filename ::] access to image file
	mformat -f 1440 -C -B $^ -i $@ ::
	



