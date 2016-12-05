	@ Global symbol
    .global set_speed_motor
    .global set_speed_motors
    .global read_sonar
    .global read_sonars

	.align 4

@ set_speed_motor sets motor speed. 
@ Parameters:
@ 	r0: speed (unsigned char) (Only the last 6 bits are used)
@	r1: id (unsigned char) (0 for right motor, 1 for left motor)
set_speed_motor:
	stmfd sp!, {r4-r11, lr}
	cmp r1, #0
	beq motor0
	
	cmp r1, #1
	beq motor1
	b fim_set_speed_motor 
	
motor0:
	mov r7, #126
	svc 0x0
	b fim_set_speed_motor
	
motor1:
	mov r7, #127
	svc 0x0
	b fim_set_speed_motor
	
fim_set_speed_motor:
	ldmfd sp!, {r4-r11,pc}

@ set_speed_motors
@ Sets both motors speed. 
@ Parameters: 
@ r0: the speed of motor 0 (Only the last 6 bits are used)
@ r1: the speed of motor 1 (Only the last 6 bits are used)
set_speed_motors:
	stmfd sp!, {r4-r11, lr}
	mov r7, #124
	svc 0x0
	ldmfd sp!, {r4-r11, pc}

@ read_sonar
@ Reads one of the sonars.
@ Parameter: 
@ 	r0: the sonar id (ranges from 0 to 15) (unsigned char)
@ Return:
@	r0: the distance as an integer from 0 to (2^12)-1
read_sonar:
	stmfd sp!, {r4-r11, lr}
	mov r7, #125
	svc 0x0
	ldmfd sp!, {r4-r11, pc}

@ read_sonars
@ Reads all sonars at once.
@ Parameter: 
@   sonars: array of 16 unsigned integers. The distances are stored
@   on the array (unsigned int *distances)
read_sonars:
	stmfd sp!, {r4-r11, lr}
	mov r4, r0		@ salva o endereco em r4
	end:
	mov r5, #0		@ r0 representa o numero do sonar

loop_sonar:
	cmp r5, #16
	bhs fim_loop_sonar

	mov r0, r5
	bl read_sonar
	porra:
	str r0, [r4], #4	@ completa campo e incrementa o endereco para a proxima posicao
	add r5, r5,  #1
	b loop_sonar
fim_loop_sonar:
	
	ldmfd sp!, {r4-r11, pc}



