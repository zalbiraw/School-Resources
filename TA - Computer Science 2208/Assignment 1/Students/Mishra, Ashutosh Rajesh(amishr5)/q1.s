	AREA UPC_Check, CODE, READONLY
	ENTRY
	
	LDRB r0, UPC		; Loads r0
	SUB r0, r0, #48		; Calculates proper value of r0
	LDRB r2, UPC+2		; Loads r2
	SUB r2, r2, #48		; Calculates proper value of r2
	LDRB r4, UPC+4		; Loads r4
	SUB r4, r4, #48		; Calculates proper value of r4
	LDRB r6, UPC+6		; Loads r6
	SUB r6, r6, #48		; Calculates proper value of r6
	LDRB r8, UPC+8		; Loads r8
	SUB r8, r8, #48		; Calculates proper value of r8
	LDRB r10, UPC+10	; Loads r10
	SUB r10, r10, #48	; Calculates proper value of r10
	
	ADD r0, r0, r2		; Calculates first sum: r0=r0+r2
	ADD r0, r0, r4		; Calculates first sum: r0=r0+r4
	ADD r0, r0, r6		; Calculates first sum: r0=r0+r6
	ADD r0, r0, r8		; Calculates first sum: r0=r0+r8
	ADD r0, r0, r10		; Calculates first sum: r0=r0+r10
	
	LDRB r1, UPC+1		; Loads r1
	SUB r1, r1, #48		; Calculates proper value of r1
	LDRB r3, UPC+3		; Loads r3
	SUB r3, r3, #48		; Calculates proper value of r3
	LDRB r5, UPC+5		; Loads r5
	SUB r5, r5, #48		; Calculates proper value of r5
	LDRB r7, UPC+7		; Loads r7
	SUB r7, r7, #48		; Calculates proper value of r7
	LDRB r9, UPC+9		; Loads r9
	SUB r9, r9, #48		; Calculates proper value of r9
	
	ADD r1, r1, r3		; Calculates second sum: r1=r1+r3
	ADD r1, r1, r5		; Calculates second sum: r1=r1+r5
	ADD r1, r1, r7		; Calculates second sum: r1=r1+r7
	ADD r1, r1, r9		; Calculates second sum: r1=r1+r9
	
	MOV r2, #3			; Sets value of r2 to 3
	MUL r3, r0, r2		; Triples first sum and stores it in r3
	
	ADD r4, r1, r3		; Generates final sum by adding first and second sum
	SUB r4, r4, #1		; Subtracts 1 from final sum
	
	MOV r7, #123		; Sets r7 to a randomly chosen number
loop
	SUBS r4, #10		; Subtracts 10 from final sum
	CMP r4, #10			; Compares final sum and 10
	MOVLE r8, #123		; If final sum os less than 10, sets r8 register to same randomly chosen number
	SUBS r1, r7, r8		; Subtracts r7 and r8 to set zero flag to true
	BNE loop			; Exits loop when zero flag is true
	
	MOV r5, #9			; Sets r5 register to value of 9
	SUBS r5, r5, r4		; Subtracts calculated value (stored in r4) from r5 register's value
	
	LDRB r11, UPC+11	; Loads check digit
	SUB r11, r11, #48	; Calculates proper value of check digit

	CMP r5, r11			; Compares check digit with calculated digit
	MOVEQ r0, #1		; If two digits are equal, sets r0 register to 1
	MOVNE r0, #2		; If two digits are not equal, sets r1 register to 2

UPC	DCB	"065633454712"	; Saves UPC code (program tested with 013800150738, 060383755577, and 065633454712)
	END
