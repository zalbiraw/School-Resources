		AREA polynomial, CODE, READONLY
		ENTRY
		
		LDR r0, x				; Load x into r0
		ADR r9, abcd			; Pointer to the variables of a,b,c,d
		LDM r9!, {r4,r5,r6,r7}	; Store a,b,c,d into r4,r5,r6,r7
		
		BL Calc					; Function to calculate result
		MOV r1, r0, LSL #1		; Shift to multiply by two

Done	B Done					; End loop			

Calc	STR r1, storage1		; Store the value in r1 to be put back later
		STR r2, storage2		; Store the value in r2 to be put back later
		MLA r1,r0,r4,r5			; Calculate (x*a) + b and store into r1
		MLA r2, r1, r0, r6		; Calculate a*x^2 + b*x + c and store into r0
		MOV r0, r2				; Move value of calculation into r0, to avoid unexpected MLA errors
		CMP r0, r7				; Check if y > d
		MOVGT r0, r7			; If so, then return d
		LDR r1, storage1		; Load r1 from the storage, restoring original value
		LDR r2, storage2		; Load r2 from the storage, restoring original value
		BX  r14					; Load in the old value inside r1 from storage
							
		AREA polynomial, CODE, READWRITE					
abcd    	DCD 5,6,7,90			; Variables a, b, c, d for use within the function
x			DCD 3					; Value to x to be used as input for function
storage1	DCD 0x00				; temporary value storage for sub-routine
storage2	DCD 0x00				; temporary value storage for sub-routine
			END