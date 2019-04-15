			AREA question2, CODE, READWRITE
			ENTRY
			
			LDR r13, =stack				; Setup stack pointer
			LDR r0, x					; load the value of x to r0, this value will be used in our calculation function
			BL calculation
			MOV r1, r0, LSL #1			; After control is returned from the function, multiply r0 and move the product into r1
finish		B finish		

calculation	STMFD r13!, {r2-r7, r14}	; Store the following registers in the stack for use in the calculation, the stack pointer is autoindexed here (Note r14, this will be used to exit the function)
			LDR r2, a					; Lines 11-16 involve loading the registers that are in the stack with variables
			LDR r3, b					;
			LDR r4, c					;
			LDR r5, d					;
			LDR r6, x					;
			MOV r7, #0					; r7 will be used for the actual calculations, it represents "y" in the calculation
			
			MLA r7, r3, r6, r4			; The following MLA operation is equivalent to (b*x) + c
			MUL r0, r6, r6				; The following MUL operation is a way of squaring the value of x
			MLA r7, r0, r2, r7			; The following MLA operation is equivalent to a*x^2 + z, where z represents (b*x) + c
			
			CMP r7, r5					; Compare the result with the value of d
			MOVGT r0, r5				; If the value of the result is larger, then set r0 to the value of d
			MOVLE r0, r7				; IF the value of the result is equal or smaller, then set r0 to the value of the result
			
			LDMFD r13!, {r2-r7, r15}	; Restore the registers and use r15 to return back to the BL calculation call
			
			
			
			AREA question2, CODE, READONLY
			SPACE 0x40					; Create enough space for the stack
stack		DCD 0x00					; Set the base of the stack
a			DCD 5						; Lines 33-37 involve setting values for the variables a,b,c,d,x.store 
b			DCD 6						;
c			DCD 7						;
d			DCD 90						;
x			DCD 3						;
			END
		