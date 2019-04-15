		AREA question1, CODE, READONLY
		ENTRY
		LDR r0, X						;load x
		LDR r1, N						;load n
		LDR sp, =STACK					;load stack pointer
		MOV fp, sp						;set up frame pointer
		STMFD sp!, {r0,r1}				;push params
		SUB sp, #4						;make space for return value
		BL POWER						;call function
		LDR r2, [sp]					;result
		STR r2, result
LOOP	B LOOP
		
		
POWER	STMFD sp!, {r0,r1,r2,r3,fp,lr}	;save caller's registers
		MOV fp, sp						;set up frame pointer
		LDR r0, [fp, #28]				;load first parameter (x)
		LDR r1, [fp, #32]				;load second parameter (n)
		CMP r1, #0						;n == 0?
		MOVEQ r2, #1					;
		STREQ r2, [fp, #24]				;return 1
		BEQ DONE						;
		TST r1, #1						;n & 1?
		SUBNE r1, #1					;if yes, n = n-1
		MOVEQ r1, r1, LSR #1			;if no, n = n >> 1
		MRS r3, CPSR					;save status flags
		STMFD sp!, {r0,r1}				;push params for next call
		SUB sp, #4						;make space for return value
		BL POWER						;recursive call
		LDR r2, [sp]					;load return value (y)
		ADD sp, #12						;collapse parameters and return value
		MSR CPSR_f, r3					;move status flags back
		MOVEQ r0, r2					;if not n & 1, return y * y
		MUL r3, r0, r2					;else return x * y
		STR r3, [fp, #24]				;store return value
DONE	LDMFD sp!, {r0,r1,r2,r3,fp,pc}	;load caller's registers
		
		AREA question1, DATA, READWRITE
X		DCD 5
N		DCD 3
result	DCD 0
		SPACE 256
STACK	DCD 0
		
		END