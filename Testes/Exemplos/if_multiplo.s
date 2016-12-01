.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	ldr r1, = x
	ldr r1, [r1]	@ x esta em r1

	ldr r2, = y
	ldr r2, [r2]	@ y esta em r2
if:
	cmp r1, #10		
	blt fim_if		@ salta o if se x eh menor do que 10
	cmp r2, #20
	bge fim_if		@ salta o if se y eh maior ou igual a 20
	mov r1, r2
fim_if:
		
		
@ Fim do programa
fim:
    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               @ seção de dados
x: .word 0x00000100
y: .word 0x00000001
