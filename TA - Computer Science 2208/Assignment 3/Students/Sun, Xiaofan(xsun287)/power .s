			AREA asn5, CODE, READWRITE
			ENTRY
;Main method--------------------------------------------------------------------------------------------------------		
			LDR sp, =BoS					;set sp to point to bottom of stack
			LDR fp, =BoS					;set fp to point to bottom of stack
			LDR r1, X						;load value of x into r1
			LDR r2, N						;load value of n into r2
			STMDB sp!, {r0-r2}				;push empty return value, x, and n onto stack
			BL Function						;call function
			LDMIA sp!, {r0-r2}				;pop return value and parameters on stack			
			STR r0, result					;store return value in result
Loop		B Loop							;end of main method
;Function------------------------------------------------------------------------------------------------------------
Function	STMDB sp!, {r1, r2, fp, lr}		;push r1, r2, fp and lr onto stack
			LDMDB fp, {r1, r2}				;load parameters into r1 and r2
			MOV fp, sp						;set fp to top of stack for new stack frame
			CMP r2, #0						;check if n is 0
			MOVEQ r2, #1					;if n is 0, set return value in r2 to 1
Return		STREQ r2, [fp, #returnDis]		;store return value in proper location in stack
			MOVEQ sp, fp					;collapse stack frame
			LDMIAEQ sp!, {r1, r2, fp, pc}	;pop registers and return address from stack
			
			TST r2, #1						;if n is not 0, then check if n is even or odd
			SUBNE r2, #1					;if n is odd, n=n-1
			LSREQ r2, #1					;if n is even, n=n/2
			STMDB sp!, {r0-r2}				;push x and new n in stack as parameters for next function call
			BLEQ Function					;for even n: call function
			LDREQ r1, [sp]					;for even n: load the returned value into r1
			MULEQ r2, r1, r1				;for even n: square returned value and store in r2
			BEQ Return						;for even n: return from function
			BL Function						;for odd n: call function
			LDR r2, [sp]					;for odd n: load the returned value into r2
			MUL r2, r1, r2					;for odd n: multiply returned value by x
			B Return						;for odd n: return from function
;Data----------------------------------------------------------------------------------------------------------------		
X			DCD 3							;x
N			DCD 12							;n
result		SPACE 4							;local variable result
stack		SPACE 168						;space for stack
BoS			DCD 0x00						;bottom of stack
SFSize		EQU 12							;size of stack frame
returnDis	EQU 16							;distance from fp to return value location in stack
			END