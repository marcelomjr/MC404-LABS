.org 0x0
.section .iv,"a"

_start:		

interrupt_vector:
	@ 0x0
    b RESET_HANDLER
    
.org 0x18    
    @ 0x18
    b IRQ_HANDLER
    
.org 0x100
.text
RESET_HANDLER:

    @Set interrupt table base address on coprocessor 15.
    ldr r0, =interrupt_vector
    mcr p15, 0, r0, c12, c0, 0
    
    @ Configuracao do GPT
    
    @ GPT Control Register (GPT_CR)
    ldr r0, = 0x00000041
    ldr r1, = 0x53FA0000		@ Endereco do GPT_CR (control register)
    str r0, [r1]				@ Habilita o GPT e configura o clock_src para periferico
    
    @ GPT Prescaler Register (GPT_PR)
    mov r0, #0
    ldr r1, = 0x53FA0004		@ Endereco do GPT_PR
    str r0, [r1]				@ Zera o prescaler (GPT_PR)
    
    @ GPT Output Compare Register 1 (GPT_OCR1)
    mov r0, #100
    ldr r1, = 0x53FA0010		@ Endereco de (GPT_OCR1)
    str r0, [r1]				@ Registra o valor a ser contado
    
    @ GPT Interrupt Register (GPT_IR)
    mov r0, #1
    ldr r1, = 0x53FA000C		@ Endereco de GPT_IR
    str r0, [r1]				@ Habilita a interrupção Output Compare Channel 1, que se inicia desligada.
    
   @ Configuração do TZIC (TrustZone Interrupt Controller)
SET_TZIC:
	@ Constantes para os enderecos do TZIC
	.set TZIC_BASE,             0x0FFFC000
	.set TZIC_INTCTRL,          0x0
	.set TZIC_INTSEC1,          0x84 
	.set TZIC_ENSET1,           0x104
	.set TZIC_PRIOMASK,         0xC
	.set TZIC_PRIORITY9,        0x424

	@ Liga o controlador de interrupcoes
	@ R1 <= TZIC_BASE

	ldr	r1, =TZIC_BASE

	@ Configura interrupcao 39 do GPT como nao segura
	mov	r0, #(1 << 7)
	str	r0, [r1, #TZIC_INTSEC1]

	@ Habilita interrupcao 39 (GPT)
	@ reg1 bit 7 (gpt)

	mov	r0, #(1 << 7)
	str	r0, [r1, #TZIC_ENSET1]

	@ Configure interrupt39 priority as 1
	@ reg9, byte 3

	ldr r0, [r1, #TZIC_PRIORITY9]
	bic r0, r0, #0xFF000000
	mov r2, #1
	orr r0, r0, r2, lsl #24
	str r0, [r1, #TZIC_PRIORITY9]

	@ Configure PRIOMASK as 0
	eor r0, r0, r0
	str r0, [r1, #TZIC_PRIOMASK]

	@ Habilita o controlador de interrupcoes
	mov	r0, #1
	str	r0, [r1, #TZIC_INTCTRL]

	@instrucao msr - habilita interrupcoes
	msr  CPSR_c, #0x13       @ SUPERVISOR mode, IRQ/FIQ enabled
	
	@ Após habilitar o TZIC, a interrupção pode ser gerada a qualquer momento 

	@ Habilitacao das interrupções no ARM
	msr  CPSR_c,  #0x13   @ SUPERVISOR mode, IRQ/FIQ enabled
	
    @ Zera o contador
    ldr r2, =CONTADOR  @lembre-se de declarar esse contador em uma secao de dados! 
    mov r0,#0
    str r0,[r2]
	
	@ Laco infinito
loop:
	b loop
	
IRQ_HANDLER:

	@ Informa ao GPT que o processador já está ciente de que ocorreu
	@  a interrupção, e ele pode limpar a flag OF1
	mov r0, #1
	ldr r1, = 0x53FA0008
	str r0, [r1]
	
	@ Incrementa o contador de interrupcoes
	ldr r1, = CONTADOR
	ldr r0, [r1]
	add r0, r0, #1
	str r0, [r1]
	
	@ Retorno da interrupcao
	sub lr, lr, #4		@ Correcao de lr para PC + 4	
	movs pc, lr
	
@ Outros tratadores de iterrupcoes
UNDEFINED_INSTRUCTION_HANDLER:
SOFTWARE_INTERRUPTION_HANDLER:
ABORT_INSTRUCTION_HANDLER:
ABORT_DATA_HANDLER:
FIQ_HANDLER:

@ secao de dados
.data
CONTADOR: .skip 4

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	
