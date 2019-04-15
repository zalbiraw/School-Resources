		AREA myfirstQuestion, CODE, READONLY
		ENTRY
Start	ADR	r1,UPC				;register r0 points to UPC
		MOV r2,#5				;initialize loop counter in r1 to 5			
		LDRB r5,[r1],#1			;loads the first digit into r5
		SUB r5,r5,#48			;converts the first digit from ascii to decimal
		ADD	r3,r3,r5			;add the first digit to the first sum
		
Loop	LDRB r5,[r1],#1			;get the next digit in the code
		SUB r5,r5,#48			;converts digit from ascii to decimal
		ADD r4,r4,r5			;add the digit to the second sum
		LDRB r5,[r1],#1			;get the next digit
		SUB r5,r5,#48			;converts the digit from ascii to decimal
		ADD r3,r3,r5			;add the digit to the first sum
		SUBS r2,r2,#1			;decrement loop counter
		CMP r2,#0				;test if loop counter equals zero
		BNE Loop				;exit loop
		
		ADD r3,r3,r3,LSL #1		;[r2]<-[r2] + [r2] x 3 (multiplies the first sum by 3)
		ADD r6,r3,r4			;adds the two sums together
		SUB r6,r6,#1			;subtracts 1 from the total of the two sums
Loop2	SUB r6,r6,#10			;repeatedly subtracts 10 from the total until a negative number is produced (division)
		CMP r6,#0				;checks if the difference is negative
		BPL Loop2				;restarts loop
		
		ADD r6,r6,#10			;adds 10 to r6 to get the remainder when the totals are divided by 10
		RSB r6,r6,#9			;subtracts the remainder from 9
		LDRB r5,[r1],#1			;gets the check digit
		SUB r5,r5,#48			;converts the digit from ascii to decimal
		CMP r6,r5				;compares the check digit to r6
		BNE nValid				;if the check digit does not equal r6, the code is not valid
		B	Valid				;check digit equals r6, therefore Valid
								
nValid	MOV r0,#2				;store 2 in r0 to state invalidity
		B	EndLoop				;calls endless loop to finish program
Valid	MOV	r0,#1				;store 1 in r0 to state validity
EndLoop	B	EndLoop				;end of program
		
UPC		DCB	"060383755577"		;UPC string
		END