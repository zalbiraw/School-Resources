				AREA questionTwo, CODE, READONLY
				ENTRY
del				EQU		0xFF			;Deleted characters will be set to 0xFF
				LDR		r0, =STRING		;Loading string
				MOV		r4, #del		;Setting up r4 with del so that it can be stored in an address
parseString
				LDRB	r1, [r0, r2]	;Loading the first character into r1 so it can be parsed
				CMP		r1, #'A'		;Converting upper case to lower case
				RSBGES	r3, r1, #'Z'	
				ORRGE	r1, r1, #0x0020
				
				STRB	r1, [r0, r2]	;Storing character to be checked
				CMP		r1,	#'a'		;if character is less than 'a' 
				STRLTB	r4, [r0, r2]	;store 'del' in its place
				CMP		r1, #'z'		;if character is greater than 'z' 
				STRGTB	r4, [r0, r2]	;store 'del' in its place
				
				CMP		r1, #0			;Testing for the EoS
				ADDNE	r2, #1			;Add one to r2 if there are more characters
				BNE		parseString		;Loop otherwise
				
				SUB		r2, #1			;Decrementing counter because index starts at 0
check
				LDRB	r1,	[r0, r5]	;First pointer
				LDRB	r3,	[r0, r2]	;Second pointer
				CMP		r2, r5			;Testing to see if indexes have crossed over
				BLT		valid			;If so branch to valid
	
				CMP		r1,	#del		;Checking to see if the character should be skipped
				ADDEQ	r5, #1			;Increment fisrt pointer
				BEQ		check			;Contiue checking until r1 is a valid character
				CMP		r3,	#del		;Contiue checking until r3 is a valid character
				SUBEQ	r2, #1			;Decrement second pointer
				BEQ		check			;Contiue checking until r3 is a valid character

				CMP		r1, r3			;Comparing characters
				MOVNE	r6, #2			;If not matching setting a flag
				ADDEQ	r5, #1			;If matches increase r5 
				SUBEQ	r2, #1			;and decrease r2
				BEQ		check			;Continue checking if characters match
				
valid									
				CMP		r6, #2			;If there was a previous pair of characters that did not match
				MOVEQ	r0, #2			;r6 would be equal to 2, so move 2 into r0
				MOVNE	r0, #1			;If r6 is not equal to 2 then the string is a palindrome so move 1 into r0
				
				
STRING 			DCB "He lived as a devil, eh?" ;string
EoS 			DCB 0x00 ;end of string 
				END