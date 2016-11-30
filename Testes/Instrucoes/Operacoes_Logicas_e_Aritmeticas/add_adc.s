.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	mov r1, #24			
	ldr r0, = x 	@ Carrega o endereco da variavel mascara para r0
	ldr r0, [r0]		

    adds r0, r0, #1	@ Adicao setando as flags

    adc r4, r1, #15		@ adicao com carry (resultado = 40)
    add r3, r1, #15 	@ Adicao sem carry (resultado = 39)
    adc r5, r1, #15		@ Flags permanecem setadas
    adc r6, r1, #15		@ Flags permanecem setadas
    
    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da
	            @ syscall exit
    svc 0x0         


.data               @ seção de dados
x:       .word 0xffffffff