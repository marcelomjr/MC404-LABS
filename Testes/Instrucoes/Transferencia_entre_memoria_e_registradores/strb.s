.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	ldr r1, = x
	mov r0, #123
	mov r2, #4
	mul r0, r0, r2	@ r0 = r0 *r2 =492
	strb r0, [r1]	@ porem nao cabe 492 em um byte, ou seja, apenas os 
					@ 8 bits menos significativos sao armazenados = 236
					@ pois ARM eh Little Endian
fim:
    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               @ seção de dados
x:	.word 0x0