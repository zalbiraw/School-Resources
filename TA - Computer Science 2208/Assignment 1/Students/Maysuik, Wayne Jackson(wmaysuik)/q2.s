		AREA Question2, CODE, READONLY
		ENTRY
LOWER	EQU		0x20
BIG_A	EQU		0x41
SMALL_A	EQU		0x61
SMALL_Z	EQU		0x7A
		
		ADR		r1, STRING					; Move the address of the string into r1
		ADR		r2, EoS -1					; Move the address of the last character of the string into r2
		
		MOV		r0, #0x1					; Set the palindrome as correct

char1	LDRB	r3, [r1], #1				; Load the next character of the string into r3 and increment the address by 1 byte
		CMP		r1, r2						; Compare the addresses of r1 and r2 to see if they are equal
		BPL		loop						; If the addresses are the same or greater, then the word is a palindrome
		CMP		r3, #BIG_A					; Compare the value of r3 with 0x41 to see if it is less than the ascii code for 'A'
		BLT		char1						; If the number is less than the ascii code for 'A', get next character
		CMP		r3, #SMALL_A				; Check if the value of the character is less than 'a'
		ADDLT	r3, #LOWER					; Change lowercase to uppercase
		CMP		r3, #SMALL_Z				; Campare the value of r3 with the ascci code for 'z'
		BGT		char1						; If the character is greater than the ascii code for 'z', get next character
		
char2	LDRB	r4, [r2], #-1				; Load the next character from the back of the string into r4 and decrement the address by 1 byte
		CMP		r4, #BIG_A					; Compare the value of r4 with 0x41 to see if it is less than the ascii code for 'A'
		BLT		char2						; If the number is less than the ascii code for 'A', get next character
		CMP		r4, #SMALL_A				; Check if the value of the character is less than 'a'
		ADDLT	r4, #LOWER					; Change lowercase to uppercase
		CMP		r4, #SMALL_Z				; Campare the value of r4 with the ascci code for 'z'
		BGT		char2						; If the character is greater than the ascii code for 'z', get next character						; If the character is not a letter, move to the next character
		
		CMP		r3, r4						; Compare the characters in r2 and r3 to see if they are the same
		BEQ		char1						; If the letters are the same, check the next pair
		MOVNE	r0, #2						; If the letters are not the same, the word is not a palindrome and move 0x2 into r0

loop	B		loop						; Endless loop
		
STRING 	DCB 	"He lived as a devil, eh?" 	;string
EoS 	DCB 	0x00 						;end of string
		END