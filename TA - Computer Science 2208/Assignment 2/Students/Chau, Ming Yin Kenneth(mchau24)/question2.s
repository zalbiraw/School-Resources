		AREA question2, CODE, READONLY
		ENTRY
Main	LDR r0,x 				;load x to r0
		BL Function1			;call function 1 
		MOV r2,#2				;store the constant 2 in r2
		MUL r1,r0,r2			;MUL r0 by 2
loop	B loop 					;infinity loop 
;--------------------------------------
Function1 LDR r1,a				;using r1 as a working directory, move a to r1  
		  LDR r2,b				;using r2 as a working directory, move b to r2
		  LDR r3,c				;using r3 as a working directory, move c to r3
		  LDR r4,d				;using r4 as a working directory, move d to r4
		  MOV r5,r3				;using r5 as a working directory which is used to stored the result of c 
		  MUL r2,r0,r2			;multiply b with x
		  MUL r6,r0,r0			;calculate the square of x
		  MUL r1,r6,r1			;calculate ax^2
		  MOV r0,#0     		;reset r0 to 0
		  ADD r0,r5,r1			;store the result in r0
		  ADD r0,r0,r2			;same as above
		  CMP r4,r0				;compare r0 and r4
		  MOVLT r0,r4			;if r0 is smaller than r4 it will replace by r4
		  MOV r2,#0				;reset r1-r6'same for below'
		  MOV r1,#0
		  MOV r3,#0
		  MOV r4,#0
		  MOV r5,#0
		  MOV r6,#0
		  MOV r15,r14			;quit the function 
;--------------------------------------
		SPACE 0x40				;leave space for the stack to grow 
stack 	DCD 0x40 				;the base of the stack 
;--------------------------------------
;THE BELOW IS THE DATA AREA 
a		DCD 5					;Declare variables 
b		DCD 6
c		DCD 7
d		DCD 90
x		DCD 3
		END 