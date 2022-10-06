.text
	main:
	li	$v0, 5		# lendo um inteiro
	syscall
	move 	$t0, $v0	# move o inteiro para s0
	
	li	$v0, 5		# le o outro coeficiente
	syscall
	move 	$t1, $v0	# move o inteiro para s1
	
	div	$s0, $t1, $t0	# x = (-b) /a
	
	not	$s0, $s0	# inverte s1 
	addi	$s0, $s0, 1	# complemento de 2
	
	add 	$a0, $zero, $s0	# carregando o resultado para a0
	li	$v0, 1		# comando para imprimir int
	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	 