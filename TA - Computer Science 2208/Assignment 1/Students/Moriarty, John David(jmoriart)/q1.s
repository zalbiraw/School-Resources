		AREA q_one, CODE, READONLY
		ENTRY
		ADR		r0, UPC			; load address of UPC in r0
		MOV		r4, #6			; setup a counter starting at 6, counting down
Loop	LDRB	r1, [r0, #1]!	; get value at r0, put in r1
		SUB		r1, r1, #48		; subtract the ascii number to get the decimal value
		SUBS	r4, r4, #1		; decrement counter
		ADD		r2, r2, r1		; add to a running total for first sum
		LDRB	r1, [r0, #1]!	; get value at r0 and put in r1
		SUB		r1, r1, #48		; subtract ascii number to get decimal value
		BEQ		Next			; checks if at the end, then skips check digit
		ADD		r3, r3, r1		; add to a running total for first sum
		BNE		Loop			; checks if counter is zero
Next	ADD		r2, r2, LSL#1	; multiply sum1 by 3
		ADD 	r2, r2, r3		; add sum1 and sum2, store in r2
		SUB		r2, r2, #1		; subtract 1 from the total
Div		SUB		r2, r2, #10		; repeated subtraction by 10 (div)
		CMP		r2, #10			; compare the subtraction with 10
		BGT		Div				; if > 10, loop again
		SUB		r2, r2, #9		; subtract total from 9
		ADDS	r2, r1			; add the check digit and the remainder
		MOV		r0, #1			; VALID
		BEQ		Done			; if equals 0, skip to end, else NOT VALID
		MOV		r0, #2			; NOT VALID
Done	B 		Done				

		AREA q_one, DATA, READONLY
UPC		DCB	 	"060383755577"		;UPC code string
		END