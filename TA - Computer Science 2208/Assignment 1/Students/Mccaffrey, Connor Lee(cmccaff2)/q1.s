		AREA question1, CODE, READONLY
		ENTRY

		MOV r3, #0 ;Clear r3 to use for the first sum
		MOV r4, #0 ;Clear r4 to use for the second sum
		ADR r1,UPC ;Point r1 at the UPC

loop	LDRB  r2,[r1],#1 ;Read an element of the UPC to r2
		CMP r2,#0xFF
		BEQ next
		SUB r2, r2, #48 ;Subtract 48 from the ascii code to get the decimal value
		ADD r3, r2 ;Add the value to the first sum
		
		LDRB  r2,[r1],#1 ;Read another element of the UPC to r2
		SUB r2, r2, #48 ;Subtract 48 from the ascii code to get the decimal value
		ADD r4, r2 ;Add the value to the second sum
		B loop

next	MOV r5, #3 ;Move a 3 to be used in multiplying the first sum
		MLA r4, r3, r5, r4 ;Multiply the first sum by 3, then add to the second sum
		

loop2	SUB r4,#10 ;Repeatedly subtract 10 from r4 to check divisibility by 10
		CMP r4,#0 ;Compare to zero
		
		BGT loop2

		MOVEQ r0,#1 ;If r4 was zero, then the check digit was correct and we move 1 to r0
		MOVLT r0,#2 ;If r4 was less than zero, then the check digit was incorrect
		
UPC 	DCB "013850150738" ;UPC string
EOS		DCB 0xFF
		END