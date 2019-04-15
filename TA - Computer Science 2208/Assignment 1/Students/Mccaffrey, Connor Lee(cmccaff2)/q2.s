		AREA question2, CODE, READONLY
		ENTRY
		
		ADR r1,STRING 			;Point r1 at the string
		ADR r2,EoS -1 			;Point r2 at the end of the string
			
		;Read the string one line at a time
loop	LDRB  r3,[r1],#1 		;Read an element from the front of the string to r3
		LDRB  r4,[r2],#-1 		;Read an element from the end of the string to r4
		
		;Check for punctuation
check	CMP r3, #'A' 			;Compare r3 to A...
		LDRBLT  r3,[r1],#1 		;If less than A, it must be punctuation so read the next value	
		BLT check 				;Keep checking until a valid character is found
		
		CMP r4, #'A' 			;Compare r4 to A...
		LDRBLT  r4,[r2],#-1 	;If less than, read the next value
		BLT check 				;Keep checking until a valid character is found
		
		;Check for capital letters
		CMP r3, #'Z' 			;Compare r3 to Z...
		ADDLE r3, r3, #32 		;If it is a capital letter, add 32 to the value to get the equivalent lower case value
		
		CMP r4, #'Z' 			;Compare r4 to Z...
		ADDLE r4, r4, #32 		;If it is a capital letter, add 32 to the value to get the equivalent lower case value
		
		CMP r3,r4 				;Compare the two characters
		BNE next 				;If characters do not match, exit loop
		
		CMP r1,r2 				;Compare pointers r1 and r2
		BLE loop 				;Branch to start of loop if pointers have not passed each other
		
		CMP r3,r4 				;Compare the two characters
		MOVEQ r0,#1 			;If palindrone move 1 to r0
next	MOVNE r0,#2 			;If not, move 2 to r0
		
STRING 	DCB "He lived as a devil, eh?" ;string
EoS 	DCB 0x00 ;end of string
		END