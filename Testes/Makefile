SOURCE = lab04.s
ARM_CC = arm-eabi-as # cross compiling toolchain
LINKER = arm-eabi-ld

# IC Computer
#DUMBOOT = /home/specg12-1/mc404/simulador/dumboot.bin
#OS = /home/specg12-1/mc404/simulador/dummyos.elf

TEXTADDR = 0x77802000 # OS will load user application code at this address
DATAADDR = 0x77802800 # various data item

GDB = /home/mc404/simuladorfromspecg/simulador/bin/arm-eabi-gdb
GDB_FLAG = -g
# target remote localhost:5000

assembly: $(SOURCE)
	$(ARM_CC) $(SOURCE) $(GDB_FLAG) -o object.o

link: assembly
	$(LINKER) object.o $(GDB_FLAG) -o executable.exe -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR)

image_creation: link
	$(MKSD) --so $(OS) --user executable.exe

simulation: image_creation
	$(ARMSIM) --rom=$(DUMBOOT) --sd=disk.img $(GDB_FLAG)

gdb:
	$(GDB) executable.x

clean:
	rm -rf *.o
	rm -rf *.exe
	rm -rf *.img