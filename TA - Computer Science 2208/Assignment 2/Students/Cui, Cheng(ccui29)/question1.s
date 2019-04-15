		AREA question1, CODE, READONLY
		ENTRY
		
ED		EQU		0x00			;setup ED as the end of the STRING1 equals to 0x00
WS		EQU		0x20			;setup WS as the white space in ASCII code equals to 0x20
t		EQU		0x74			;setup t in ASCII code equals to 0x74
h		EQU		0x68			;setup h in ASCII code equals to 0x68
e		EQU		0x65			;setup e in ASCII code equals to 0x65
		
		ADR		r4,STRING1-1	;setup the pointer r4 and point to 1 space before the STRING1
		ADR		r1,STRING2		;setup the pointer to point at the stack STRING2
		MOV		r2,#1			;setup r2 equals to 1 as the increment value
loop1	LDRB	r3,[r4,r2]!		;load the value from STRING 1 and store in r3, alos increment the pointer by r2 automatically
		CMP		r3,#ED			;check if it is the end of the STRING 1
		BEQ		loop			;exit if it is the end of the STRING 1
		CMPNE	r3,#t			;if it is not the end and compare r3 with t
		LDRBEQ	r5,[r4,r2]!		;if r3=t then check the next value and store in r5
		STRBNE	r3,[r1],r2		;if r3 is not equal to t then store the value in the stack with the pointer r1 and increment by r2
		BNE		loop1			;also go back to loop1 to check the next value
		CMPEQ	r5,#h			;if r3=t also check if the next value r5=h
		LDRBEQ	r6,[r4,r2]!		;if r5=h then check the next value and store in r6
		STRBNE	r3,[r1],r2		;if r5 is not equal to h then store the value from r3 to the stack
		STRBNE	r5,[r1],r2		;also store the value from r5 to the stack
		BNE		loop1			;go back to loop1 to check the next value as well
		CMPEQ	r6,#e			;if r5=h also check if the next value r6=e
		LDRBEQ	r7,[r4,r2]!		;if r6=e then check the next value and store in r7
		STRBNE	r3,[r1],r2		;if r6 is not equal to e then store the value from r3 to the stack
		STRBNE	r5,[r1],r2		;also store the value from r5 to the stack
		STRBNE	r6,[r1],r2		;as well as store the value from r6 to the stack
		BNE		loop1			;go back to loop1 to check the next value as well
		CMPEQ	r7,#WS			;if r6=e also check if the next value r7=white space
		BEQ		loop1			;if r7=white space back to loop1 to check the next value without store "the "
		CMPNE	r7,#ED			;if r7 not equal white space then check if the next value r7=the end of the STRING1
		BEQ		loop			;if r7=the end of the STRING1,then exit without store "the"
		STRBNE	r3,[r1],r2		;if r7 no equals to white space or the end of the STRING 1, store the value r3 to the stack
		STRBNE	r5,[r1],r2		;store the value r5 to the stack
		STRBNE	r6,[r1],r2		;store the value r6 to the stack
		STRBNE	r7,[r1],r2		;store the value r7 to the stack
		BNE		loop1			;also go back to loop1 the check the next value
		
loop	B		loop			;finished

		AREA question1, DATA, READWRITE
			
		ALIGN					;change the memary map at 0x78 to read and write
STRING1	DCB		"the" 			;STRING1
EoS		DCB		0x00			;end of STRING1
		ALIGN
STRING2	space	0xFF			;stack
		END