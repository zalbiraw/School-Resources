;Project will determine if a given String is a Palindrome
;By Andres Rodriguez
		AREA QuestionOnePartTwo, CODE, READONLY
		ENTRY	
		ADR r1, STRING 		 ;Stores the String
		ADR r2, EoS-1		 ;Stores the Location of the last char
		MOV r0, #1			 ;Defaulted as 1 will be turned into a two if the String isnt a Palindrome

;Loop1 Will find the next available letter char in the string begining from the start
Loop1	LDRB r3, [r1], #1	 ;Stores the first char and increases the counter by one
		CMP r3, #0x20		 ;Compares the char to an empty space
		BEQ Loop1			 ;If the char is an empty space restarts the loop
		CMP r3, #0			 ;Compares the char to NULL
		BEQ BrkLoop			 ;If the char is NULL skips to BrkLoop
		
		CMP r3, #"A" 		 ;Compares the char with the value of 'A'
		BLT Loop1			 ;If the char is less than the value of 'A' restart loop
		RSBGES r4 , r3, #"Z" ;If >= 'A',then check with 'Z' and update the flags
		ORRGE r3, r3, #0x20  ;If between 'A' and 'Z' inclusive,then set bit 5 to force lower case
		
		CMP r3, #"a"		 ;Compares the char with the value of 'a'
		BLT Loop1			 ;If the cahr is less than the value of 'a' restart loop
		CMPGT r3, #"z"		 ;If the char is greater than 'a', Compares the char to 'z'
		BGT Loop1			 ;If the char value is larger than 'z' restarts loop
		
;Loop2 Will find the next available letter char in the string begining from the end and going backwards
Loop2	LDRB r5, [r2], #-1   ;Stores the last char and decreases the counter by one
		CMP r5, #0x20		 ;Compares the char to an empty space
		BEQ Loop2			 ;If the char is an empty space restarts the loop
		
		CMP r5, #"A"         ;Compares the char with the value of 'A'
		BLT Loop2			 ;If the char is less than the value of 'A' restart loop
		RSBGES r4, r5, #"Z"  ;If >= 'A',then check with 'Z' and update the flags
		ORRGE r5, r5, #0x20  ;If between 'A' and 'Z' inclusive,then set bit 5 to force lower case
		
		CMP r5, #"a"		 ;Compares the char with the value of 'a'
		BLT Loop2			 ;If the cahr is less than the value of 'a' restart loop
		CMPGT r5, #"z"		 ;If the char is greater than 'a', Compares the char to 'z'
		BGT Loop2			 ;If the char value is larger than 'z' restarts loop
		
		CMP r3, r5			 ;Compares the two char
		ADDNE r0, #1		 ;If they are not equal adds one to r0
		BNE BrkLoop			 ;If they are not equal skip to BrkLoop code
		B Loop1				 ;Otherwise, both chars are equal, repeat everything starting at Loop1
		
BrkLoop MOV r8, #0		     ;Useless code used in order to break out of the loop on line #43
STRING 	DCB "He lived as a devil, eh?"	;String
EoS 	DCB 0x00     		 ;End of string 
		END