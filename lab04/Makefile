seta_variaveis:
	source /home/specg12-1/mc404/simulador/set_path.sh

monta_programa: seta_variaveis
	arm-eabi-as arquivo_de_entrada.s -o arquivo_de_saida.o

liga_objetos: monta_programa:
	arm-eabi-ld arquivo_de_entrada.o -o arquivo_de_saida_do_ligador -Ttext=0x77802000 -Tdata=0x77802050



