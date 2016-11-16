DUMBOOT = /home/mc404/usr/bin/dumboot.bin
OS = /home/mc404/simuladorfromspecg/simulador/dummyos.elf
TEXTADDR = 0x77802000 # OS will load user application code at this address
DATAADDR = 0x77802050 # various data item

monta_programa:
	arm-eabi-as lab04.s -o objeto.o

liga_objetos: monta_programa
	arm-eabi-ld objeto.o -o executavel.exe -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR)

cria_imagem: liga_objetos
	mksd.sh --so $(OS) --user executavel.exe

simulacao: cria_imagem
	rm -rf *.o
	rm -rf *.exe
	${ARMSIM} --rom=$(DUMBOOT) --sd=disk.img

simulacao_gdb:
	arm-eabi-as lab04.s -g -o object.o
	arm-eabi-ld object.o -g -o arquivo_de_saida_do_ligador -Ttext=$(TEXTADDR) -Tdata=$(DATAADDR)
	${ARMSIM} --rom=DUMBOOT --sd=disk.img -g

roda_gdb:
	arm-eabi-gdb executavel.exe
