			AREA asn4, CODE, READONLY
			ENTRY
	
			LDR r0, X	;loads in the value X in r0
			BL FUNCTION1	;Runs the function
			MOV r1, r0, LSL #1	;doubles the value in r0 (the returned value)
				
				
				
				
FUNCTION1	PUSH {r1-r5}	;pushes the old values in r1-r5 onto the stack to store them
			LDR r1, va	;loads in the registers with new values
			LDR r3, vd	;loads in the value d to r3
			LDR r4, vb	;loads in the value b to r4
			LDR r5, vc	;loads in the value c to r5
			MLA	r2, r1, r0, r4; multiplies r1 by r0 and adds r4 and stores the value in r2 (ax+b)
			MLA r0, r2, r0, r5; multiples the value in r2 by r0 and adds r5 (x(ax+b)+c=ax^2+bx+c)
			CMP r0, r3	;compares the y value (r0) to d (r3)
			MOVGT r0, r3	;if y is greater replaces the y value with d
			POP {r1-r5}	;restores the old register values by popping items off the stack
			MOV pc, lr	;returns to where the function was called
				
			AREA sn4, DATA, READONLY
va			DCD 2
vb			DCD 3
vc			DCD 4
vd			DCD 70
X			DCD 5

			END