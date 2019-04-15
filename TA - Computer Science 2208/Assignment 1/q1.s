		AREA	upc, CODE, READONLY
		ENTRY
PAIRS	EQU		6				;set a counter to count for 6 pair of digits (6 even abd 6 odd)
OK		EQU		1				;successful return code
FAIL	EQU		2				;failure return code
MASK	EQU		48				;mask to convert ascii to numeric
MOD		EQU		10				;Modulus value for check digit

		MOV		r0,#FAIL		;initialize result to fail
		MOV		r1,#0			;initialize r1 to 0 for group 1 sum (odd  positions)
		MOV		r2,#0			;initialize r2 to 0 for group 2 sum (even positions)
		MOV 	r3,#PAIRS		;set a counter to count for 6 pairs of digits
		
		ADR		r4,UPC			;reg r5 points at start of UPC string
								;loop through each character in string
loop	LDRB	r5,[r4],#1		;  load temp reg r3 with ascii value at string offset
		BIC		r5,#MASK		;  convert ascii to numeric value
		ADD		r1,r1,r5		;  accumulate values to group 1 sum
		
		LDRB	r5,[r4],#1		;  load temp reg r3 with ascii digit
		BIC		r5,#MASK		;  convert ascii to numeric value
		ADD		r2,r2,r5		;  accumulate values to group 2 sum

		SUBS	r3,r3,#1		;  decrement pointer offset
		BNE		loop			;  branch if offset > 0
		
		ADD		r1,r1,r1,LSL#1	;multiply group 1 by 3
		ADD		r2,r2,r1		;add group 1 to group 2
								;loop to calculate mod 10 - predecrement for optimization
modLoop	SUBS	r2,r2,#MOD		;  decrement total by 10
		BGT		modLoop			;  while total > 0 : will produce result [-9,0]
		
		MOVEQ	r0,#OK			;set result to correct if total was 0
	
EoP		B		EoP				;infinite end-of-program loop

		AREA	upc, DATA, READONLY
UPC		DCB	"013800150738"	;UPC string
		END