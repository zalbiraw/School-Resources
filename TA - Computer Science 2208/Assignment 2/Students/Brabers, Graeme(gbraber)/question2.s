		AREA Assignment_4_2_code, CODE, READONLY
		ENTRY
		LDR r0, x							;Load x into r0
		BL Calc								;Call Calc function
		MOV r1, r0, LSL #1					;Double the result in r0, set to r1
Loop	B Loop

Calc	LDR	sp, =Stack						;Load stack address
		STMIA sp!, {r1-r2}					;Store contents of r1-r3, pc to the stack
		LDR r1, b							;Load b into r2
		LDR r2, c							;Load c into r3
		MLA r1, r0, r1, r2					;Multiply r0 (x) by r2 (b) and add r3 (c), put into r2
		MOV r0, r0, LSL #1					;Move r0 (x) to r1, multiply it by 2
		LDR r2, a							;Load a into r1
		MUL r1, r0, r2						;Multiply r0 (2x) by r1 (a), put it in r1
		ADD r0, r1, r2						;Add r0 (ax^2) to r1 (bx + c), put into r0
		LDR r2, d							;Load d into r2
		CMP r0, r2							;Compare the value of r0 (y = ax^2 + bx + c) and r2 (d)
		MOVGT r2, r0						;If y is greater than d, set d to r0
		LDMDB sp!, {r1-r2}					;Load contents from stack back to pc, r3-r1
		MOV pc, lr
		
		AREA ASsignment_4_2_data, DATA, READWRITE
a		DCD 2								;Value of a
b		DCD 3								;Value of b
c		DCD 5								;Value of c
d		DCD 10								;Value of d
x		DCD 5								;Value of x
Stack	SPACE 0x8							;Stack space
		END