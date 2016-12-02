.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	ldr r0, = positivo
	ldrb r1, [r0]

	ldr r2, = negativo
	ldrsb r3, [r2]		@ o byte menos significativo de "positivo" 0x83 = -125
						@ Nao importa o sinal de "positivo" e sim o oitavo bit menos significativo.

	
	@strb r0, [r1]	@ porem nao cabe 492 em um byte, ou seja, apenas os 
					@ 8 bits menos significativos sao armazenados = 236
					@ pois ARM eh Little Endian
fim:
    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               @ seção de dados
positivo:	.word 0x81010110
negativo:	.word 0x70101083