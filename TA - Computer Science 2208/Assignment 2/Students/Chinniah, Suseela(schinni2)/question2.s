			AREA question2, CODE, READONLY
			ENTRY
			ADR sp, stack			;we will need the stack to save registers when the subroutine is executed
			LDR r0, X				;initialize r0 with X
			BL quadratic			;call the function
			ADD r1, r0, r0			;store double the value of r0 in r1
endless		B endless			
quadratic	STMFD sp!, {r1-r12}		;save register values
			LDR r1, A				;initialize r1-r3 with coefficients
			LDR r2, B
			LDR r3, C
			MUL r1, r0, r1			;calculate A * X
			MLA r3, r2, r0, r3		;calculate B * X + C
			MLA r0, r1, r0, r3		;calculate (A*X)* X + (B*X+C) and store in r0
			CMP r0, #D				;compare it to value D
			LDRMI r0, D				;if Y > D, replace r0 with D
			LDMFD sp!, {r1-r12}		;restore register values
			MOV pc, lr				;return to program
			
			AREA question2, DATA, READWRITE

A			DCD -5
B			DCD 6
C			DCD 7
D			DCD 10
X			DCD 3
			SPACE 0x40
stack		DCD 0x0

			END