				AREA is_palindrome, CODE, READWRITE
				ENTRY								;Start program
		
				LDR		r0, =STRING					;Store string in r0 so we can access it. r0 will go index from left to right			
				MOV		r1, r0						;r1 will index word from right to left
					
					
LASTCHAR		LDRB 	r2, [r1], #1				;LASTCHAR will make r1 point to the right most letter - increases the index of r1 each loop
				CMP 	r2, #0x00					;If r2 is not equal to the end string
				BNE 	LASTCHAR					;We loop until it is
				SUB 	r1, r1, #2					;We want r1 to point to last letter, not end string, so move it to the left 2 spots
				
PALCHECK											;PALCHECK iterates over word and determines if it is a palindrome
													;MOVEFRONT moves the front pointer
MOVEFRONT		LDRB 	r3, [r0]					;stores the value being pointed to so that we can compare it
				ADD		r0, r0, #1					;moves pointer 1 to the right
				CMP 	r3, #65						;if r3 < 65
				BLT		MOVEFRONT					;we move pointer because it is not pointing a valid character
				CMP		r3, #122					;if r3 > 122
				BGT		MOVEFRONT					;we move pointer to the right because it is not pointing at valid char
				CMP		r3, #91						;if r3 < 91 but > 65
				ADDLT	r3, r3, #32					;it is an uppcase character - add 32 to it to make it lowercase
				CMP		r3, #97						;if r3 >91 but <97
				BLT		MOVEFRONT					;it is an invalid character, so move pointer forward

													;MOVEBACK moves the back pointer
MOVEBACK		LDRB	r4, [r1]					;stores the value being pointed to so that we can compare it
				SUB		r1, r1, #1					;moves pointer 1 to the left
				CMP 	r4, #65						;if r3 < 65
				BLT		MOVEBACK					;we move pointer because it is not pointing a valid character
				CMP		r4, #122					;if r3 > 122
				BGT		MOVEBACK					;we move pointer to the right because it is not pointing at valid char
				CMP		r4, #91						;if r3 < 91 but > 65
				ADDLT	r4, r4, #32					;it is an uppcase character - add 32 to it to make it lowercase
				CMP		r4, #97						;if r3 >91 but <97
				BLT		MOVEBACK					;it is an invalid character, so move pointer forward

COMPARE			CMP		r3,r4						;if r3 and r4 are not equal
				MOVNE	r0,#2						;not palindrome store 2 in r0
				BNE		ENDPROG						;end program			
				CMP		r0,r1						;if r0 and r1 are equal
				BEQ		ISPAL						;word is pal
				SUB		r5, r1, #1					;checks if r1-1 is equal to r0, incase word has even # of letters
				CMP		r0,r5						;if equal:
				BEQ		ISPAL						;word is pal
				B		PALCHECK					;moves index and checks if inner two more letters are the same
				
ISPAL			MOV		r0,#1						;puts 1 in r0

ENDPROG			B		ENDPROG						;end program
				
				
		
		
		
				AREA is_palindrome, DATA, READWRITE
STRING	DCB		"He lived as a devil, eh?"			;string
EoS		DCB		0x00								;end of string
				END
		