			AREA question2, CODE,READONLY
			ENTRY
	
main		MOV		r1,#2		;store 2 into r1 in order to double the value
			BL		function1	;call the function1
			MUL		r1,r0,r1	;multiply r0 by r1 to get the final result
loop		B		loop		;finished
	
function1	LDR		r0,x		;store the value of x into r0
			LDR		r2,a		;store the value of a into r2
			LDR		r3,b		;store the value of b into r3
			LDR		r4,c		;store the value of c into r4
			LDR		r7,d		;store the value of d into r7
			MLA		r5,r0,r3,r4	;multiply x with b and add c store the result into r5
			MUL		r6,r0,r0	;multiply x by x and store into r6
			MLA		r0,r6,r2,r5	;multiply a with x^2 and plus r5 which is (b*x+c) to get the totaly y and store in r0
			CMP		r0,r7		;compare y with b
			LDRGT	r0,d		;if y>d the store value d into r0
			MOV		r15,r14		;return funcation to main



a			DCD		-5			;defined the value of parameter of a
b			DCD		6			;defined the value of parameter of b
c			DCD		7			;defined the value of parameter of c
d			DCD		10			;defined the value of parameter of d
x			DCD		3			;defined the value of parameter of x
			END