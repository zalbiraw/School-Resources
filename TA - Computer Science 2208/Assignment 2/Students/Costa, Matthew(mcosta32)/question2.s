			AREA question2, CODE, READONLY
			ENTRY
			ADR r13, STACK 					; put the first pointer of memory of the stack int r13					
			STMDA r13!, {r1-r8} 			; load the registers into the stacks memory saving their original values decrementing after each store
			bl Funct1						; branch to funct1 to perform neccassary oper and enter the subroutine
			ADD r1, r0,r0					; double the value of r0 by adding it to itself and store in r1
			b done							; branch to signify end of program
Funct1		LDR r1, x						; load value of x into r1
			LDR r2, x						; load value of x into r2
			LDR r3, a 						; load value of a into r3
			MUL r8, r2, r1					; multiply x by x to simulate x^2
			MUL r0, r3, r8					; multiply the result of x^2 by a
			LDR r4, b						; load value of b into r4
			LDR r5, c						; load value of c into r5
			LDR r6, d						; load value of d into r6
			MLA r7, r4,r1, r5				; multiple r4 and r1 and add r5 to the result **contents
			ADD r0, r7						; put the value into r0 using ADD
			CMP r0, r6						; check if d is larger than y
			BGT finish						; branch accordingly if yes
			LDMIB r13!, {r1-r8}				; prior to return from subroutine restore all registers affected			; if yes branch to finish
			MOV pc, lr						; exit subroutine
finish		MOV r0, r6						; put the value of d into r0
			LDMIB r13!, {r1-r8}				; prior to return from subroutine restore all registers affected
			MOV pc, lr						; exit subroutine
done		NOP								; NOP to signify end of program
			AREA question2, DATA, READWRITE			
a			DCD 5							;allocate label a the value 5
b			DCD 6							;allocate label b the value 6
c			DCD	7							;allocate label c the value 7		
d 			DCD 90							;allocate label d the value 90			
x			DCD 3							;allocate label x the value 3							
			SPACE 0x50						;allocate space for stack
STACK		DCD 0x0							;start of stack gonna decrement through memory
			END