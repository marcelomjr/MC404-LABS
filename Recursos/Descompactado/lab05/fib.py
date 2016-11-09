def fib(n):
	if type(n) is not int:
		raise TypeError("fib accepts an integer argument but you passed a " + str(type(n)))
	if n < 1:
		raise Exception("fib only accepts positive numbers")
	prev = 1
	curr = 1
	for i in range(3, n+1):
		prev, curr = curr, prev + curr
	return curr
#print(fib(int(input("enter a number n to compute the nth fibonacci number\n"))))

print('%10s%10s' % ('n','fib(n)'))
for i in range(1, 100):
	print('%10s%10s' % (i, fib(i)))
