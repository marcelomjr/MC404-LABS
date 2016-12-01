.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	mov r0, #0b101
	mov r1, #0xff
	bl funcao
	mov r0, #0x40

funcao:
	mov r0, #1
	mov r1, #1
	mov r2, #1
	mov pc, lr
		
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	
    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               @ seção de dados
numero: .word 0x80000000
