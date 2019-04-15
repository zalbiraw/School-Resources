			AREA upc, code, READONLY
			ENTRY
			MOV r0, #2			;Prep r0 with value of 2 (assume invalid until proven valid)
			LDR r1, =UPC		;Load address of UPC into r1
			MOV r5, #10			;set counter in r5 to 11th digit
FSUM		LDRB r2, [r1, r5]	;load the item from the UPC into r2
			SUB r2, r2, #48		;convert from ASCII to Integer
			ADD r3, r2, r3		;Add this digit
			SUBS r5, r5, #2		;Sub from counter
			BNE FSUM			;Check that we haven't gone through everything
			MOV r5, #9			;set counter in r5 to the 10th digit
SSUM		LDRB r2, [r1, r5]	;load the item from the UPC into r2
			SUB r2, r2, #48		;convert from ASCII to Integer
			ADD r4, r2, r4		;Add this digit
			SUBS r5, r5, #2		;Sub from counter
			BPL SSUM			;Check that we haven't gone through everything
			MOV r2, #3			;Need 3 so we can muliply by it
			MUL r6, r3, r2		;Muliply first sum by 3
			ADD	r6, r6, r4		;Add first and second sums together
			SUB r6, r6, #1		;Subtract 1
			MOV r7, r6			;Make copy to use as remainder in modulo
MODULO		SUB r7, r7, #10		;Loop to repetiviely subtract and complute modulo
			CMP r7, #10			;Make sure we aren't done
			BGE MODULO			;If not done, loop again
			MOV r2, #9			;Need 9 to subtract by
			SUB r8, r2, r7		;Subtract current value from 9
			LDRB r2, [r1, #11]	;Get check digit from UPC
			SUB r2, r2, #48		;convert from ASCII to Integer
			CMP r2, r8			;Compare calculated check digit to actual
			MOVEQ r0, #1		;If vald, set r0 to 1
PARK 		B PARK				;Parking loop
UPC			DCB	"013800150738"	;UPC string
			END