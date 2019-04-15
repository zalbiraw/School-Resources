	AREA question2, CODE, READONLY
	ENTRY
	
		LDR		r0, x						;Load x from memory into program
		BL		funct						;Branch to function from program
		MOV		r1, r0, LSL#1				;Shift returned value in r0 left 1, multiplying value by 2 and then store value in r1
Loop	B		Loop						;Infinite loop indicating end of program
;------------------------------------------------------------
funct	STMFD	r13!, {r1-r10}				;Store memory of registers in registers r1 through r10
		ADR		r1, a						;Store address of a in r1
		LDMIA	r1!, {r2-r6}				;Load the next 5 values in memory into registers r2 through r6 through incrementing and writing back to pointer, storing values in stack 
		MLA		r8, r3,r0,r4				;Store value of ([r3]x[r0] + [r4]) in r8
		MUL		r9, r6,r0					;Store value of ([r6]x[r0]) in r9
		MLA		r10,r9,r2,r8				;Store value of ([r9]x[r2] + [r8]) in r10
		CMP		r10, r5						;Compare the values of "d" and "y" through registers r10 and r5
		MOVGT	r0, r5						;If value of r5 is greater than r10, move value of r5 into r0
		MOVLE	r0, r10						;If value of r5 is less than or equal to r10, move value of r10 into r0
		LDMFD	r13!,{r1-r10}				;Clear the stack, values of registers will be restored following this instruction
		MOV		r15, r14					;Copy return address in r14 to PC 
;--------------------------------------------------------------
	AREA question2, DATA, READWRITE	
a		DCD		5							;Store value of a
b		DCD		6							;Store value of b 
c		DCD		7							;Store value of c
d		DCD		90							;Store value of d
x		DCD		3							;Store value of x
stack	space	36							;Allocate memory for the stack 
	
		END