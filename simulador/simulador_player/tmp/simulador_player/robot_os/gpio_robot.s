@ -----[ gpio.s ]----------------------------------------------------------@
@                                                                          @
@         i.MX53 SoC GPIO based IO library                                 @
@                                                                          @
@ -------------------------------------------------------------------------@
@ --[ Includes ]-----------------------------------------------------------@
@
	.include "gpio_defs.inc"

@ --[ Global data ]--------------------------------------------------------@
@
	.data
	.align 4

@ --[ Module initialization ]----------------------------------------------@
@
@   Executed at boot time
	.text
	.align 4
	.globl configure_gpio
@ Configures GPIO
configure_gpio:

	@ do something
	ldr r0, =0xFFFC003E  
	ldr r1, =GPIO_BASE

	str r0, [r1, #GPIO_DIR]

	mov r0, #0
  str r0, [r1, #GPIO_DR]
	str r0, [r1, #GPIO_ICR1]
	str r0, [r1, #GPIO_ICR2]
	str r0, [r1, #GPIO_IMR]
	str r0, [r1, #GPIO_ISR]
	str r0, [r1, #GPIO_EDGE_SEL]

	mov pc, lr


@ --------------------------------------------------------------------------------
@ Expects:
@  'r0' input register: number of sonar ray to read
@  'r0' output register: read value
@ --------------------------------------------------------------------------------
.globl read_sonar

read_sonar:
  stmfd sp!, {r4-r11,lr}
        
@@@@@@@@@@@ RESET TRIGGER AND SET MUX @@@@@@@@@@@@@@@@@
        
  ldr r1, =GPIO_BASE
  ldr r2, [r1, #GPIO_DR]

  @ set trigger and select ray
  mov r3, #0x1F      
  mov r3, r3, LSL #1 @ mask
  and r4, r3, r0, LSL #2 @ limited mux
  mvn r5, r3 @ mask to clean bits
  and r2, r2, r5 @ do cleaning 
  orr r2, r2, r4 
      
  str r2, [r1, #GPIO_DR]
  
  @ wait
  ldr r3, DELAY
_loop_wait_1:
  subs r3, r3, #1
  bne _loop_wait_1

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        
  @ set trigger
  eor r2, r2, #2
  str r2, [r1, #GPIO_DR]

  @ wait
  ldr r3, DELAY
_loop_wait_2:
  subs r3, r3, #1
  bne _loop_wait_2

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        
  @ unset trigger
  eor r2, r2, #2
  str r2, [r1, #GPIO_DR]

  @ wait
  ldr r3, DELAY
_loop_wait_3:
  subs r3, r3, #1
  bne _loop_wait_3


        
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
  @ pooling for ready-bit
_loop_pooling:
  ldr r2, [r1, #GPIO_DR]        
  tst r2, #0x1
  bne _end
        
  @ wait
  ldr r3, DELAY
_loop_wait_4:
  subs r3, r3, #1
  bne _loop_wait_4        
        
  b _loop_pooling 

_end:      
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
  @ prepare output
  ldr r0, =0xFFF
  and r0, r0, r2, LSR #6 
    
  ldmfd sp!, {r4-r11,pc}

@ --------------------------------------------------------------------------------	
@ Expects:
@  'r0' input: speed value
@ --------------------------------------------------------------------------------
  .globl write_motor1  
write_motor1:
  stmfd sp!, {r4-r11,lr}

  ldr r1, =GPIO_BASE
  
  mov r2, #0x3F
  lsl r2, r2, #19
  and r3, r2, r0, LSL #19
  mvn r2, r2         
        
  ldr r0, [r1, #GPIO_DR]
  and r0, r0, r2      
  orr r0, r0, r3
    
  str r0, [r1, #GPIO_DR]
  
  ldmfd sp!, {r4-r11,pc}

@ --------------------------------------------------------------------------------	
@ Expects:
@  'r0' input: speed value
@ --------------------------------------------------------------------------------
  .globl write_motor2
write_motor2:
stmfd sp!, {r4-r11,lr}

  ldr r1, =GPIO_BASE
  
  mov r2, #0x3F
  lsl r2, r2, #26
  and r3, r2, r0, LSL #26
  mvn r2, r2         
        
  ldr r0, [r1, #GPIO_DR]
  and r0, r0, r2      
  orr r0, r0, r3
    
  str r0, [r1, #GPIO_DR]
  
  ldmfd sp!, {r4-r11,pc}




@ --------------------------------------------------------------------------------	
@ Expects:
@  'r0' and 'r1' inputs: speed motor0 and motor1
@ --------------------------------------------------------------------------------
  .globl write_motors
write_motors:
stmfd sp!, {r4-r11,lr}

  ldr r2, =GPIO_BASE


        
  mov r3, #0x3F
  mov r4, r3, LSL #19
  orr r4, r4, r3, LSL #26
  mvn r4, r4     @ cleaning mask      
  and r0, r0, r3 @ limited speed 0
  and r1, r1, r3 @ limited speed 1
  mov r3, r0, LSL #19
  orr r3, r3, r1, LSL #26
               
  ldr r0, [r2, #GPIO_DR]
  and r0, r0, r4      
  orr r0, r0, r3
    
  str r0, [r2, #GPIO_DR]
  
  ldmfd sp!, {r4-r11,pc}

        
DELAY:
    .word 5000
