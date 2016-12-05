USER = user_code
SYSTEM = ra156531
ARM_CC = arm-eabi-as # cross compiling toolchain
LINKER = arm-eabi-ld

# IC Computer
#source /home/specg12-1/mc404/simulador/set_path.sh
 MKSD = mksd.sh
 DUMBOOT = /home/specg12-1/mc404/simulador/simulador_player/bin/dumboot.bin
 ARMSIM = arm-sim
 GDB = arm-eabi-gdb

# ARM Simulator
#GDB = /home/mc404/simuladorfromspecg/simulador/bin/arm-eabi-gdb

GDB_FLAG = -g
# target remote localhost:5000

TEXTADDR = 0x77802000 # OS will load user application code at this address
DATAADDR = 0x77802800 # various data item

sys:
# Para compilar e ligar o seu programa (note a diferença no ligador)
	$(ARM_CC) $(GDB_FLAG) $(SYSTEM).s -o $(SYSTEM).o
	$(LINKER) $(SYSTEM).o -o $(SYSTEM) -g --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0

assembly: sys
	$(ARM_CC) $(USER).s $(GDB_FLAG) -o $(USER).o

link: assembly
	$(LINKER) $(USER).o $(GDB_FLAG) -o $(USER).exe -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR)

image_creation: link
	$(MKSD) --so $(SYSTEM) --user $(USER).exe

simulation: image_creation
	$(ARMSIM) --rom=$(DUMBOOT) --sd=disk.img $(GDB_FLAG)

gdb:
	$(GDB) $(SYSTEM)
	
clean:
	rm -rf *.o
	rm -rf *.exe
	rm -rf *.img
