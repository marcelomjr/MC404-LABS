monta_programa:
	arm-eabi-as modelo.s -o objeto.o

liga_objetos: monta_programa
	arm-eabi-ld objeto.o -o executavel.exe -Ttext=0x77802000 -Tdata=0x77802050

cria_imagem: liga_objetos
	mksd.sh --so /home/specg12-1/mc404/simulador/dummyos.elf --user executavel.exe

simulacao: cria_imagem
	rm -rf *.o
	arm-sim --rom=/home/specg12-1/mc404/simulador/dumboot.bin --sd=disk.img





