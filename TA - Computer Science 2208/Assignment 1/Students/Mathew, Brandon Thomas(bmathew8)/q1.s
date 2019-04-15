	AREA QUESTION1, CODE, READWRITE
	ENTRY

	LDR	r0, =UPC				;initializes UPC memory location in r0 so we can access it
	MOV	r1, #0					;loads int 0 into r1, which will be the odd pointer
	MOV r2, #1					;loads int 1 into r2, which will be the even pointer
		
LOOP							;begin loop to sum odd and even UPC digits			
	LDRB r3, [r0, r1]			;load byte from odd pointer and store result in r3
	LDRB r4, [r0, r2]			;load byte from even pointer and store result in r4
	
	SUB r3, r3, #48				;subtract 48 to convert from ASCII to int (because ASCII nums range 48-57)
	SUB r4, r4, #48				;subtract 48 to convert from ASCII to int (because ASCII nums range 48-57)
	
	ADD r5, r5, r3				;compound the sum of odd UPC digits
	ADD r6, r6, r4				;compound the sum of even UPC digits
	
	ADD r1, r1, #2				;add 2 to increment pointer to next odd digit
	ADD r2, r2, #2				;add 2 to increment pointer to next even digit
		
	CMP r1, #12					;check if we have reached the end (index position 12)
	BNE LOOP					;keep looping if index does not equal 12
	
	
	ADD r5, r5, r5, LSL#1		;left shift (ie times 2) r5 and adding r5 is same as multiplying by 3
	SUB r6, r6, r4				;this subtraction excludes the check digit for the calculation
	
	ADD r7, r6, r5				;add the resulting odd and even sums together
	SUB r7, r7, #1				;subtract 1 from the total
	
	B MODULO					;breaks to MODULO subroutine

MODULO
	CMP r7, #9					;before dividing, must check if r7 is greater than 9
	SUBGT r7, r7, #10			;minus 10 if greater...division involves repeated subtraction
	CMP r7, #9					;check again if r7 is still greater than 9
	BGT MODULO					;subroutine will repeat until value is less
	
CHECK
	RSB r7, r7, #9				;this allows us to computer the check digit
	CMP	r7, r4					;r4 contains the check digit...check if this computed value is the same
	BEQ VALID					;branches to VALID subroutine if equal
	BNE INVALID					;branches to INVALID subroutine if not equal

VALID
	MOV r0, #1					;set r0 to 1 to indicate valid UPC
	B FINAL

INVALID
	MOV r0, #2					;set r0 to 2 to indicate invalid UPC

FINAL

loop b loop						;end of loop
	
	
	AREA QUESTION1, DATA, READWRITE
UPC	DCB "013800150738"			;sample UPC string that can be changed for testing the program
	
	END
