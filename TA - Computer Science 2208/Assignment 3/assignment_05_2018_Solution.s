     AREA Power, CODE, READONLY
x    EQU 3
n    EQU 5
     ENTRY
Main ADR   sp,stack      ;define the stack

     MOV   r0, #x        ;prepare the x parameter
     STR   r0,[sp,#-4]!  ;push the x parameter on the stack
	 
     MOV   r0, #n        ;prepare the n parameter
     STR   r0,[sp,#-4]!  ;push the n parameter on the stack

     SUB   sp,sp,#4      ;reserve a place in the stack for the return value

     BL    Pow           ;call the Fact subroutine

     LDR   r0,[sp],#4    ;load the result in r0 and pop it from the stack
     ADD   sp,sp,#8      ;also remove the parameters from the stack

     ADR   r1,result     ;get the address of the result variable
     STR   r0,[r1]       ;store the final result in the result variable

Loop B     Loop          ;infinite loop
;--------------------------------------------------------------------------------
     AREA Power, CODE, READONLY
Pow STMFD sp!,{r0-r3,fp,lr} ;push general registers, as well as fp and lr
     MOV   fp,sp         ;set the fp for this call
     SUB   sp,sp,#4      ;create space for y local variables

     LDR   r0,[fp,#0x1C] ;get the n parameter from the stack
     LDR   r1,[fp,#0x20] ;get the x parameter from the stack

     CMP   r0,#0         ;compare n with zero
     MOVEQ r2,#1         ;prepare the return value and store it in r2 for now
	 STREQ r2,[fp,#0x18] ;store the return value in the stack 
     BEQ   ret      

     TST   r0,#1         ;check the LSB in n
	 BEQ   even          ;deal with even n value

odd  STR   r1,[sp,#-4]!  ;push the x parameter on the stack
     SUB   r0,r0,#1      ;decrement n
	 STR   r0,[sp,#-4]!  ;push the new value of n parameter on the stack
     SUB   sp,sp,#4      ;reserve a place in the stack for the return value

     BL    Pow           ;call the Fact subroutine
     
	 LDR   r3,[sp],#4    ;load the result of the last BL in r3 and pop it from the stack
     ADD   sp,sp,#8      ;also remove the parameters from the stack
     MUL   r2,r1,r3
	 STR   r2,[fp,#0x18] ;store the return value in the stack 
	 B     ret

even STR   r1,[sp,#-4]!  ;push the x parameter on the stack
     ASR   r0,r0,#1      ;divid  n by 2
 	 STR   r0,[sp,#-4]!  ;push the new value of n parameter on the stack     
	 SUB   sp,sp,#4      ;reserve a place in the stack for the return value

     BL    Pow           ;call the Fact subroutine
     
	 LDR   r3,[sp],#4    ;load the result of the last BL in r3 and pop it from the stack
	 STR   r3,[fp,#-4]   ;store the return value in the stack 
     ADD   sp,sp,#8      ;also remove the parameters from the stack
     MUL   r2,r3,r3
	 STR   r2,[fp,#0x18] ;store the return value in the stack 

ret  MOV   sp,fp         ;collapse all working spaces for this function call
     LDMFD sp!,{r0-r3,fp,pc} ;load all registers and return to the caller
;--------------------------------------------------------------------------------
     AREA Power, DATA, READWRITE
result DCD   0x00        ;the final result
       SPACE 0xC8        ;declare the space for stack
stack  DCD   0x00        ;initial stack position (FD model)
;--------------------------------------------------------------------------------
       END
