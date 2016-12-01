.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	ldr r1, = x
	ldr r1, [r1]

	ldr r2, = y
	ldr r2, [r2]

	@ agora x esta em r1 e y em r2

	cmp r1, #10		@ compara x com 10
	blt senao		@ se for menor que 10 pula pro senao
	add r2, r2, #1	@ y = y + 1 (se x >= 10)
	b fim 			@ salta para o fim do programa

	senao:
	mov r2, r1		@ caso seja menor copia x para o y

		
@ Fim do programa
fim:
    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               @ seção de dados
x: .word 0x0000000a
y: .word 0x00000100
