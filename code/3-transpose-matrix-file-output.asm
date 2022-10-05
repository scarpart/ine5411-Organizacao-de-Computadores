.data
	matrix: 	.word 1, 2, 0, 1, -1, -3, 0, 1, 3, 6, 1, 3, 2, 4, 0, 3
	transpose:	.space 16
	fout:		.asciiz "transpose.dat"
	buffer:		.word 0:64
.text

# Assignment 3 - Same as assignment 1, however, the output needs to be written into a .dat file.
	
	allocate_bytes:
	
	li 	$v0, 9		# i'm losing my mind
	li 	$a0, 16		# allocates 36 bytes for 36 chars (4 numbers per line +
				# 4 spaces per line + 1 \n per line and the one at the beginning)
	syscall
	
	la 	$s5, transpose	# hope this works 
	
	main:
	
	# Opening a file to be written
	li 	$v0, 13		# the command to open a new file
	la 	$a0, fout	# loading the name of the file to be opened
	li	$a1, 1		# open for writing (flags: 0-read, 1-write)
	li	$a2, 0		# mode is ignored
	syscall
	move 	$s6, $v0	# saves the file descriptor to be used when closing, for example
	
	li 	$s0, 0		# int i = 0;
	li	$s1, 0  	# int j = 0;
	
	la	$s3, matrix	# int* s3 = matrix
	la	$s4, transpose	# int* s4 = transpose
	
	loop_j:
	sll	$t0, $s0, 2	# int t0 = 4*i;
	sll	$t1, $s1, 2	# int t1 = 4*j;
	
	add	$t0, $t0, $s1	# t0 = 4*i + j;
	add	$t1, $t1, $s0	# t1 = 4*j + i;
	
	sll	$t0, $t0, 2	# t0 = 16*i + 4*j;
	sll	$t1, $t1, 2	# t1 = 16*j + 4*i;
	
	add	$t0, $t0, $s3	# t0 = s3 (pointer to start of matrix) + 16*i + 4*j;
	add	$t1, $t1, $s4	# t1 = s4 (pointer to start of transpose) + 16*j + 4*i;
	
	lw	$t2, 0($t0)	# int t2 = matrix[4*i + j];
	sw	$t2, 0($t1)	# transpose[4*j + i] = t2;
	
	addi	$s5, $s5, 4	# next byte
	
	addi	$s1, $s1, 1	# j++;
	bge	$s1, 4, loop_i  # if (j >= 4) stop nested iteration  
	j	loop_j		# stay in nested for loop

	loop_i:
	li	$s1, 0		# resets j to 0
	addi	$s0, $s0, 1	# i++;
	
	bge	$s0, 4, EXIT	# if (i >= 4) stop master iteration, go to EXIT 
	j	loop_j		# go into nested loop_j
	
	EXIT:
	li 	$v0, 15		# system call for writing into a new file
	move	$a0, $s6 	# the unique file descriptor is passed in
	la	$a1, transpose	# address of buffer to be written at
	la	$a2, 64		# i don't know
	syscall
	
	# closing the file
	li	$v0, 16		# system call for closing a file
	move	$a0, $s6	# file descriptor to close
	syscall	
