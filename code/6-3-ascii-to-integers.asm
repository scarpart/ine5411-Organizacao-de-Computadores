.data
	a10:	.space 512
	buffer:	.space 512
	file:	.asciiz "output.txt"
.text

main:
	# opening file in write mode
	li	$v0, 13		# opening file
	la	$a0, file	# name of file to be read from
	li	$a1, 0		# using read mode (0)
	li	$a2, 0		# in ignore mode (0)
	syscall
	move 	$s0, $v0	# loading file descriptor into s0
	
	# calling the transfer routine
	jal	transfer
	
	# closing file
	li	$v0, 16 	# 16 = close file
	move	$a0, $s0	# file descriptor moved to a0
	syscall
	
end:
	# infinite loop, stays here after end of main execution
	j 	end 		
	
transfer:
	# saving passed arguments into the stack using the stack pointer
	addi	$sp, $sp, -12		# prepares for push
	sw	$ra, 8($sp)		# saves the return
	sw	$a0, 4($sp)		# saves the value in a0
	sw	$a1, 0($sp)		# saves the value in a1
	
	# loading the variables to be used in the routine 
	li	$s1, 10			# limit of iterations (array size is 10)
	li	$s2, 0			# keeps track of the loop
	li	$s3, 0			# sets i = 0 to run through the file
	li	$s4, 0			# sets j = 0 to run through the array
	
loop:
	# loading reocurring address variables
	la	$a0, a10		# loading the base address of a10
	la 	$a1, buffer		# loading the base address of the buffer
	
	# indexation variables $t0 and $t1
	move 	$t3, $s3		# moving s3 to t3 to be used in the calculations
	sll	$t3, $t3, 2		# multiplies the value in t3 by 4 for indexation
	addi	$t0, $t3, 0 		# initializes t0 to the value of s3*4
	add	$t0, $t0, $a0		# points to the start of the a10 array
	
	move 	$t4, $s4		# moving s4 to t4 to be used in the calculations
	sll	$t4, $t4, 2		# multiplies the value in t4 by 4 for indexation
	addi	$t1, $t4, 0		# initializes t1 to the value of s4*4
	add 	$t1, $t1, $a1		# points to the start of the buffer
	
	# reading from file
	li	$v0, 14			# 14 = read from file
	move 	$a0, $s0		# loading file descriptor
	la	$a1, buffer		# address of buffer to which to read
	li	$a2, 512		# buffer length
	syscall
	
	# taking the data from buffer[i]
	add	$t1, $t1, $t3		# i += s3
	lw	$t2, 0($t1)		# load contents of buffer[i] to t2
	addi	$t2, $t2, -48		# convert from ASCII
	sw	$t2, 0($t0)		# stores contents of buffer[i] to a10[j]
	
	# updating base indexation variables
	addi	$s3, $s3, 1		# i++
	addi	$s4, $s4, 1		# j++
	
	# while s2 != 10 stay on loop
	addi	$s2, $s2, 1		# s2++, new iteration 
	bne 	$s2, $s1, loop		# jump back to loop while condition is met 
	
	# restoring previously stacked variables
	lw	$a1, 0($sp)		# restores $a1
	lw	$a0, 4($sp)		# restores $a0
	lw	$ra, 8($sp)		# restores $ra
	addi	$sp, $sp, 12		# updates $sp (popped 3 instructions)
	jr	$ra			# returns from routine to the main program
	
	# end of routine
	