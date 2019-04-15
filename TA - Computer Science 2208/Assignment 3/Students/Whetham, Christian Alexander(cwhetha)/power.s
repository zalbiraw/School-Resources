			AREA power, CODE, READONLY
			ENTRY
Main		ADR sp,Stack
			MOV r0,#3             		;loads our parameter n
			STR r0,[sp,#-4]!      		;stores the parameter in the stack
			BL  Func              		;calls the function
			LDR r1,[sp],#4        		;pops the value from the stack
			STR r1, result        		;stores the value in result
Loop		B Loop
		
Func		STMDB sp!,{fp,lr,r1-r3}		;saves the resisters and the return address
			MOV fp,sp					;frame pointer at the bottom of the frame
			LDR r2,[fp,#20]				;loads the parameter value
			SUB sp,sp,#4				;creates a stack frame
			TST r2, #0x1				;checks if parameter is odd
			BLNE Odd					;if so branch to odd 
			CMP r2,#0x0					;checks if parameter is even and not 0
			BLNE Even					;if so branch to even
			MOV r2,#1					;otherwise value is zero
			STR r2,[fp,#20]				;store one in the previous parameter slot
			ADD sp,sp,#4				;clean stack frame
			LDMIA sp!,{fp,pc,r1-r3}		;return to previous call, restoring previous values
			
Odd			LDR r1,Base					;loads our x value
			SUB r2,r2,#1				;subtracts one from the parameter
			STR r2,[fp,#-4]				;stores the parameter
			BL Func						;recursivly calls the function
			LDR r2,[fp,#-4]				;load updated parameter
			MUL r3,r2,r1				;multiply parameter with the base
			STR r3,[fp,#20]				;store the updated value in the previous parameter spot
			ADD sp,sp,#4				;clean stack frame
			LDMIA sp!,{fp,pc,r1-r3}		;return to previous call, restoring previous values
			
Even		LSR r2, #1					;shifts parameter right 1 ie divide by 2
			STR r2,[fp,#-4]				;stores the parameter
			BL Func						;recursively calls function
			LDR r2,[fp,#-4]				;load updated parameter
			MUL r3,r2,r2				;multiply parameter by itself
			STR r3,[fp,#20]				;store parameter in the previous parameter spot
			ADD sp,sp,#4				;clean the stack frame
			LDMIA sp!,{fp,pc,r1-r3}		;return to previous call, restoring previous values
			
			AREA power, DATA, READONLY
			SPACE 0x90	
Stack		DCD 0x0000
result		DCD 0x0000
Base        DCD 0x0002
			END