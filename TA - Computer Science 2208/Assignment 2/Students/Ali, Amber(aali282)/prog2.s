AREA prog2, CODE, READONLY
			ENTRY

			MOV r0, #3													
			ADR r2, store						; put the address for the start of the store in r2
																	

			STMFD r2!, {r3-r9}  				; store the values in r3-r9 into memory			
			LDR r3, a							; load a in r3
			LDR r4, b							; load b in r4
			LDR r5, c							;	load c in r5
			LDR r6, d							; load d in r6
			MUL r8, r0, r0						; put the square in r8
			MUL r8, r3, r8						; put the cube in r8
			MLA r0, r4, r0, r8					; multiply x(r0) and b, and add to total and save in r0
			ADD r0, r0, r5						; add c to total
			CMP r0, r6							; compare total to d
			MOVGT r0, r6						; if greater than d, put total as d
			LDMFD r2!, {r3-r9}					; load values back
			BX r14								;exit function


			AREA prog2, DATA, READWRITE
a			DCD 5
b			DCD 6
c			DCD 7
d			DCD 50
			SPACE 64
store		DCD 0x00				
			END