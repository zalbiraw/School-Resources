		AREA Assignment4_Q1, CODE, READWRITE
		ENTRY
		
		LDR r0, =STRING1	; load string1 into register 0
		MOV r1, #0		; move 0 into register 1
		LDR r2, =STRING2	; load string2 (empty) into register 2
		LDR r4, =EoS		; load EoS (end of string/null character) into register 4
		MOV r5, #0		; move 0 into register 5
		MOV r7, #0		; move 0 into register 7
		B FIRST			; jump to first (skips the check for a space)
		
LOOP		LDRB r3, [r0, r1]	; loads r0 (string1) in position r1 into r3
		CMP r3, #0x20		; compares r3 to the ASCII character space (0x20)
		BNE NEXT		; if r3 is not a space then the program jumps to NEXT

		ADD r1, r1, #1		; increments r1 by 1

FIRST		LDRB r3, [r0, r1]	; loads r0 (string1) in position r1 into r3
		CMP r3, #0x74		; compares r3 to the ASCII character "t" (0x74)
		BNE NEXT		; if r3 is not a "t" then the program jumps to NEXT

		ADD r1, r1, #1

		LDRB r3, [r0, r1]	; loads r0 (string1) in position r1 into r3
		CMP r3, #0x68		; compares r3 to the ASCII character "h" (0x68)
		BNE NEXT		; if r3 is not a "h" then the program jumps to NEXT

		ADD r1, r1, #1		; increments r1 by 1

		LDRB r3, [r0, r1]	; loads r0 (string1) in position r1 into r3
		CMP r3, #0x65		; compares r3 to the ASCII character "e" (0x65)
		BNE NEXT		; if r3 is not an "e" then the program jumps to NEXT

		ADD r1, r1, #1		; increments r1 by 1

		LDRB r3, [r0, r1]	; loads r0 (string1) in position r1 into r3
		CMP r3, #0x20		; compares r3 to the ASCII character space (0x00)
		BEQ UPDATE		; if r3 is a space, then jump to UPDATE

		CMP r3, r4		; compares r3 to r4, which is EoS (0x00)
		BNE NEXT		; if r3 is not the end of string, then jump to NEXT
		BEQ DONE		; if r3 is equal to the end of string, then jump to DONE

UPDATE		ADD r5, r5, r1		; add r1 to r5, and store in r5	
		MOV r1, r5		; move the value in r5 into r1
		B LOOP			; jump to LOOP

NEXT		LDRB r6, [r0, r5]	; loads r0 (string1) in position r5 into r6
		STR r6, [r2, r7]	; store the value r6 into r2 at the position specified by r7
		ADD r5, r5, #1		; increment r5 by 1
		ADD r7, r7, #1		; increment r7 by 1
		B LOOP			; jump to LOOP

DONE					; end of program
			
		AREA Assignment4_Q1, DATA, READWRITE
		
STRING1	DCB "and the man said they must go"
EoS		DCB 0x00
STRING2	space 0xFF
	
		END