ASSEMBLER = arm-eabi-as
LINKER = arm-eabi-ld
MKSD = mksd.sh --so
DUMBOOT = /home/specg12-1/mc404/simulador/dumboot.bin # /home/mc404/usr/bin/dumboot.bin (VM)
OS = /home/specg12-1/mc404/simulador/dummyos.elf # /home/mc404/simuladorfromspecg/simulador/dummyos.elf (VM)
ARMSIMULATOR = arm-sim # ${ARMSIM} (VM)

TEXTADDR = 0x77802000 # OS will load user application code at this address
DATAADDR = 0x77802800 # various data item

monta_programa:
	$(ASSEMBLER) lab04.s -o object.o

liga_objetos: monta_programa
	$(LINKER) object.o -o executable.x -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR)

cria_imagem: liga_objetos
	$(MKSD) $(OS) --user executable.x

clean:
	rm -rf *.o
	rm -rf *.x

simulacao: cria_imagem
	$(ARMSIMULATOR) --rom=$(DUMBOOT) --sd=disk.img

simulacao_gdb:
	$(ASSEMBLER) lab04.s -g -o object.o
	$(LINKER) object.o -g -o executable.x -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR)
	$(MKSD) $(OS) --user executable.x
	$(ARMSIMULATOR) --rom=$(DUMBOOT) --sd=disk.img -g

roda_gdb:
	arm-eabi-gdb executable.x
