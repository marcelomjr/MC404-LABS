@ lab06: implement simple collision avoidance for a robot
@ if the frontal sonars report values below some threshold, make it turn left or right depending on the value of the lateral sonars
.text

.globl _start
_start:

.macro write_motor m0 m1 @ motor 0 and motor 1 (right and left, respectively)
	.if \m0 < 0 || \m0 >= 64 || \m1 < 0 || \m1 >= 64
		.error "motor speed must be set to a value between 0 and 63"
	.endif
	mov r0, #\m0
	mov r1, #\m1
	mov r7, #124
	svc 0x0
.endm
.macro read_sonar which @ sonar id: between zero and 15
	.if \which < 0 || \which >= 16
		.error "specified sonar must be between 0 and 15"
	.endif
	mov r0, #\which
	mov r7, #125
	svc 0x0
.endm
.macro write fd msg size
	mov r0, #\fd
	ldr r1, =\msg
	mov r2, #\size
	mov r7, #4
	svc 0x0
.endm


check_proximity:
.equ toocloseforcomfort, 2048 @ sonar distance values go from 0 to 4095
	@ check frontal sonars for proximity:
	read_sonar 3
	cmp r0, #toocloseforcomfort @ if too close for comfort
	ble adjust_course
	read_sonar 4 
	cmp r0, #toocloseforcomfort @ if too close for comfort
	ble adjust_course

	@debug
	write 1, goingforwardmsg, (goingforwardmsgend - goingforwardmsg)

	@ time to move forward:
	write_motor 32, 32

	b check_proximity

adjust_course:
	
	@ debug 
	write 1, adjustcoursemsg, (adjustcoursemsgend - adjustcoursemsg)

	@ take evasive action to the left if (s0+s1+s2+s3)/4 >= (s4+s5+s6+s7)/4,
	@ and to the right otherwise
	@ obtain reading from front-left sonars:
	read_sonar 0
	mov r8, r0
	read_sonar 1
	mov r9, r0
	read_sonar 2
	mov r10, r0
	read_sonar 3
	add r0, r8
	add r0, r9
	add r0, r10
	mov r11, r0 @ tmp <= s0+s1+s2+s3
	@ obtain reading from front-right sonars
	read_sonar 4
	mov r8, r0
	read_sonar 5
	mov r9, r0
	read_sonar 6
	mov r10, r0
	read_sonar 7
	add r0, r8
	add r0, r9
	add r0, r10

	cmp r11, r0 @ if there is more room for manuever to the left
	bge turn_left @ then turn left

	@ turn right:
	write_motor 0, 32

	b check_proximity
turn_left:
	@ turn left:
	write_motor 32, 0
	
	b check_proximity
	
adjustcoursemsg: .ascii "i have to adjust course now\n"
adjustcoursemsgend:
.align 4
goingforwardmsg: .ascii "now i'm going forward\n"
goingforwardmsgend:
.align 4
