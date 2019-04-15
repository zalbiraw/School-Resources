		AREA q_2, CODE, READONLY
		ENTRY
		LDR r0, x
		BL FUNC1
		B DON
FUNC1	LDR r2, a	;SET VALUES TO REGISTERS BUT REMEMBER TO SET BACK TO ORIGNAL VALUE
		LDR r3, b
		LDR r4, c
		LDR r5, d
	
		MUL r6, r0, r0	;Go through with order of operations. 
		MUL r7, r6, r2	;Mulitply the square with a
		MUL	r2, r3, r0	;Multiply b and x together
		ADD r3, r7, r2	;Add first two together
		ADD r6, r3, r4	;Add last value to y
		CMP r6, r5		;compare to see which value to get moved to r0
		MOVGT r0, r5	;If greater, set d into r0
		MOVLT r0, r6	;If less than, set y into r0
		MOV r2, #0		; RETURN ALL VALUES TO ORIGINAL VALUE
		MOV r3, #0
		MOV r4, #0
		MOV r5, #0
		MOV r6, #0
		MOV r7, #0
		MOV pc, lr		
DON		MOV r1, r0, LSL #1	;Multiply r0 by two and set into r1
		
		AREA q_2, DATA, READWRITE
a		DCD 5
b		DCD 6
c		DCD 7
d		DCD 50
x		DCD 3
		END