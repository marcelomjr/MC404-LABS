.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	ldr r0, = string
	mov r2, #-1

	ldr r2, [r0, #4]	@ Pre-indexado: r2 = vetor[base + deslocamento] 
						@ Soma o deslocamento antes, mas sem atualizar a base

	ldr r2, [r0, #4]!	@ Pre-indexado com Writeback: r2 = vetor[base + deslocamento] 
						@ Soma o deslocamento a base antes e atualiza o valor da base

	ldr r3, [r0], #4	@ Pos-indexado: r2 = vetor[base]; base +=4;
						@ Obtem valor antes e depois atualiza o valor da base
	 atualiza o indice depois da instrucao


fim:
    mov r7, #1      	@ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               	@ seção de dados
string: 
	.word 0x1
	.word 0x2
	.word 0x3
	.word 0x4
	.word 0x5
	.word 0x6