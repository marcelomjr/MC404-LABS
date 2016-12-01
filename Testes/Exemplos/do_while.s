.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	
	ldr r2, = y
	ldr r2, [r2]	@ y esta em r2
	
	mov r1, #0		@ i esta em r0 (i = 0)
do:
	add r2, r2, #2	@ y = y + 2
	add r1, r1, #1	@ i = i + 1
	cmp r1, #10		@ while(i<10)
	blt do
		
		
@ Fim do programa
fim:
    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               @ seção de dados
y: .word 0x00000100
