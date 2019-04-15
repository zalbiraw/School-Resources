	; -- Connor Cozens - 250902936 -- ;	
		AREA	assignment4q2, CODE, READONLY
		ENTRY
		ALIGN
	; -- Setup of Function -- ;
setup	LDR		r0,		x				;load x into r0
		MOV		r6, 	#0x00			;put the null character into r6
		BL		funk					;Branch with a link to the funktion
		MOV		r1, 	r0, LSL #1		;Multiply x by 2 and store it in r1
break	b		break					;To prevent readwrite error
		
funk	STMDB	r13!,	{r1-r5, r14}	;Store registers 1-5 into the stack with the link register
	;-- Data Section --;
		LDR		r1, 	a				;Load values
		LDR		r2,		b				;From data section
		LDR		r3, 	c				;Into
		LDR		r4, 	d				;Registers
	; -- Equation and Formula stuff -- ;
		MLA		r2, 	r0, r2, r3		;Multiply  x and b, then add c and store it in r2
		LDR		r5, 	x				;Store x into r5
		MLA		r0, 	r5, r5, r6		;Multiply x by itself to square it, then add 0
		MLA		r0, 	r1, r0, r2		;Multiply a by the new value of x and then add c
	; -- Comparison -- ;
		CMP		r4,		r0				;Check if the final y value is smaller or larger
		MOVGT	r0, 	r4				;If it's greater, set the value of d into y
		LDMIA	r13!, 	{r1-r5, r15}	;Load registers and the PC value
		
	; -- Data Declarations -- ;
		AREA	assignment4q2, DATA, READWRITE
a		DCD		5						;Data section
b		DCD		6						;Containing
c		DCD		7						;All the
d		DCD		10						;Data values
x		DCD		3						;For testing
		SPACE	64						;Create room for the stack
MEM		DCD		0x00					;Create final 
		END