.text

.globl syscall_write
@ r0 -> file descriptor, r1 -> buffer_addr, r2 -> buffer_byte_length
@ return: bytes read -> r0
syscall_write: @ syscall wrapper for 'write'
	push {r7, lr}
	mov r7, #4 @ syscall number for write
	svc 0x0 @ forwards arguments that were passed in
	pop {r7, pc} @ returns number of bytes written