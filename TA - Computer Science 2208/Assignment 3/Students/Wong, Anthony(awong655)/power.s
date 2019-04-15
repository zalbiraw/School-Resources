		AREA POW, CODE, READONLY
		ENTRY
								;This section will initialize the values that will be utilized later in the function
								;Will also perform the initial recursive call and retreive the result
MAIN	ADR sp, STACK			;Saves the address of the stack into r13 as a pointer
		STR fp, [sp,#-4]!		;Decrement the stack pointer because the stack we will use is FD
		MOV fp, sp				;Set fp equal to the beginning of the stack
		
		MOV r0, #0				;Local variable for result. To be passed as parameter
		MOV r1, #X				;Parameter 1 (x) this is temporary storage before load to mem
		MOV r2, #N				;Parameter 2 (n) this is temporary storage before load to mem
		STMFD sp!, {r0,r1,r2}	;Store parameters into the FD stack
		BL POWER				;Initial recursive call
		LDR r0, [fp,#-12]		;Grab the return value which is above the parameters, save to r0
		ADR r1, RESULT			;Get address of result
		STR r0, [r1]			;Store final answer into result
								;At this point the final result is stored in the local variable RESULT
		MOV sp, fp				;Clears the rest of the stack
LOOP	B LOOP
								
								;This section manages the stack for the current recursive call
POWER	STR fp, [sp,#-4]!		;Save old fp into stack
		MOV fp, sp				;Change fp to point to CURRENT stack frame's fp
		STMFD sp!, {r3-r6,r14}	;Store working registers and LR
		LDR r3, [fp,#4]			;Load running total into r5
		LDR r4, [fp,#8]			;Load parameter x into r3
		LDR r5, [fp,#12]		;Load parameter n into r4
		
								;BASE CASE 1: This is when n is equal to 0
		CMP r5, #0				;See if n = 0
		MOVEQ r5,#1				;Use r5 as arbitrary storage for 1
		STREQ r5, [fp,#4]		;Store 1 into running total
		STMFDEQ sp!, {r3,r4,r5}	;Store parameters into stack
		BEQ RETURN				;execute return steps
		
								;CASE 1: n is odd
		TST r5, #1				;See if n is even. If so, can shorten the number of recursive calls
		SUBNE r5, r5, #1		;Decrement n
		STMFDNE sp!, {r3-r5}	;Store the parameters to be used in next frame
		BNE RECURSE
								;CASE 2: n is even
		LSREQ r5,r5,#1			;Divide by 2 if even. NOTE zero bit set from TST above
		STMFDEQ sp!, {r3-r5}	;Store the updated parameters into the stack
		BEQ SQUARE				;Handle the case when n is even
								
								;This section performs the calculation for the case when n is even
SQUARE	BL POWER				;Recursive call
		LDR r6, [sp]			;Use r6 as a temporary storage for the old running total
		MUL r3, r6, r6			;Squares the previous value
		STR r3, [fp,#4]			;Store value back into parameter
		B RETURN				;Return current stack frame
								;This section performs the calculation for the case when n is odd
RECURSE	BL POWER				;RECURSIVE CALL
		LDR r6, [sp]			;Load total into regiter
		MUL r3, r6, r4			;Multiply by x
		STR r3, [fp,#4]			;Store updated total in param
		B RETURN				;Return current stack frame
								;This section returns the current stack frame
RETURN	ADD sp, sp, #12			;Shift sp past the parameters
		LDMFD sp!, {r3-r6,r14}	;Recover all the registers
		MOV sp, fp				;Move the SP back to the FP
		LDR fp, [sp]			;Load the FP with the OLD FB
		ADD sp, sp, #4			;Move stack pointer back 4 bytes
		MOV pc, lr				;Branch back to the previous call
		
		SPACE 0x100
STACK	DCD 0x00
RESULT 	DCD 0x00
X		EQU 3
N		EQU 4
		END