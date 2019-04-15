		AREA question1, CODE, READWRITE	
		ENTRY
		LDRB r0, EoS							;r0 is the eos symbol
		ADR r9, STRING1							;address the real string
		ADR r8, STRING2							;address of the new string
		MOV r2, r0								;r2-r6 will emulate a queue, initially empty
		MOV r3, r0								;r3 is eos symbol
		MOV r4, r0								;r4 is eos symbol
		MOV r5, r0								;r5 is eos symbol
		MOV r6, #' '							;r6 will be the space character for simpler logic later on, but it won't get appended to the string
		MOV r7, #0								;length of word so far (will include eos character at end)
Repeat 	LDRB r1,[r9],#1 						;BEGIN OF LOOP, read the next character of string1 into r1
		CMP r2, #' '							;lines 15-23 check if ' the ' occurs. special case is added later for 'the' appearing at end/beginning of string.
		BNE AddStr								;go to determine if the character should be added to the 2nd string or not
		CMP r3, #'t'							;check that the next character is 't'
		BNE AddStr								;go to determine if the character should be added to the 2nd string or not
		CMP r4, #'h'							;check that the next character is 'h'
		BNE AddStr								;go to determine if the character should be added to the 2nd string or not
		CMP r5, #'e'							;check that the next character is 'e'
		BNE AddStr								;go to determine if the character should be added to the 2nd string or not
		CMP r6, #' '							;check that the next character is a space
		BNE AddStr								;go to determine if the character should be added to the 2nd string or not
		MOV r3, #' '							;since we've encountered a 'the' to be removed (and determined the next character after is a space), set the next character to be added to the new string to be a space
		MOV r4, r0								;r4 as eos symbol (to be ignored)
		MOV r5, r0								;r5 as eos symbol (to be ignored)
		MOV r6, r0								;r6 as eos symbol (to be ignored)
AddStr	CMP r3, r0								;check if the character to be added is the end of the string
		BEQ leave								;if it is end of string1, don't add it to string2
		CMP r7, #3								;check for the 'fake' space i added at the beginning
		BEQ leave								;don't add the character if it's the 'fake' space
		STRBNE r3, [r8], #1						;store the character in the 2nd string
leave	MOV r2, r3								;lines 34-37 moves the queue along
		MOV r3, r4								;set r3 (the character to be added) to r4
		MOV r4, r5								;set r4 to r5
		MOV r5, r6								;set r5 to r6
		MOV r6, r1								;grabs the next element to be in the queue
		TEQ r0, r1								;check if at end of string
		ADD r7, r7, #1							;increase counter/length of word
		BNE Repeat 								;END OF LOOP
		CMP r2, #' '							;if the loop has ended, we have unprocessed characters in the queue. check if the last 4 are ' the'
		BNE NoThe								;it does not contain ' the', so add the valid characters into string2
		CMP r3, #'t'							;check for the 't' in 'the'
		BNE NoThe								;it does not contain ' the', so add the valid characters into string2
		CMP r4, #'h'							;check for the 'h' in 'the'
		BNE NoThe								;it does not contain ' the', so add the valid characters into string2
		CMP r5, #'e'							;check for the 'e' in 'the'
		BEQ ContThe								;if 'the' is located, just add the end character
NoThe	CMP r7, #3								;special case for length 3 words
		STRBNE r3, [r8], #1						;append r3 to string 2, but ignore it in the special case (it will always be a space)
		CMP r7, #2								;special case for length 2 words
		STRBNE r4, [r8], #1						;append r4 to string 2, but ignore it in the special case (it will always be a space)
		CMP r7, #1								;special case for length 1 words
		STRBNE r5, [r8], #1						;append r5 to string 2, but ignore it in the special case (it will always be a space)
ContThe STRB r0, [r8], #1						;store null character in string 2
Loop	B Loop									;parking loop
STRING1 DCB "" 									;String1
EoS 	DCB 0x00 								;end of string1
STRING2 space 0xFF 								;allocate 255 bytes for STRING2
		END