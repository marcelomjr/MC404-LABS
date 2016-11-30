.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:

    ldr r1, = maior
    ldr r1, [r1]    @ r1 = 0x7fffffff

    mov r2, #1      @ r2 = 1

    adds r4, r1, #1 @ r4 = r1 + r2

    mov r3, #0

    adc r8, r3, #0  @ Nao houve overflow, carry = 0

    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da


	
    ldr r0, =menor
    ldr r0, [r0]

    svc 0x0         


.data               @ seção de dados
maior:       .word 0x7fffffff
menor:       .word 0x80000000