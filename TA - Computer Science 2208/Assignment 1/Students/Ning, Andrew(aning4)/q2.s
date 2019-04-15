	AREA Question2, CODE, READONLY
	ENTRY
	
	;Register r0 is used to store the validity of the string as a palindrome
	;Register r1 is used as a pointer processing the string from left to right
	;Register r2 holds the value of the current character pointed to by r1
	;Register r3 is used as a pointer processing the string from right to left
	;Register r4 holds the value of the current character pointed to by r3
	MOV r0,#1				;Pre-emptively load 1 as the answer (Default valid palindrome)
	ADR r1, STRING			;Initialize pointer to start of string
	ADR r3,EoS				;Initialize pointer to end of string
	
	;The first pointer will process each character one by one (from left to right)
	;Once a valid character is found, it is held to be compared to the matching valid character from the other side of the string
PAS LDRB r2,[r1],#1			;Load first byte and post-increment so that the next value is ready to be loaded at the start of the next loop
	CMP r2,#0x00			;Check if end of string has been reached
	BEQ FIN					;If it has been reached, end the program
	CMP r2, #0x61			;Check if the current ascii character is greater than 0x61 (ascii lowercase a)
	SUBGE r2,r2,#0x20		;If it is, subtract 0x20 (difference between lower and upper case characters)
	CMP r2,#0x5A			;Check if the character is above the character range 
	BGT PAS					;If it is, the character is invalid, move to the next one
	CMP r2,#0x41			;Check if the character is below the character range
	BLT PAS					;If it is, the character is invalid, move to the next one
	
	;The second pointer will process each character one by one (from right to left)
	;Once a valid character is found, it is held to be compared to the matching valid character from the other side of the string
PBS	LDRB r4,[r3],#-1		;Load last byte of string, and post-decrement so that the next value is ready to be loaded at the start of the next loop
	CMP r4, #0x61			;Check if the current ascii character is greater than 0x61 (ascii lowercase a)
	SUBGE r4,r4,#0x20		;If it is, subtract 0x20 (difference between lower and upper case characters)
	CMP r4,#0x5A			;Check if the character is above the character range
	BGT PBS					;If it is, the character is invalid, move to the next one
	CMP r4,#0x41			;Check if the character is below the character range
	BLT PBS					;If it is, the character is invalid, move to the next one
	
	;The two valid characters being held by registers r2 and r4 are comapred to check if they are equal
	;If they are, the entire process is restarted until the entire string has been processed
PCS CMP r2,r4				;Check if the two valid characters are the same
	BNE NOT					;If not, then the string is not a palindrome and the validity needs to be updated
	B PAS					;If the characters are the same, check the next set of valid characters
NOT	MOV r0,#2				;If the string is not a palindrome change the validity (this instruction is only reached if a failed comparison is formed
FIN B FIN					;End of program

	;String to be tested
STRING DCB "He lived as a devil, eh?"
EoS	DCB 0x00

	END