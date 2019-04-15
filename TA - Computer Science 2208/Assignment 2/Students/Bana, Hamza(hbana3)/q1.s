		AREA question1, CODE, READONLY
		ENTRY
		
		LDRB r0, EoS ;load r0 with end of string character
		LDR r1, =STRING1 ;load string 1 to r1
		LDR r2, =STRING2 ;load string 2 to r2
		MOV r3, #0 ;initialize r3 as the counter variable
		MOV r4, #0 ;variable to hold the length
		LDR r5, =0x74686520 ;hex code for "the"
		LDR r6, =0x54686520 ;hex code for "The"
		LDRB r7, [r1, r3] ;load first character of strign 1 to r7
		
COUNTLOOP CMP r0, r7 ;compare the value in r0 and r7 to see if the current character is EOS
		BEQ COUNTDONE ;if ro==r7, go to countdone loop
		ADD r3, #1 ;increment r3 by 1
		LDRB r7, [r1, r3] ;load r0 to r5 then increment by 1
		B COUNTLOOP ;repeat loop
		
COUNTDONE MOV r4, r3 ;store the value in r3 to r4 as the length of the string
		MOV r3, #0; reset r3 to 0 as the new counter variable
		B WHILELOOP ;jump to while loop
		
WHILELOOP CMP r3, r4 ;check if r3 == r4
		BGE LOOP ;if counter is the same as length, jump to end of program
		LDRB r7, [r1, r3] ;load character at r3 from string 1 to r7
		CMP r7, #'t' ;compare character at r7 to check if its t
		BEQ COMPAREFUNCTION ;if letter is t, jump to compare function to test if the word is the
		CMP r7, #'T' ;if its not 't', compare to see if the character is "T"
		BEQ COMPAREFUNCTION ;if letter is T jump to compare function to test if the word is The
		;if not equal to 't' or "T", copy character to new string 
NOTT	STRB r7, [r2], #1; if the letter is not T, or the word is found to be not equal to 'the'
		;jump to this function and copy the word from [r1, r3] to location r2(strign 2) then increment pointer by 1
		ADD r3, #1 ;increment r3 counter by 1
		B WHILELOOP
		
		;responsible for checking if the word loaded in memory is the same as The or the
COMPAREFUNCTION SUB r12, r3, #1;
;LDRB r8, [r1,r3] ;load the address of [r1,r3] to r8
		LDRB r9, [r1, r12] ;load the character right before the current address stored
		;ADD r12, r3; copy r3 and store the value in 12
		;test to see if the character in r7 is either a space or null character
		;if its not, means that the word cant be 'the' or 'The', jump to NOTT loop
		CMP r9, #0x20 ;compare current char to space
		CMPNE r9, #0 ; if its not space, compare it to null
		BNE NOTT;if condition not met, jump to NOTT
		;if condition is met, word can potentially be 'the'', test more memory blocks
		MOV r9, #0; set r9 to 0 and add the next 3 characters and compare to 'the ' and "The "
		MOV r10, #4; load 4 into r10 to act as a counter while adding characters
		ADD r12, #1 ;increment r12 by 1 so it points to the t and not the space before it
LOADERLOOP	LDRB r8, [r1, r12] ;load current character into r1
		ADD r12, #1;increment r12 pointer by 1
		ADD r9, r8, r9, LSL #8; add character in r11 to r9, increment by 1 and logical shift left by 8
		;repeat until the next 3 characters have been added
		SUBS r10, #1;subtract 1 from r10 and set flags
		;if counter is not 0, repeat loop until counter is 0
		BNE LOADERLOOP
		;r9 now contains 4 characters, test to see if they match the hex code for "the " or "The " stored in r5 and r6
		CMP r5, r9 ;compare r5 containing "the " to hex code in r9
		CMPNE r5, r9;if above is not equal, compare to see if the hex code equals "The "
		BNE NOTT ;if none of the conditions are met, means that the word is not the, jump back to NOTT loop
		;and add character to string 2
		;else if the condition is met, means that the word is the, increment counter by 4, dont add to string 2 and continue execution
		ADD r3, #4 ;increment r3 by 4
		B WHILELOOP
		
LOOP	B LOOP
		
		AREA question1, DATA, READWRITE
STRING1 DCB "and the man said they must go" ;String1
EoS 	DCB 0x00 ;end of string1
STRING2 SPACE 0xFF ;just allocating 255 bytes 
		END
		