		AREA question2, CODE, READONLY
		ENTRY
		
main	LDR r0, x ;loasd value of x to r0
		ADR sp, stack ;set up stack pointer
		BL func1
		;double the result in r0 and store it in r1
		;same as logical shift left by 1 bit
		MOV r1, r0, LSL #1 ;move to r1 the value of r0 logical left shifted by 1 bit
		
loop	b loop

		AREA question2function, CODE, READONLY
		
		
func1	STMFD sp!, {r1-r5} ;store registers (r1-r5) at destination stack pointer
		;multiply a*x^2 and store it in r3
		LDR r1, a; load value of a in r1
		LDR r2, varB ;load value of b in r2
		LDR r3, c ;load value of c in r3
		MLA r5, r0, r1, r2 ;multiply r0 by r4 (a*x) and add r2 to the result (b), store it in r5
		MOV r1, r5 ;move r5 to r1
		MUL r2, r1, r0;multiply r1 (ax+b) with r0 (x), result will be ax^2+bx and store itin r2
		ADD r3, r2 ;add r2 and r3 and store it in r3. result will be ax^2+bx+c
		;r3 now holds the value of y
		LDR r4, d; load d to r4
		;compare d with the value of y, r3 with r4
		CMP r3, r4; compare value of y and d
		MOVGT r0, r4;if y > d, move the value of r4 to r0 to return the value of d
		MOVLE r0, r3;else move the value of y to r0
		;restore values of working registers before returning function
		LDMIA sp!, {r1-r5} ;subrountine is complete, restore the registers
		MOV r15, r14 ;copy address from r14 to r15 and return from function
		
		;---------fix compare function
		;------ figure out how to reset registers
		
		AREA question2, DATA, READWRITE
		;assign directive values for the parameters
a		DCD	5
varB	DCD	6
c		DCD	7
d		DCD 90
x		DCD 3	
		space 20 ;reserve room for stack to grow up
stack	DCD 0x0 ;the base of the stack			
		END
		