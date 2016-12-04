ARM_CC = arm-eabi-as # cross compiling toolchain
LINKER = arm-eabi-ld

# IC Computer
#source /home/specg12-1/mc404/simulador/set_path.sh
 #MKSD = mksd.sh
 #OS = /home/specg12-1/mc404/simulador/dummyos.elf
 #DUMBOOT = /home/specg12-1/mc404/simulador/dumboot.bin
 #ARMSIM = arm-sim
 #GDB = arm-eabi-gdb

# ARM SimulatorG
GDB = /home/mc404/simuladorfromspecg/simulador/bin/arm-eabi-gdb

GDB_FLAG = -g
# target remote localhost:5000

TEXTADDR = 0x77802000 # OS will load user application code at this address
DATAADDR = 0x77802800 # various data item

conversion: 
	arm-eabi-gcc main.c -S -o main.s

assembly: conversion
	$(ARM_CC) main.s $(GDB_FLAG) -o main.o
	$(ARM_CC) api_robot.s $(GDB_FLAG) -o api_robot.o

link: assembly
	$(LINKER) main.o api_robot.o $(GDB_FLAG) -o robot_ctrl.exe -Ttext=$(TEXTADDR)

image_creation: link
	$(MKSD) --so $(OS) --user robot_ctrl.exe

simulation: image_creation
	$(ARMSIM_PLAYER) --rom=$(DUMBOOT) --sd=disk.img $(GDB_FLAG)

run_player:
	$(PLAYER) $(PLAYER_WORLDS)/simple.cfg # run this first in another window

gdb:
	$(GDB) robot_ctrl.exe

clean:
	rm -rf *.o
	rm -rf *.exe
	rm -rf *.img
