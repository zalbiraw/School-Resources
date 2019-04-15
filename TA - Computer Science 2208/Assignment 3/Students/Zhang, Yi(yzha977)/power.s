		AREA power,CODE,READONLY
n		EQU		7						;n=7
x		EQU		2						;x=2		
	    ENTRY							;This is the calling environment
Main 	ADR 	sp,stack 				;define the stack
		MOV 	r3,#1					;prepare the parameter,r3 = 1, for check if the n = 0 in the beginning
		MOV 	r0,#n 					;prepare the parameter,r0 = n
		MOV		r2,#x					;prepare the parameter,r2 = x
		STR 	r0,[sp,#-4]! 			;push the parameter on the stack
		SUB 	sp,sp,#4 				;reserve a place in the stack for the return value
		BL 		POWER 					;call the Fact subroutine
		LDR 	r0,[sp],#4 				;load the result in r0 and pop it from the stack
		ADD 	sp,sp,#4 				;also remove the parameter from the stack
BACK	ADR 	r1,result 				;get the address of the result variable
		STR 	r0,[r1]					;store the final result in the result variable
Loop 	B 		Loop 					;infinite loop 
;--------------------------------------------------------------------------------
		AREA	power, DATA, READONLY
POWER	CMP		r0,#0					;if n = 0
		MOVEQ	r0,#1					; { result = 1, store in r1
		STREQ	r0,[sp]					; 	update the value of result 
		BEQ		ret						;	go to ret}
		MOV		r3,#0					; r3 -> 0 meaning n is not 0 in the beginning
		STMFD 	sp!,{r0,r1,r2,fp,lr} 	; push general registers, as well as fp and lr]
		MOV		fp,sp					; set the fp for this call
		LDR		r0,[fp,#0x18]			; get the parameter from the stack
		CMP		r0,#0					; if n==0
		MOVEQ	r1,#1					;{ result = 1, store in r1
		STREQ	r1,[fp,#0x14]			;  update the value of result
		BLE		ret						;  return }
		AND		r1,r0,#1				; check n is odd or even and store the result in r1,if the value of r0 is end with 0, r0 is even, then r1 --> 0,if the value of r0 is end with 1, r0 is odd, then r1 --> 1
		CMP		r1,#1					; if n is odd
		BEQ		ODD						; jump and call ODD
		MOV		r0,r0,LSR #1			; n>>1
		STR		r0,[sp,#-4]!			; push new n in stack
		SUB		sp,sp,#4				; reserve a place in the stack for the return value
		BL		POWER					; Back to power
		MOV     sp,fp					; reset sp
		LDR		r0,[sp,#-8]				; get the previous result
		MUL		r1,r0,r0				; when n is even, result = result * result
		STR		r1,[fp,#0x14]			; store the result 
		MOV		sp,fp					; reset sp
		LDMFD	sp!,{r0,r1,r2,fp,pc}	; load all registers and return to the caller
ODD		LDR		r0,[sp]					; load n in r0
		SUB		r0,r0,#1				; n=n-1
		STR		r0,[sp,#-4]!			; update the value of n in stack
		SUB		sp,sp,#4				; create space for the result
		BL		POWER					; back to power
		MOV     sp,fp					; reset sp
		LDR		r0,[sp,#-8]				; get the previous result
		MUL		r0,r2,r0				; when n is odd, result = result * x
		STR		r0,[fp,#0x14]			; push result in stack
ret  	CMP		r3,#1					; if r3 == 1, meaning n is 0 in the beginning
		BEQ		BACK					; END
		CMP     r0,#1					; if r0 == 1, meaning it turns base case 
		MOVEQ   sp,fp					; reset sp
		MOVEQ   pc,lr					; reset pc
		MOV  	sp,fp       			; collapse all working spaces for this function call
		LDMFD 	sp!,{r0,r1,r2,fp,pc} 	; load all registers and return to the caller
;--------------------------------------------------------------------------------
		AREA	power, DATA, READWRITE
result	DCD		0X00					;the final result
		SPACE	0x8F					;declare the space for stack
stack	DCD		0x00					;initial stack position (FD model)
;--------------------------------------------------------------------------------
		END