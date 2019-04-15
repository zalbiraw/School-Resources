		AREA question1, CODE, READONLY
		ENTRY
	
		ADR r1, STRING1			;Address STRING1 into r1
		ADR r5, STRING1			;Address STRING1 into r5
		ADR r2, STRING2			;Address STRING2 into r2
Loop	LDRB r3, [r1], #1		;load a byte of string
		ADD r4,r4,#1			;increment counter
		CMP r3, #0x74			;if r3 has the value of 't'
		BEQ Check				;check if 'the ' truly exist
Store	STRB r2, [r3]			;store the string without 'the'
		CMP r3, #EoS			;check if the byte is EoS
		BEQ Quit				;if it is EoS quit the loop
		BNE Loop				;if the string is not the end keep looping
Check	LDRB r6, [r5,r4]		; load the next letter after the 't'
		CMP r6, #0x68			;if r6 has the value of 'h'
		BEQ Check2				;Confirmed 'h', check again
		BNE Store				;Not a part of 'the ', store the letter
Check2	ADD r7, r4,#1			;increment counter
		LDRB r6, [r5,r7]		;load the next letter after the 'h'
		CMP r6, #0x65			;if r6 has the value of 'e'
		BEQ Check3				;Confirmed 'e', check again
		BNE Store				;Not a part of 'the ', store the letter
Check3  ADD r7, r7, #1			;increment counter
		LDRB r6, [r5,r7]		;load the next letter after the 'e'
		CMP r6, #0x20			;if r6 has the value of ' '
		BEQ delete				;delete the characters 'the '
		BNE Store				;Not a part of 'the ', store the letter
delete  LDRB r3, [r1], #1		;load a byte of string
		ADD	r8, r8, #1			;increment counter
		CMP r8, #3				;After looping 3 times past 'the '
		BEQ Loop				;Next letter after deletion
		BNE delete				;load until r3 has past 'the '

Quit	B 	Quit

STRING1 DCB "and the man said they must go"	;String1
EoS		EQU 0x00							;end of string1
STRING2 space 0xFF							;just allocating 255 bytes

		END