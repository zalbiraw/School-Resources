			AREA question2, CODE, READONLY
			ENTRY
			
			ADR r10, string 	;holds pointer to start of string
			MOV r1, #0 			;holds count from start of string
			MOV r2, #0 			; holds count from end of string
			
lenLoop		LDRB r3, [r10, r2] 	;loop to find string length
			CMP r3, #0x00		;if EoS encountered
			BEQ bigLoop			;go to loop to compare letter by letter
			ADD r2, r2, #1		;increment r2
			B lenLoop			;loop back
			
bigLoop		CMP r1, r2			;if the count from the start is bigger than the count from the end (ie entire string has been processed)
			BGT true			;then branch to true
								;otherwise process the letters
inLoop1		LDRB r4, [r10, r1]	;load first letter into r4
			ADD r1, r1, #1		;increment r1
			CMP r4, #122		;if r4 is not a capital letter
			BGT next1			;check if its a lowercase
			CMP r4, #97			
			BLT next1
			SUB r4, r4, #32		;if it is an uppercase letter subtract 32 to make it lowercase
next1		CMP r4, #65			;if its not a lowercase letter
			BLT inLoop1			;iterate through loop again
			CMP r4, #90
			BGT inLoop1	
			
inLoop2		LDRB r5, [r10, r2] 	;load last letter into r5
			SUB r2, r2, #1		;sub 1 from r2
			CMP r5, #122		;if r4 is not a capital letter
			BGT next2			;check if its a lowercase
			CMP r5, #97
			BLT next2
			SUB r5, r5, #32		;if it is an uppercase letter subtract 32 to make it lowercase
next2		CMP r5, #65			;if its not a lowercase letter
			BLT inLoop2			;iterate through loop again
			CMP r5, #90
			BGT inLoop2	
			
			CMP r4, r5			;compare r4 and r5
			BNE false			;if they are different then branch to false
			B bigLoop			;if they are the same then iterate through loop again
			
false		MOV r0, #2			;if determined to be false move 2 into r0
			B exit				;enter infinite loop
true 		MOV r0, #1			;if determined to be true, move 1 into r0
exit		B exit				;infinte loop


string 		DCB "He lived as a devil, eh?" ;string
EoS 		DCB 0x00 ;end of string
		
			END