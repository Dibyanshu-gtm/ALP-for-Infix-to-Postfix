CODE
.data
infix: .space 256
postfix: .space 256
stack: .space 256
prompt:.asciiz "Enter Expression:"
newLine: .asciiz "\n"
pst: .asciiz "Postfix is: "
inf: .asciiz "Infix is: "


.text
 li $v0, 54
 la $a0, prompt
 la $a1, infix
 la $a2, 256
 syscall 
 
 
 la $a0, inf
li $v0, 4
syscall
	
la $a0, infix
li $v0, 4
syscall



li $s6, -1 
li $s7, -1 
li $t7, -1 
while:
        la $s1, infix  //Her we are initialising the operator constants//
        la $t5, postfix
        la $t6, stack 
        li $s2, '+'
        li $s3, '-'
        li $s4, '*'
        li $s5, '/'
	addi $s6, $s6, 1  
	
	
	add $s1, $s1, $s6
	lb $t1, 0($s1)	
	
	//comparing the expression with the operators
	
	beq $t1, $s2, operator 
	nop
	beq $t1, $s3, operator 
	nop
	beq $t1, $s4, operator 
	nop
	beq $t1, $s5, operator 
	nop
	beq $t1, 10, n_operator 
	nop
	beq $t1, 32, n_operator 
	nop
	beq $t1, $zero, endWhile
	nop
	
	
	addi $t7, $t7, 1
	add $t5, $t5, $t7
	
	sb $t1, 0($t5)
	

	lb $a0, 1($s1)

	
	
	beq $v0, 1, n_operator
	nop
	
	add_space:
	add $t1, $zero, 32
	sb $t1, 1($t5)
	addi $t7, $t7, 1
	//if no operator found
	j n_operator
	nop
	
	operator:
	
		
	beq $s7, -1, pushToStack
	nop
	
	add $t6, $t6, $s7
	lb $t2, 0($t6) 
	
	
	beq $t1, $s2, t1to1
	nop
	beq $t1, $s3, t1to1
	nop
	
	li $t3, 2
	
	j check_t2
	nop
		
t1to1:
	li $t3, 1
	
	
check_t2:
	
	beq $t2, $s2, t2to1
	nop
	beq $t2, $s3, t2to1
	nop
	
	li $t4, 2	
	
	j compare_precedence
	nop
	
	
t2to1:
	li $t4, 1	
//to compare the precedence of the operators
compare_precedence:
	
	
	beq $t3, $t4, equal_precedence
	nop
	slt $s1, $t3, $t4
	beqz $s1, t3_large_t4
	nop


	sb $zero, 0($t6)
	addi $s7, $s7, -1  
	addi $t6, $t6, -1
	la $t5, postfix
	addi $t7, $t7, 1
	add $t5, $t5, $t7
	sb $t2, 0($t5)
	
	
	j operator
	nop
	
	
t3_large_t4:

	j pushToStack
	nop

equal_precedence:


	sb $zero, 0($t6)
	addi $s7, $s7, -1  
	addi $t6, $t6, -1
	la $t5, postfix 
	addi $t7, $t7, 1  
	add $t5, $t5, $t7
	
	sb $t2, 0($t5)
	j pushToStack
	nop

pushToStack:

	la $t6, stack 
	addi $s7, $s7, 1  
	add $t6, $t6, $s7
	sb $t1, 0($t6)	
	
	n_operator:	
	j while	
	nop
	

endWhile:
	
	addi $s1, $zero, 32
	add $t7, $t7, 1
	add $t5, $t5, $t7 
	la $t6, stack
	add $t6, $t6, $s7
	
popallstack:

	lb $t2, 0($t6) 
	beq $t2, 0, endPostfix
	sb $zero, 0($t6)
	addi $s7, $s7, -2
	add $t6, $t6, $s7
	
	sb $t2, 0($t5)
	add $t5, $t5, 1
	
	
	j popallstack
	nop

endPostfix:

la $a0, pst
li $v0, 4
syscall

la $a0, postfix
li $v0, 4
syscall

la $a0, newLine
li $v0, 4
syscall
