			AREA POWER, CODE, READONLY					; This code recursively calculates powers
            ENTRY
n			EQU 2										; Define n=2
x			EQU 4										; Define x=4
	
MAIN
			MOV r9, #x									; [r9] <-- x
			MOV r8, #n 									; [r8] <-- n
			
			ADR SP, STACK								; Let SP= STACK
			MOV FP, SP									; Prepare framepointer for stack parameters
			
			
			STMFD SP!, {r9, r8}							; PUSH r9, r8
			SUB SP, #4									; Move call frame down
		
			BL REC_POWER
			
			LDR r0, [SP], #4							; r0 <-- [SP]
			ADD SP, #8									; Reclaim stack space
			ADR r8, ANSWER								; r8 <-- &ANSWER
			STR r0, [r8]								; Save r0 to r8
			
ENDMAIN		B ENDMAIN									; Ending loop

REC_POWER
			STMFD SP!, {r8-r10,FP,LR}					; PUSH r8,r9,r10, FP, LR	
			MOV FP, SP									; Let FP = SP
			SUB SP, #12									; Alloc stack
			LDR r8, [FP, #24]							; r8 <-- x
			LDR r9, [FP, #28]							; r9 <-- n
			CMP r9, #0									; Base Case: n=0 
			MOVEQ r10, #1								; Add 1 and finish
			BEQ EXIT_FUNCTION							; Exit
			
			LSRS r10,r9,#1								; Bitwise AND
			BCC NOT_EVEN								; n%2 ==0? Check Carry, ODD?
			SUB r1, #1									; ODD -> CONVERT EVEN
			
			STMFD FP, {r8,r9}							; Prepare next recursive call
			BL REC_POWER								; Resurve
			LDR r9,[FP,#-12]							; Load R9 <-- FP-12
			MUL r10,r8,r9	
			B EXIT_FUNCTION			
					
NOT_EVEN
			STMFD FP,{r8,r10}							; PUSH X,n --> STACK
			BL REC_POWER								; Recurse
			LDR r9,[FP,#-12]							; Load r1<-- FP-12
			MUL r10,r9,r9								; r10 <-- (r9)^2		
			
EXIT_FUNCTION
			STR r10, [FP,#20]							; return value PUSH --> r2
			ADD SP, #12								; Clear FP in Stack
			LDMFD SP!, {r8-r10, FP,PC}					; Set registers and return
			
			AREA POWER, DATA, READWRITE			
ANSWER		DCD 0x00
			SPACE 0xFF								; Requires space for stack pointer
STACK		DCD 0x00									; Use FD model, initial stack position
			END
				
				