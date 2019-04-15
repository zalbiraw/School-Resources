		AREA theCode, CODE, READONLY
		ENTRY
		
		ADR r0, String1				;r0 is a pointer to the first string
		ADR r1, Eos					;r0 holds the address of the end of the string
		ADR r13, String2			;r13 is a pointer to the second string
		MOV r10, #1					;start the counter at 1 so we can detect 'the ' at the beginning
		
first	CMP r0, r1					;see if we have reached the end of the first string
		BEQ stop					;stop if we have
		LDRB r2, [r0], #1			;get the next character from the string then increment

		CMP r2, #' '				;see if the current char is space
		CMPEQ r10, #4				;see if the previous chars were ' the'
		SUBEQ r13, #3				;if yes, pop three
		MOVLE r10, #1				;if no, set counter to one
		BLE store					;skip later checks
		
		CMPNE r10, #1				;if not space, was the previous char space?
		CMPEQ r2, #'t'				;if yes, is the current char t?
		ADDEQ r10, #1				;if yes, increment counter
		BEQ store					;skip later checks

		CMPNE r10, #2				;if not space, was the previous char t?
		CMPEQ r2, #'h'				;if yes, is the current char h?
		ADDEQ r10, #1				;if yes, increment
		BEQ store					;skip later checks

		CMPNE r10, #3				;if not space, was the previous char h?
		CMPEQ r2, #'e'				;if yes, is the current char e?
		MOVNE r10, #0				;if no, reset the  counter (triggered when r10==3 and r2!='e' or r10==4 and r2!=' ')
		ADDEQ r10, #1				;if yes, increment the counter
		CMPEQ r0, r1				;see if this was the last character in the string
		SUBEQ r13, #2				;if yes, pop two
		BEQ stop					;if yes, don't store the e
			
store	STRB r2, [r13], #1			;store the character in the second string
		B first						;loop until we reach the end of string1
stop	STRBEQ r4, [r13], #1		;terminate the string with a null char
		STRBEQ r4, [r13], #1		;terminate the string with a null char
		
loop	B loop						;infinite loop
		
		AREA theCode, DATA, READWRITE

		ALIGN			
String1 DCB "the the the  they 123   the the "
Eos		DCB 0x00
		ALIGN
String2 SPACE 0xFF
			
		END