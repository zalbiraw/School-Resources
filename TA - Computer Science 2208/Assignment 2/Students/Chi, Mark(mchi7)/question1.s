		AREA assn4, CODE, READWRITE
		ENTRY
		ADR r0, STRING1									;Pointer to main string we want to manipulate
		ADR r9, STRING2									;Pointer to space in memory where modified string1 will go
		MOV r5, r0										;Index Address for where we are in the string
		LDRB r1, EoS									;Loads the end of string into r1 0x00
		B CHECKT										;Check for t initially if it is the first iteration
		
CHECKSP	LDRB r2, [r0], #1								;Check for spaces, load the char into r2
		CMP r2, #32										;if it's a space
		STRB r2, [r9], #1								;Store the char into memory
		BEQ CHECKT										;it means this is the start of a new word. Now check for t
		CMP r2, r1										;if EoS
		BEQ loop										;stop running
		BNE CHECKSP										;keep checking if it is not either a space or EoS
		
CHECKT	MOV r5, r0										;position of where we are in the string
		LDRB r2, [r0], #1								;Load the char
		CMP r2, #'t'									;check if it is a t
		BEQ CHECKH										;if it is, check for h (branch)
		BNE FAIL1										;Go to fail to retrace our steps
		
CHECKH	LDRB r2, [r0], #1								;load char
		CMP r2, #'h'									;Check if it is h
		BEQ CHECKE										;Now check for e, so we will know it is 'the'
		BNE FAIL1										;retrace our steps if it is not 'the'
		
CHECKE	LDRB r2, [r0], #1								;load char
		CMP r2, #'e'									;Check if it is e
		BEQ FINAL										;branch to final for final checking
		BNE FAIL1										;retrace steps

FINAL	LDRB r2, [r0]									;end check to see if it is the end of the string
		CMP r2, r1										;Check to see if it is the end of the string
		BEQ CHECKSP										;If it is, go to the inital start
		CMP r2, #32										;Check to see if it's a space
		BEQ CHECKSP										;Branch to check space
		BNE FAIL1										;Retrace our steps
		B loop											;To skip fail1 once our process is done
FAIL1	MOV r0, r5										;Will move the previous address of where we were back into the pointer so the pointer can include the word
		B CHECKSP										;Go back to checksp and adds it to the new string

loop 	B loop											;Endless loop
		
		AREA assn4, DATA, READWRITE
STRING1 DCB "the the  the 123  the1"   					;String1 
EoS     DCB 0x00                              			;end of string1 
STRING2 space 0xFF                          			;just allocating 255 bytes 
		END