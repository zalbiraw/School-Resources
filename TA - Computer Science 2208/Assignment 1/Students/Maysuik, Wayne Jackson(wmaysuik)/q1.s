	AREA Question1, CODE, READONLY
		ENTRY
		
ASCII	EQU		0x30		
			
		ADR 	r1, UPC			; Move the address of the UPC string into r1
		MOV 	r2, #6			; Initialize the loop counter to 6

sum		LDRB 	r5, [r1], #1	; Load r5 with the base value of r1 then increment the address by 1 byte
		SUB		r5, #ASCII		; Convert the ascii character into an integer
		ADD 	r3, r5			; Add to r3 the next digit of the UPC (stored in r5)
		
		ADD 	r4, r6			; Add to r4 the next digit of the UPC (stored in r6)
		LDRB 	r6, [r1], #1	; Load r6 with the base value of r1 then increment the address by 1 byte
		SUB		r6, #ASCII		; Convert the ascii character into an integer
		SUBS	r2, #1			; Subtract 1 from the loop counter
		BNE		sum				; If the loop counter is not 0, loop again
		
		ADD		r3, r3, LSL	#1	; Multiply the contents of r3 (sum 1) by 3
		ADD		r3, r4			; Add r3 (sum 1) and r4 (sum 2)
		SUB		r3, #1			; Subtract 1 from the sum total
div		SUBS	r3, #10			; Subtract 10 to do 1 division
		BPL		div				; While r3 is positive, keep dividing
		ADD		r3, #10			; Add 10 to get back the remainder
		RSB		r3, #9			; Subtract the remainder from 9
		
		CMP		r3, r6			; Compare the remainder to the last digit
		MOVEQ	r0, #1			; Move 1 into r0 if the result is correct
		MOVNE	r0, #2			; Move 2 into r0 if the result is incorrect
		
loop	B		loop		
		
UPC 	DCB 	"692771017440" 	;UPC string 
		END