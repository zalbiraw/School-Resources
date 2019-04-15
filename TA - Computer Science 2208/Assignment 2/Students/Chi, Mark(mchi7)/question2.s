		AREA assn4, CODE, READWRITE
		ENTRY
d		EQU 0x32			;value of 50 in decimal
x		EQU	0x03			;value of 3 in decimal
		LDR r9, a			;Register to store the value of a
		LDR r1, b			;register to store the value of b
		LDR r2, c			;register to store the value of c
		MOV r3, #x			;register to store the value of x
		MOV r4, #d			;register to store the value of d
		
		BL func				;branch with a link (go to subroutine)
		LSL r1, r0, #1 		;Double the value of r0 and store it into r1
loop 	B loop				;Endless loop

func	STMIA SP!, {r5-r8}	;store the values of the register on a stack
		MUL r5, r3, r3 		;x^2
		MUL r7, r1, r3		;b*x
		MLA r6, r9, r5, r7	;a*(x^2) + (b*x)
		ADD r8, r6, r2		;r8 = a*(x^2) + (b*x) + c
		CMP r8, r4			;compares y and d
		MOVGT r0, r4		;if y is greater than d, move d into r0
		MOVLT r0, r8		;else move y into r0
		LDMDB SP!, {r5-r8}	;restore the previous values by popping off the stack
		MOV PC, LR			;Go back to the next instruction after BL func
		
		AREA assn4, DATA, READWRITE
a		DCD 0x05			;value of a stored in memory
b		DCD 0x06			;value of b stored in memory
c		DCD	0x07			;value of c stored in memory
		END