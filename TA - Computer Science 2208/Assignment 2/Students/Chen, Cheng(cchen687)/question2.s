		AREA assignment2Q2, CODE,READWRITE
		ENTRY
		ADR r13,S		;let r13 points to reserved space
		ADR r0,X		;let r0 points to the address of x
		LDR r0,[r0]		;load the value of x into r0 for further calculation
		BL FUNC			;jump into subroutine(function) and save link address in lr
		MOV r1,r0,LSL #1;when come back,after implementing the function,double the value and store in r1
		B EXIT			;exit this program
FUNC	STMIA r13!,{r1-r10}	;store the value from r1 to r10
		ADR r10,A			;let r10 points to the address of parameter a
		LDR r9,[r10],#4		;let r9 gets the parameter a
		LDR r8,[r10],#4		;let r8 gets the parameter b
		LDR r7,[r10],#4		;let r7 gets the parameter c
		LDR r6,[r10]		;let r6 gets the parameter d
		MUL	r1,r0,r8		;b*x first
		MUL r2,r0,r0		;x*x
		MLA r1,r2,r9,r1		;a*x*x+b*x
		ADD	r1,r1,r7		;a*x*x+b*x+c
		MOV r0,r1			;move result into r0
		CMP r6,r0			;compare d and y
		MOVLT r0,r6 		;if y is greater than d,return d
		LDMIA r13!,{r1-r10}	;load the original value of r1 to r10 back
		MOV pc,r14			;return to main function
EXIT	B	EXIT
		

		AREA assignment2Q2, DATA,READWRITE
A	DCD	5
B	DCD	6
C	DCD	7
D	DCD 90
X	DCD 3
S	SPACE 0xFF
	END