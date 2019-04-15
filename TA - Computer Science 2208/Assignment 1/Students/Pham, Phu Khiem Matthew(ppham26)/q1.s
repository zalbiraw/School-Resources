		AREA questionOne, CODE, READONLY
		ENTRY
		
toInt	EQU	48					;Need to subtract 48 from acsii of number to get integer
		LDR r0, =UPC			;Loading UPC into r0

sum								;Summing every number storing the sum of odd index in r4 and even index in r3
		LDRB	r1, [r0, r2]	;Loading digit
		SUB r1, #toInt			;Converting digit to integer
		TST	r2, #1				;Even/odd test
		ADDNE	r4, r1 			;If odd index add the digit to r3
		ADDEQ	r3, r1			;If even index add the digit to r4
		ADD r2, #1				;Incrementing counter
		CMP r2, #11				;Testing if all digits other than the check digit have been summed
		BNE sum					;Continues to add if false
		
		ADD r3, r3, r3, LSL#1	;Multiply the odd sum by 3
		ADD r3, r4				;Add both sums together
		SUB r3, #1				;Subtract 1 from the sum
		LDRB r1, [r0, #11]		;Move to the last position of the UPC
		SUB r1, #toInt			;Converting to integer				
			
div10
		SUB r3, #10				;Dividing by 10 and storing remainder in r2
		CMP r3, #10
		BGT div10
		
		RSB r3, r3, #9			;Subtracting r2 from 9 and storing in r2
		CMP r1, r3				;If the check digit is valid store 1 in r0, else store 2 in r0
		MOVEQ r0, #1
		MOVNE r0, #2

UPC 	DCB "065633454712" 		;UPC string 
		END