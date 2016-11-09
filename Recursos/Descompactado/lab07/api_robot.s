@ implementation of the
@
@ void set_speed_motor(unsigned char speed, unsigned char id);
@ void set_speed_motors(unsigned char spd_m0, unsigned char spd_m1);
@ unsigned short read_sonar(unsigned char sonar_id);
@ void read_sonars(unsigned int *distances);
@
@ functions declared in api_robot.h
@
@ dependencies:
@ syscall #124: write_motors(r0 -> motor 0, r1 -> motor 1)
@ syscall #125: read_sonar(r0 -> sonar)
@ syscall #126: write_motor0(r0 -> motor 0) (one on the right)
@ syscall #127: write_motor1(r0 -> motor 1) (one on the left)
@
@ sonars are indexed from 0 to 15.
@ the sonar value returned ranges from 0 to 4095
@ motor values range from 0 to 63

.text

.globl read_sonar
.globl read_sonars
.globl set_speed_motor
.globl set_speed_motors

.macro write fd msg size
	mov r0, #\fd
	ldr r1, =\msg
	mov r2, #\size
	mov r7, #4 @ write syscall
	svc 0x0
.endm

.macro exit_fatal_error exit_code
	mov r0, #\exit_code
	mov r7, #1 @ exit syscall
	svc 0x0


set_speed_motor:
	push {r7, lr}
	cmp r1, #1 @ if (unsigned) motor_id > 1,
	bhi error_invalid_motor_id @ then abort
	cmp r0, # 63 @ if (unsigned) motor_speed > 63
	bhi error_invalid_motor_speed @ then abort
	add r7, r1, #126 @ call write_motor0 or write_motor1 depending on the id passed
	svc 0x0
	pop {r7, pc}

set_speed_motors:
	push {r7, lr}
	cmp r0, # 63 @ if (unsigned) motor_speed > 63
	bhi error_invalid_motor_speed @ then abort
	cmp r1, # 63 @ if (unsigned) motor_speed > 63
	bhi error_invalid_motor_speed @ then abort
	mov r7, #124 @ call write_motors
	svc 0x0
	pop {r7, pc}

read_sonar:
	push {r7, lr}
	cmp r0, #15 @ if sonar_id > (unsigned) 15
	bhi error_invalid_sonar_id @ then abort
	mov r7, #125 @ call read_sonar
	svc 0x0
	pop {r7, pc} @ returning the 12 bit sonar reading

read_sonars:
	push {r4, r5, lr}
	mov r4, #0 @ i = 0
	mov r5, r0 @ addr = distances_array
read_sonars_loop:
	cmp r4, #16 @ while i < 16, read values from the array and call read_sonar
	beq finished_read_sonars_loop
	ldr r0, [r5, r4, lsl #2] @ sonar_id = distances[i]
	bl read_sonar
	str r0, [r5, r4, lsl #2] @ distances[i] = sonar_value
	add r5, #1 @ i++
	b read_sonars_loop
finished_read_sonars_loop:
	pop {r4, r5, pc}


error_invalid_motor_speed:
	write 1, error_invalid_motor_speed_msg, (error_invalid_motor_speed_msg_end-error_invalid_motor_speed_msg)
	exit_fatal_error -1

error_invalid_motor_id:
	write 1, invalid_motor_id_msg, (invalid_motor_id_msg_end-invalid_motor_id_msg)
	exit_fatal_error -1

error_invalid_sonar_id:
	write 1, invalid_sonar_id_msg, (invalid_sonar_id_msg_end-invalid_sonar_id_msg)
	exit_fatal_error -1



.data

invalid_motor_id_msg: .ascii "motor id must be either zero (right motor) or 1 (left motor)\n"
invalid_motor_id_msg_end:
.align 4
invalid_sonar_id_msg: .ascii "sonar id must be in the range from zero to 15\n"
invalid_sonar_id_msg_end:
.align 4
error_invalid_motor_speed_msg: .ascii "motor speed must in the range from zero to 63\n"
error_invalid_motor_speed_msg_end:






