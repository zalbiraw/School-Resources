		AREA questionTwo, CODE, READONLY
		ENTRY
		
Start 	ADR r0,STRING			;register r0 points to List
		ADR r1,EoS				;register r0 points to List
		
loop	CMP r1,r0				;compares the values of the two locations
		BLE exit				;the location of the two registers is either equal or r1 is less than r2 and goes past the exit part
		LDRB r2,[r0]			;copy the element pointed at by r0 to r2 
		LDRB r3,[r1]			;copy the element pointed at by r1 to r3
		
		CMP r2, #'A' 			;checks if the current character is a capital letter
		RSBGES r4, r2, #'Z' 	;checks if it is greater than Z
		ORRGE r2, r2, #0x0020	;If between 'A' and 'Z' inclusive, convert to a common letter
		
		CMP r3, #'A' 			;checks if the current character is a capital letter
		RSBGES r4, r3, #'Z' 	;checks if it is greater than Z
		ORRGE r3, r3, #0x0020	;If between 'A' and 'Z' inclusive, convert to a common letter
			
		CMP r2, #'a' 			;checks if the current character is a common letter
		RSBGES r4, r2, #'z' 	;checks if it is greater than z
		BGE	next  				;if it is a common letter go past the next part
		ADD r0,r0,#1			;if it isnt a common letter go to the next value in the string
		LDRB r2,[r0]			;load the new value of the string into r2
		B loop					;loop back to the start of the loop to check the new character
		
next	CMP r3, #'a' 			;checks if the current character is a common letter
		RSBGES r4, r3, #'z' 	;checks if it is greater than z
		BGE	dothis  			;if it is a common letter go past the go this part
		SUB r1,r1,#1			;if it isnt a common letter go to the next value in the string (from the end of the string)
		LDRB r3,[r1]			;load the new value of the string into r1
		B loop					;loop back to the start of the loop to check the new character
		
dothis	CMP r2,r3				;check if the letters stored in r2 and r3 are the same
		BNE failed				;if the letters are not equal go past the faiiled part
		ADD r0,r0,#1			;go to the next value in the string
		SUB r1,r1,#1			;go to the next value in the string (from the end of the string)
		B loop					;loop back to the start of the loop to check the new string values
		
exit	MOV r0,#1				;place 1 into r0 as the string was a palindrome
		B Endless				;go past the endless part
		
failed	MOV r0,#2 				;place 2 into r0 as the string was not palindrome	


Endless B 	Endless ;infinite loop
STRING 	DCB "He lived as a devil, eh?" 	;string
EoS 	DCB 0x00 						;end of string
		END	
			