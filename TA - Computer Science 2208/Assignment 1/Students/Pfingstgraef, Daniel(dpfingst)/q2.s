			AREA palindrome, code, READONLY
			ENTRY
			MOV r0, #2			;Prep r0 with value of 2 (assume invalid until proven valid)
			LDR r8, EoS			;Load EoS into r8
			LDR r1, =STRING		;Load address of palindrome into r1
COUNT		ADD r5, r5, #1		;Increment the counter
			LDRB r2, [r1, r5]	;load the next char into r2	
			CMP r2, r8			;check if next char is null string
			BNE	COUNT			;if it isn't the end, do this again
			SUB r5, r5, #1		;the count gets us the actual length starting at 1, but we need it to start at 0, so subtract 1
CHECK		LDRB r2, [r1, r5]	;start the check loop - load rightmost char into r2
			LDRB r3, [r1, r6]	;load leftmost char into r3
			CMP r2, r3			;check if the are equal
			BNE	PARK			;if not, no a palindrome and we are done
			ADD r6, r6, #1		;they are equal, so increment the right-travelling pointer
			SUB	r5, r5, #1		;and decrement the left-travelling pointer
			CMP r6, r5			;check difference between pointers
			BLE	CHECK			;if they are even, or if the cross over each other, we know we are done - if not go again
			MOV r0, #1			;if we made it here, we have a valid palindrome
PARK 		B PARK				;Parking loop
STRING		DCB	"noon"			;string
			ALIGN
EoS			DCB	0x00			;end of string
			END