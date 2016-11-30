.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	mov r0, #10		@ r1 = 10
	mvn r1, #10		@ r1 = -11
	@ r1 = (00000000000000000000000000001010)' = (11111111111111111111111111110101) = -((00000000000000000000000000001010) + 1) = -11

	mov r2, r0		@ r2 = 10
	mvn r3, r0		@ r1 = -11

    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da

    svc 0x0         


.data               @ seção de dados
numero: .word 0x80000000
