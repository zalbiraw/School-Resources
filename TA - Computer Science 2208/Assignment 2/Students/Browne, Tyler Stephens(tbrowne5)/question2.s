		AREA Assignment4_Q2, CODE, READWRITE
		ENTRY
		
		LDR r0, =X		; load the value in X into register 0
		BL FUNC			; call the function
		MOV r1, r0, LSL #1	; move two times the number in r0 into r1
LOOP		B LOOP			; infinite loop end to the program
		
;--------------------------------------------
;--------------------------------------------

FUNC		STM r13!, {r2-r6}	; store registers r2-r6 in the stack r13
		LDR r2, =A		; load the value A into register 2
		LDR r3, =B		; load the value B into register 3
		LDR r4, =C		; load the value C into register 4
		LDR r5, =D		; load the value D into register 5
		MUL r6, r0, r0		; multiply r0 by itself and store in r6
		MUL r4, r2, r6		; multiply r2 by r6 and store it in r4
		MLA r2, r3, r0, r4	; multiply r3 by r0 and add r4 to it
		ADD r0, r4, r2		; add r2 to r4 and store it in r0
		CMP r0, r5		; compare r0 to r5 (D)
		MOVGT r0, r5		; if r5 is greater than r0, then store r5 in r0
		LDM r13!, {r2-r6}	; restore the original values of r2-r6 from r13
		MOV r15, r14		; return the function to the calling location
					;	via modifying the Program Counter
		
;--------------------------------------------
		AREA Assignment4_Q2, DATA, READWRITE
		
A		DCD 5
B		DCD 6
C		DCD 7
D		DCD 90
X		DCD 3
	
		END