.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	ldr r0, =numero
	ldr r0, [r0]	@ r0 = 0x80000000


    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da

    svc 0x0         


.data               @ seção de dados
numero: .word 0x80000000
