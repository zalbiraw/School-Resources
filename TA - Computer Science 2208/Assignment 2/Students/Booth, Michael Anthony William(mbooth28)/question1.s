		AREA q_1, CODE, READONLY
		ENTRY
		ADR   r9, STRING1	;Load in the string with the words
		LDRB  r10, EoS      ;Load in the end of string symbol
		ADR   r11, STRING2  ;Load in empty string to append to
Repeat  LDRB  r1, [r9], #1  ;Load first byte into registar r1
		CMP   r1, r10       ;Compare it to end of string
		BEQ   Final         ;Branch to end if equal to end of string
		CMP   r1, #116      ;Compare to lowercase t
		BNE   LoadWd        ;Brach to loading byte if not equal
		ADD   r2, #1        ;Add to counter for letters skipped so far
		LDRB  r1, [r9], #1	;Load next byte into registar r1
		CMP   r1, #104		;Compare to lowercase h
		BNE   LoadWd		;Brach to loading byte if not equal
		ADD   r2, #1		;Add to counter for letters skipped so far
		LDRB  r1, [r9], #1	;Load next byte into registar r1
		CMP   r1, #101		;Compare to lowercase e
		BNE   LoadWd		;Brach to loading byte if not equal
		ADD   r2, #1		;Add to counter for letters skipped so far
		LDRB  r1, [r9], #1	;Load next byte into registar r1
		CMP   r1, r10		;Compare to end of string
		BEQ   Final			;Jump to end of program if end of string
		CMP   r1, #32		;Compare to space ASCII
		BNE   LoadWd		;Brach to loading byte if not equal
		SUB   r9, #1		;Move pointer back one so it can store space afterwards
		MOV   r2, #0		;Reset counter
		B  	  Repeat		;Branch back to start
LoadWd 	SUB   r9, r2		;Move pointer back according to the counter
		SUB   r9, #1		;Move pointer back one more so I can reload the proper byte into r1
		LDRB  r1, [r9], #1	;Load next byte into registar r1
		MOV   r2, #0		;Reset the counter
		STRB  r1, [r11], #1 ;Store byte in second string
		B     Repeat    	;Branch back to the start
Final						;Ending branch
STRING1 DCB   "the 123 the" ;String1
EoS 	DCB   0x00 			;end of string1
STRING2 SPACE 0xFF 			;Second string
		END