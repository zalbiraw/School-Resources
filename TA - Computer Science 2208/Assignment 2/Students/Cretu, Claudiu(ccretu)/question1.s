			AREA question1, CODE, READWRITE
			ENTRY
		
			LDR r0, =STRING1					; Load the value of STRING1 into r0. This string will contain any instances of "the"
			LDR r1, =EoS						; Load the value of EoS which is 0x00. This represents the end of string
			LDR r2, =STRING2					; Load the space needed for STRING2 into r2. This is where the new string will be stored
			MOV r7, #32							; r7 will represent the last letter that was stored into STRING2. Its initial value is #32, which represents a space in ASCII

Loop1		LDRB r3, [r0], #1					; Load a character (byte) from STRING1 into r3 and post increment
			MOV r6, #0							; r6 will represent the counter for when we test for an instance of "the"
			CMP r3, #0x00						; If the character in r3 is the end of STRING1, then terminate
			BEQ Finished						; Branch to the termination line
			
			CMP r7, #32							; If the last letter stored in STRING2 was a space, then continue to test for an instance of "the"
			CMPEQ r3, #'t'						; If the current character stored in r3 is "t", store it in r8 and test for an instance of "the"
			MOVEQ r8, r3						; Store the value of t in r8
			BLEQ test							; Branch link to the test function, here STRING1 will be tested for an instance of "the"
				
			
			STRB r3, [r2], #1					; Store the character from r3 into r2 (STRING2)
			MOV r7, r3							; Move the stored character to r7 to keep count of the last stored letter
			B Loop1								; Loop back to continue reading characters
			
			
			

test		LDRB r3, [r0], #1					; Load a character (byte) from STRING1 into r3 and post increment
			ADD r6, r6, #1						; Increment the counter
			CMP r3, #0x00						; If the character in r3 is the end of STRING1, then terminate
			BEQ Finished						; Branch to the termination line
			
			
			
			CMP r6, #1							; If the counter is 1 then branch to test if the character is h
			BEQ hTest							; Branch to hTest to test if the second character is an h
			
			CMP r6, #2							; If the counter is 2 then branch to test if the character is e
			BEQ eTest							; Branch to eTest to test if the third character is an e
			
			CMP r6, #3							; If the counter is 3 then check if it the character in r3 is a space (meaning it is an instance of "the")
			CMPEQ r3, #' '						; If the character is a space then do nothing. This means that we will not store the instance of "the" into STRING2
			STRBNE r8, [r2], #1					; If the character is not a space then store t in STRING2
			STRBNE r9, [r2], #1					; If the character is not a space then store h in STRING2
			STRBNE r10, [r2], #1				; If the character is not a space then store e in STRING2
			
			
			MOV r15, r14						; Return back to the branch link call of test
			
hTest		CMP r3, #'h'						; If the character stored in r3 is h, then store it in r9
			MOVEQ r9, r3						; Store h in r9	 
			BEQ test							; If the second character is h then branch back to test to continue testing for an instance of "the"
			STRBNE r8, [r2], #1					; If the second character is not an h then store t in STRING2
			MOV r15, r14						; Return back to the branch link call of test
			
eTest		CMP r3, #'e'						; If the character stored in r3 is e, then store it in r10
			MOVEQ r10, r3						; Store e in r10	 
			BEQ test							; If the second character is e then branch back to test to continue testing for an instance of "the"
			STRBNE r8, [r2], #1					; If the second character is not an e then store t in STRING2
			STRBNE r9, [r2], #1					; If the second character is not an e then store h in STRING2
			MOV r15, r14						; Return back to the branch link call of test
			
			
		
Finished 	B Finished			
		
		AREA question1, CODE, READONLY
STRING1 DCB "and the man said they must go"		; The value of STRING1 will be tested for any instances of "the"
EoS		DCB 0x00								; End of string value
STRING2 space 0xFF								; Allocate space for STRING2								
		END