.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	mov r0, #1
	mov r1, #2
	mov r2, #4
	mov r5, #32

	stmdb sp!, {r0,r5,r2,r1}	@ Carrega na memoria na ordem do registrador de 
								@ menor indice com o menor endereco e vice-versa

	ldmia sp!, {r6,r9,r7,r8}	@ Carrega nos registradores na ordem do menor indice com 
								@ o menor endereco de memoria, e vice-versa

	

fim:
    mov r7, #1      	@ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               	@ seção de dados
string: 
	.word 0x1
	.word 0x2
	.word 0x3
	.word 0x4
	.word 0x5
	.word 0x6