		AREA question1, CODE, READONLY
		ENTRY
		LDR	    r0, =UPC					;loading memory location of UPC in r0
		MOV 	r1, #0						;loading 0 into r1 to use as counter
		
LOOP 	LDRB	r2, [r0, r1] 				;fetching first digit of UPC to loop through
		SUB 	r2, r2, #48					;convert ASCII value to integer
		TST 	r1, #1						;checking for even numbered indexes
		BEQ 	EVEN						;branch out to even
		ADD		r3, r3, r2					;add odd numbered indexes to r4
		B		ONE							;branch to jump
		
EVEN	ADD 	r4, r4, r2					;add even numbered indexes to r3

ONE		ADD		r1, r1, #1					;incrementing r1 in order to get the next letter
		CMP		r1, #10						;checking counter to see if end has been reached
		BNE 	LOOP						;repeat if not complete
		ADD		r4, r4, LSL #1				;multiply first sum by 3 in order to find check digit
		ADD 	r5, r4, r3					;add first sum to second sum
		SUB 	r5, r5, #1					;subtracting 1 from total

TWO		CMP		r5, #10						;checking if r5 is at least 10 (for division by 10)
		BLT		THREE						;if it is less than 10, branch out because this # is the remainder
		SUB 	r5, r5, #10					;subtracting 10 more from the number
		B		TWO							;looping back
		
THREE	RSB		r5, #9						;subtract total from 9 to find check digit
		LDRB	r6, [r0, #11] 				;fetching last digit of UPC for comparison 
		CMP 	r6, r5						;comparing result to last digit
		BNE		WRONG						;branches off if not equal
		MOV		r0, #1						;puts 1 in r0 if valid
		B		BYE
		
WRONG	MOV 	r0, #2						;if invalid, puts 2 in r0

BYE
		AREA question1, DATA, READONLY
			
UPC 	DCB 	"060383755577"				;UPC string
		END              					;end 

	