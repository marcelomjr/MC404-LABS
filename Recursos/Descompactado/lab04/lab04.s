@ lab04: print a string to the console

.text

.globl _start
.align 4
_start:
	@ call write(stdout, str, strlen(str))
	mov r0, #1 @ stdout === 1
	ldr r1, =str
	mov r2, #(strend-str)
	mov r7, #4 @ id number of write()
	svc 0x0

	@ call exit(0)
	mov r0, #0 @ return value of zero (success)
	mov r7, #1 @ id number of exit()
	svc 0x0

.data

str: .ascii "MC404 - Giuliano Sider - ra146271\n"
strend: .word 0
