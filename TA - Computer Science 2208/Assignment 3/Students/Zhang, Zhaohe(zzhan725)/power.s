		AREA po, CODE, READWRITE
n		EQU		3								;constant n
x		EQU		2								;constant x
		ENTRY
		ADR 	sp, stack						;load stack
		MOV 	r0, #n							;load constant n into r0
		STR 	r0,[sp, #-4]!					;load n into stack
		SUB		sp, sp, #4						;reserve the space for return value
		BL		power							;enter the recursion function
		LDR		r0, [sp], #4					;load the result into r0
		ADD		sp, sp, #4						;remove from stack
		ADR 	r1, result						;store the address of result into r1
		STR		r0, [r1]						;store the value into result
EXIT	B		EXIT							;infinit loop
		
power	STMFD	sp!, {r0, r1, r2, fp, lr}		;push registers and fp, lr into the stack
		MOV		fp, sp							;set the fp for current iteration
		LDR		r0, [fp, #0x18]					;load value n
		CMP		r0, #0							;if n is equal to 0
		ADDEQ	r0, r0, #1						;equal then store 1 into r0
		STREQ	r0, [fp, #0x14]					;store the value into the reserved place
		BEQ		return							;branch to return
		AND		r1, r0, #1						;check if
		CMP		r1, #1							;n is odd
		BNE		even							;branch to even calculation if not equal
		SUB		r1, r0, #1						;get new n for next iteration
		STR		r1, [sp, #-4]!					;store new n into stack
		SUB		sp, sp, #4						;reserve the space for return value for next iteration
		BL		power							;enter the recursion function
		LDR		r0, [sp], #4					;load return value into r0
		ADD		sp, sp, #4						;remove n from stack
		MOV		r1, #x							;load x into r1
		MUL		r2, r1, r0						;calculate result for current iteration(x*power(x, n-1))
		STR 	r2, [fp, #0x14]					;store the result into reserved place
		B		return							;branch to return
		
even	MOV		r1, r0, LSR#1					;devide current n by 2, get new n for next iteration
		STR		r1, [sp, #-4]!					;store new n into stack
		SUB		sp, sp, #4						;reserve the space for return value for next iteration
		BL		power							;enter the recursion function
		LDR		r0, [sp], #4					;load return value into r0
		ADD		sp, sp, #4						;remove n from stack
		MUL		r1, r0, r0						;calculate result for current iteration(y*y)
		STR 	r1, [fp, #0x14]					;sotre the result into reserved place
		
return	MOV		sp, fp							;cpllapse the stack
		LDMFD	sp!, {r0, r1, r2, fp, pc}		;load registers and return to the caller

result	DCD 	0x00							;memory for store the result
		SPACE	0xFF							;space for stack
stack	DCD 	0x00							;initial stack position
		END