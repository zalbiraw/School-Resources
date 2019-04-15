		AREA question2, CODE, READONLY
		ENTRY
		
		LDR r1, =STRING ;Load the string into r1
		MOV r2,r1 ; Copy string to r2 this will be the right pointer
point	LDRB r3, [r2], #1 ; Cycle through the string until 
		CMP r3,#0         ; the end of the string tis reached
		BNE point ; Repeat the loop
		SUB r2,r2,#2 ; Move the pointer back to point at the last element in the string
		B loadval ; Branch to loadval

leftm	ADD r1,r1,#1 ; Move the left pointer to the right
		b loadval ; Load next values
rightm	sub r2,r2,#1 ; Move the right pointer to the left 

loadval	LDRB r4,[r1] ; Load the left pointer value
		LDRB r5,[r2] ; Load the right pointer value
		
		cmp  r4,#'A' ; Check if the character is less the A
		blo leftm	 ; If not move the left pointer
		cmp r4,#'z' ; Check if the character is greater then z
		bhi leftm   ; If it is move the left pointer
		
		cmp  r5,#'A' ; Check if the character is less the A
		blo rightm ; If not move the right pointer
		cmp r5,#'z' ; Check if the character is greater then z
		bhi rightm ; If it is move the right pointer
		
		cmp r4,#'A' ; Are we in the range of the capital?
		RSBGES r8,r4,#'Z' ;If >= 'A', 
						  ;then check with 'Z'
						  ;		and update the flags 
		ORRGE r4,r4,#0x0020 ;If between 'A' and 'Z' inclusive, 
							;then set bit 5 to force lower case
		
		cmp r5,#'A' ; Are we in the range of the capital?
		RSBGES r8,r5,#'Z' ;If >= 'A', 
						  ;then check with 'Z'
						  ;		and update the flags 
		ORRGE r5,r5,#0x0020 ;If between 'A' and 'Z' inclusive, 
							;then set bit 5 to force lower case
		
check2	CMP r4,r5 ; is the Value of r4 and r5 the same
		BNE false ; If not the same, then branch to false
		CMP r1,r2 ; If the pointers are the same, In this case the string is odd
		BEQ true ; branch to true
		ADD r3,r1,#1 ; Store the next pointer in r3
		CMP r3,r2 ; If the pointers are the same, In this case the string is even
		BEQ true; branch true
		ADD r1,r1,#1 ; Move the left pointer right
		sub r2,r2,#1 ; move the right pointer left
		B loadval ; Repeat loop
		
true	MOV r0,#1 ; Store 1 in r0 indicating that the string is a palindrome
		b endless ; end program
false	MOV r0,#2 ; Store 2 in r0 indicating that the string is not a palindrome
endless b endless ; end program

STRING 	DCB "He lived as a devil, eh?" ;string  
EoS    	DCB 0x00                       ;end of string 
		END