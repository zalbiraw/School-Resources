		AREA DRAFT, CODE, READONLY
		LDR r0,x			;Load r0 with x, effectively passing it to fun_1
		BL fun_1			;Branch with link to fun_1
		MOV r1,r0,LSL#1		;Take the return value in r0 and store it with double the value in register r1
loop	b loop
fun_1	STR r1,[pc,#0x4C]	;Store r1 and r2 in memory within the memory location of EMPTY
		STR r2,[pc,#0x4C]	;Offset is calculated by pc. Hence the offset will be the same
		LDR r2, aa			;Store the a value in r2
		MUL r1,r2,r0		;Calculate a multiplied by x
		MUL r1,r0,r1		;And multiply again by x to get ax^2
		LDR r2,bb			;Store the b value in r2
		MUL r0,r2,r0		;Multiply by x
		ADD r0,r1			;Add the value of r1 to r0 and store in r0 to get ax^2+bx
		LDR r1,cc			;Store the c value in r1
		ADD r0,r1			;Add the value of r1 to r0 and store in r0 to get ax^2+bx+c
		LDR r1,dd			;Store the d value in r1
		CMP r0,r1			;Check to see whether y or d is larger
		LDRGT r0,dd			;If y is larger, store d in r0 instead
		LDR r1,[pc,#0x18]	;Restore the value of r1 and r2
		LDR r2,[pc,#0x18]
		MOV pc,lr			;Return back to the method call
			
		AREA DRAFT, DATA, READWRITE
aa		DCD 5
bb		DCD 6
cc		DCD 7
dd 		DCD 90
x		DCD 3
EMPTY	SPACE 2
		END 