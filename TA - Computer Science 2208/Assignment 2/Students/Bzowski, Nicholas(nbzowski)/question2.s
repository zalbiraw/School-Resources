		;CS2208 Assignment 4
		;question2
		;Nicholas Bzowski
		;
		;This is a program that will calculate a number using
		;a variable x and four parameters, a, b, c, and d.
		;The equation will be calculated in a subroutine.
		
		AREA question2,CODE,READONLY
		ENTRY
		
Main	LDR r0,x								;load the value of x
		BL Func									;call the function, store the return address
		ADD r1,r0,LSL#con1							;multiply the value in r0 by 2 and store in r1
		
infLoop	B infLoop								;infinite loop terminating the main program


Func	ADR SP,stack							;set up the stack pointer
		STMFA SP!,{r1-r5}						;store the current contents of the specified registers, to save their data

		ADR r5,a								;set up a pointer to the first parameter in data
		LDMFD r5!,{r1-r4}						;load all parameters to registers r1 to r4.

		MLAS r2,r1,r0,r2						;calculate a * x + b, store in r2
		MLAS r3,r2,r0,r3						;calculate x * r2 + c
		
		CMP r3,r4								;compare d to y
		MOVGT r0,r4								;if y > d, then store d in r0
		MOVLE r0,r3								;if y <= d, then store y in r0

		LDMFA SP!,{r1-r5}						;restore original states to the working registers
		MOV PC,LR								;exit function

;------------------------------------------------------------------------------------------------

		AREA question2,DATA,READONLY
a		DCD -5
b		DCD 6
c		DCD 7
d		DCD 50
	
x		DCD 3

stack	SPACE 0x40								;the stack to save data

con1	DCD 1

		END