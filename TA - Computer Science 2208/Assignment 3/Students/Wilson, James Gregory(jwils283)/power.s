;--------------------------------------------------------------------------------
		AREA  power, CODE, READONLY
x		EQU   2
n    	EQU   4
		ENTRY
Main 	ADR   sp,stack      ;define the stack

		MOV   r0, #n        ;prepare the n parameter
		STR   r0,[sp,#-4]!  ;push the n parameter on the stack
		MOV   r1, #x        ;prepare the x parameter
		STR   r1,[sp,#-4]!  ;push the x parameter on the stack

		SUB   sp,sp,#4      ;reserve a place in the stack for the return value

		BL    Pow           ;call the Pow subroutine

		LDR   r0,[sp],#4    ;load the result in r0 and pop it from the stack
		ADD   sp,sp,#8      ;also remove the parameter from the stack

		ADR   r1,result     ;get the address of the result variable
		STR   r0,[r1]       ;store the final result in the result variable

Loop 	B     Loop          ;infinite loop
;--------------------------------------------------------------------------------
		AREA  power, CODE, READONLY
Pow 	STMFD sp!,{r0,r1,r2,r3,r4,r5,fp,lr} 	;push general registers, as well as fp and lr
		MOV   fp,sp         		;set the fp for this call

		LDR   r0,[fp,#0x28] 		;get the n parameter from the stack
		LDR   r1,[fp,#0x24] 		;get the x parameter from the stack

		CMP   r0,#0         		;if (n == 0)
		MOVEQ r0,#1         		;prepare the value to be returned
		STREQ r0,[fp,#0x20]  		;store the returned value in the stack
		BEQ   ret           		;branch to the return section 
									
		AND   r3,r0,#1				;store result of AND operation in r3
		CMP   r3,#1					;check if result is 1, meaning n is odd
		BNE   els					;if result is not one branch to the els(e) routine
		SUB   r0,r0,#1      		;prepare the new n parameter value
		STR   r0,[sp,#-4]!  		;push the n parameter on the stack
		STR   r1,[sp,#-4]!  		;push the x parameter on the stack
		SUB   sp,sp,#4      		;reserve a place in the stack for the return value
		BL    Pow					;call the Pow subroutine
		LDR   r4,[sp],#4			;get the return value
		MUL   r5,r1,r4				;multiply x by the return value
		STR   r5,[fp,#0x20]			;store the new value
		B     ret					;branch to the ret subroutine
		
els		LSR   r0,r0,#1      		;prepare the new n parameter value
		STR   r0,[sp,#-4]!  		;push the n parameter on the stack
		STR   r1,[sp,#-4]!  		;push the x parameter on the stack
		SUB   sp,sp,#4      		;reserve a place in the stack for the return value
		BL    Pow  					;call the Pow subroutine     	 
		LDR	  r4,[sp],#4			;get the return value
		MUL   r5,r4,r4				;multiply y by y
		STR   r5,[fp,#0x20]			;store the new value

ret  	MOV   sp,fp         		;collapse all working spaces for this function call
		LDMFD sp!,{r0,r1,r2,r3,r4,r5,fp,pc} 	;load all registers and return to the caller
;--------------------------------------------------------------------------------
		AREA power, DATA, READWRITE
result 	DCD   0x00        	;the final result
		SPACE 0x110       	;declare the space for stack
stack  	DCD   0x00        	;initial stack position (FD model)
;--------------------------------------------------------------------------------
		END