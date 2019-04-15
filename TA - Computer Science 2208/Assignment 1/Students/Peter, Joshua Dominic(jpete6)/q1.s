		AREA questionOne, CODE, READONLY
		ENTRY
		
Start 	ADR r0,UPC				;register r0 points to List
		MOV r1,#11 				;initialize loop counter in r1 to 11
		MOV r2,#0 				;clear the sum in r2
		MOV r4,#0 				;clear the sum in r4
		MOV r5,#1 				;initialize check value in r4 to 1

Loop 	LDRB r3,[r0] 			;copy the element pointed at by r0 to r3
		ADD r0,r0,#1 			;point to the next element in the series
		SUB r3,r3,#0x30			;converts the number from ASCII code to a number
		
		CMP r5,#1				;checks if the current iteration is at an odd index
		BEQ DoThis 				;if equal then goto DoThis
		ADD r2,r2,r3 			;add the element to the running total if it is on an even index
		ADD r5,r5,#1			;changes the check value stored in r5 to 1
		B Next 					;jump past the Next part
DoThis 	ADD r4,r4,r3 			;add the element to the running total
		SUB r5,r5,#1			;changes the check value stored in r5 to 0
Next 		
		SUBS r1,r1,#1			;decrement to the loop counter
		BNE Loop 				;repeat until all elements added
		
		ADD r4,r4,LSL#1			;multiply r4 by 3
		ADD r2,r2,r4			;add the first sum*3 to the second sum
		SUB	r2,r2,#1			;subtract one from the sum
		
loop	CMP r2,#10				;loop to proform repeated subtraction to find the remainder
		BLT exit				;if the value of r2 is less than 10 it will move to the exit part
		SUB r2,r2,#10			;subtacts 10 from r2 
		B loop					;repeat until the condition is met
exit	RSB r2,r2,#9			;subtract r2 from 9 
		LDRB r3,[r0]			;load the last upc number into the register
		SUB r3,r3,#0x30			;converts the number from ASCII code to a number 
		
		CMP r2,r3				;checks if the number obtained is the same as the check digit
		BNE goto				;jump past the goto part if the number is not the same as the check digit
		MOV r0,#1				;changes r0 to 1 if the check digt was valid 
		B Endless				;jump past the Endless part 
goto	MOV r0,#2				;changes r0 to 2 if the check digt was invalid 

Endless B 	Endless 			;infinite loop
UPC 	DCB "013800150738" 		;UPC string 
		END
			
			