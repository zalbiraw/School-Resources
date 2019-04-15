		AREA power, CODE, READONLY
		ENTRY

;-------Assign values to variables-------
x		EQU 0x6					
n		EQU 0x2
		
		ADR sp, stack				; stack pointer will point to bottom of stack, given by stack memory location
		MOV r1, #x					; store x in r1
		MOV r2, #n					; store n in r2
		STMFD sp!, {r1, r2}			; store both variables at bottom of stack
		BL func						; branch to function to perform instrucitons in subroutine
		LDR r0, [sp]				; load return value into r0
result	EQU r0
loop	B	loop
		
func	STMFD sp!, {fp, lr}			; store frame pointer and link register in stack
		MOV fp, sp					; move stack pointer to point to begninning of stack
		SUB sp, sp, #4				; create stack frame
		; Case 1: n is zero
		CMP r2, #0					; compare n with 0
		MOVEQ r2, #1				; if so, return value = 1
		BEQ finish					; branch to finish
		
		; Case 2: n is odd
		TST r2, #1					; test if n is odd
		BEQ even					; if event, go to even	
		SUBNE r2, r2, #1			; if n is odd, subtract 1 from n
		STMFDNE sp!, {r1-r2}		; store parameters and the result
		BLNE func					; recursive call 
		LDR r0, [sp], #4			; get the value returned 
		LDMFD sp!, {r1-r2}			; load variables into r0 and r1 again
		MUL r2, r1, r0				; multiply return value by x
		B finish					; go to finish
		
		; Case 3: n is even
even	ASR r2, #1					; divide n by 2
		STMFD sp!, {r1-r2}			; store the parameters of the current frame
		BL func						; recursive call
		LDR r0, [sp], #4			; load return value into r0
		LDMFD sp!, {r1-r2}			; load parameters of current call frame
		MOV r2, r0					; copy return value into r2
		
		MUL r2, r0, r2				; square return value
		B finish

finish	LDR r0, [sp]				; put return value in r0
		ADD sp, sp, #4				; clean stack frame
		LDMFD sp!, {fp, lr}			; restore frame pointer and link register from stack
		ADD r0, r0, r2				; add previous return value to current return value
		STR r0, [sp, #-4]!			; store return value on the stack above x and n
		BX lr						; return to instruction following sub-routine call		
		
		AREA power, DATA, READWRITE
		space 0x1							; padding
		space 0xFF							; space for stack
stack	DCD	0x00							; beginning of stack							
		END