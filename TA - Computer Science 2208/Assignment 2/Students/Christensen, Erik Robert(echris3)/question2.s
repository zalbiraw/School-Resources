			AREA theCode, CODE, READONLY;Coding region
			ENTRY
			
			ADR r13, theStack			;Get the address from the stack
			LDR r0, opX					;Get X from memory
			BL theFunction				;Call the function
			MOV r1, r0, LSL#1			;Multiply the result of the function by 2

loop		B loop						;Infinite loop		


theFunction	STMDA r13!, {r1-r10}		;store the things in memory so we don't lose them
			ADR r1, opA					;Get the address of the first operand
			LDM r1!, {r2-r5}			;get the operands from memory
			
			MUL r6, r0, r0				;x^2
			MUL r7, r6, r2				;a*x^2
			MUL r8, r3, r0				;b*x
			ADD r10, r7, r8				;a*x^2+b*x
			ADD r10, r10, r4			;a*x^2+b*x+c = y
			
			CMP r10, r5					;compare y to d
			MOVGT r0, r5				;if y>d put d in r0
			MOVLE r0, r10				;if y<d put y in r0
			
			LDMIB r13!, {r1-r10}		;get the things we saved from memory(restore registers)
			MOV pc, lr					;Return the function


			AREA theCode, DATA, READWRITE;Data region
			
opA			DCD -5
opB			DCD 6
opC			DCD 7
opD			DCD 10
opX			DCD 3
			ALIGN
			SPACE 0x44
theStack    DCD 0x0
			
			END 