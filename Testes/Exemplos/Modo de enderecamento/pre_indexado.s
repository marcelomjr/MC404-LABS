.text               @ seção de código
    .align 4        @ alinha ponto de montagem em endereços múltiplos de 4
    .globl _start   @ torna o símbolo main visivel fora do arquivo

_start:
	ldr r0, = string
	mov r1, #0x65		@ r1 = 'e'
	mov r3, #0			@ indice do vetor

while:
	ldrb r2, [r0,r3]	@ r2 = vetor[indice]
	cmp r2, #0b0		@ Verifica se o caractere atual eh um zero
	beq nao_achou		@ Se chegou ao fim da string e nao achou, saia do loop
	cmp r2, r1			@ Verifica se o caractere carregado em r2 eh o mesmo que o procurado
	beq achou 			@ Se achou sai do loop
	add r3, r3, #1		@ Atualiza o indice
	b while				@ Salta para o inicio do loop

achou:
	add r0, r0, r3		@ Move o endereco do caractere encontrado para r0 
	b fim

nao_achou:
	mov r0, #0x0		@ Nao achou retorna zero
	b fim

fim:
    mov r7, #1      	@ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         

.data               	@ seção de dados
string: .asciz "teste"