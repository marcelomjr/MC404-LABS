@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Codigo de teste para o controle de um robo via Player/Stage.
@ Todo o controle eh baseada em duas syscalls.
@    write_motors: Syscall numero 124
@          Parametros:
@                      r0: velocidade do motor[0] (apenas os 6 bits menos 
@                                          significativos serao considerados)
@                      r1: velocidade do motor[1] (apenas os 6 bits menos 
@                                          significativos serao considerados)
@ --------------------------
@ 
@    read_sonar: Syscall numero 125
@          Parametros:
@                      r0: ID do sonar (valor de 4 bits)
@
@          Retorno:
@                      r0: Valor de 12 bits proporcional a distancia lida.
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       
.text
        .align 4
        .globl _start

_start:
        
main:
        @ comeca a andar reto
        mov r0, #25           @ velocidade do motor[0] = 15
        mov r1, #25           @ velocidade do motor[1] = 15
        mov r7, #124          @ ID syscall write_motors
        svc 0x0               @ chama syscall identificada em r7


loop:           
        mov r0, #4            @ Sonar de ID 4
        mov r7, #123          @ ID syscall read_sonar
        svc 0x0               @ faz a leitura desse sonar
        mov r1, r0            @ armazena o retorno em r1  
  
        mov r0, #3            @ Sonar de ID 3
        mov r7, #123
        svc 0x0

        cmp r0, r1            @ compara a leitura dos 2 sonares frontais
        blt min               @ se r0 < r1: salta para "min"
        mov r0, r1            @ senao: r0 = r1

min:
        ldr r1, =1600         @ r1 = 1600 (limiar para evitar colisao frontal)
        cmp r0, r1            @ compara a menor leitura com o limiar 
        bgt loop              @ se ainda é maior salta para "loop"
                              @ senao

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        @ comeca a virar o robo
        mov r0, #0            @ velocidade do motor[0] = 0
        mov r1, #3            @ velocidade do motor[1] = 3
        mov r7, #124          @ syscall write_motors
        svc 0x0              
  
loop2:
        mov r0, #4            @ Sonar de ID 4
        mov r7, #123          @ ID syscall read_sonar
        svc 0x0               
        mov r1, r0            @ armazena o retorno em r1  
  
        mov r0, #3            @ Sonar de ID 3
        mov r7, #123
        svc 0x0

        cmp r0, r1            @ compara os valores dos sonares
        blt min2
        mov r0, r1

min2:

        ldr r1, =2200         @ limiar para voltar a andar reto
        cmp r0, r1            @ compara a menor leitura com r1
        blt loop2             @ se ainda eh menor: continua virando
                              @ senao:  
        mov r0, #0            @ motor[0] = 0
        mov r1, #0            @ motor[1] = 0  
        mov r7, #124          @ write_motors (parar o robo)
        svc 0x0

        b main               @ reinicia a  logica

        

