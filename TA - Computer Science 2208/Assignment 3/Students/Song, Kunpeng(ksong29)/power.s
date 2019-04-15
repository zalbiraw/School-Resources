		AREA power, CODE, READONLY
x	   EQU 2
n	   EQU 3
	   ENTRY
main   ADR sp, stack						;sp points to stack
	   MOV r0, #x							;move parameter into register
	   MOV r1, #n
	   STR r0, [sp,#-4]!					;push parameter x and n into stack
	   STR r1, [sp,#-4]!
	   SUB sp, sp, #4						;reserve a spot for return value
	   BL  Func								;branch into function
	   LDR r0, [sp], #4     				;store result into r1 and clean the spot
	   ADD sp, sp, #8	      				;pop out parameter from stack which is x and n
	   ADR r1, result       				;get address of result variable
	   STR r0, [r1]                         ;store result into result variable
loop   B   loop
;--------------------------------------
		AREA power, CODE, READONLY
Func   STMFD sp!, {r0, r1, r2, r3, fp, lr}  ;push registers into stack
	   MOV fp, sp							;set up fp
	   SUB sp, sp, #4						;create a space for local variable y
	   LDR r1, [fp, #0x1C]  				;load n
	   LDR R0, [FP, #0x20]  				;load x
	   CMP r1, #0                           ;if(n==0)
	   MOVEQ r1, #1							;return 1
	   STREQ r1, [fp, #0x18]
	   BEQ ret								;branch into return section.
	   TST r1, #1							; AND instruction 
       BNE Odd								;if n it's odd return x* power(x,n-1)			
	   BNE Even								;even, y*y
;--------------------------------------
Odd	   SUB r2,r1,#1							;get n-1
	   STR r0, [sp, #-4]!					;push into stack
	   STR r2, [sp, #-4]!
	   SUB sp, sp, #4						;spot for return value
	   BL  Func
	   LDR r3, [sp], #4 				    ;load result into r3
	   ADD sp, sp, #8      					; clean r2,r0 which stores x and n-1
	   MUL r3, r0, r3 						;calculate x*power(x,n-1)
	   STR r3, [fp, #0x18]					;store return value.
	   B  ret
;--------------------------------------
Even   LSR r2, r1, #1   					;divide by 2, store n/2 into r2
	   STR r0, [sp, #-4]!
	   STR r2, [sp, #-4]!
	   SUB sp, sp, #4
	   BL Func
	   LDR r3, [sp], #4 					;load result into r3
	   ADD sp, sp, #8   				    ; clean the stack, remove parameters, free r0,r1
	   STR r3, [fp, #-4] 					;store result into y
	   MUL r1, r3, r3    					;doing y * y, store final ans into r1
	   STR r1, [fp, #0x18] 
	   B   ret
;--------------------------------------
ret    MOV sp, fp
       LDMFD sp!, {r0, r1, r2, r3, fp, pc}
;--------------------------------------
		AREA, power, DATA, READWRITE
result DCD   0x00						   ; initial variable
	   SPACE 0x0200						   ; declare the space for stack
stack  DCD   0x00						   ; initial stack postition
;--------------------------------------
	   END

	 
	 
	 