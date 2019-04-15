	AREA question1, CODE, READONLY
			
			ENTRY
			
			LDR r0,=STRINGONE	;Store the address of the string that we want to remove 'the' from in r0
			LDR r1,=STRINGTWO	;use r1 to contain the address of the filtered expression.
			
TOP			LDRB r3, [r0],#1	;Store a character from the string to be filtered in register r3 and increment the pointer to the next character
			CMP r3, #116		;Check if the loaded character is equivalent to a lowercase t
			BEQ CheckThe		;If equivalent to a lowercase t, we branch to a subroutine where we determine whether or not there is a valid the to remove
CONTINUE	STRB r3,[r1],#1		;Here, we store the letter of the string contained in register r3 into the destination string, where 'the' will be removed
			CMP r3,#0			;If the value previously stored was 0, then we reached the end of the unfiltered string and can terminate the program
			BNE TOP				;If the EoS character has not yet been reached, then cycle through the next character in the string to be filtered
		
DONE		B DONE				;Branch continuously to end the program
		
CheckThe	MOV r4, r0 			;Pass the current location in the unfiltered string to the register r4 to scan for 'the'
			LDRB r5,[r1,#-1]	;First, we load the previous character stored in the filtered string into register r5
			CMP r5,#32			;If the most recent character stored is a space, then we will continue to check if it is a valid 'the'
			BEQ NEXT			;Branch to continue checking if we can remove 'the'
			CMP r5,#0			;If the most recent character stored is a 0 (meaning that the t is the first character in the string), then we will continue to check if it is a valid 'the'
			BNE CONTINUE		;Branch back to the main loop because there was no valid 'the' to remove
NEXT		LDRB r5,[r4],#1		;Load r5 with the value in the string that follows t
			CMP r5,#104			;If the following value is 'h', then we continue checking for a valid 'the'
			BNE CONTINUE		;Branch back to the main loop because there was no valid 'the' to remove
			LDRB r5,[r4],#1		;Load r5 with the value in the string that follows h
			CMP r5,#101			;If the following value is 'h', then we continue checking for a valid 'the'
			BNE CONTINUE		;Branch back to the main loop because there was no valid 'the' to remove
			LDRB r5,[r4]		;Load r5 with the value in the string that follows e
			CMP r5,#0			;If the following value is 0, then wecan remove 'the'
			BEQ REMOVE			;Branch to remove the valid 'the'
			CMP r5,#32			;If the following value is a space, then we can remove 'the'
			BNE CONTINUE		;Branch back to the main loop because there was no valid 'the' to remove
REMOVE		MOV r0,r4			;To remove 'the' we simply adjust r0 to point past 'the', as to prevent, it from being stored in the new string
			LDRB r3,[r0],#1		;Store the following value in r3, and increment to point to next value in string
			B CONTINUE			;Continue to the main loop as we scan through the string
		
	AREA question1, DATA, READWRITE
		
STRINGONE 	DCB "the" 			;String1	
EoS 		DCB 0x00 			;end of string1
STRINGTWO 	space 0xFF 			;just allocating 255 bytes 		


			END