		AREA factorial,CODE,READONLY
n		EQU  5             ;set n
x       EQU  2              ;set x
	    ENTRY
Main    ADR   sp,stack      ;stack for main
	    MOV   r0,#x         ;load x value and push into the stack
		STR   r0,[sp,#-4]!
	    MOV   r0,#n    		;load n value and push into the stack
		STR   r0,[sp,#-4]!
		SUB   sp,sp,#4      ;stack frame up to make sure it ready for the next stack which is for FACT
		BL    FACT
		
		LDR   r0,[sp],#4 	;get the result
		ADD   sp,sp,#4		;clean the stack
		ADR   r1,result		;store the result
		STR   r0,[r1]
	
LOOP    B     LOOP			;end LOOP
FACT    STMFD sp!,{r0,r1,r2,fp,lr}  ;push current value r0,r1,r2,fp,lr,into the stack
		MOV   fp,sp          ;set up fp
		SUB   sp,sp,#12;    ;move sp up to 12 bytes inorder to store ,x,n,y
		LDR   r0,[fp,#24];  ;load n into r0
		LDR   r1,[fp,#28];  ;load x into r1
		CMP   r0,#0         ;compare n wiht 0 
		MOVEQ r0,#1         ; if it is equal, set r0 value to 1, and push into stack
		STREQ r0,[fp,#0x14]
		BLE   ret           ;return 
		
		 
		AND   r2,r0,#1		; check odd
		CMP   r2,#1;   		;if it is odd,go to odd part
		BEQ   ODD			
		MOV   r0,r0,LSR#1   ;if it is not odd, n divided by 2
		STR   r1,[fp,#-4]	;push new n and x value into stack (above fp, below sp)
		STR   r0,[fp,#-8]
		BL    FACT          ; jump back to FACT for new stack
		
		LDR   r0,[sp],#4    ;get the result (r0,in sp)
		ADD   sp,sp,#4		;remove parameters
		MUL   r2,r0,r0      ; y ^2
		STR   r2,[fp,#0x14] ;store into r0 (in stack)
		MOV   sp,fp	        ;remove stack
        LDMFD sp!,{r0,r1,r2,fp,pc} ;return 
		
ODD  	SUB   r2,r0,#1 		; n = n -1
		STR   r1,[fp,#-4]   ;store new x and n value 
		STR   r2,[fp,#-8]
		BL    FACT 			;jump back to FACTfor new stack(call)
	    LDR   r0,[sp],#4	;get r0 (result of last call) in the stack
		ADD   sp,sp,#4		;remove prarmeter
		MUL   r2,r1,r0		;return x* power(x,n-1)
		STR   r2,[fp,#0x14] ;store the value
		
		
ret     MOV   sp,fp 		;return 
        LDMFD sp!,{r0,r1,r2,fp,pc} 
		
		AREA factorial, DATA, READWRITE
result DCD 0x00 ;the final result
       SPACE 0xFF ;declare the space for stack
stack  DCD 0x00 ;initial stack position (FD model) 
	   END