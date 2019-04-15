		AREA question_two, CODE, READONLY
		ENTRY
		ADR r11, STRING		;is pointing to the palindrome sentence
Loop 	LDRB r3,[r11],#1	;Looping through the sentence byte by byte
		CMP r3,#0			;Checking if the character is ASCII zero which would signal the end of a sentence.
		BEQ Exit			;If it is, the loop breaks.
		ADD r4,r4,#1		;r4 is a counter of the amount of characters in the sentence
		B Loop				;Unless the end of the sentence is reached, loop back. 
Exit	SUB r4,r4,#1		; Exit subtracts one from the number of chars to get the index of the last char. 
		ADR r5, STRING		; The first pointer to the sentence, going backwards
		ADR r11, STRING		; The pointer to the sentence, going forwards
Loop2 	LDRB r3,[r11],#1	; Is looping through the first pointer
		CMP r9, r4			; Both the counter for the first pointer and second pointer are compared
		BGE Exit2			; If the first pointer is greater than or equal to the second pointer, it's a palindrome and it exits.
		CMP r3,#0x41		; Checking for special characters
		BLT Loop2			; If a character is special, the next one is looked at
		CMP r3, #'A'		; Checking if a character is upper case
		RSBGES r6, r3, #'Z'	; Converting a character to lower case
		ORRGE r3,r3, #0x0020; Coverting a character to lower case
		ADD r9,r9,#1		; One is added to the first pointer counter
Loop3 	LDRB r8,[r5,r4]		; Is looping through the second pointer
		SUB r4,r4,#1		; The second pointer count is subtracted by one
		CMP r8,#0x41		; Checking if the character is a special character
		BLT Loop3			; If it is, the program loops back
		CMP r8, #'A'		; Checking if a chracter is upper case
		RSBGES r7, r8, #'Z'	; If it is upper case, it is modified
		ORRGE r8,r8, #0x0020; If it is upper case, it is modified
		CMP r3,r8			; Comparing the character from the first pointer and second pointer
		BEQ Loop2			; If they're equal, loop back to reach the next characters
		MOV r0, #2			; Otherwise, it is not a palindrome
		B LoopB				; Loop to LoopB to exit the program
Exit2 	MOV r0, #1			; If it is a palindrome, one is stored
		B LoopB				;The code loops to the end of the program
STRING 	DCB "maedam"		;string; Is the string to be checked
EoS		DCB 0x00			;end of string; Represents the end of a string
LoopB 	B LoopB				; Is what a non palindrome loops to, ending the program
		END