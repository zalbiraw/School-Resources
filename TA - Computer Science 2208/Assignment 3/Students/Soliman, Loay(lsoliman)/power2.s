		AREA power, CODE, READONLY
x		EQU 4								;declare the initial x value
n		EQU 4								;declare the initial n value
		ENTRY
MAIN	ADR sp,STK							;define the stack
		MOV r0, #x							;prepare the parameter `x`
		MOV r1, #n							;prepare the parameter `n`
		STMFD sp!, {r0-r1}					;push the parameters onto the stack
		SUB sp,sp,#4						;reserve a place in the stack for the return value
	
		BL POW								;call the Pow subroutine
		LDR r1,[sp],#4						;load the result in r1 and pop it from the stack
		ADD sp,sp,#8						;also remove the parameters from the stack
	
		ADR r2,RES							;get the address of the result variable
		STR r1,[r2]							;store the final result in the result variable
STP		B STP								;infinite loop


POW		STMFD sp!,{r0,r1,r2,r3,fp,lr}		;push general registers, as well as fp and lr
		MOV fp,sp							;set the fp for this call
		LDR r0,[fp,#0x1C]					;get the parameter `x` from the stack
		LDR r1,[fp,#0x20]					;get the parameter `n` from the stack
	
		CMP r1,#0							;if (n == 0)
		MOVEQ r1,#1							;{ prepare the value to be returned
		STREQ r1,[fp,#0x18]					; store the returned value in the stack
		BEQ RET								; branch to the return section
											;}
		
		TST r1,#1							;else if (!n & 1) [n is even]
		BEQ EVE								;branch to the section that handles even exponents
		
											;else [n is odd]
		SUB r2,r1,#1						;{ prepare the new parameter value `n-1`
		STR r2,[sp,#-4]!					; push the parameter `n-1` on the stack in place of n
		STR r0,[sp,#-4]!					; push the parameter `x` on the stack as is
		SUB sp,sp,#4						; reserve a place in the stack for the return value
		BL POW								; call the Pow subroutine
		LDR r2,[sp],#4						; load the result in r2 and pop it from the stack
		ADD sp,sp,#8						; remove also the parameters from the stack
		MUL r3,r0,r2						; prepare the value to be returned
		STR r3,[fp,#0x18]					; store the returned value in the stack
		B RET
											;}
EVE		LSR r2,r1,#1						;{ prepare the new parameter value `n >> 1`
		STR r2,[sp,#-4]!					; push the parameter `n >> 1` on the stack in place of n
		STR r0,[sp,#-4]!					; push the parameter `x` on the stack
		SUB sp,sp,#4						; reserve a place in the stack for the return value
		BL POW								; call the Pow subroutine
		LDR r2,[sp],#4						; load the result in r2 and pop it from the stack
		ADD sp,sp,#8						; remove also the parameters from the stack
		MUL r3,r2,r2						; prepare the value to be returned
		STR r3,[fp,#0x18]					; store the returned value in the stack
											;}
RET		MOV sp,fp							;collapse all working spaces for this function call
		LDMFD sp!,{r0,r1,r2,r3,fp,pc}		;load all registers and return to the caller
		
		AREA power, DATA, READWRITE
RES		DCD 0x00							;the final result
		SPACE 0xB4 							;declare the space for stack
STK		DCD 0x00 							;initial stack position (FD model)
		END
		 