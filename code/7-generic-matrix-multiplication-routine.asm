
.text

main:
	# taking input from user - order of matrix
	li	$v0, 5			# reading an integer
	syscall
	move 	$s0, $v0		# assigning n to s0
	
	# matrix size in memory = n * n * 4
	mul	$s0, $s0, $s0		# n = n * n
	sll	$s0, $s0, 2		# n = n * 4
	
	# allocating in memory
	move	$a0, $t0		# assigning the total size in memory to a0
	li	$v0, 9			# allocation command
	syscall
	move	$s6, $v0		# assigning base address of allocated matrix to s6
	
	# second allocation for the second matrix
	move	$a0, $t0
	li	$v0, 9
	syscall
	move	$s7, $v0		# assigning base address to s7
	
	# third allocation for the resulting matrix
	move	$a0, $t0
	li	$v0, 9
	syscall
	move 	$s1, $v0		# assigning base address to s1 
	
	# initializing variables to run through these matrixes
	li	$s2, 0			# s2 will track lines in matrix a
	li	$s3, 0			# s3 will track columns in matrix b
	li	$s4, 0	 		# s4 will keep track of columns in a and lines in b

	# calling routine to take input matrixes
	jal	taking_input
	
	# calling routine to multiply matrixes
	jal	matrix_multiplication
			
matrix_multiplication:
	# saving argument variables into the stack
	addi	$sp, $sp, -12		# prepares for push operation
	sw	$ra, 8($sp)		# saves $ra
	sw	$a0, 4($sp)		# saves a0
	sw	$a1, 0($sp)		# saves a1
	
	# s2 - lines in a   (i)
	# s3 - columns in b (j)
	# s4 - (k)
	
loop_k:
	# for (int k = 0; k < n; k++)
	move	$t0, $s6		# base address of matrix a moved to t0
	move	$t1, $s6		# base address of matrix b moved to t1
	
	# a[i*N] * b[k*N]
	mult 	$t4, $s0, $s2		# i*N
	mult	$t5, $s0, $s4		# j*N
	
	# a[i*N + k] * b[k*N + j]
	add	$t4, $t4, $s4		# i*N + k
	add	$t5, $t5, $s3		# k*N + j
	
	# multiplying by 4 to get the indexation in bytes
	sll	$t4, $t4, 2		# t4 * 4
	sll	$t5, $t5, 2		# t5 * 4	
	
	# adding to base addresses to get correct position in memory
	add	$t4, $t4, $s6		# a[i*N + k]
	addi	$t5, $t5, $s7		# b[k*N + j]
	
	# loading words from these indexes
	lw	$t6, ($t4)		# saving contents of address t4 to t6
	lw	$t7, ($t5)		# saving contents of address t5 to t7
	
	# adding multiplication of t6 and t7 to sum
	mult	$t8, $t6, $t7 		# t8 = t6 * t7
	add	$s5, $s5, $t8		# sum += t8 
	
	# storing these variables into their new addresses 
	
	
	
loop_j:
	# for (int j = 0; j < n; j++)
	addi	$s3, $s3, 0		# j++
	li	$s4, 0			# k = 0
	li	$s5, 0			# sum = 0
	
	j 	loop_k			# jumps to the second nessted for loop
	bne	$s3, $s0, loop_j	# if j != n, go to the next iteration
	
	j 	loop_i			# returns to parent loop

loop_i:
	# for (int i = 0; j < n; i++)
	addi	$s2, $s2, 1		# i++
	li	$s3, 0			# j = 0
	
	j	loop_j			# jumps to first nested for loop
	bne	$s2, $s0, loop_i	# if i != n, go to next iteration
	
	jr	$ra			# returns to main, exits routine 

taking_input:
	# saving argument variables into the stack
	addi	$sp, $sp, -12		# prepares for push operation
	sw	$ra, 8($sp)		# saves the return
	sw	$a0, 4($sp)		# saves contents of a0
	sw	$a1, 0($sp)		# saves contents of a1

input_matrix_a:
	# reading input integer
	li	$v0, 5			# reading an integer
	syscall
	move	$t1, $v0		# moves integer to t1
	
	# storing integer into s0 + s2
	add	$t2, $s6, $s2 		# base address + index
	sw	$t1, ($t2)		# storing in position t2
	
	# updating index
	addi	$s2, $s2, 4		# s2++
	
	bne	$s0, $s2, input_matrix_a
	li	$s2, 0			# resetting s2	

input_matrix_b:
	# reading input integer
	li	$v0, 5			# reading an integer
	syscall
	move 	$t1, $v0		# moves integer to t1
	
	# storing integer into s0 + s2	
	add	$t2, $s7, $s2		# base address + index
	sw	$t1, ($t2)		# storing in position t2
	
	# updating index
	addi	$s2, $s2, 4		# s2++
	
	bne	$s0, $s2, input_matrix_b
	li	$s2, 0			# resetting s2
	
	# returning to main
	lw	$ra, 8($sp)		# loading back the contents of ra
	lw	$a0, 4($sp)		# loading back the contents of a0
	lw	$a1, 0($sp)		# loading back the contents of a1
	addi	$sp, $sp, 12		# returning stack pointer to original position
	jr	$ra			# returning to main
	
	# end of routine
	
	
	
	
	
	
	
	
	
	
