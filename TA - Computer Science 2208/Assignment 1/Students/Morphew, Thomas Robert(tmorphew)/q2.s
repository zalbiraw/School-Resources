		AREA question_two, CODE, READONLY
		ENTRY
		
		;Register uses:
		;r0 contains the output of the program, 1 if STRING is a palindrome, 2 if it is not a palindrome.
		;r1 points to the location of the beginning of the string, this pointer moves further to the end of the string.
		;r2 points to the location of the last character of the string, this pointer moves closer to the beginning of the string.
		;r3 stores the character from the beginning moving towards the end of the string. The "left" character.
		;r4 stores the character from the end moving towards the end of the string. The "right" character.
		
		LDR r1, =STRING		;Beginning of string location
		LDR r2, =EoS 		;End of String location
		SUB r2,r2,#1 		;Subtract 1 so it points to the last character, not EoS.
		
		;Compare pointers to see if they crossed. If so then end the program. 
compare	CMP r2,r1 			;Compare pointers to see if they crossed.
		BMI EoP 			;Pointers have crossed without finding different characters so skip to End of Program (EoP) and update r0 = 1.
		
		;Pointers not crossed. Load and mask characters.
		LDRB r3,[r1]		;Load left character.
		LDRB r4,[r2]		;Load right character.
		ORR r3,r3,#0x0020 	;Mask left character (r3) to lowercase. Might not be a letter but instead a symbol.
		ORR r4,r4,#0x0020 	;Mask right character (r4) to lowercase. Might not be a letter but instead a symbol.
		
		;Is the left character (r3) a lowercase letter or a symbol?
		CMP r3,#'a' 		;Check if r3 is greater than or equal to 'a'
		RSBGES r5,r3,#'z' 	;If r3 is greater/equal than 'a', check if r3 less than or equal to 'z', then go to next character, else update pointer.
		ADDLT r1,r1,#1		;Outside of range so update the pointer to the next character after r3 (to the right).
		BLT compare 		;Go back after updating range. Not a letter so check if the next character after r3 is a letter
		
		;Is the right character (r4) a lowercase letter or a symbol?
		CMPGE r4,#'a' 		;Check if r4 is greater than or equal to 'a'
		RSBGES r5,r4,#'z' 	;If r4 is greater/equal than 'a', check if r4 less than or equal to 'z', then compare if both r3 and r4 are the same, else update the pointer.
		SUBLT r2,r2,#1		;Outside of range so update the pointer to the next character after r4 (to the left).
		BLT compare 		;Go back after updating range. Not a letter so check if the next character after r4 is a letter
		
		;Both characters (r3 and r4) are letters, are they the same or different?
		CMPGE r4,r3 		;Are r4 and r3 the same?
		BNE notp 			;Not a palindrome (notp) jump to end of program after updating r0
		ADDEQ r1,r1,#1		;Update r3's pointer
		SUBEQ r2,r2,#1 		;Update r4's pointer
		BEQ compare 		;Go back to start of loop to compare the next characters
		
		;End of Program cases
EoP		MOV r0,#1		 	;Pointers have crossed and all characters checked were equal therefor string is a palindrome. Store 1 in r0.
		B loop 				;end of program
		
notp	MOV r0,#2 			;Pointers found two different letters so the string is not a palindrome. Store 2 in r0.
loop	B loop				;end of program

		AREA someData, DATA, READONLY
STRING 	DCB "Noon" 			;string
EoS 	DCB 0x00 
		END
		