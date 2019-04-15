		AREA arithmetic, CODE, READWRITE
		ENTRY
start
		ADR		r13,stack			;initialize stack (r13 = new Stack(20))
		ADR		r0,x				;load address of x
		BL		func				;branch with a link to function
		ADD		r1,r0,r0			;double to value inside r0 and store it in r1
loop	
		B	loop					;infinite debugging loop
func	
		STMIA	r13!,{r1-r8}		;store current values of registers in stack
		LDMIA	r0!,{r1-r5}			;load values of x, a, b, and c into their respective registers
		MLA		r7,r1,r3,r4			;multiple x by b and add it together with c. Store the value in register 7
		MUL		r8,r1,r1			;square the value of x and store it in register 8
		MLA		r7,r8,r2,r7			;multiple x^2 by a and add to total 
		MOV		r0,r7				;move total to register 0
		CMP		r0,r5				;compare y to d
		MOVGT	r0,r5				;IF y is bigger than d, store d in register 0
		LDMIA	r13!,{r1-r8}		;reset all used registers to original values
		BX 		LR					;return to calling routine
					
		AREA arithmetic, DATA, READWRITE
x		DCD		3
a		DCD		-5
b		DCD		6
c		DCD		7
d		DCD		10
stack	space	20
		END