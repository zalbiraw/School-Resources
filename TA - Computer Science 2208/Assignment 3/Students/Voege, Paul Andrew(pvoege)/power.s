				AREA Assignment5,CODE,READONLY
				ENTRY
				;for safety, stack allocation will be set to 0x200
				ADR r13,Stack				;set stack pointer to point to the stack

				MOV r0,#3					;change this to set x
				STR r0,[r13,#-4]!			;push x to stack
				
				MOV r0,#5					;change this to set n
				STR r0,[r13,#-4]!			;push n to stack

				ADR r0, after				;push return address, with a return slot
				STR r0,[r13,#-8]!
				
				b power						;branch to function
				
after			LDR r2,[r13],#12			;pull return into result, also pull twice more (x and n) to clean the stack
				STR r2,result
				
loop			b loop						;infinite loop forever	

				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function
power										;save registers
				STR r0,[r13,#-4]!			;push r0 to preserve value
				STR r1,[r13,#-4]!			;push r1 to preserve value
				STR r2,[r13,#-4]!			;push r2 to preserve value
				
				LDR r2,[r13,#24]			;read x into r2
				LDR r1,[r13,#20]			;read n into r1
				
				
				
				CMP r1,#0					;check n==0
				BEQ ret1					;return 1 if n==0
				
				
				ANDS r0,r1,#1				;check n&1
											
											;{return x*power(x,n-1)
				STRNE r2,[r13,#-4]!			;push x
				
				SUBNE r0,r1,#1				;push n-1
				STRNE r0,[r13,#-4]!
				
				
				ADRNE r0,and1				;push return address, with a slot for the return value
				STRNE r0,[r13,#-8]!
				
				BNE power					;call power recursively

											;else
											;y = power(x,n>>1)
				STR r2,[r13,#-4]!			;push x
				
				MOV r1,r1,LSR #1			;push n>>1
				STR r1,[r13,#-4]!
				
				ADR r0,els					;push return address, with a slot for the return value
				STR r0,[r13,#-8]!
				
				b power						;call power recursively
				

ret1			MOV r0,#1					;store 1 into r0
				b rtn						;branch to universal return
				
and1			LDR r0,[r13],#12			;pull return into r0
				MUL r0,r2,r0
				b rtn						;branch to universal return
				
els				LDR r1,[r13],#12			;pull return to r1
				MUL r0,r1,r1				;y*y
											;proceed to universal return

rtn				STR r0,[r13,#16]       		;store r0 into the return slot in the stack				
								
											;restore registers
				LDR r2,[r13],#4				;pull r2
				LDR r1,[r13],#4				;pull r1
				LDR r0,[r13],#4				;pull r0
				

				ADD r13,r13,#4				;pull return address into PC
				LDR PC,[r13,#-4]			;go to return address
	
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function
				AREA Assignment5,DATA,READWRITE
				SPACE 0x200
Stack			DCD 0x00
result			DCD 0x00
				END