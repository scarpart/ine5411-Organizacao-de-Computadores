.text
	main:
	li	$v0, 5		# lendo um inteiro
	syscall
	move 	$a0, $v0	# move o inteiro para s0
	
	li	$v0, 5		# le o outro coeficiente
	syscall
	move 	$a1, $v0	# move o inteiro para s1
	
	jal 	funcao
	j	main
	
funcao:
	div	$t0, $a1, $a0	# x = (-b) /a
	
	not	$t0, $t0	# inverte s1 
	addi	$t0, $t0, 1	# complemento de 2
	
	add 	$a0, $zero, $t0	# carregando o resultado para a0
	li	$v0, 1		# comando para imprimir int
	syscall
	
	jr	$ra
	
	
	
