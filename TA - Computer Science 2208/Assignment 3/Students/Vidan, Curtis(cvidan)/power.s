			AREA a5, code, READONLY

			ENTRY

			MOV			sp, #0x10000		;set frame pointer
			MOV			r0, #3				;load n into r0
			PUSH		{r2-r6}				;push registers
			PUSH		{r0}				;push n
			MOV			r1, #5				;load x into r1
			PUSH		{r1}				;push x
			MOV			r1, #1				;initialize r1 to 1
			
			BL			pwr					;call subroutine
				
			POP			{r0}				;pop and store in r0
			LDR			r1, [r0]			;store y in r1
			STR			r1, result			;store y in result
			POP			{r2-r6}				;restore registers
loop		B			loop				;end

pwr			CMP			r1, #1				;check if it is the initial call
			MOVEQ		r1, #0				;if yes, then change r1
			POPEQ		{r2}				;" ", then pop x
			POPEQ		{r3}				;" ", then pop n 
			ADR			r1, y				;set r1 to address of y
			PUSHEQ		{r1}				;" ", then push address of y
				
			CMP			r3, #0				;is n == 0?
			MOVEQ		r4, #1				;if yes, then store 1 in r4
			STREQ		r4, y				;" ", then store return value in y
			BXEQ		lr					;" ", then return
				
			TST			r3, #1				;is n odd?
			BEQ			else				;if no, skip to else
			SUB 		r3, r3, #1			;if yes, subtract 1
			PUSH		{lr}				;" ", push link register as return address
			
			BL			pwr					;" ", call subroutine
			MUL			r4, r2, r4			;" ", multiply the returned value by x and store in r4
			STR			r4, y				;" ", store result in y
			POP			{r5}				;" ", pop return address from stack
			BX			r5					;" ", return

else		LSR			r3, #1				;n is not odd. divide by 2
			PUSH		{lr}				;push link register as return address
			
			BL			pwr					;call subroutine
			MOV			r6, r4				;store the returned value in r6
			MUL			r4, r6, r4			;square the returned value
			STR			r4, y				;store result in y
			POP			{r5}				;pop return address
			BX			r5					;return

			AREA a5, data, READWRITE
			ALIGN
result		DCD			0x00				;initialize as 0
y			DCD			0x00				;initialize as 0
			END
