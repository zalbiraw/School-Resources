			AREA question1, CODE, READWRITE
			ENTRY
			
			ADR r0, EoS
			ADR r1, STRING1
			ADR r2, STRING2
			MOV r5, 0x084							;Loads the ASCII value representing "t" into r5 to compare later
			MOV r6, 0x072							;Load the ASCII value representing "h" into r6 to compare later
			MOV r7, 0x069							;Load the ASCII value representing "e" into r7 to compare later
	
STRING1		DCB "and the man said they must go" 	;String1
EoS			DCB 0x00 								;end of string1
STRING2		space 0xFF 								;just allocating 255 bytes
		
FIND_T		LDRB r3, [r1], #1						;Loads the first character of the string into r3 which is being used as a temporary register
			CMP r3, r5								;Checks to see if the character in r3 is a "t" to decide what to do next
			BEQ FOUND_T								;If r3 is a "t" it will run FOUND_T in order to get rid of "t" from the string
			LDRB r2, [r3], #1						;If the character in r3 is not "t" it will add the character to r2 pointing to STRING2
			CMP r3, r0								;Checks to see if r3 is at the end of STRING1
Loop 		B	Loop									;If the end of STRING1 is found the program waits here
			BNE FIND_T								;Loops through FIND_T until a "t" is found
			
FIND_H		LDRB r3, [r1], #1						;Loads the first character of the string into r3 which is being used as a temporary register
			CMP r3, r6								;Checks to see if the character in r3 is a "h" to decide what to do next
			BEQ FOUND_H								;If r3 is a "h" it will run FOUND_H in order to get rid of "h" from the string
			BNE FIND_T								;If the character is not an "h" it will go back to looping FIND_T to restart the process

FIND_E		LDRB r3, [r1], #1						;Loads the first character of the string into r3 which is being used as a temporary register
			CMP r3, r7								;Checks to see if the character in r3 is a "e" to decide what to do next
			BEQ FOUND_E								;If r3 is a "e" it will run FOUND_E in order to get rid of "e" from the string
			BNE FIND_T								;If the character is not an "e" it will go back to looping FIND_T to restart the process

FOUND_T     MOV r4, r3								;Moves r3 into r4 which will be cleared thus deleting the "t"
			SUB r4, r4								;Clears the register r4 to delete the "t"
			BNE FIND_H								;After clearing r4 the program now goes and looks for an H
			
FOUND_H     MOV r4, r3								;Moves r3 into r4 which will be cleared thus deleting the "h"
			SUB r4, r4								;Clears the register r4 to delete the "t"
			BNE FIND_E								;After clearing r4 the program now goes and looks for the "e"
			
FOUND_E     MOV r4, r3								;Moves r3 into r4 which will be cleared thus deleting the "e"
			SUB r4, r4								;Clears the register r4 to delete the "t"
			BNE FIND_T								;Once e is found it will restart the process of finding "t"
			
			END