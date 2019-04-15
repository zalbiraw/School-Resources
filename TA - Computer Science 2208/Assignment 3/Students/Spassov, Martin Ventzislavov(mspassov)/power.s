		AREA one, CODE, READONLY		
		ENTRY
main	LDR sp, =stk			   ;place address of stack in stack pointer
		MOV r0, #x				   ;load value x
		MOV r1, #n			       ;load value n
		STMFD sp!, {r0,r1}	       ;push the two parameters onto the stack
		SUBS sp,sp, #4			   ;clear a space for the return value in the stack
		
		BL power			       ;Recursive part, call the power function to compute power
		
		LDR r0, [sp], #4		   ;load the final answer from the stack
		ADD sp, sp, #8			   ;clear out the stack
		LDR r1,=result 			   ;get address of local variable
		STR r0,[r1] 		       ;store final result there
		B loop					   ;terminate the program
;------------------------------------------------------------------------------
power 	STMFD sp!, {r2-r8, fp, lr} ;push some working registers, as well as fp and lr
		MOV fp,sp				   ;anchor the fp to the base of the stack
		SUB sp,sp,#4			   ;create a space for the local variable y
		LDR r2, [fp,#x_str]		   ;get x from the stack 
		LDR r3, [fp, #0x2C]		   ;get n from the stack
		
		CMP r3, #zero			   ;IF(n==0)
		MOVEQ r3, #1			   ;{ prepare 1 to be returned
		STREQ r3, [fp, #empty]	   ;store the value 1 in the designated area of the stack
		BLE return				   ;execute the return sequence
								   ;}
		TST r3, #1			   	   ;IF(n&1) //test to see if n is odd
		BEQ even				   ;if n is even, redirect to ELSE
		SUBNE r3, r3, #1		   ;subtract 1 from n, as this will be new paramter
		STMFDNE sp!, {r2,r3}	   ;push the new parameter onto the stack
		SUBNE sp, sp, #4		   ;create a space on the stack for the return value
		BLNE power				   ;call the function recursively
		
		
		LDR r4, [sp], #4		   ;load the return value from the designated space on the stack
		MUL r5, r2, r4		       ;x*power(x,n-1) //perform the multiplication with the returned value
		STR r5, [fp,#empty]		   ;store the multiplied result in the stack
		B return				   ;return unconditionally to the calling function

even	MOV r3, r3, LSR #1		   ;ELSE lsr n, essentially dividing it by 2, making this new parameter
		STMFD sp!, {r2,r3}		   ;push the new parameter onto the stack
		SUB sp, sp, #4		   	   ;create a space on the stack for the return value
		BL power				   ;call the function recursively
		LDR r4, [sp], #4		   ;load value that was returned
		MUL r5, r4, r4			   ;square the returned value
		STR r5, [fp,#empty]		   ;store the squared result into the stack
			
return MOV sp, fp				   ;collapse the stack frame
	   LDMFD sp!,{r2-r8, fp, pc}   ;reset registers and return to the caller
;--------------------------------------------------------------------------------		
		

loop 	B loop					    ;program terminates	
		AREA one, DATA, READWRITE
result	DCD 0x00					;set up a space to keep the final answer
		SPACE 0x400					;make space for the stack
stk		DCD 0x00					;where the stack begins. FD model will be used
x		EQU 5						;this is the x value
n		EQU 3						;this is the n value
zero	EQU 0x00					;used for comparison 
empty   EQU 0x24					;address relative to fp of empty space
x_str	EQU 0x28					;where x is stored in stack relative to fp
n_str	EQU 0x2C					;where n is stored in stack relative to fp
		END