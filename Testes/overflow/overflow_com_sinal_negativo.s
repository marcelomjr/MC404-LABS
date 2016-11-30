.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:

    ldr r1, = numero
    ldr r1, [r1]    @ r1 = 0x800000000

    subs r0, r1, #1 @ r0 = -1

    mov r3, #0

    sbc r8, r3, #0  @ Nao houve overflow , carry = 0

    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da

    svc 0x0         


.data               @ seção de dados
numero: .word 0x80000000
