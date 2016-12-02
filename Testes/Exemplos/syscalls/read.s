.globl _start

.data

input_buffer:   .skip 32
output_buffer:  .skip 32
    
.text
.align 4

@ Funcao inicial
_start:
    mov r0, #0              @ stdin file descriptor = 0
    ldr r1, = input_buffer  @ endereco do buffer
    mov r2, #5              @ tamanho maximo.
    mov r7, #3              @ read
    svc 0x0
    @ Sendo (&input_buffer = 0x77802800)
    @ Se digitarmos: "1234\n" no terminal, sera armazenado:
    @ 0x77802800 = '1'
    @ 0x77802801 = '2'
    @ 0x77802802 = '3'
    @ 0x77802803 = '4'
    @ 0x77802804 = '\n'

    @ Para ver isso no gdb utilize:  p * (char*) 0x7780280?
    
    fim:
    mov r7, #1          @ carrega o valor 1 em r7, indicando a escolha da  
    svc 0x0         