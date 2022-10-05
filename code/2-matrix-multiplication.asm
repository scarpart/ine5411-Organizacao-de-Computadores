.data
	am: 	.word 	1, 2, 3, 0, 1, 4, 0, 0, 1
	bm:	.word 	1, -2, 5, 0, 1, -4, 0, 0, 1
	cm:	.space	9 
.text

# Translating the C code written in 2-matrixMultiplication.c

	main:
	li 	$s0, 0		# int i = 0;
	li	$s1, 0  	# int j = 0;
	li	$s2, 0		# int k = 0;
	li 	$t6, 0 		# int sum = 0;
	
	la	$s3, am		# int* s3 = matrix a
	la	$s4, bm		# int* s4 = matrix b
	la	$s5, cm		# int* s5 = matrix c
	
	loop_k:
	mul	$t0, $s0, 3	# int t0 = 3*i;
	mul 	$t1, $s2, 3	# int t1 = 3*k;
	
	add	$t0, $t0, $s2	# t0 = 3*i + k;
	add	$t1, $t1, $s1	# t1 = 3*k + j;
	add	$t2, $t0, $s1	# t2 = 3*i + j;
	
	sll	$t0, $t0, 2	# t0 = 12*i + 4*k;
	sll	$t1, $t1, 2	# t1 = 12*k + 4*j;
	sll	$t2, $t2, 2	# t2 = 12*i + 4*j;
	
	add	$t0, $t0, $s3	# t0 = s3 (pointer to start of a) + 12*i + 4*k;
	add	$t1, $t1, $s4	# t1 = s4 (pointer to start of b) + 12*k + 4*j;
	add 	$t2, $t2, $s5	# t2 = s5 (pointer to start of c) + 12*i + 4*j;
	
	lw	$t3, 0($t0)	# int t3 = a[3*i + k];
	lw	$t4, 0($t1)	# int t4 = b[3*k + j];
	
	mul 	$t5, $t3, $t4	# int t5 = a[3*i + k] * b[3*k + j];
	add	$t6, $t6, $t5 	# sum += t5;
	
	addi 	$s2, $s2, 1	# k++;
	bge	$s2, 3, loop_j	# if (k >= 3) stop nested iteration
	j	loop_k		# stay in doubly nested for loop
	
	loop_j:
	sw	$t6, 0($t2)	# c[3*i + j] = sum;
	li	$s2, 0		# resets k to 0
	addi	$s1, $s1, 1	# j++;	
	
	li	$a0, 0		# resetting a0 here since it might carry a value from loop_i
	add	$a0, $a0, $t6	# loading t2 (c matrix) into output register
	li	$t6, 0		# sum = 0;
	li	$v0, 1		# sending contents of a0 to stdOut
	syscall

	li 	$a0, ' '	# loading a blank space into the output register
	li	$v0, 11		# sending contents of a0 to stdOut
	syscall
	
	bge	$s1, 3, loop_i  # if (j >= 3) stop nested iteration  
	j	loop_k		# stay in nested for loop

	loop_i:
	li	$s1, 0		# resets j to 0
	addi	$s0, $s0, 1	# i++;
	
	li	$a0, '\n'	# resetting a0
	li	$v0, 11		# sending contents of a0 to stdOut
	syscall
	
	bge	$s0, 3, EXIT	# if (i >= 3) stop master iteration, go to EXIT 
	j	loop_j		# go into nested loop_j
	
	
	
	EXIT:
