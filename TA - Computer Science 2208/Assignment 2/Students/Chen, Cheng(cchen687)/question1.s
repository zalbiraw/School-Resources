		AREA assignment2Q1, CODE,READONLY
		ENTRY
		ADR r0,STRING1		;let r0(true pointer) points to STRING1
		ADR r9,STRING1		;let r9(checking pointer) points to STRING1
		ADR r2,STRING2		;let r2(store pointer) points to STRING1
		LDRB r1,[r0],#1		;load the value of r0 into r1 and update automatically
		LDRB r10,[r9],#1	;load the value of r0 into r1 and update automatically
		B LOOP				;jump to loop to start checking
WRITE	CMP r0,r9			;if r0 is not in the same position as r9, keep writing
		BEQ LOOP			;if r0 is in the same position as r9, continue checking 
		STRBNE r1,[r2],#1	;store r1 in the address pointed by r2 and update r2
		LDRBNE r1,[r0],#1	;keep loading and writing until r0 meets r9
		BNE	WRITE			;keep looping until r0 meets r9
LOOP	CMP r10,#0x00		;check if it is the end of string
		STRBEQ r10,[r2],#1	;if it is the end of string,load 0x00 to show the program ends
		BEQ	EXIT			;EXIT if we've end checking
		CMP r10,#0x74		;check if it is a word starting as 't'
 		LDRB r10,[r9],#1	;update checking pointer and register(r10)
		BNE WRITE			;if it is not a 't', write into memory
		CMP r10,#0x68		;if it is a 't', then check if the second one is  a 'h'
		LDRB r10,[r9],#1	;update checking pointer and register
		BNE WRITE			;if not, write these two letters
		CMP r10,#0x65		;if it starts as 'th', then check if the third one is a 'e'
		LDRB r10,[r9],#1	;update checking pointer and register
		BNE WRITE			;if not, write these three letters
		CMP r10,#0x00		;if it starts as 'the',then check if there are any other words follow
		STRBEQ r10,[r2],#1	;if it is the end of string, write 0x00 to end STRING2
		BEQ	EXIT			;then EXIT
		CMP r10,#0x20		;if it is not the end of string, check if it is the word 'the',(no other letters follow) 
		LDRB r10,[r9],#1	;update checking pointer
		LDRBEQ r1,[r0,#2]	;if it is 'the',let r1 equals to 0x20(space) because we only want to delete 'the'
		ADDEQ r0,#3			;if it is 'the',update r0 to jump over this 'the',so we not gonna write into memory
		B	WRITE			;if it is 'the',write "space",if it is not 'the'(then we don't update true pointer r0),write the whole word
EXIT	B EXIT				;this is how we exit

	
STRING1 DCB "and the man said they must go" ;String1
EoS DCB 0x00 ;end of string1
STRING2 space 0xFF ;just allocating 255 bytes
		END