			AREA	assQ2,	CODE, READONLY
			ENTRY
			;salman
			
			MOV r0,#3		
			BL function
			B Finish
				

function	STMED sp!, {r1-r4}		; all the registers are pushed to stack
			LDR r1, A_A1						; LOADING a to r1
			MUL r2, r0, r0						; Square the x value
			MUL r3, r1,r2						; multiply r2 and r1 a x x^2
			
			LDR r1, B_B1						; LOADING b to r1
			MUL r4, r1,r0					; r4 = (B * x)
			ADD r2, r3,r4						; add a*x^2 + b*x  
			
			LDR r1, C_C1						; LOADING c to r1
			ADD r0, r2,r1							; r2 = add r2 and r1 to r0
			
			LDR r1, D_D1						; LOADING d to r1
			
			CMP r1, r0							; compare d and y 
			MOVLT r0, r1						; if its less than d than d will become y
			MOVGT r0, r2						; else y  will be r0 
			LDMED sp!, {r1-r4}	 				; reset the stack 
			BX lr								; go back to main
Finish		B Finish
			
A_A1		DCD 5
B_B1		DCD 6
C_C1		DCD 7
D_D1	    DCD 90
 
			ALIGN
	
			END