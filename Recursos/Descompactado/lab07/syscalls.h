/* additional syscall wrapper functions */

#ifndef SYSCALLS_H
#define SYSCALLS_H

/*
 * executes a 'write' system call
 * Parameters:
 *   1. file descriptor where buffer will be written
 *   2. buffer to be written
 *   3. number of bytes to be written
 * Returns:
 *   number of bytes actually written (-1 in the event of an error)
 */
int syscall_write(int file_descriptor, void *buffer, int numbytes);

#endif // SYSCALLS_H