			AREA question1, CODE, READONLY
			ENTRY
			ADR r2, UPC				;pointer to UPC string
			MOV r0, #0 				;counter for array
			MOV r1, #0 				;holds sum and eventually check digit

Loop	 	LDRB r3, [r2, r0]		;load character value into r3
			SUB r3, r3, #48			;subtract by 48 to get int form string
			CMP r0, #11				;compare counter with 11
			BEQ Exit1				;if counter is equal to 11 break look
			TST r0, #1				;test if counter is odd
			ADDEQ r3, r3, r3, LSL#1	;if counter is odd multiply the current value by 3
			ADD r1, r1, r3			;add current value to sum
			ADD r0, r0, #1			;increment counter
			B Loop 					;branch back and loop again

Exit1		SUB r1, r1, #1			;subtract sum by 1

DivLoop		CMP r1, #10				;loop to mod by 10, check if r1 is less than 10
			BLT Exit1				;if r1 is less than 10 then exit loop
			SUB r1, r1, #10			;subtract r1 by 10 
			B DivLoop				;branch back and loop again

Exit		RSB r1, r1, #9			;subtract r1 mod 10 from 9
			CMP r1, r3				;compare check digit with last digit in UPC string
			MOVNE r0, #2			;if check digit is not equal to last digit then move 2 into r0
			MOVEQ r0, #1			;if check digit is equal to last digit then move 1 into r0

UPC 		DCB "060383755577"	ADR r2, UPC
			END