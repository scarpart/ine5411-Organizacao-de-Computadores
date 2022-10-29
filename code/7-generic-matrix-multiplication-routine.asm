.text

main:
	# taking input from user - order of matrix
	li	$v0, 5			# reading an integer
	syscall
	move 	$t0, $v0		# assigning n to t0
	
	# matrix size in memory = n * n * 4
	mul	$t0, $t0, $t0		# n = n * n
	sll	$t0, $t0, 2		# n = n * 4
	
	# allocating in memory
	move	$a0, $t0		# assigning the total size in memory to a0
	li	$v0, 9			# allocation command
	syscall
	move	$s0, $v0		# assigning base address of allocated matrix to s0
	
	# second allocation for the second matrix
	move	$a0, $t0
	li	$v0, 9
	syscall
	move	$s1, $v0		# assigning base address to s1
	
	# initializing variables to run through these matrixes
	li	$s2, 0			# s2 will track lines in matrix a
	li	$s3, 0			# s3 will track columns in matrix b
	li	$s4, 0	 		# s4 will keep track of columns in a and lines in b
	
			
input_matrix_a:
	# reading input integer
	li	$v0, 5			# reading an integer
	syscall
	move	$t1, $v0		# moves integer to t1
	
	# storing integer into s0 + s2
	add	$t2, $s0, $s2 		# base address + index
	sw	$t1, ($t2)		# storing in position t2
	
	# updating index
	addi	$s2, $s2, 4		# s2++
	
	bne	$t0, $s2, input_matrix_a
	li	$s2, 0			# resetting s2	

input_matrix_b:
	# reading input integer
	li	$v0, 5			# reading an integer
	syscall
	move 	$t1, $v0		# moves integer to t1
	
	# storing integer into s0 + s2	
	add	$t2, $s1, $s2		# base address + index
	sw	$t1, ($t2)		# storing in position t2
	
	# updating index
	addi	$s2, $s2, 4		# s2++
	
	bne	$t0, $s2, input_matrix_b
	li	$s2, 0			# resetting s2
	
	# --------------------
	# CONTINUATION OF MAIN
	# --------------------
	
	
	
	
	
	
	
	
	
	
