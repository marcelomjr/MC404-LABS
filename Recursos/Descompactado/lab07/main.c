#include "api_robot.h"
#include "syscalls.h"

void _start(void) {
	const int stdout_fd = 1;
	const int toocloseforcomfort = 2048; // when closer than this, take evasive action
	
	const char tooclosemsg[] = "reached proximity threshold. must taken evasive action\n"
	const char l_evasion_msg[] = "taking evasive manuever to the left\n";
	const char r_evasion_msg[] = "taking evasive manuever to the right\n";
	const char movingforwardmsg[] = "now moving forward\n";

	while (1) { // robot action loop
		if (read_sonar(3) <= toocloseforcomfort || read_sonar(4) <= toocloseforcomfort) {
			syscall_write(stdout_fd, tooclosemsg, sizeof(tooclosemsg));
			if (read_sonar(0)+read_sonar(1)+read_sonar(2)+read_sonar(3) <= 
				read_sonar(4)+read_sonar(5)+read_sonar(6)+read_sonar(7))
			{
				// if average distance on the upper left is less then on the upper right
				syscall_write(stdout_fd, r_evasion_msg, sizeof(r_evasion_msg));
				write_motors(0, 32); // turn right to escape obstacle
			} 
			else
			{
				syscall_write(stdout_fd, l_evasion_msg, sizeof(l_evasion_msg));
				write_motors(32, 0); // turn left to escape obstacle
			}
		} else {
			syscall_write(stdout_fd, movingforwardmsg, sizeof(movingforwardmsg));
			write_motors(32, 32);
		}
	}
}
