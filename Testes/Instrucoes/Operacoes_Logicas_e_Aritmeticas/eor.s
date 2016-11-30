.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
    ldr r0, =x
    ldr r0, [r0]

    eor r3, r0, # 255 @ Nega os valores dos 8 bits menos significativos.

    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da
	            @ syscall exit
    svc 0x0         


.data               @ seção de dados

x:       .word 0x7bcdeabc