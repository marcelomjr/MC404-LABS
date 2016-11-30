.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
    ldr r0, =x
    ldr r0, [r0]

    ldr r1, = mascara @ Carrega o endereço da variavel mascara
    ldr r1, [r1] 	  @ Carrega em r1 o conteudo do endreco que esta em r1

    bic r3, r0, r1

    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da
	            @ syscall exit
    svc 0x0         


.data               @ seção de dados
mascara: .word 0xff000000
x:       .word 0x7bcdeabc