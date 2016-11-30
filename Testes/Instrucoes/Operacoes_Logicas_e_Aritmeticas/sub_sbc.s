.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	mov r1, #24			
	ldr r0, = x 	@ Carrega o endereco da variavel mascara para r0
	ldr r0, [r0]		

    subs r0, r0, #1 @ Subtração setando as flags
    sub r2, r1, #10 @ Subratacao normal
    sbc r3, r1, #10 @ Subtracao com carry (Notacao sem sinal)

    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da
	            @ syscall exit
    svc 0x0         


.data               @ seção de dados
x:       .word 0x00000000