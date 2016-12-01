.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	ldr r2, = vetor	@ o endreco do vetor esta em r2
	ldr r3, = TAM
	ldr r3, [r3]	@ o numero de elementos esta em r3

	ldr r0, [r2]	@ r0 recebe o primeiro elemento e o considera como o maior elemento
	mov r1, r2
	mov r4, #1		@ r4 sera uma variavel de controle do indice do vetor

while:				@ Repete enquanto nao se verifica todos os elementos do vetor
	cmp r4, r3
	bhs fim_while	@ Termina o loop se r4 >= TAM
	add r2, r2, #4	@ proximo elemento (indice += 4) ERRO DESSA INSTRUCAO
	ldr r5, [r2]	@ temp = vetor[indice]				PARA ESSA INSTRUCAO

	cmp r5, r2		@ verificacao do maior
	movhi r0, r5	@ Atualiza o maior
	movhi r1, r2	@ Atualiza o endereco do maior

	b while 		@ Volta para o inicio do loop
fim_while:
		
    mov r7, #1      @ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               @ seção de dados

TAM: .word 0X00000005

vetor:
	.word 0x00000100
	.word 0x098008aa
	.word 0x2323faab
	.word 0xf0000000
	.word 0x234faff2
