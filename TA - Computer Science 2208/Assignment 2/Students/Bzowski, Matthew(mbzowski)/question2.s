		AREA Question2, CODE, READONLY		; Matthew Josef Bzowski, 250910538
		ENTRY								; Program will call a subroutine to calculate the value of a function and double it
		
		LDR r0, X							; Load the value of x into r0
		ADR r13,Stack						; Initialize the stack pointer
		BL Sub_1							; Branch to the subroutine to perform the calculation
		MOV r1, r0, LSL#Double				; Double the returned value in r0 and store in r1
		
Loop	B Loop								; Quit the program

Sub_1	STMFD r13!,{r1-r5,r14}				; Save initial values of registers r1 to r5 for working registers and r14 to return
		LDR r1, A							; Load the value of a into r1
		LDR r2, B							; Load the value of b into r2
		LDR r3, C							; Load the value of c into r3
		LDR r4, D							; Load the value of d into r4
		MLA r5, r1, r0, r2					; Perform calculation ax+b, store in register r5
		MLA r0, r5, r0, r3					; Multiply previous result by x and add c and store in r0
		CMP r0, r4							; Check if x is greater than d
		MOVGT r0, r4						; If x is greater than d store the value of d in r0
		LDMFD r13!, {r1-r5,r15}				; Restore working registers, restore return address to r15 to exit the subroutine

		AREA Question2, DATA, READONLY		; Data definitions
			
A		DCD	5								; Value of a
B		DCD	6								; Value of b
C		DCD 7								; Value of c
D		DCD 90								; Value of d
	
X		DCD 3								; Value of x
Double	EQU 1								; Shift value to multiply 2^1
		SPACE 0x40							; Space for full descending stack
Stack	DCD 0x0								; Initial location of the stack pointer in memory

		END									