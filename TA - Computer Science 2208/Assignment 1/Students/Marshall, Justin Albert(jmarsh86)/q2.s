		AREA assignment3_q2, CODE, READONLY
		ENTRY
		MOV r0, r1 			;Error if this isn't here
STRING	DCB "Hh,Hh/.hh" 	;string
EoS		DCB 0x00 			;end of string
		ADR r2, STRING		;register r2 points to STRING
		ADR r3, EoS			;register r3 points to EoS
		
Loop	LDRB r4,[r2], #1	;Load the next character of the STRING into register r4, then increment by 1
CheckP	CMP r4, #0			;Compare r4 and 0
		BEQ NotP			;Jump to NotP if r4 = 0
		CMP r4, #122		;Compare r4 and  122
		BGT Next1			;Jump to Next1 if r4 > 122
		CMP r4, #90			;Compare r4 and 90
		BGT Capitl			;Jump to Capitl if r4 > 90
		B	IsLetr			;Jump to IsLetr
		
Capitl	SUB r4, #32			;Subtract 32 from r4 to make it a capital letter (ASCII)
IsLetr	CMP r4, #65			;Compare r4 and 65
		BLT Next1			;Jump to Next1 if r4 < 65
		
		ADD r3, #2			;Add 2 to r3
		CMP r2,r3			;Compare r2 and r3
		BEQ IsP				;Jump to IsP if r2 = r3
		SUB r3, #2			;Subtract 2 from r3

		LDRB r5,[r3], #-1	;Load the previous character of the STRING into register r5, then de-increment by 1
Letr2	CMP r5, #122		;Compare r5 and 122
		BGT Next2			;Jump to Next2 if r5 > 122
		CMP r5, #90			;Compare r5 and 90
		BGT Capitl2			;Jump to Capitl2 if r5 > 90
		B	IsLetr2			;Jump to IsLetr2
		
Capitl2	SUB r5, #32			;Subtract 32 from r5 to make it a capital letter (ASCII)
IsLetr2	CMP r5, #65			;Compare r5 and 65
		BLT Next2			;Jump to Next2 if r5 < 65
		
		CMP r4,r5			;Compare r4 and r5
		BNE NotP			;Jump to NotP if r4 != r5
		ADD r3, #2			;Add 2 to r3
		CMP r2,r3			;Compare r2 and r3
		BEQ IsP				;Jump to IsP if r2 = r3
		SUB r3, #2			;Subtract 2 from r3
		B	Loop			;Jump to Loop
		
Next1	LDRB r4,[r2], #1	;Load the next character of the STRING into register r4, then increment by 1
		B	CheckP			;Jump to CheckP
Next2	LDRB r5,[r3], #-1	;Load the previous character of the STRING into register r5, then de-increment by 1
		B	Letr2			;Jump to Letr2

NotP	ADD r0, #1			;Add 1 to r0
IsP		ADD r0, #1			;Add 1 to r0
		END