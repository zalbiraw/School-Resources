	
	AREA Power, CODE, READONLY
	ENTRY
	

Base	EQU 	8				; define base number
Exp		EQU 	3				; define exponent number
	
Load_values

		MOV		r0, #Base		; store base number in register
		MOV		r1, #Exp		; store target exponent in register to act as a counter
 		MOV		r2, #0			; set up a stack counter
		BL		Fill_stack		; move to Fill_stack step to begin multiplication
		
Fill_stack
	
		CMP		r1, #0			; check if exponent counter is equal to 0, and loop until it is
		BEQ		Empty_stack		; move to Empty_stack section if the counter reaches 0		
		ADD 	r2, r2, #1		; increment the stack counter
		ADD		r13, r13, #4	; move up stack memory address
		STR 	r0, [r13]		; store the base number at the top of the stack
		SUB		r1, r1, #1		; decrement exponent counter
		B		Fill_stack		; return to top of loop
		
Empty_stack		

		SUB 	r2, r2, #1		; decrement stack counter
		CMP		r2, #0			; check if stack counter is equal to 0, and loop until it is
		BEQ		Exit_stage		; move to Exit_stage section if the counter reaches 0
		LDR 	r4, [r13]		; store value at top of stack in r4
		SUB		r13, r13, #4	; move down stack memory address
		LDR		r5, [r13]		; store new top of stack value in r5
		MUL 	r6, r4, r5		; multiply the top two values retrieved from the stack and store in r6
		STR		r6, [r13]		; store result in lower level of stack
		B		Empty_stack		; return to top of loop
		
Exit_stage

		STR 	r7, [r13]		; store final top of stack value at r6

	END