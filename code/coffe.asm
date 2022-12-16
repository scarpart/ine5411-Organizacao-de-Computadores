.data
	file: .asciiz "receipt.txt"
	fheader: .asciiz "-------RECEIPT-------"
	ffooter: .asciiz "---------------------"
	fdrink_coffee: .asciiz " Vanilla "
	fdrink_latte: .asciiz " Latte "
	fdrink_mocacchino: .asciiz " Mocacchino "
	fdrink_milk: .asciiz "w/ Milk "
	fsize_big: .asciiz "- Big"
	fsize_small: .asciiz "- Small"
	fsugar: .asciiz  " Sugar "
	buffer: .space 1024
	
	welcome_msg: .asciiz "Welcome to our Coffe Shop!\n"
	action_sel: .asciiz "Please select an action: \n1 - Get Coffee\n2 - Refill Machines\n3 - Check Drink and Sugar Availability\n"
	drink_sel: .asciiz "Please select your drink from the following options: \n1 - Pure Coffee (vanilla)\n2 - With Milk\n3 - Mochaccino\n"
	size_sel: .asciiz "Please select the size of your drink: \n1 - big\n2 - small\n"
	sugar_sel: .asciiz "Do you want sugar in your drink? \n1 - yes \n2 - no\n"
	refill_sel: .asciiz "Select the container you wish to refill:\n1 - Vanilla\n2 - Latte\n3 - Mocacchino\n4 - Sugar\n"
	amount_sel: .asciiz "Input the amount to refill:\n"
	
	available_drinks: .word 1, 2, 0
	available_sugar: .word 0
	
	not_enough_drink: .asciiz "The drink you selected is not available. Please ask an employee to refill!\n"
	not_enough_sugar: .asciiz "There isn't any sugar left. Please ask an employee to refill!\n"

	no_mocacchino: .asciiz "No mocacchino left. Please contact an employee!\n"
	no_vanilla: .asciiz "No pure coffee (vanilla) left. Please contact an employee!\n"
	no_latte: .asciiz "No latte left. Please contact an employee!\n"

	preparing_coffee: .asciiz "Preparing coffee...\n"
	preparing_vanilla: .asciiz "Preparing vanilla...\n"
	preparing_latte: .asciiz "Preparing latte...\n"
	preparing_mocacchino: .asciiz "Preparing mocacchino\n"
	
	print_coffee: .asciiz "Vanilla amount... "
	print_latte: .asciiz "\nLatte amount... "
	print_mocacchino: .asciiz "\nMocacchino amount... "
	print_sugar: .asciiz "\nSugar amount... "
	newline: .asciiz "\n\n"
	
	sucessful_prepare: .asciiz "Your coffee is ready!\n\n"
	successful_refill: .asciiz "Successful refill!\n\n"

	STD_ERROR: .asciiz "Input error. Please make sure that the option you've selected is an available one!\n"
.text

main:
	# Printing welcome message 
	la	$a0, welcome_msg
	li 	$v0, 4
	syscall
	
	# -- Asking the user for input 
	la	$a0, action_sel
	li	$v0, 4
	syscall
	jal 	get_numeric_input
		
	# controlling program flow based on user input
	beq	$v0, 1, select_coffee
	beq	$v0, 2, refill_machines
	beq	$v0, 3, print_amount
	
	# handling errors
	blt	$v0, 1, ERROR
	bgt	$v0, 3, ERROR
	
	LOOP:
	j	main
	
	
refill_machines:
	# -- Routine for selecting and refilling a coffee container
	
	# getting user input for the amount to be refilled
	la	$a0, amount_sel
	li	$v0, 4
	syscall
	jal	get_numeric_input
	move	$s0, $v0			# refill amount stored in s0
	
	# getting user input for the container to be refilled
	la 	$a0, refill_sel
	li	$v0, 4
	syscall
	jal	get_numeric_input
	
	# refilling a container based on inputs
	beq	$v0, 1, refill_vanilla
	beq	$v0, 2, refill_latte
	beq	$v0, 3, refill_mocacchino
	beq	$v0, 4, refill_sugar
	
	# handling errors
	blt	$v0, 1, STD_ERROR
	bgt	$v0, 4, STD_ERROR
	
	continue_refill:
	# printing successful refill message and returning to main loop
	la	$a0, successful_refill
	li	$v0, 4
	syscall
	j	LOOP

refill_vanilla:
	# -- Routine for refilling vanilla coffee container
	
	# loading available amount from memory
	la	$t0, available_drinks
	lw	$t1, ($t0)			# first index = vanilla amount
	
	# adding refill amount to container
	add	$t1, $t1, $s0
	
	# rewritting in memory
	sw	$t1, ($t0)
	
	# jumping back to caller routine
	j	continue_refill
	
refill_latte:
	# -- Routine for refilling latte coffee container
	
	# loading available amount from memory
	la	$t0, available_drinks
	lw	$t1, 4($t0)			# second index = latte amount
	
	# adding refill amount to container
	add	$t1, $t1, $s0
	
	# rewritting in memory
	sw	$t1, 4($t0)
	
	# jumping back to caller routine
	j	continue_refill
	
refill_mocacchino:
	# -- Routine for refilling mocacchino coffee container
	
	# loading available amount from memory
	la	$t0, available_drinks
	lw	$t1, 8($t0)			# third index = mocacchino amount
	
	# adding refill amount to container
	add	$t1, $t1, $s0
	
	# rewritting in memory
	sw	$t1, 8($t0)
	
	# jumping back to caller routine
	j	continue_refill
	
refill_sugar:
	# -- Routine for refilling the sugar container
	
	# loading available amount from memory
	la	$t0, available_sugar
	lw	$t1, ($t0)
	
	# adding refill amount to container
	add	$t1, $t1, $s0
	
	# rewritting in memory
	sw	$t1, ($t0)
	
	# jumping back to caller routine
	j	continue_refill
	
print_amount:
	# -- Routine to print amount of drinks and sugar available
	
	# Loading drink vector
	la	$t0, available_drinks
	lw	$t1, 0($t0)
	
	# Printing available drinks
	li	$v0, 4
	la	$a0, print_coffee
	syscall
	li	$v0, 1
	move	$a0, $t1
	syscall
	
	lw 	$t1, 4($t0)
	
	li	$v0, 4
	la	$a0, print_latte
	syscall
	li	$v0, 1
	move	$a0, $t1
	syscall
	
	lw	$t1, 8($t0)
	
	li	$v0, 4
	la	$a0, print_mocacchino
	syscall
	li	$v0, 1
	move	$a0, $t1
	syscall
	
	# printing amount of sugar available
	la	$t0, available_sugar
	lw	$t1, 0($t0)
	li	$v0, 4
	la	$a0, print_sugar
	syscall
	li	$v0, 1
	move	$a0, $t1
	syscall
	
	# prints newline
	li	$v0, 4
	la	$a0, newline
	syscall
	
	# returns to main routine
	j	LOOP
	
	
select_coffee:
	# -- Routine for selecting what type of coffee the user wants
	
	# getting user input
	la	$a0, drink_sel
	li	$v0, 4
	syscall
	jal	get_numeric_input
	move	$s0, $v0
	
	# handling errors
	blt	$v0, 1, ERROR
	bgt	$v0, 3, ERROR
	
	# storing user input in s0
	move	$s0, $v0
	
	# getting input for the drink size
	la	$a0, size_sel
	li	$v0, 4
	syscall
	jal 	get_numeric_input
	
	# handling errors
	blt	$v0, 1, ERROR
	bgt	$v0, 2, ERROR
	
	# storing user input in s1
	move	$s1, $v0
	
	# getting input for whether or not the user wants sugar 
	la	$a0, sugar_sel
	li	$v0, 4
	syscall
	jal	get_numeric_input
	
	# handling errors
	blt	$v0, 1, ERROR
	bgt 	$v0, 2, ERROR
	
	# storing user input in s2
	move	$s2, $v0
	
	# checking for drink type availability
	move	$a0, $s0
	jal	check_for_drink
	
	# checking for sugar availability, if the user wanted it
	move	$a0, $s2
	jal	check_for_sugar
	
	# entering routine to prepare coffee
	move	$a0, $s0		# passing drink type as argument
	move	$a2, $s2		# passing has_sugar (bool) as an argument
	move	$a1, $s1		# passing drink size as argument
	jal	prepare
	
	# going back to main loop
	j	LOOP
	
prepare:
	# -- Routine to prepare coffee
	
	# preparing stack pointer and making push operations
	addi	$sp, $sp, -12		# 3 slots available
	sw	$a0, 0($sp)		# storing drink type in stack
	sw	$a1, 4($sp)		# storing drink size in stack
	sw	$a2, 8($sp)		# storing has_sugar in stack
	sw	$ra, 12($sp)		# storing program counter in stack
	
	# subtracts from sugar container if the user wants it
	beq	$a2, 2, continue_prepare_1
	j	update_sugar_count
	
	continue_prepare_1:
	# continues preparing coffee after possible sugar subtraction
	
	# changing what is prepared based on selected drink
	beq	$a0, 1, prepare_vanilla
	beq	$a1, 2, prepare_latte
	beq	$a2, 3, prepare_mocacchino
	
	continue_prepare_2:	
	# waits for timer (simulating real preparation)	

	TIMER_WAIT:
	li 	$v0,30        	
	syscall			
	move 	$t1, $a0

	wait:	
	li 	$v0, 30        	  
	syscall			
	move 	$t0, $a0
	sub    	$t2, $t0, $t1	
	sle	$s0, $t2, 2000  
	bgtz  	$s0, wait	
		
	# end timer
	
	# printing successful preparation message
	la	$a0, sucessful_prepare
	li	$v0, 4
	syscall
	
	# writing receipt
	jal	write_receipt
	
	# returning to caller routine
	#lw	$a0, 0($sp)
	#lw	$a1, 4($sp)
	#lw	$a2, 8($sp)
	lw	$ra, 12($sp)
	addi	$sp, $sp, 12
	jr	$ra
	
write_receipt:
	
	# acquiring parameters again
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)

	# opening file in write mode
	li	$v0, 13		# opening file
	la	$a0, file	# name of file to be read from
	li	$a1, 0		# using read mode (0)
	li	$a2, 0		# in ignore mode (0)
	syscall
	move 	$s6, $v0	# loading file descriptor into s0
	
	# write file first address
 	li 	$v0, 15
 	move 	$a0, $s6   # move fd
 	la 	$a1, fheader
 	li 	$a2, 1024
 	syscall

	 # write file break line
 	li 	$v0, 15
 	move	$a0, $s6   # move fd
 	la 	$a1, newline
 	li	$a2, 8
 	syscall

	bne	$a0, 1, rlatte
	rvanilla:
 	li 	$v0, 15
 	move 	$a0, $s6   # move fd
 	la 	$a1, fdrink_vanilla
	li 	$a2, 64
	syscall
	
	rlatte:
	bne	$a0, 2, rmocacchino
	li 	$v0, 15
 	move 	$a0, $s6   # move fd
 	la 	$a1, fdrink_latte
	li 	$a2, 64
	syscall
	
	rmocacchino:
	bne	$a0, 3, continue_receipt_1
	li 	$v0, 15
 	move 	$a0, $s6   # move fd
 	la 	$a1, fdrink_mocacchino
	li 	$a2, 64
	syscall
	
	continue_receipt_2:
	bne	$a1, 1, continue_receipt_3
	li	$v0, 15
	move	$a0, $s6
	la	$a1, fsize_big
	li	$a2, 8
	syscall	
	
	continue_receipt_3:
	bne	$a1, 2, continue_receipt_4
	li	$v0, 15
	move	$a0, $s6
	la	$a1, fsize_small
	li	$a2, 8
	syscall	
	
	continue_receipt_1:
	bne 	$a2, 1, continue_receipt_2
	rmilk:
	li	$v0, 15
	move	$a0, $s6
	la	$a1, fmilk
	li	$a2, 16
	syscall
	
	
				
prepare_mocacchino:
	# -- Subroutine for preparing mocacchino

	# printing preparing message
	la	$a0, preparing_mocacchino
	li	$v0, 4
	syscall
	
	# decreasing mocacchino count
	la 	$t0, available_drinks
	lw	$t1, 8($t0)
	addi	$t1, $t1, -1
	sw	$t1, 8($t0)
	
	# continuing preparation
	j 	continue_prepare_2

prepare_latte:
	# -- Subroutine for preparing latte

	# printing preparing message
	la	$a0, preparing_latte
	li	$v0, 4
	syscall
	
	# decreasing vanilla count
	la 	$t0, available_drinks
	lw	$t1, 4($t0)
	addi	$t1, $t1, -1
	sw	$t1, 4($t0)
	
	# continuing preparation
	j 	continue_prepare_2
	
prepare_vanilla:
	# -- Subroutine for preparing vanilla coffee
	
	# printing preparing message
	la	$a0, preparing_vanilla
	li	$v0, 4
	syscall
	
	# decreasing vanilla count
	la 	$t0, available_drinks
	lw	$t1, 0($t0)
	addi	$t1, $t1, -1
	sw	$t1, 0($t0)
	
	# continuing preparation
	j 	continue_prepare_2
	
update_sugar_count:
	# -- Subroutine for updating sugar count in memory
	la	$t0, available_sugar
	lw	$t1, 0($t0)
	addi	$t1, $t1, -1
	sw	$t1, 0($t0)
	j 	continue_prepare_1
	
check_for_sugar:
	# -- Routine for checking if there is sugar available and handling possible errors
	
	# if user wants sugar, checks availability, else, returns to caller routine
	beq	$a0, 1, continue_sugar_check
	jr	$ra
	
	continue_sugar_check:
	# storing available sugar amount in t1
	la	$t0, available_sugar
	lw	$t1, ($t0)
	
	# checking if > 0
	blt	$t1, 1, SUGAR_AMOUNT_ERROR
	jr 	$ra
	
SUGAR_AMOUNT_ERROR:
	# -- Routine for handling unavailability of sugar
	
	# printing error message
	la	$a0, not_enough_sugar
	li	$v0, 4
	syscall
	
	# jumping back to main to continue the execution loop
	j 	LOOP
	

check_for_drink:
	# -- Routine for checking if there is enough of a drink available

	# argument passed in $a0 is the type of drink to check 
		
	# getting availability of drinks
	la	$t0, available_drinks
	lw	$t1, 0($t0)		# pure coffee availability
	lw	$t2, 4($t0)		# latte availability
	lw	$t3, 8($t0)		# mocacchino availability

	# performs subchecks for coffee types
	beq 	$a0, 1, SUBCHECK_FOR_VANILLA
	beq	$a0, 2, SUBCHECK_FOR_LATTE
	beq	$a0, 3, SUBCHECK_FOR_MOCACCHINO

	continue_drink_check:
	# goes back to caller routine get_coffee
	jr	$ra
	
	# -- Routines below handle all types of suberrors
	SUBCHECK_FOR_VANILLA:
	blt	$t1, 0, NO_VANILLA_ERROR
	j	continue_drink_check
	NO_VANILLA_ERROR:
	la	$a0, no_vanilla
	li	$v0, 4
	syscall
	j 	LOOP
	SUBCHECK_FOR_LATTE:
	blt	$t1, 0, NO_LATTE_ERROR
	j	continue_drink_check
	NO_LATTE_ERROR:
	la	$a0, no_latte
	li	$v0, 4
	syscall
	j 	LOOP
	SUBCHECK_FOR_MOCACCHINO:
	blt	$t1, 0, NO_MOCACCHINO_ERROR
	j	continue_drink_check
	NO_MOCACCHINO_ERROR:
	la	$a0, no_mocacchino
	li	$v0, 4
	syscall
	j 	LOOP	

get_numeric_input:
	# -- Routine for acquiring and returning a single input
	
	li	$v0, 5
	syscall
	jr	$ra
	
ERROR:
	la	$a0, STD_ERROR
	li	$v0, 4
	syscall
	j 	LOOP
		
	
