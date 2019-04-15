		AREA Question1, CODE, READONLY			; Matthew Josef Bzowski, 250910538
		ENTRY									; Program will remove all instances of 'the' from a string
		ADR r0, STRING1							; Register r0 points to STRING1
		LDRB r5, EoS							; Load the null character into r5
		ADR r3, STRING2							; Register r3 points to STRING2
		MOV r4, #inc							; Initialize the counter at 1 to account for missing space 
		
Top		LDRB r2, [r0], #inc						; Load a character from STRING1 into r2 and advance pointer
		STRB r2, [r3], #inc						; Store the character from r2 in STRING2 and advance pointer
		
Next	CMP r2, #t								; Check if the character is t
		ADDEQ r4, r4, #inc						; Increment counter if it is t
		BEQ Top									; Go to look at next character
		
		CMP r2, #h								; If not a t, check if it is an h
		ADDEQ r4, r4, #inc						; Increment counter if it is h
		BEQ Top									; Go to look at next character
		
		CMP r2, #e								; If not a t or an h, check if it is an e
		ADDEQ r4, r4, #inc						; Increment counter if it is e
		BEQ Top									; Go to look at next character
		
Cont	CMP r2, #spc							; Check if character is a space
		BNE cEnd								; If it is not a space branch to cEnd
		CMP r4, #inc							; Check if this is the second space in a row
		ADDNE r4, r4, #inc						; If it is not the second space increment the counter
		
		CMP r4, #fcoun							; Check if the count is 5, if it is then 'the' must be removed
		SUBEQ r3, r3, #fdec						; Move the STRING2 pointer back 4 places to remove 'the'
		SUBEQ r0, r0, #inc						; Move the STRING1 pointer back 1 place to preserve the space character
		MOVEQ r4, #reset						; If 'the' has been removed reset the counter
		B Top									; Go to look at next character
								
cEnd	CMP r2, r5								; Check if the end of the string is reached
		MOVNE r4, #reset						; If not at the end of the string reset the counter, the character is good
		BNE Top									; If not the end of the string go to look at next character
		
		CMPEQ r4, #fdec							; Check if the counter is 4 - if so 'the' is at the end of the string
		SUBEQ r3, r3, #fdec						; Move the STRING2 pointer back 4 places to remove 'the'
		STRBEQ r5, [r3]							; Store the EoS character to denote the end of the string, charcters after is garbage
		
Loop	B Loop									; Quit program

				
		AREA Question1, DATA, READONLY			; Data definitions
STRING1	DCB "and the man said they must go"		; String1
EoS		DCB 0x00								; end of string1
		ALIGN									; Align STRING2
STRING2	space 0xFF								; just allocating 255 bytes
	
t		EQU 0x74								; ASCII value for t
h		EQU 0x68								; ASCII value for h
e		EQU	0x65								; ASCII value for e
spc		EQU 0x20								; ASCII value for SPACE character
inc		EQU 1									; 1 for increment and decrement
reset	EQU 0									; 0 for reset
fcoun	EQU 5									; Value to determine if 'the' is found
fdec	EQU 4									; 4 for decrement	
	
		END