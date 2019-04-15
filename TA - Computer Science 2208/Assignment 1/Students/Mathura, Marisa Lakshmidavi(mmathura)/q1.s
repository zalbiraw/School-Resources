		AREA q_1, CODE, READONLY
		ENTRY
		ADR r0, UPC-1		;register r0 points to UPC
		MOV r1, #6		;initialize counter to 6
loop 		LDRB r2, [r0, #1]!	;copies element in r0 to r2
		SUB r2, r2, #48		;convert from ascii to decimal
		SUBS r1, r1, #1		;decrement counter
		ADD r3, r3, r2		;add to the total of the first sum of odds
		LDRB r2, [r0, #1]!	;copies elementin r0 to r2
		SUB r2, r2, #48		;convert from ascii to decimal
		BEQ last		;checks for the end of the UPC
		ADD r4, r4, r2		;add to the total of the second sum of evens
		BNE loop		;checks to see if the counter is at zero
last 		ADD r3, r3, LSL #1	;multiply the first sum by 3
		ADD r3, r3, r4		;stores the sum of the odd sum and even sum in r3
		SUB r3, r3, #1		;subtract 1 from the total
divide 		SUB r3, r3, #10		;continue to subtract 10 to divide
		CMP r3, #10		;compare the difference with 10
		BGT divide		;if the difference is greater than 10 repeat
		SUB r3, r3, #9		;subtract p from the remainder
		ADD r3, r2		;add the negative difference to the positive check digit
		CMP r3, #0		;compare the sum to zero
		BEQ valid		;if the sum equals zero the check digit is valid
		BNE no			;if the sum is not equal to zero the check digit is not valid
valid		MOV r0, #1		;store 1 in the element r0 to signify validity
		B fi			;branch to the end
no		MOV r0, #2		;store 2 in the element r0 to signify non-validity
		B fi			;branch to the end
fi 		B fi			;finish
		AREA q_1, DATA, READWRITE
UPC 		DCB "013800150738"  ;UPC string
		END