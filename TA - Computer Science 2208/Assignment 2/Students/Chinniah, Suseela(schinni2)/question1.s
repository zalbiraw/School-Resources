		AREA question1, CODE, READONLY
		ENTRY
		ADR r0, STRING1				;load pointer to start of string
		ADR r2, STRING2				;load pointer to start of result string
		LDRB r3, EoS				
loop	LDRB r1, [r0], #1			;load current character
		CMP r1, #'t'				;if current char is t check the next 3 chars
		BLEQ check					;call subroutine
		CMPNE r1, #'T'
		BLEQ check
		CMP r10, #1					;test subroutine result
		ADDEQ r0, #2				;if word equals "the", skip the characters
		MOV r10, #0					;reset the subroutine result register
		LDREQB r1, [r0], #1
		STRB r1, [r2], #1		
		CMP r1, r3
		BEQ end
		BNE loop		
check	LDRB r5, [r0]
		LDRB r6, [r0, #1]
		LDRB r7, [r0, #2]
		LDR r9, =0x686520
		SUB r9, r5, LSL #16
		SUB r9, r6, LSL #8
		SUB r9, r7
		CMP r9, #0x20
		CMPNE r9, #0x0
		MOVEQ r10, #1
exit	MOV PC, LR
end		B end		
		
		AREA question1, DATA, READWRITE
		
STRING1 DCB "they The" ;String1
EoS 	DCB 0x00 ;end of string1
STRING2 SPACE 0xFF ;just allocating 255 bytes
	
		END