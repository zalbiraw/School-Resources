
		
			AREA prog1, code, READONLY
			ENTRY

CaseMask	EQU 0xDF						;this mask is used to convert characters to uppercase
LetterA		EQU 0x41						;this is the ascii equivalent to 'A'
LetterZ		EQU	0x5A						;this is the ascii equivalent to 'Z'
Valid		EQU 1							;store 1 in r0 if it is a palindrome
InValid		EQU 2							;store 2 in r0 if it is not a palindrome

			ADR r1, STRING					;this pointer points to the first character
			ADR r2, EoS-1					;this pointer points to the last character
			MOV r3, #0						;clear the register to store the character iterated by r1
			MOV r4, #0						;clear the register to store the character iterated by r2
			
Loop		
check1		LDRB r3,[r1],#1					;load the character at the current index of r1 and increment it
			AND r3, #CaseMask				;uppercase the character
			CMP r3, #LetterA				;check if its 'less than' A
			RSBSGE r8,r3,#LetterZ			;check if its 'greater than' Z
			BLT check1						;if the character is not in the range of A-Z,
											;check the next character
			
				
check2		LDRB r4,[r2],#-1				;load the character at the current index of r2 and decrement it
			AND r4, #CaseMask				;uppercase the character
			CMP r4, #LetterA				;check if its 'less than' A
			RSBSGE r8,r4,#LetterZ			;check if its 'greater than' Z
			BLT check2						;if the character is not in the range of A-Z,
											;check the next character


			CMP r3,r4						;check if r3 and r4 have the same value
			MOVNE r0, #InValid				;if they are not the same character, store 2 in r0 (not a palindrome)
			BNE Done						;terminate the program if it is not a palindrome
			CMP r1, r2						;check if the r1 index is greater or equal to the r2 index
			BLT Loop						;Keep looping through the program until r1>=r2 (traverse the whole string)
			MOV r0, #Valid					;If the whole string is traversed without the program termininating, it is a palindrome
Done		B	Done						;Branch here forever once the palindrome is determined


STRING	 	DCB "He lived as a devil, eh?"	;string
EoS    		DCB 0x00                    	;end of string

			END