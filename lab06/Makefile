monta_programa:
	arm-eabi-as lab06.s -o objeto.o

liga_objetos: monta_programa
	arm-eabi-ld objeto.o -o executavel.exe -Ttext=0x77802000 -Tdata=0x77802800

cria_imagem: liga_objetos
	mksd.sh --so /home/mc404/simuladorfromspecg/simulador/dummyos.elf --user executavel.exe

simulacao: cria_imagem
	rm -rf *.o
	rm -rf *.exe
	${ARMSIM} --rom=/home/mc404/usr/bin/dumboot.bin --sd=disk.img





