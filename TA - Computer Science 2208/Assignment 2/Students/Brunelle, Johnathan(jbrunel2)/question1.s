			AREA RemoveThe, CODE, READONLY
			ENTRY

			ADR r0, inputString							; Point to the start of the first String
			ADR r1, outputString						; Point to the start of the string to write to
			
			MOV r3, #'t'								; Store t incase the first word is the
			MOV r4, #'h'								; Store h incase the first word is the
			MOV r5, #'e'								; Store e incase the first word is the
			
			
Loop		LDRB r2, [r0], #1							; Load the next character in the String
			CMP r2, #0x00								; Check if it's the end of the String
			BEQ Done									; If so, then exit
			
			CMP r2, #'t'								; Check if next character is t
			STRBNE r2, [r1], #1							; If not, then store the character
			BLNE Store									; Then store every other character until next space
			BNE Loop									; loop back to the start
			
			LDRB r2, [r0], #1							; Get next character
			CMP r2, #'h'								; Check if next character is h
			STRBNE r3, [r1], #1							; If not, then store the last t we removed 
			STRBNE r2, [r1], #1							; If not, then store the current character
			BLNE Store									; Store the rest of the word
			BNE Loop									; Repeat for next character
			
			LDRB r2, [r0], #1							; Get next character
			CMP r2, #'e'								; Check if next character is e
			STRBNE r3, [r1], #1							; If not, then store the last t we removed 
			STRBNE r4, [r1], #1							; If not, then store the last h we removed 
			STRBNE r2, [r1], #1							; If not, then store the current e
			BLNE Store									; Store the rest of the word
			BNE Loop									; Repeat for next character
					
			LDRB r2, [r0], #1							; Get next character
			CMP r2, #' '								; Check if space
			STRBNE r3, [r1], #1							; If not, then store the last t we removed 
			STRBNE r4, [r1], #1							; If not, then store the last h we removed 
			STRBNE r5, [r1], #1							; If not, then store the last e we removed 
			STRB r2, [r1], #1							; Store the current character
			B Loop										; Loop for next character

Store		LDRB r2, [r0], #1							; Load the next character
			CMP r2, #' '								; Check if null/end of string, since nothing should be lower than space in ASCII
			BEQ Done									; If so, then the word is over, so get next char
			
			STRB r2, [r1], #1							; Store the character
			BNE Store									; Loop until next character is a space
			
			CMP r0, #0xFF								; Used to clear flags from function
			MOV r15,r14									; Jump back to main routine
			
Done		b Done										; End loop

			AREA RemoveThe, CODE, READWRITE
inputString 	DCB "the them    the123 the"				; String to remove 'the' from
EoS     		DCB 0x00                           			; End of the first String
outputString 	space 0xFF 									; Space to store new parsed string
				END