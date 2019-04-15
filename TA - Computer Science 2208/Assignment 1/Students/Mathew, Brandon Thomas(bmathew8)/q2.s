		AREA QUESTION2, CODE, READWRITE
		
		LDR r0, =STRING			;load and initialize given STRING in r0
		LDR r8, =TEMP			;load and initialize TEMP in r8, to store mined ASCII chars
		LDR r9, =EoS			;Make r9 the value of the End of String
		
		MOV r1, #0				;pointer for STRING chars
		MOV r5, #0				;pointer for TEMP chars			
		
MINELOOP						;the MINELOOP allows us to mine for ASCII chars from memory
		LDRB r2, [r0, r1]		;load byte with pointed char into r2
		
		CMP r2, #122			;check if char is 'z' (ASCII undercase range = 97-122)
		BGT NOTALPHABET			;ASCII values greater than 122 are not alphabet
		CMP r2, #97				;next we check if the ASCII value is part of the undercase alphabet
		BGT UNDERCASE			;if so, it is undercase and it branches to handle the special case
		CMP r2, #90				;if it isn't undercase, we need to see if it is a uppercase or not
		BGT NOTALPHABET			;the ASCII values 91-96 are not alphabet
		CMP r2, #65				;however, ASCII values between 65 and 90 ARE uppercase alphabet
		BGT ALPHABET			;uppercase and lowercase alphabet are both valid
		B NEXT					;branch to get the next char
	
ALPHABET
		STRB r2, [r8, r5]		;store the pointer value into r2 for TEMP
		ADD r5, r5, #1			;increment the TEMP pointer

NOTALPHABET	
		B NEXT					;non-alphabet chars like '?' are ignored so just look for the next value

UNDERCASE
		SUB r2, r2, #32			;for consistency, we will convert all undercase to uppercase by subtracting 32
		B ALPHABET				;upon conversion, it is uppercase

NEXT	
		ADD r1, r1, #1			;increment the STRING pointer to get next value
		LDRB r7, [r0, r1]		;load next byte so we know if we reached the end
		CMP r7, #0x00			;check if end of string
		BNE MINELOOP			;MINELOOP will not terminate until we reach the end
		
		MOV r1, r5				;r1 is the pointer traversing from right to left
		SUB r1, r1, #1			;minus 1 since it is currently pointed at the EoS locations
		MOV r2, #0				;r2 is the pointer traversing from left to right
		
CHECK
		LDRB r3, [r8, r1]		;we check if given string is valid palindrome, starting by loading pointers
		LDRB r4, [r8, r2]		;load the second pointer
		ADD r2, r2, #1			;increment L-R pointer by 1
		SUB r1, r1, #1			;decrement R-L pointer by 1
		CMP r3, r4				;the pointed chars MUST ALWAYS be identical for it to be a valid palindrome
		BNE NOT					;instance of unmatched chars breaks and means it is not a palindrome
		
		CMP r2, r1				;if the pointers have crossed paths, we can proceed to the end
		BLT CHECK				;otherwise, there are still chars to iterate through
		B YES					;finally, we can exit this subroutine to have it marked as a YES

YES
		MOV r0, #1				;store 1 in r0 if indeed a palindome

NOT
		MOV r0, #2				;store 2 in r0 if not a palindome
		B endloop

endloop	b endloop
	
		AREA QUESTION2, DATA, READWRITE
STRING 	DCB "He lived as a devil, eh?"		;the string
TEMP	DCB 0x00							;temp string
EoS		DCB 0x00							;End of String
	
		END