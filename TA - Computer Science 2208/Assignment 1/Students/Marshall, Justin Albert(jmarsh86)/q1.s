		AREA assignment3_q1, CODE, READONLY
		ENTRY
		MOV r1,#6			;Set register r1 to 6 to act as a counter
UPC		DCB "065633454712"	;UPC string
		ADR r2, UPC			;register r2 points to UPC
		
LoopAdd	LDRB r3,[r2], #1	;Load the next digit of the UPC into register r3, then increment by 1
		SUB r3, #48			;Subtract 48 from register r3 to get actual number from ASCII
		ADD r4, r3			;Add the actual number to register r4
		SUB r1, #1			;remove 1 from the counter
		CMP r1,#0			;Compare r1 and 0
		BEQ LEnd			;Jump to LEnd if r1 = 0
		LDRB r3,[r2], #1	;Load the next digit of the UPC into register r3, then increment by 1
		SUB	r3, #48			;Subtract 48 from register r3 to get actual number from ASCII
		ADD r5, r3			;Add the actual number to register r5
		B	LoopAdd			;Jump back to LoopAdd
;This loop adds the proper digits as specified in the outline to r4 (first group of 5) and r5 (second group of 5)
		
LEnd	ADD r4,r4,LSL #1	;Multiply the value of r4 by 3
		ADD r4, r5			;Add the value of r5 to r4
		SUB r4, #1			;Subtract 1 from the value of r4
LoopDiv CMP r4,#10			;Compare r4 and 10
		BLT LEnd2			;Jump to LEnd2 if r4 < 10
		SUB r4, #10			;Subtract 10 from the value of r4
		B LoopDiv			;Jump back to LoopDiv
;This loop gets the remainder of the value of r4 when divided by 10
		
LEnd2	RSB r4, r4, #9		;Subtract the value of r4 from 9 and store it in r4
		LDRB r6,[r2]		;Load the last digit of the UPC into register r6
		SUB r6, #48			;Subtract 48 from register r6 to get actual number from ASCII
		CMP r4,r6			;Compare r4 and r6
		BEQ Correct			;Jump to Correct if r4 = r6
		ADD r0,#1			;Add 1 to the value of r0
Correct	ADD	r0,#1			;Add 1 to the value of r0
		END