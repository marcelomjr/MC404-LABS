	@ Global symbol
    .global set_speed_motor

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
	b fim_set_motor

motor0:
	mov r7, #126
p0:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2
	svc 0x0
p0d:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2
	b fim_set_motor

motor1:
	mov r7, #127
p1:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2	
	svc 0x0
p1d:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2
	b fim_set_motor

fim_set_motor:
	ldmfd sp!, {r4-r11, lr}