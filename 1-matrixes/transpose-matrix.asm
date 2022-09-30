.data
	matrix: 	.word 1, 2, 0, 1, -1, -3, 0, 1, 3, 6, 1, 3, 2, 4, 0, 3
	transpose:	.space 16
.text

# Comentários em inglês porque eu gosto de colocar esses projetos no github

	main:
	li 	$s0, 0		# int i = 0;
	li	$s1, 0  	# int j = 0;
	
	la	$s3, matrix	# int* s3 = matrix
	la	$s4, transpose	# int* s4 = transpose
	
	# normally, --> int t0 = 4*i + j <-- would work
	# however, since we are messing with the addresses in memory,
	# and especially since an int takes 4 bytes of storage,
	# all operations need to be multiplied by 4 to fetch the correct addresses
	# thus, --> int t0 = 4*(4*i + j) <-- would be correct here
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
	
	li	$a0, 0		# resetting a0 here since it might carry a value from loop_i
	add	$a0, $a0, $t2	# loading t2 (transpose[n]) into output register
	li	$v0, 1		# sending contents of a0 to stdOut
	syscall

	li 	$a0, ' '	# loading a blank space into the output register
	li	$v0, 11		# sending contents of a0 to stdOut
	syscall

	addi	$s1, $s1, 1	# j++;
	bge	$s1, 4, loop_i  # if (j >= 4) stop nested iteration  
	j	loop_j		# stay in nested for loop

	loop_i:
	li	$s1, 0		# resets j to 0
	addi	$s0, $s0, 1	# i++;
	
	li	$a0, '\n'	# resetting a0
	li	$v0, 11		# sending contents of a0 to stdOut
	syscall
	
	bge	$s0, 4, EXIT	# if (i >= 4) stop master iteration, go to EXIT 
	j	loop_j		# go into nested loop_j
	
	EXIT:
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		 