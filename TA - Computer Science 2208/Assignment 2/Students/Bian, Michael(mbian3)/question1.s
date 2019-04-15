		AREA DRAFT, CODE, READONLY
		ADR r0,STRING1			;Have r0 point to the read string
		ADR r12, STRING2		;Have r12 point to the store string
AGAIN	LDRB r2,[r0],#1			;Read the next letter into r2 and have r0 point to the next letter
		MOV r3, #0				;Clear r3,5,7,9 prior to each loop
		MOV r5,#0
		MOV r7,#0
		MOV r9,#0
		CMP r2,#0x00			;If the null string is encountered, exit
		BEQ FINISH
		MOV r3,r2				;Store r3 with r2 as a temporary holder
		CMP r2,#0x74			;Check to see if r2 is the letter t
		BNE skip				;If not, this word cannot begin with the and append this letter
		LDRB r4,[r0],#1			;Otherwise, check the next letter to see if it matches h
		MOV r5,r4
		CMP r4,#0x68
		BNE special				;If it does not, branch to special to append this letter and the previous letter
		LDRB r6,[r0],#1			;Otherwise, check for the next letter to see if it maches e
		MOV r7,r6
		CMP r6,#0x65
		BNE special				;If it does not, branch to special to append this letter and the previous two letters
		LDRB r8,[r0],#1			;Otherwise, check to see if this letter is followed by a space
		CMP r8,#0x00
		BEQ FINISH				;If this is the last letter, branch to finish
		CMP r8,#0x20
		BEQ skip2				;If this is a space, then we have found a word "the" and we skip it by branching to skip2
		MOV r9,r8				
		b special				;If not, then we branch to special and append all previous letters skipped
skip	STRB r2,[r12],#1		;If branched here, we store the letter just read and reloop
		b AGAIN
skip2	STRB r8,[r12],#1		;If branched here, we have found "the" and we reloop without appending stored letters
		b AGAIN
special CMP r3,#0x00			;If branched here, we have found at least "t" but the word was not "the"
		STRNEB r3,[r12],#1		;We go through register r3,5,7,9 to see if there were stored letters and append them if so
		CMP r5,#0x00
		STRNEB r5,[r12],#1
		CMP r7,#0x00
		STRNEB r7,[r12],#1
		CMP r9,#0x00
		STRNEB r9,[r12],#1
		b AGAIN
FINISH  LDRB r11,EoS			;Branched to if we have found the null character
		STRB r11,[r12],#1		;We append the null character to String2 and terminate
loop	b loop
		
		AREA DRAFT, DATA, READWRITE
STRING1 DCB "and the man said they must go";String1
EoS 	DCB 0x00 ;end of string1
STRING2 space 0xFF ;just allocating 255 bytes 
		END 