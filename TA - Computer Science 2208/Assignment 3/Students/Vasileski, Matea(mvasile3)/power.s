		AREA POWER, CODE, READWRITE
		ENTRY		
		
		STMFD sp!, {fp} 		;creating stack frame
		MOV fp, sp				;pointing frame pointer at base of the stack
		SUB sp, sp, #8			;making sure sp is pointing correctly at the top of 2 integers
							
x		EQU	1					;inserting 1 into x
n		EQU 1					;inserting 1 into n
		MOV r0, #x				;putting x into r0
		MOV r1, #n				;putting n into r1
		STR r0, [fp, #-4]		;pushing the first parameter 'x' onto stack frame 
		STR r1, [fp, #-8]		;pushing second parameter 'n' onto stack frame
		BL power				;calling the power function
		ADD sp,sp,#8 			;removing parameters from the stack
		
loop	b	loop

power	STMFD sp!, {fp}			;creating stack frame
		MOV fp, sp				;pointing frame pointer at base
		
		STR r4, [fp, #-12]
		
		LDR r2, [fp,#4]			;get parameter x
		
		LDR r3, [fp, #8]		;get parameter n
		
		CMP r3, #0				;if (n==0)
		BNE false				;if false skip to next if statement
		
		MOV r0, #1				;put 1 in r0
		STR r0,[sp,#-4]			;returning 1 above the stack parameters since n was == to 1
		MOV sp,fp				;restoring sp
		LDMFD sp!, {fp}			;restoring frame pointer
		
		

false	AND r3, #1				;check if (n & 1)
		BEQ then				;if false, branch to then
		SUB r3, r3, #1			;changing n, to n-1
		MUL sp, r2, BL power	;returning x*power(x,n-1)
		
then	LSR r3, #1				;shifting n right by 1 bit
		STR r3, [fp, #-8]		;setting n in proper stack position after the shift
		MOV r7, BL power		;setting r7 (y) equal to power(x, n>>1)
		MUL r7, r7				;multiplying y by itself
		LDR r2, [sp]			;returning the value
		ADD sp, sp, #4			;cleaning stack frame
		LDMFD sp, {fp}			;returning back to frame pointer

		END