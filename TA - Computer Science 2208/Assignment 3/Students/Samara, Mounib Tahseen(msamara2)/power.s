
		AREA XTOTHEN, CODE, READONLY
		ENTRY
		
		ADR r13,stack					;Assign to the stack pointer the adress of the stack
		MOV r1,#x						;Store value of x in r0
		MOV r0,#n						;Store value of n in r1
		STR r1,[r13,#-4]!				;Push x on to stack
		STR r0,[r13,#-4]!				;Push n on to  stack
		SUB r13,r13,#4 					;Reserve a stack place for the return value
		
		BL power						;Call the power subroutine (x, n)
		
		LDR r0,[r13],#4					;load result into r0 and pop from stack
		ADD r13,r13,#8					;Remove parameters from the stack
		ADR r11,result					;put the result to r11
		STR r0,[r11]					;Store the result in the result variable

ILOOP	B ILOOP							;Infinite loop to signify we are done

power	STMFD r13!,{r0,r1,FP,LR}		;Push n,x,frame pointer, and link register on to stack
		MOV FP,r13						;Set the frame pointer for this call
		LDR r1,[FP,#0x18]				;Load x from stack
		LDR r0,[FP,#0x14]				;Load n from stack
				
		CMP r0,#0						;Compare n with 0
		MOVEQ r0,#1						;Store 1 as the result if n is equal to 0
		STREQ r0,[FP,#0x10]				;Push return value in the stack
		BEQ output 						;Branch to the output section
		
		AND r0,#1						;AND n with 1: if (n & 1)
		CMP r0,#1						;0 in r0 if n is even, 1 in r0 if n is odd
		LDR r0,[FP]						;Get the n parameter from stack and put it in r0
		BNE TELSE						;if r0 is even go to else
		SUB r0,#1						;Subtract 1 from n
		STR r0,[r13]					;Push the parameter on the stack and write over the old n
		SUB r13,r13,#4					;Reserve a space for the return value
		
		BL power						;Call the power subroutine: power(x, n - 1)
		
		LDR r0,[r13],#4					;Load the result in r0 and pop it from stack
		ADD r13,r13,#8					;Remove the parameters from the stack
		MUL r0,r1,r0					;Multiply the result by x: x * power(x, n-1)
		STR r0,[FP,#0x10]				;Store the return value in the stack
		B output
		
TELSE	MOV r0,r0,LSR #1				;Divide n by 2: else 
		STR r0,[r13]					;Push the parameter on to stack and write over old n
		SUB r13,r13,#4					;Reserve space for the return value
		BL power						;Call the power subroutine: y = power(x, n >> 1)
		LDR r0,[r13],#4					;Load the result and pop from the stack
		ADD r13,r13,#8					;Remove the parameters from the stack
		MUL r1,r0,r0					;Multiply the result by itself (y*y)
		STR r1,[FP,#0x10]				;Store the return value in the stack
		
output 	MOV r13,FP						;Collapse all working spaces for this function call
		LDMFD r13!,{r0,r1,FP,PC}		;Load all the registers and return to the caller

		AREA XTOTHEN, DATA, READWRITE

n		EQU 4							;Assign variable n a specific value
x		EQU	3							;Assign variable x a specific value 
result	DCD 0							;Variable to store the result of x^n in
		SPACE 200						;Space for stack
stack	DCD 0							;Beginning of stack

		END