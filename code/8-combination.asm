.data
	newline: .asciiz "\n"
	print_n: .asciiz "Input n: "
	print_p: .asciiz "Input p: "
	print_result: .asciiz "The result is: "
.text

main:
	# printing print_n
	li	$v0, 4			# command to write string
	la	$a0, print_n		# passing buffer to a0
	syscall
	
	# taking input from user - n elements
	li	$v0, 5			# reading an integer
	syscall
	move	$s0, $v0		# moving integer to s0
	
	# printing print_p
	li	$v0, 4			# command to write string
	la	$a0, print_p		# passing buffer to a0
	syscall
	
	# taking p from user
	li	$v0, 5		
	syscall
	move	$s1, $v0
	
	# calculating the factorial of n
	move	$a0, $s0		# passing s0 as argument to factorial
	jal	factorial
	move	$t0, $v0		# result goes to t0
	
	# factorial of p
	move	$a0, $s1		# passing s1 as argument
	jal 	factorial
	move 	$t1, $v0		# result goes to t1	
	
	# n - p to calculate the next factorial
	sub	$s2, $s0, $s1		# t = n - p
	move	$a0, $s2		# passing t as argument
	jal	factorial	
	move	$t2, $v0		# result goes to v0
	
	# C(n, p) = n! / p!(n-p)!
	mul	$t1, $t1, $t2		# calculating t1 = p!(n-p)!
	div	$t0, $t0, $t1		# calculating n! / t1
	
	# printing print_n
	li	$v0, 4			# command to write string
	la	$a0, print_result	# passing buffer to a0
	syscall
	
	# writing the result to screen
	move	$a0, $t0		# passing the result as argument to syscall
	li	$v0, 1			# command to print integer
	syscall
	
	# printing a newline
	li	$v0, 4			# command to print string
	la	$a0, newline		# loads newline into a0
	syscall
	
end_program:
	# infinite loop to end the program
	j 	end_program
	
factorial:
	# routine to calculate the factorial of a given number
	addi	$sp, $sp, -8		# preparing stack for push
	sw	$ra, 0($sp)		# storing instruction register value
	sw	$a0, 4($sp)		# storing the argument
	move	$t3, $a0		# argument is moved onto t3
	move	$t4, $a0		# sum = argument

loop_factorial:
	# uses a loop to calculate the factorial
	addi	$t3, $t3, -1		# subtracts 1 from t3
	mul	$t4, $t4, $t3		# t4 = t4 * t3
	bne 	$t3, 1, loop_factorial	# while t3 != 1, goes back to next iteration
	move	$v0, $t4		# storing the result into v0 for return
	
	# popping the stack
	lw	$a0, 4($sp)		# loading a0 back
	lw	$ra, 0($sp)		# loading instruction address
	addi	$sp, $sp, 8		# popping the stack back to the original position of sp
	jr	$ra			# jumps back to main, ends routine
	
	# end of routine
	
	
