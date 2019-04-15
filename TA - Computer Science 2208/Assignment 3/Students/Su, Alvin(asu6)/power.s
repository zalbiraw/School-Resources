		AREA PowerProg, CODE, READONLY
		
x		EQU 	5					;Set the x value for x^n
n		EQU	3					;Set the n value for x^n
		
		ENTRY
		
MAIN	ADR		SP, STACK			;Set up stack pointer
		MOV		r0, #x				;Set parameters for x
		MOV		r1, #n				;Set parameters for n 
		STR		r1, [SP, #-4]!		;Push n onto the stack
		STR		r0, [SP, #-4]!		;Push x onto the stack
		
		SUB		SP, SP, #4			;Location is reserved in stack for return value 
		BL		POWER				;Call POWER subroutine 
		LDR		r0, [SP], #4		;Result is loaded into r0 and popped from stack 
		ADD		SP, SP, #4			;remove parameter from stack 
		
		ADR		r1, RESULT			;Get address of RESULT
		STR		r0, [r1]			;Store end result of calculations into RETURN

LOOP	B		LOOP				;Infinite loop

;--------------------------------------------------------------------------------
		AREA PowerProg, CODE, READONLY

POWER	STMFD	SP!, {r0-r2, FP, LR}	;general registers (r0-r2),FP and LR are pushed
		MOV		FP, SP					;Set FP for this call 
		SUB		SP, SP, #4				;Space for local variable y is created 
		
		LDR		r0, [FP, #0x18]			;Get parameter from stack
		STR		r0, [FP, #-0x4]			;Update value of local variable y
		
		CMP		r1, #0					;Check if n = 0, if true, then
		MOVEQ	r0, #1					;	prepare value to be returned 
		STREQ	r0, [FP, #0x14]			;	store return value into stack
		BEQ		RETURN					;	branch to RETURN
		
		TST		r1, #1					;Check if n is odd, if true, then
		SUBNE	r1, #1					;Decrease n by 1
		STRNE	r0, [SP, #-4]!			;store x into stack 
		SUBNE	SP, SP, #4				;Location is reserved in stack for return value 
		
		BLNE	POWER					;Call POWER function 
										;If n is even, then 
		LSREQ	r1, #1					;divide n by 2 
		
		BLEQ	POWER					;Call POWER function
		
		MULEQ	r2, r0, r0				;Return value multiplied by itself and stored in y
		STREQ	r2, [SP, #-4]!			;Store y in stack 
		
		SUBEQ	SP, SP, #4				;Location is reserved in stack for return value 
		
		LDR		r0, [SP], #4			;Load RESULT into r0 and pop from stack 
		ADD		SP, SP, #4				;Remove parameter from stack 
		
		MUL		r2, r0, r2				;Prepare value to be returned 
		STR		r2, [FP, #0x14]			;Store return value into stack
		
RETURN	MOV		SP, FP					;Collapse working space for this function call
		LDMFD	SP!, {r0-r2, FP, PC}	;Load all registers and return to caller 
		
;---------------------------------------------------------------------------------
		AREA PowerProg, DATA, READWRITE
			
RESULT	DCD		0x0						;Final result
		SPACE	0xC						;Declare space for stack
STACK	DCD		0x0						;initial stack position (FD)

;---------------------------------------------------------------------------------
		END