		AREA q_1, CODE, READONLY
		ENTRY
		LDR   r0, xVal		;Load value of X from memory
		BL 	  Func			;Branch to the function
		ADD   r1, r0, r0    ;Double the return and store in r1 
		B 	  Ending		;Branch to the ending
Func   	ADR   r13, Stack    ;Start of function, load space for stack
		STMIA r13!, {r1-r7} ;Store registers r1-r7 in memory
		ADR   r3, aVal      ;Load in starting value from stored variables
		LDMIA r3!, {r4-r7}  ;Load in stored variables to registars r4-r7
		MUL   r1, r0, r0    ;Square the passed in X value and store in r1
		MUL   r2, r1, r4    ;Multiply the squared value by A and store in r2
		MUL   r1, r0, r5    ;Multiply the passed in value by B
		ADD   r1, r2        ;Add the results of the multiplication together
		ADD   r1, r6        ;Add the variable C 
		MOV   r0, r1		;Move results to r0
		CMP   r1, r7        ;Compare the results to variable D
		MOVHI r0, r7        ;Return variable D if return is greater than D
		ADR   r13, Stack    ;Move start of the stack back to r13
		LDMIA r13!, {r1-r7} ;Load the original registars back in
		MOV   PC, LR        ;Return from function
Ending 						;Branch for the ending
aVal 	DCD   0x00000005    ;A variable
bVal 	DCD   0x00000006    ;B variable
cVal    DCD   0x00000007	;C variable
dVal    DCD   0x0000005A	;D variable
xVal    DCD   0x00000003    ;X variable
Stack   SPACE 0xFF  		;Space for the stack
		END