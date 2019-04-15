		AREA question2, CODE, READWRITE
		ENTRY
		
		LDR r2, x				;Load r2 with value of x
		LDR r3, a				;Load r3 with value of a
		LDR r4, b				;Load r4 with value of b
		LDR r5, c				;Load r5 with value of c
		LDR r6, d				;Load r6 with value of d
		BL 	Func1				;call out Func1
		ADD r1, r0, r0			;store the doubled value into r1
Loop 	B	Loop

Func1	MUL r0, r2, r2			;x^2
		MUL r0, r3, r0			;a times x^2
		MLA r7, r2, r4, r5		;bx + c (store in r7)
		ADD r0, r0, r7			;ax^2 + bx + c
		CMP r0,	r6				;compare value of r0 and d
		MOVGT r0, r6			;if r0 is greater than d, then replace r0 with d
		MOV r7, #0				;clear r7
		MOV pc, r14				;return by restoring saved PC
		
		AREA question2, DATA, READWRITE
a		DCD 0x00000005
b		DCD 0x00000006
c		DCD 0x00000007
d		DCD 0x0000005A
x		DCD 0x00000003

		END