.data
	buffer: .space 512
	filename: .asciiz "test.txt"
	newline: .asciiz "\n"
.text

main:
	# opening file in read mode
	li	$v0, 13		# opening file
	la	$a0, filename	# name of file to be read from
	li	$a1, 0		# using read mode - 0
	li	$a2, 0		# using ignore mode - 0
	syscall
	move	$s0, $v0	# file descriptor loaded into s0
	
	# calling the test print routine
	jal print_matrix
	
	# closing file
	li	$v0, 16		# 16 = close file
	move 	$a0, $s0	# file descriptor moved to a0
	syscall
	
end:
	# infinite loop after all operations are done
	j end
	
print_matrix:
	# reading from file
	li	$v0, 14
	move 	$a0, $s0
	la	$a1, buffer
	li	$s2, 512
	syscall
	
	# saving passed arguments into the stack using the stack pointer
	addi	$sp, $sp, -12	# prepares for push
	sw	$ra, 8($sp)	
	sw	$a0, 4($sp)
	sw	$a1, 0($sp)
	
	# loading the variables to be used in the routine
	li	$s1, 0		# keeps track of the first loop
	li	$s2, 0 		# keeps track of the second loop
	
loop_j:
	addi	$s2, $s2, 4	# s2++
	la	$t1, buffer
	add	$t2, $t1, $s2 	
	lw	$t3, ($t2)
	
	li	$v0, 1
	move	$a0, $t3
	syscall

	bne	$s2, 16, loop_j
	j 	loop_i

loop_i:
	addi	$s1, $s1, 4	# s1++
	li	$s2, 0
	j	loop_j
	
	li	$v0, 4
	la	$a0, newline
	syscall
	
	bne 	$s1, 16, loop_i
	
	lw	$a1, 0($sp)
	lw	$a0, 4($sp)
	lw	$ra, 8($sp)
	jr	$ra
	
	


