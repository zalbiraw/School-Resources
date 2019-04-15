	    AREA Pointers, CODE, READONLY
	    ENTRY
Start   ADR  r1,UPC   			;register r0 points to UPC
		MOV  r0, #0				;initialize r0 for use later
		MOV  r3, #0				;initialize accumulator
		MOV  r4, #6				;initialize counter

LoopA	LDRB r2,[r1],#2 		;load first byte of upc code into r2 and increment by 2 bytes
		SUB  r2, #0x00000030	;calculate hex representation of ASCII code
		ADD  r3, r2				;add value to accumulator
		SUBS r4, #1				;decrement counter
		BNE  LoopA				;repeat until 11th digit
		
		ADD  r3, r3, LSL#1		;multiply first sum by 3
		ADR  r1,UPC				;reset pointer to UPC code
		ADD  r1, #1				;skip first byte
		MOV  r4, #5				;reset counter
LoopB	LDRB r2,[r1],#2 		;load first byte of upc code into r2 and increment by 2 bytes
		SUB  r2, #0x00000030	;calculate hex representation of ASCII code
		ADD  r3, r2				;add value to accumulator
		SUBS r4, #1				;decrement counter
		BNE  LoopB				;repeat until 11th digit
		
		SUB  r3, #1				;subtract 1
LoopC	SUB  r3, #10			;repeatedly subtract 10 until it is below 10 (i.e. the remainder)	
		CMP  r3, #10			;determine if it is below 10 yet
		BGE  LoopC				;loop until it is less than 10
		
		NEG  r3, r3				;store negative
		ADD  r3, #9				;add 9 (same as subtracting 9)
		ADR  r1,UPC				;find final digit
		ADD  r1, #11			;find final digit
		LDRB r2, [r1]			;store final digit in r2
		SUB  r2, #0x00000030	;calculate hex representation of ASCII code
		CMP  r2,r3				;see if check digit is valid
		ADDEQ r0, #1			;store 1 if valid
		ADDNE r0, #2			;store 2 if not valid
		
UPC 	DCB	 "060383755577" 	;UPC string
	    END
