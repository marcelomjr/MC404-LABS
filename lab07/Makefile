SOURCE = motors
ARM_CC = arm-eabi-as # cross compiling toolchain
LINKER = arm-eabi-ld

# IC Computer
#Configuração de variáveis de ambiente:
#source /home/specg12-1/mc404/simulador/set_path_player.sh
MKSD = mksd.sh
OS = /home/specg12-1/mc404/simulador/simulador_player/bin/knrl
DUMBOOT = /home/specg12-1/mc404/simulador/simulador_player/bin/dumboot.bin
ARMSIM = arm-sim
GDB = arm-eabi-gdb
PLAYER = player
PLAYER_WORLDS = /home/specg12-1/mc404/simulador/simulador_player/worlds_mc404/
ARMSIM_PLAYER = armsim_player

# ARM SimulatorG
#GDB = /home/mc404/simuladorfromspecg/simulador/bin/arm-eabi-gdb

#GDB_FLAG = -g
# target remote localhost:5000

TEXTADDR = 0x77802000 # OS will load user application code at this address
DATAADDR = 0x77802800 # various data item

assembly: 
	$(ARM_CC) $(SOURCE).s $(GDB_FLAG) -o $(SOURCE).o

link: assembly
	$(LINKER) $(SOURCE).o $(GDB_FLAG) -o $(SOURCE).exe -Ttext=$(TEXTADDR)

image_creation: link
	$(MKSD) --so $(OS) --user $(SOURCE).exe

simulation: image_creation
	$(ARMSIM_PLAYER) --rom=$(DUMBOOT) --sd=disk.img $(GDB_FLAG)

run_player:
	$(PLAYER) $(PLAYER_WORLDS)/simple.cfg # run this first in another window

gdb:
	$(GDB) executable.exe

clean:
	rm -rf *.o
	rm -rf *.exe
	rm -rf *.img
