	AREA question2, CODE, READONLY
			
			ENTRY
			
			ADR sp,STACKP		;Here, we are initializing the stack pointer so that it points to the bottom of the stack (FD stack)
			LDR r0,VX			;We store the value of the variable x in r0, so that it is passed to the function CALCULATE
			BL CALCULATE		;We branch to the function CALCULATE, storing the return address in r14
			ADD r1,r0,r0		;When we return, we take double the value returned from the function CALCULATE and store it in r1
DONE		B DONE				;Branch indefinitely
			
			
			
CALCULATE	STMFD sp!,{r1-r6}	;We block store registers r1-r6 onto the stack, so that we can use theose registers for operations in the function
			ADR r6,VA			;Store the address of variable a into r6. This is in preperation for block loading the variables required
			LDMFD r6!,{r1-r4}	;Block load register r1-r4 with variables a-d to be used in the function
			MLA r5,r1,r0,r2		;Using Horners rule, we first compute (ax + b) and store the result in r5
			MLA r0,r5,r0,r3		;Applying Horner's rule a second time, we compute (ax + b)x + c and store the result in r0 for future comparison
			CMP r0,r4			;We compare the computed value of y (r0) with the value d (r4) to identify which to return
			MOVPL r0,r4			;If the value of d (r4) is less than y, then store d in r0, otherwise, we keep y in r0
			LDMFD sp!,{r1-r6}	;Restore the registers r1-r6 to the state that they were in prior to entering the function
			MOV r15,r14			;Load the PC with the return address that was stored in r14 when the CALCULATE function was branched to

	AREA question2, DATA, READWRITE
		
VA		 	DCD 5 				;Reserve room for variable 'a' in memory
VB		 	DCD 6 				;Reserve room for variable 'b' in memory	
VC		 	DCD 7 				;Reserve room for variable 'c' in memory	
VD		 	DCD 90 				;Reserve room for variable 'd' in memory	
VX		 	DCD 3 				;Reserve room for variable 'x' in memory		
			space 0x18 			;just allocating 24 bytes for the stack
STACKP		DCD 0x000			;Setting the location of the stack pointer to be at the bottom of the stack


			END