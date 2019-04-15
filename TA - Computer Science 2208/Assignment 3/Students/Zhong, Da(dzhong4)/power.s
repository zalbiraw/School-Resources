;--------------------------------------------------------------------------------
     AREA factorial, CODE, READONLY
n    EQU 7
x	 EQU 5
     ENTRY
Main ADR   sp,stack      ;define the stack
     MOV   r0, #n        ;prepare the n
	 MOV   r1, #x		 ;prepare the x
     STR   r1,[sp,#-4]!  ;push the x on the stack
	 STR   r0,[sp,#-4]!  ;push the n on the stack
     SUB   sp,sp,#4      ;reserve a place in the stack for the return value
     BL    power          ;call the Fact subroutine
     LDR   r0,[sp],#4    ;load the result in r0 and pop it from the stack
     ADD   sp,sp,#4      ;also remove the parameter from the stack
     ADR   r1,result     ;get the address of the result variable
     STR   r0,[r1]       ;store the final result in the result variable
Loop B     Loop          ;infinite loop
;--------------------------------------------------------------------------------
     AREA factorial, CODE, READONLY
power STMFD sp!,{r0,r1,r2,fp,lr} ;push general registers, as well as fp and lr
     MOV   fp,sp         ;set the fp for this call
	 SUB   sp,sp,#12      ;make some space for x, n and return value
	 LDR   r1,[fp,#0x1C] ;get x from the stack
	 LDR   r0,[fp,#0x18] ;get the n from the stack	 
	 CMP   r0,#0         ;if (n = 0)
     MOVEQ r0,#1         ;{ prepare the value to be returned
     STREQ r0,[fp,#0x14]  ;  store the returned value in the stack     
	 BLE   ret 			; branch to the return section	 
	 AND   r2,r0,#1		;chack if it are odd or even
	 CMP   r2,#1		;if is odd
     BEQ   ODD           ;  branch to the return section                      
	 MOV   r2,r0, LSR#1  ; n >> 1
	 STR   r1,[fp,#-4]  ;  push the x on the stack
	 STR   r2,[fp,#-8]  ;  push the n on the stack
	 BL    power          ;  call the Fact subroutine
	 LDR   r0,[sp],#4      ;  load the result in r0 and pop it from the stack
     ADD   sp,sp,#4        ;  remove also the parameter from the stack
     MUL   r2,r0,r0      ;  y^2
     STR   r2,[fp,#0x14] ;  store the returned value in the stack
     MOV   sp,fp         ;collapse all working spaces for this function call
     LDMFD sp!,{r0,r1,r2,fp,pc} ;load all registers and return to the caller
ODD  SUB   r2,r0,#1      ;{ prepare the new parameter value
	 STR   r1,[fp,#-4]  ;  push the x on the stack
     STR   r2,[fp,#-8] 		;push the n on the stack
     BL    power          ;  call the Fact subroutine     	 
     LDR   r0,[sp],#4      ;  load the result in r0 and pop it from the stack
     ADD   sp,sp,#4        ;  remove also the parameter from the stack
     MUL   r2,r1,r0      ;  prepare the value to be returned
     STR   r2,[fp,#0x14] ;  store the returned value in the stack
ret  MOV   sp,fp         ;collapse all working spaces for this function call
     LDMFD sp!,{r0,r1,r2,fp,pc} ;load all registers and return to the caller
;--------------------------------------------------------------------------------
     AREA factorial, DATA, READWRITE
result DCD   0x00        ;the final result
       SPACE 0xFF		   ;declare the space for stack
stack  DCD   0x00        ;initial stack position (FD model)
;--------------------------------------------------------------------------------
       END