
DUMBOOT = /home/mc404/usr/bin/dumboot.bin # firmware bootstrap code loaded upon powerup of ARM core
OS = /home/mc404/usr/bin/knrl # operating system loaded from the SD card by the bootstrap code
PLAYER_WORLDS = /home/mc404/usr/worlds_mc404 # folder with environments for robot Player
ARMSIM = arm-sim # armv7 simulator
ARMSIM_PLAYER = armsim_player # armv7 simulator adapted for interaction with robot Player
MKSD = mksd.sh # script for creating bootable SD card with OS and application (userland) code

TEXTADDR = 0x77802000 # OS will load user application code at this address
DATAADDR = 0x77802800 # various data item
ARM_CC = arm-eabi- # prefix for cross compiling toolchain

LAB04_DIR = lab04
LAB05_DIR = lab05
LAB06_DIR = lab06
LAB07_DIR = lab07

LAB_DIRS = $(LAB04_DIR) $(LAB05_DIR) $(LAB06_DIR) $(LAB07_DIR)
# DEBUG=--gdb --gdb-port=5000 # uncomment this to run the simulator in debug mode (waiting for gdb driver)

lab04: $(LAB04_DIR)/disk.img
lab04run: $(LAB04_DIR)/disk.img
	$(ARMSIM) --rom=$(DUMBOOT) --sd=$(LAB04_DIR)/disk.img $(DEBUG)
$(LAB04_DIR)/disk.img: $(LAB04_DIR)/lab04.elf
	$(MKSD) --so $(OS) --user $^ && mv disk.img $(LAB04_DIR)
$(LAB04_DIR)/lab04.elf: $(LAB04_DIR)/lab04.o
	$(ARM_CC)ld -o $@ -g -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR) $^
	$(ARM_CC)objdump -D $(LAB04_DIR)/lab04.elf > $(LAB04_DIR)/lab04.objdump
$(LAB04_DIR)/lab04.o: $(LAB04_DIR)/lab04.s
	$(ARM_CC)as -o $@ -g $^

lab05: $(LAB05_DIR)/disk.img
lab05run: $(LAB05_DIR)/disk.img
	$(ARMSIM) --rom=$(DUMBOOT) --sd=$(LAB05_DIR)/disk.img $(DEBUG)
$(LAB05_DIR)/disk.img: $(LAB05_DIR)/lab05.elf
	$(MKSD) --so $(OS) --user $^ && mv disk.img $(LAB05_DIR)
$(LAB05_DIR)/lab05.elf: $(LAB05_DIR)/lab05.o
	$(ARM_CC)ld -o $@ -g -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR) $^
	$(ARM_CC)objdump -D $(LAB05_DIR)/lab05.elf > $(LAB05_DIR)/lab05.objdump
$(LAB05_DIR)/lab05.o: $(LAB05_DIR)/lab05.s
	$(ARM_CC)as -o $@ -g $^

lab06: $(LAB06_DIR)/disk.img
lab06runplayer:
	player $(PLAYER_WORLDS)/simple.cfg # run this first in another window
lab06run: $(LAB06_DIR)/disk.img
	$(ARMSIM_PLAYER) --rom=$(DUMBOOT) --sd=$(LAB06_DIR)/disk.img $(DEBUG) # then run the simulator
$(LAB06_DIR)/disk.img: $(LAB06_DIR)/lab06.elf
	$(MKSD) --so $(OS) --user $^ && mv disk.img $(LAB06_DIR)
$(LAB06_DIR)/lab06.elf: $(LAB06_DIR)/lab06.o
	$(ARM_CC)ld -o $@ -g -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR) $^
	$(ARM_CC)objdump -D $(LAB06_DIR)/lab06.elf > $(LAB06_DIR)/lab06.objdump
$(LAB06_DIR)/lab06.o: $(LAB06_DIR)/lab06.s
	$(ARM_CC)as -o $@ -g $^

lab07: $(LAB07_DIR)/disk.img
lab07runplayer:
	player $(PLAYER_WORLDS)/simple.cfg # run this first in another window
lab07run: $(LAB07_DIR)/disk.img
	$(ARMSIM_PLAYER) --rom=$(DUMBOOT) --sd=$(LAB07_DIR)/disk.img $(DEBUG) # then run the simulator
$(LAB07_DIR)/disk.img: $(LAB07_DIR)/lab07.elf
	$(MKSD) --so $(OS) --user $^ && mv disk.img $(LAB07_DIR)
$(LAB07_DIR)/lab07.elf: $(LAB07_DIR)/lab07.o $(LAB07_DIR)/syscalls.o $(LAB07_DIR)/api_robot.o
	$(ARM_CC)ld -o $@ -g -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR) $^
	$(ARM_CC)objdump -D $(LAB07_DIR)/lab07.elf > $(LAB07_DIR)/lab07.objdump
$(LAB07_DIR)/lab07.o: $(LAB07_DIR)/main.c
	$(ARM_CC)gcc -o $@ -g -Wall -c $^
$(LAB07_DIR)/syscalls.o: $(LAB07_DIR)/syscalls.s
	$(ARM_CC)as -o $@ -g $^
$(LAB07_DIR)/api_robot.o: $(LAB07_DIR)/api_robot.s
	$(ARM_CC)as -o $@ -g $^


clean:
	for i in $LAB_DIRS; do rm $$i/disk.img $$i/*.o $$i/*.elf $$i/*.objdump; done

