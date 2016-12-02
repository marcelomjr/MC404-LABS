.globl _start

.data

input_buffer:       .skip 32
output_buffer:      .skip 32
entrada_codificada: .skip 8
saida_decodificada: .skip 5
erro:               .skip 2
    
.text
.align 4

@ Funcao inicial
_start:
    @@@@@@@@@@@@@@@@@@@Leitura da entrada padrao @@@@@@@@@@@@@@@@@@@@@
    @ Chama a funcao "read" para ler 4 caracteres da entrada padrao
    ldr r0, =input_buffer
    mov r1, #5              @ 4 caracteres + '\n'
    bl  read

    @ Chama a funcao "read" para ler 7 caracteres de um codigo de hamming(7,4)
    ldr r0, =entrada_codificada
    mov r1, #8              @ 7 caracteres + '\n'
    bl  read

    @@@@@@@@@@@@@@@@@@@@@@@@@@Codificacao @@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Chama a funcao "atoi" para converter a string para um numero
    ldr r0, =input_buffer
    mov r1, #4
    bl  atoi

    @ Chama a funcao "encode" para codificar o valor de r0 usando
    @ o codigo de hamming.
    bl  encode
	
    @ Chama a funcao "itoa" para converter o valor codificado
    @ para uma sequencia de caracteres '0's e '1's
    mov r2, r0
    ldr r0, =output_buffer
    mov r1, #7
    bl  itoa

    @ Adiciona o caractere '\n' ao final da sequencia (byte 7)
    ldr r0, =output_buffer
    mov r1, #'\n'
    strb r1, [r0, #7]

    @ Chama a funcao write para escrever os 7 caracteres e
    @ o '\n' na saida padrao.
    ldr r0, =output_buffer
    mov r1, #8         @ 7 caracteres + '\n'
    bl  write

    @@@@@@@@@@@@@@@@@@@@@@@@@@ Decodificacao @@@@@@@@@@@@@@@@@@@@@@@@@@
    @ Chama a funcao "atoi" para converter a string para um numero
    ldr r0, =entrada_codificada
    mov r1, #7
    bl  atoi

    @ Chamada da funcao decode
    @ Para recuperar o dados de 4 bits
    bl decode
    mov r10, r1
    
    @ Chama a funcao "itoa" para converter o valor codificado
    @ para uma sequencia de caracteres '0's e '1's
    mov r2, r0
    mov r1, #4
    ldr r0, =saida_decodificada
    bl  itoa

    @ Adiciona o caractere '\n' ao final da sequencia (byte 4)
    ldr r0, =saida_decodificada
    mov r1, #'\n'
    strb r1, [r0, #4]

    @ Chama a funcao write para escrever os 4 caracteres e
    @ o '\n' na saida padrao.
    ldr r0, =saida_decodificada
    mov r1, #5         @ 4 caracteres + '\n'
    bl  write

    @ Erro
    ldr r0, = erro
    cmp r10, #0
    moveq r10, #'0'
    movne r10, #'1'
    strb r10, [r0]
    mov r1, #'\n'
    strb r1, [r0, #1]
    mov r1, #2
    bl write

    b _start @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2
    @ Chama a funcao exit para finalizar processo.
    mov r0, #0
    bl  exit

@ Codifica o valor de entrada usando o codigo de hamming.
@ parametros:
@  r0: valor de entrada (4 bits menos significativos)
@ retorno:
@  r0: valor codificado (7 bits como especificado no enunciado).
encode:    
    push {r4-r11, lr}@ Salva o estado dos registradores
    mov r6, #0      @ Registrador para armazenar o resultado codificado

    @ Determina o p1
    push {r0-r3}
    mov r1, #0b1101  @ Mascara para o p1(d1, d2, d4)
    bl conta_bits    @ conta numero de bits, resultado sera colocado em r0
    and r5, r0, #1   @ p1 sera zero se o numero de bits for par e um ser for impar, 
                     @ ou seja, basta olhar para o bit menos significativo
    cmp r5, #1
    addeq r6, r6, #0b1000000  @ Bit relativo ao p1
    pop {r0-r3}

    @ Determina o p2
    push {r0-r3}
    mov r1, #0b1011  @ Mascara para o p2(d1, d3, d4)
    bl conta_bits    @ conta numero de bits
    and r5, r0, #1  @ p2 sera zero se o numero de bits for par e um ser for impar
    cmp r5, #1
    addeq r6, r6, #0b100000  @ Bit relativo ao p2
    pop {r0-r3}

    @ Determina o p3
    push {r0-r3}
    mov r1, #0b0111  @ Mascara para o p3(d2, d3, d4)
    bl conta_bits    @ conta numero de bits
    and r5, r0, #1   @ p3 sera zero se o numero de bits for par e um ser for impar
    cmp r5, #1
    addeq r6, r6, #0b1000  @ Bit relativo ao p3
    pop {r0-r3}

    @ Insercao do d1 do valor codificado
    and r7, r0, #0b1000
    cmp r7, #0b1000
    addeq r6, r6, #0b10000

    @ Insercao de d2, d3 e d4 ao valor codificado
    and r7, r0, #0b111
    add r6, r6, r7

    mov r0, r6      @ Move o valor codificado para o r0 para ser retornado.

    pop  {r4-r11, lr}
    mov  pc, lr

@ Decodifica o valor de entrada usando o codigo de hamming.
@ parametros:
@  r0: valor de entrada (7 bits menos significativos)
@ retorno:
@  r0: valor decodificado (4 bits como especificado no enunciado).
@  r1: 1 se houve erro e 0 se nao houve.
decode:    
    push {r4-r11, lr}
    mov r4, #0       @ o bits decodificados ficarao aqui
    mov r7, #0       @ Indica o numero de erros
    and r5, r0, #0b111   @ Seleciona os bits d2, d3 e d4
    add r4, r4, r5
    mov r5, r0, lsr #1   @ Desloca o codigo para a direita para facilitar a obtencao de d1
    and r5, r5, #1000
    add r4, r4, r5

    @ verificacao de p1
    mov r5, r0, lsr #6
    and r5, r5, #1   @ r5 armazena o bit que representa p1
    push {r0-r3}
    mov r0, r4
    mov r1, #0b1101  @ Mascara para o p1(d1, d2, d4)
    bl conta_bits    @ conta numero de bits, resultado sera colocado em r0
    mov r6, r0       @ Numero de bits relativos a p1
    pop {r0-r3}
    and r6, r6, #1 
    cmp r5, r6
    addne r7, r7, #1 @ Identifica erros

    @ verificacao de p2
    mov r5, r0, lsr #5
    and r5, r5, #1   @ r5 armazena o bit que representa p2
    push {r0-r3}
    mov r0, r4
    mov r1, #0b1011  @ Mascara para o p2(d1, d3, d4)
    bl conta_bits    @ conta numero de bits, resultado sera colocado em r0
    mov r6, r0       @ Numero de bits relativos a p2
    pop {r0-r3}
    and r6, r6, #1 
    cmp r5, r6
    addne r7, r7, #1 @ Identifica erros

    @ verificacao de p3
    mov r5, r0, lsr #3
    and r5, r5, #1   @ r5 armazena o bit que representa p3
    push {r0-r3}
    mov r0, r4
    mov r1, #0b0111  @ Mascara para o p3(d2, d3, d4)
    bl conta_bits    @ conta numero de bits, resultado sera colocado em r0
    mov r6, r0       @ Numero de bits relativos a p3
    pop {r0-r3}
    and r6, r6, #1 
    cmp r5, r6
    addne r7, r7, #1 @ Identifica erros

    mov r0, r4       @ retorno do dado decodificado
    mov r1, #0
    cmp r7, #0
    movne r1, #1    @ Retorno do erro, zero para inexistente e um para existente

    pop  {r4-r11, lr}
    mov  pc, lr

@ Le uma sequencia de bytes da entrada padrao.
@ parametros:
@  r0: endereco do buffer de memoria que recebera a sequencia de bytes.
@  r1: numero maximo de bytes que pode ser lido (tamanho do buffer).
@ retorno:
@  r0: numero de bytes lidos.
read:
    push {r4,r5, lr}
    mov r4, r0
    mov r5, r1
    mov r0, #0         @ stdin file descriptor = 0
    mov r1, r4         @ endereco do buffer
    mov r2, r5         @ tamanho maximo.
    mov r7, #3         @ read
    svc 0x0
    pop {r4, r5, lr}
    mov pc, lr

@ Escreve uma sequencia de bytes na saida padrao.
@ parametros:
@  r0: endereco do buffer de memoria que contem a sequencia de bytes.
@  r1: numero de bytes a serem escritos
write:
    push {r4,r5, lr}
    mov r4, r0
    mov r5, r1
    mov r0, #1         @ stdout file descriptor = 1
    mov r1, r4         @ endereco do buffer
    mov r2, r5         @ tamanho do buffer.
    mov r7, #4         @ write
    svc 0x0
    pop {r4, r5, lr}
    mov pc, lr

@ Finaliza a execucao de um processo.
@  r0: codigo de finalizacao (Zero para finalizacao correta)
exit:    
    mov r7, #1         @ syscall number for exit
    svc 0x0

@ Converte uma sequencia de caracteres '0' e '1' em um numero binario
@ parametros:
@  r0: endereco do buffer de memoria que armazena a sequencia de caracteres.
@  r1: numero de caracteres a ser considerado na conversao
@ retorno:
@  r0: numero binario
atoi:
    push {r4, r5, lr}
    mov r4, r0         @ r4 == endereco do buffer de caracteres
    mov r5, r1         @ r5 == numero de caracteres a ser considerado 
    mov r0, #0         @ number = 0
    mov r1, #0         @ loop indice
atoi_loop:
    cmp r1, r5         @ se indice == tamanho maximo
    beq atoi_end       @ finaliza conversao
    mov r0, r0, lsl #1 
    ldrb r2, [r4, r1]  
    cmp r2, #'0'       @ identifica bit
    orrne r0, r0, #1   
    add r1, r1, #1     @ indice++
    b atoi_loop
atoi_end:
    pop {r4, r5, lr}
    mov pc, lr

@ Converte um numero binario em uma sequencia de caracteres '0' e '1'
@ parametros:
@  r0: endereco do buffer de memoria que recebera a sequencia de caracteres.
@  r1: numero de caracteres a ser considerado na conversao
@  r2: numero binario
itoa:
    push {r4, r5, lr}
    mov r4, r0
itoa_loop:
    sub r1, r1, #1         @ decremento do indice
    cmp r1, #0          @ verifica se ainda ha bits a serem lidos
    blt itoa_end
    and r3, r2, #1
    cmp r3, #0
    moveq r3, #'0'      @ identifica o bit
    movne r3, #'1'
    mov r2, r2, lsr #1  @ prepara o proximo bit
    strb r3, [r4, r1]   @ escreve caractere na memoria
    b itoa_loop
itoa_end:
    pop {r4, r5, lr}
    mov pc, lr

@ Conta o numero de bits setados dentre os 4 bits menos significativos de 
@ uma palavra de memoria de 32 bits de acordo com uma mascara
@ parametros:
@ r0: palavra de memoria
@ r1: mascara
@ retorno:
@ r0: Numero de bits setados
conta_bits:
    push {r4-r11}
    and r4, r0, r1      @ Os bits desnecessarios sao resetados
    mov r5, #0          @ Contador de iteracoes
    mov r6, #0          @ Numero de bits setados
loop:
    cmp r5, #4
    bhs fim_loop
    and r7, r4, #1      @ Limpa todos os bits exceto o menos significativo
    add r6, r6, r7      @ Conta o bit se ele estiver setado
    mov r4, r4, lsr #1  @ Desloca todos os bits para a direita
    add r5, r5, #1      @ incrementa o contador
    b loop
fim_loop:
    mov r0, r6          @ valor de retorno
    pop {r4-r11}
    mov pc, lr



