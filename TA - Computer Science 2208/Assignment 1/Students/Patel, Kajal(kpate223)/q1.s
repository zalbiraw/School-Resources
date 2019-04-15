		
			AREA prog1, code, READONLY
			ENTRY
			
asciiToint	EQU	48						;this is the offset to change from ascii to integer
valid		EQU 1						;store this value in r1 if the UPC is valid
inValid		EQU	2						;store this value in r0 if the UPC is invalid
lastIndex	EQU 11						;the offset to the last character is 11
	
			ADR r0, UPC					;create a pointer, r0, to UPC
			MOV r1, #6					;create a loop counter for the first sum
			MOV r3, #0					;clear r3 to hold the running total
		
		
Loop		LDRB r2, [r0], #2			;load the character at the current index 
										;and increment the pointer by 2(add every other index)
			SUB r2, r2, #asciiToint		;subtract 48 to convert from ascii to integer
			ADD r3, r3, r2				;add the digit just read to the running total
			SUBS r1, #1					;decrement the loop counter
			
										;if the loop counter has reached 0, the first sum was computed
SecondSum	ADDEQ r3, r3, LSL#1			;multiply the first sum by 3
			ADREQ r0, UPC+1				;adjust the pointer to start adding the second sum
										;starting at the second character
										
Continue	CMP r1, #-5					;if the index is -5, the second sum was also added to the running total
			BNE Loop					;continue looping until both sums have been added
		
		
		
Divide		SUBS r3, r3, #10			;divide the running total by 10 by repeatedly subtracting 10
			BGE	Divide					;continue to subtract 10 until the running total is negative
	
			RSB r3, #0					;subtracting the running total from 0
										;effectively this subtracts the running total by 1 
										;(which was to be done before finding the remainder)
										;and it computes the remainder and subtracts it from 9
			LDRB r4, UPC+lastIndex		;load the last character of the UPC into r4
			SUB r4, r4, #asciiToint		;convert the character to an integer
			CMP r3, r4					;check if r3 and r4 are equal
			MOVEQ r0, #valid			;if they are equal, the upc is valid so store 1 in r0
			MOVNE r0, #inValid			;if they are no equal, the upc is invalid so store 2 in r0


UPC	DCB		"013800150738" 		;this is the UPC code
			END

	