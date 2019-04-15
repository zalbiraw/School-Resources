		AREA question_2,CODE,READONLY
x       EQU     2
n       EQU     9
		ENTRY
		ADR     sp,STACK	      		;Use sp to load the stack
		STMFA   sp!,{r0,r1,r2,r3,fp}    ;push general registers into the stack, as well as fp 
		MOV     fp,sp		      		;set fp point to the base of the stack
		MOV     r1,#1	                ;set recursive counter
		MOV     r2,#x		      		;prepare the paratemers
		STR     r2,[sp,#4]!	      		;store the parameters into the stack
		MOV     r0,#n
		STR     r0,[sp,#4]!	
		B       Calc		      		;Start calculation					
reset   MOV     sp,fp		      		;load sp point to the base of the stack
		STR     r0,result	      		;save the result in result
		LDMFA   sp!,{r0,r1,r2,r3,fp}    ;reset all general registers
Loop    B       Loop		      		;infinity loop
Calc    CMP     r0,#0		      		;compare the n 
		BNE	oddeve		      			;if n is not 0,then test it is odd or even
		MOV     r0,#1		      		;if n is 0,then set r0 to 1(each number's power of 0 equals to 1)
		STR     r0,[sp,#4]	      		;Store 1 into the top of the stack
		B       Power		      		;calculate the other results
oddeve  AND     r3,r0,#1		      	;use AND to determine n is odd or even
		CMP     r3,#1
		SUBEQ   r0,r0,#1	     		;if it is odd, then n = n-1
		MOVNE   r0,r0,LSR#1	      		;if it is even, then n = n>>1
		STR     r0,[sp,#8]!	      		;store the new n into the stack
		ADD     r1,r1,#1	      		;add 1 to the loop counter
		B       Calc		      		;back to compare the new n
Power   CMP     r1,#0	                ;Compare the recursive counter
		BEQ     reset		      		;If it is 0,then go to reset
		LDR     r3,[sp]		      		;load the n into r3
		CMP     r3,#0		      		;if n equals to 0,skip this n and move to the next
		BEQ     skip									
		ANDNE   r3,r3,#1	      		;if n is not 0,then find it is odd or even
		CMP     r3,#1						
		BNE     even									
odd		MUL     r0,r2,r0	      		;if it is odd, then r0 = the previous result * x
        STR     r0,[sp,#4]	      		;store the result above the parameter
skip    SUB     sp,sp,#8	      		;move to the next n
		SUB     r1,r1,#1	      		;adjust recursive counter
		B       Power
even    LDR     r3,[sp,#12]	      		;if n is even, then load the previous result into r3
		MUL     r0,r3,r3                ;the result is the square of the previous result
		STR     r0,[sp,#4]	      		;store the result above the parameter
		B	skip
		ALIGN
result  DCD     0x00
STACK   DCD   	0x00
        END