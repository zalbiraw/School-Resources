		AREA q1, CODE, READONLY
		ENTRY
		
		LDR r0, UPC					;load memory location of UPC into r0
		MOV r1, #0					;r1 is loaded with value 0
		MOV r2, #1					;r2 is loaded with value 1
		
LOOP
		LDRB r3, [r0, r1]			;load a byte from r0 at pointer r1 to r3
		SUB	r3, r3, #48				;get Integer value from r3
		ADD	r5, r5, r3				;add r5 and r3 and store it in r5 - odd numbers are being added
		ADD	r1, r1, #2				;move r1 pointer forward 2
		
		LDRB r4, [r0, r2]			;load a byte from r0 at pointer r2 to r4
		SUB	r4, r4, #48				;get Integer value from r4
		ADD	r6, r6, r4				;add r6 and r3 and store it in r6 - even numbers are being added
		ADD	r2, r2, #2				;move r2 pointer forward 2
		
		CMP r1, #12					;check if at the 12th digit
		BNE LOOP					;branch to LOOP if CMP does not return 0 (Not yet at 12th digit)
		
		ADD	r5, r5, LSL #1			;using logical shift left to multiply r5 (odd sum) by 3
		ADD	r1, r5, r6				;add odd digit sum and even digit sum and store in r1
		
		MOV r0, #0					;zero out r0
		
		B DIV10						;branch to DIV10

DIV10
		CMP r1, #9					;check if the sum is less than 10
		SUBGT r1, #10				;if CMP is not 0 subtract 10
		MOVLT r0, #1				;if CMP returns 0 then store value of 1 to r0
		CMP r0, #1					;check to see if r1 is 1
		BNE DIV10					;if CMP does not return 0 branch back to DIV10

CHECK
		CMP	r1, #0					;compare r1 and 0
		BEQ RIGHT					;if equal, branch to RIGHT
		BNE WRONG					;if not equal, branch to WRONG
		
RIGHT
		MOV r0, #1					;store value of 1 to r0 to signify valid UPC
		B BREAK						;branch to BREAK to terminate

WRONG
		MOV r0, #0					;store value of 0 to r0 to signify invalid UPC

BREAK

		AREA q1, DATA, READWRITE
UPC 	DCB "013800150738"				;UPC string
EOS 	DCB 0x00 						;Mark End of String
		END              					