.data
	a10: .word 0 1 2 3 4 5 6 7 8 9
	output: .asciiz "               "
	fout: .asciiz "output.txt"
.text

main:
	# loads the archive in write mode
	li 	$v0, 13		# opening a new archive
	la 	$a0, fout	# loading the name of the archive to be written
	li 	$a1, 1		# opened in write mode (1)
	li	$a2, 0 		# opened in ignore mode (0)
	syscall
	move 	$s6, $v0	# saves the file descriptor for later use
	
	# calls the the conversion procedure (32 bit integer -> ASCII)
	jal 	convert
	
	# writes the resulting output buffer into the previously opened file
	li 	$v0, 15		# 15 = write in file
	move 	$a0, $s6	# moves the file descriptor to v0
	la 	$a1, output	# loads the output buffer address
	li 	$a2, 100	# limits the size of buffer to be written
	syscall
	
	# closes the file
	li	$v0, 16		# 16 = closes file
	move 	$a0, $s6	# passes file descriptor to a0
	syscall
	
end:
	j 	end		# eternal loop when the program ends
	
convert:
	# saving passed arguments into the stack using the stack pointer
	addi	$sp, $sp, -12 	# prepares the PUSH to save data from a0 and a1 (used in the main routine)
	sw 	$ra, 8($sp)	# saves the return
	sw	$a0, 4($sp) 	# saves the contents of a0
	sw	$a1, 0($sp)	# saves the contents of a1
	
	# loading the variables to be used in the routine
	la	$a0, a10	# loads the base address of a10
	la	$a1, output	# loads the base address of the output string
	
	li	$s2, 10		# limit of iterations (array size is 10)
	li	$s7, 0		# used to count the current for loop
	li	$s4, 0		# used as index for a10
	li	$s5, 0		# used as index for output
	
loop:
	# taking data from a10[s3]
	move	$s3, $s4	# moves i to s0
	add	$t1, $s3, $s3	# points to the next index (2*s4)
	add	$t1, $t1, $t1 	# ...(4*s3), as there are 4 bytes for each int
	add	$t1, $t1, $a0 	# base address + 4*s3, now points to the first element of the array
	
	# transforming gathered integer into ASCII
	lw	$t0, 0($t1)	# $t0 <-- ARRAY[i]
	addi	$t0, $t0, 48	# adds 48 to transform into ASCII character
	addi	$s4, $s4, 1	# i++
	
	# output[j] = a10[i]
	move 	$s3, $s5	# moves j to s7
	add 	$t1, $s3, $s3 	# points to the next index (2*s4)...
	add 	$t1, $t1, $t1 	# ...(4*s4), as there are 4 bytes for each int
	add	$t1, $t1, $a1	# now points to the start of the output buffer
	
	sw	$t0, 0($t1)	# stores contents of a10[i] into output[j]
	li	$t0, 32		# loads blank character (ASCII)
	sw	$t0, 4($t1)	# stores blank character into output[j+1]
	addi	$s5, $s5, 2	# j += 2
	addi	$s7, $s7, 1	# increments loop iteration
	bne	$s2, $s7, loop	# while s3 != 10, stay on loop
	
	# restoring previously stacked variables
	lw	$a1, 0($sp)	# restores $a1
	lw	$a0, 4($sp)	# restores $a0
	lw	$ra, 8($sp)	# restores $ra
	addi	$sp, $sp, 12	# updates $sp (popped 3 instructions)
	jr	$ra		# returns from routine to the main program
	
	# end of routine