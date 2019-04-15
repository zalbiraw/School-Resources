		AREA q_1, CODE, READONLY
		ENTRY
		ADR r0, STRING1
		ADR r1, STRING2
		MOV r2, #0	; initiates loop at zero

LOOP	LDRB r3, [r0, r2]	; Load first character in String1	
		CMP r2, #0			; Check if beginning with counter
		BEQ	FIRST			; Jump to condition if it is first character
		CMP r3, #32			; Check to see if character is space
		BEQ CHECKT			; Jump to check for t function
		CMP r3, #0			; Compare for end of string
		BEQ DON				; Jump to finish line if end of string
		STR r3, [r1, r2]	; Store non-space character in String2
		ADD r2, r2, #1		; Increment counter
		B LOOP				
		
FIRST	CMP	r3, #116		; Compare to see if character is 't'
		BEQ CHECKH			; if so jump to check for h function
		STR r3,[r1, r2]		; if not, store character in string2 at spot with counter
		ADD r2, r2, #1		; increment counter
		B LOOP

CHECKT	STR r3, [r1, r2]	; Store space in string2
		ADD r2, r2, #1		; increment counter
		LDRB r3, [r0, r2]	; load next character from String1
		CMP	r3, #116		; Check to see if it is a 't'
		BEQ CHECKH			; if so, jump to check for h function
		STRNE r3, [r1, r2]	; if not, store character in String2
		ADDNE r2, r2, #1	; increment counter
		B LOOP		

CHECKH 	ADD r4, r2, #1		; begin new counter at the old counter plus one to protect old counters index for String1
		LDRB r5, [r0, r4]	; load next character to check for 'h'
		CMP r5, #104		; check to see if new character is an 'h'
		BEQ CHECKE			; if so, continue to the check for e function
		STRNE r3, [r1, r2]	; else, store previous 't' with past counter as index
		STRNE r5, [r1, r4]	; store the non-h character with the new counter as index
		B LOOP

CHECKE	ADD r6, r4, #1		;begin new counter at the past counter plus one
		LDRB r7, [r0, r6]	; load next character to check for 'e'
		CMP r7, #101		;check for 'e'
		STRNE r3, [r1, r2]	; if not, store all the past characters in String2 with their respective counters as index
		STRNE r5, [r1, r4]	
		STRNE r7, [r1, r6]
		BNE LOOP			; if not, Go back to LOOP
		ADD r8, r6, #1		; increment new counter with old counter plus one 
		LDRB r9, [r0, r8]	; load next character with new counter
		CMP r9, #32			; check to see if the character is a space
		ADDEQ r2, r2, #1	; if so, then skip storing as it is 'the'
		BEQ LOOP			; if so, jump back to LOOP
		STRNE r3, [r1, r2]	; if not, store all characters in STRING2 with respective counters as index
		STRNE r5, [r1, r4]
		STRNE r7, [r1, r6]
		STRNE r9, [r1, r8]
		BNE LOOP			; return LOOP

DON		MOV r2, #0

		AREA q_1, DATA, READWRITE
STRING1 DCB "and the man said they must go" ;String1
		ALIGN
EOS		DCB 0x00
		ALIGN
STRING2	space 0xFF
	END