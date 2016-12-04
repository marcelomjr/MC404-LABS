	@ Global symbol
    .global set_speed_motor
    .global set_speed_motors

	.align 4

@ set_speed_motor sets motor speed. 
@ Parameters:
@ 	r0: speed (unsigned char) (Only the last 6 bits are used)
@	r1: id (unsigned char) (0 for right motor, 1 for left motor)
set_speed_motor:
	stmfd sp!, {r4-r11, lr}
	porra:
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
	mov r5, r1	
	mov r1, #0	@ argumento em r1, a velocidade ja esta em r0
	
	bl set_speed_motor
	
	mov r0, r5
	mov r1, #1
	
	bl set_speed_motor
	
	ldmfd sp!, {r4-r11, pc}
	
