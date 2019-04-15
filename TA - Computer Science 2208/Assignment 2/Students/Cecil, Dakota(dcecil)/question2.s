	AREA polynomial, CODE, READWRITE
	ENTRY
	
	LDR r0, X								;load the value of X into the register
	BL	POL									;call polynomial function
	MOV r1, r0, LSL #1						;store double r0 in r1
lp 	B lp									;loop indefinitely

;-------------------------------
POL ADR r13, X								;load start index of register storage location - 4 bytes, into the stack pointer
	STMIB r13!, {r1-r5, r14}				;save current values of registers to be used in POL
	ADR r5, X								;load index of end of data + 4 bytes, into r5
	LDMDB r5!, {r1-r4}						;r1 = a, r2 = b, r3 = c, r4 = d
	
	MLA r5, r1, r0, r2						;y = ax+b
	MLA r0, r5, r0, r3						;y = ax^2+bx+c, now in r0
	
	CMP r0, r4								;is y > d
	MOVGT r0, r4							;if yes, return d in r0, else return y in r0
	
	LDMDA r13!, {r1-r5, r15}				;restore registers, except the stack pointer, and set PC to LR
;-------------------------------	
	
	AREA polynomial, DATA, READWRITE
	
AA	DCD	-5									;store a in memory
BB	DCD	6									;store b in memory
CC	DCD	7									;store c in memory
DD	DCD	10									;store d in memory
	
X	DCD 3									;store x in memory
	
	END