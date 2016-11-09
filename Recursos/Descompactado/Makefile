
DUMBOOT = /home/giuliano/mc404/borin/arm/armv7simulatorplatform/dumboot/dumboot.bin
OS = /home/giuliano/mc404/borin/arm/armv7simulatorplatform/dummyos/knrl
PLAYER_WORLDS = /home/giuliano/mc404/borin/arm/stage/Stage/worlds

ARMSIM = /home/giuliano/mc404/borin/arm/armv7simulatorplatform/armv7/ARMV7_INSTALL/bin/armsim
ARMSIM_PLAYER = /home/giuliano/mc404/borin/arm/armv7simulatorplatform/armv7/ARMV7_INSTALL/bin/armsim
MKSD = /home/giuliano/mc404/borin/arm/armv7simulatorplatform/armv7/ARMV7_INSTALL/libexec/mksd.sh


TEXTADDR = 0x77802000
DATAADDR = 0x77802400
ARM_CC = arm-none-eabi-

LAB04_DIR = lab04
LAB05_DIR = lab05
LAB06_DIR = lab06

LAB_DIRS = $(LAB04_DIR) $(LAB05_DIR) $(LAB06_DIR)
# DEBUG=--gdb --gdb-port=5000

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


clean:
	for i in $(LAB_DIRS); do rm $$i/disk.img $$i/*.o $$i/*.elf $$i/*.objdump; done

