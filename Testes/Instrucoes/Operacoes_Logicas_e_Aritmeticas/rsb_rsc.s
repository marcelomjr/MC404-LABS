.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
    mov r0, #20
    mov r1, #10
    rsbs r1, r0, #10 @ Subtração inversa setando as flags
    rsb r2, r1, #10 @ Subratacao inversa normal
    rsc r3, r1, #10 @ Subtracao inversa com carry

    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da
	            @ syscall exit
    svc 0x0         


.data               @ seção de dados
x:       .word 0x00000000