			AREA assignment3_q2, CODE, READONLY
			ENTRY

			mov r3, #0						;set up r3 to load length of string and the pointer for last character
			mov r4, #0						;set up r4 to load the pointer for the first character
			mov r5, #0						;set up r5 for the first half of the pointer's character
			mov r6, #0						;set up r6 for the second half of the pointer's character
			mov r7, #0						;set up r7 so it is given value 0
			LDR r1, =string					;load the string to r1

loop LDRB r2, [r1, r3]			;load each character byte to r2
			add r3, #1						;in order to calculate length of string
			CMP r2, r7						;if character not the end of the string
			BNE loop						;then continue the loop
			sub r3, #2						;calculates the last pointer for the string

loop1 LDRB r5, [r1, r4]			;load each of the first half character byte
			LDRB r6, [r1, r3]				;load each of the second half character byte

CMPR5 CMP r5, #0x40				;compare r5 and see if it is above the hexadecimal value 40, which is A
			BGT LARGER						;if it is larger then it can be either a letter, this is case insensitive
			b R5NEXTCHARACTER				;if it isn't, then that means it is not a letter, so skip to R5NEXTCHARACTER

LARGER CMP r5, #0x5B			;compare r2 and if it is above the hexadecimal value, [
			BLT CMPR6						;if less than 0x5B then r2 is a letter so jump to CMPR6
			CMP r5, #0x60					;if it isn't, then compare r5 to single apostrophe
			BGT SMALLER						;if it is larger then it may be lowercase letter, so skip to SMALLER
			b R5NEXTCHARACTER				;if not, skip to R5NEXTCHARACTER

SMALLER CMP r5, #0x7B			;compare r5 and hexadecimal value 7B, which is (
			SUBLT r5, #32					;if r5 is less than 7B, that means it is a lowercase letter. Subtract 32 in order to get uppercase letter since it is case insensitive
			BLT CMPR6						;if it is, go to CMPR6
			b R5NEXTCHARACTER				;if not, jump to R5NEXTCHARACTER

CMPR6 CMP r6, #0x40				;compare r6 and see if it is above hexadecimal 40, which is A
			BGT R6LARGER					;if larger, then it can be either a letter, this is case insensitive
			b R6NEXTCHARACTER				;if it isn't, then skip to R6NEXTCHARACTER

R6LARGER CMP r6, #0x5B			;compare r6 and [
			BLT comp						;if less than 0x5b, then r6 is a letter so jump to comp
			CMP r6, #0x60					;compare r6 to single apostrophe
			BGT R6SMALLER					;if larger then it may be lowercase letter, so skip to R3SMALLER
			b R6NEXTCHARACTER				;if not, then skip to R6NEXTCHARACTER

R6SMALLER CMP r6, #0x7B			;compare r6 and (
			SUBLT r6, #32					;if r6 is less than 0x7B, that means it is a lwoercase letter. Subtract 32 in order to get uppercase letter as this is case insensitive.
			BLT comp						;if it is, then skip to comp
			b R6NEXTCHARACTER				;if not, jump to R6NEXTCHARACTER

R5NEXTCHARACTER add r4, #1		;update the pointer for the first characters
			LDRB r5, [r1, r4]				;load the first half of the characters
			b CMPR5							;skip to CMPR5, so comparing can continue

R6NEXTCHARACTER sub r3, #1		;update the pointer for second characters
			LDRB r6, [r1, r3]				;load the second half of the characters
			b CMPR6							;skip to CMPR6, so comparing can continue

comp CMP r5, r6					;compare r5 and r6
			BEG next						;if they are equal, then skip to next
			b exit							;if they are not equal, go to exit

next add r4, #1					;update first character pointer, r4
			sub r3, #1						;update r3, the last character pointer
			CMP r4, r3						;compare r3 and r4, the two pointers
			BLT loop1						;if the first half the characters are less than the second half, go back to loop1 and continue to compare
			b exit2							;if not, then go to exit2

exit mov r0, #2					;if not a palindrome, then store 2 in r0
			b FINAL							;completely stop the program

exit2 mov r0, #1				;if palindrome, then store 1 in r0

FINAL NOP						;completely stop the program

			AREA assignment3_q2, DATA, READWRITE
string DCB "He lived as a deveil, eh?"			;string
EoS	DCB 0x00									;end of string

			END