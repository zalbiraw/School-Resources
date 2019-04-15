		AREA Palindrome_Checker, CODE, READONLY ;Morgan O'Brien 2208 Asn 3 Program #2
		ENTRY
		ADR r1, STRING							;the string address will be stored here for good
		mov r0, #1								;r0 will be 1 unless the palindrome is invalid
		MOV r10, #0 							;r10 will count string length
		mov r9, #0  							;upwards counter, will work towards r10 as it decrements
		mov r12, #5 							;must reduce by this much to get rid of the null terminator and return to the index of the last char in the string	
		mov r13, #90 							;uppercase Z ASCII
		mov r14, #32 							;lower to upper ASCII conversion difference
		mov r3, #122 							;lowercase z ASCII
		mov r8, #26	 							;alphabet size
		
loop	ldrb r5, [r1, r10]						;loop through string to count the length
		add r10, #1 							;length counter
		cmp r5, #0 								;r5 will be 0 at the end of the string
		BGT loop								;return to keep counting
		sub r10, r10, r12 						;reduce length to final char's index
loopy	ldrb r5, [r1,r9] 						;load current byte starting from the front of the string	
		sub r4, r13, r5							;subtract by uppercase Z ascii to check if it is an uppercase ALPHA char
		cmp r8, r4 								;if less than 26 it is an uppercase ALPHA, one more thing must be checked though
		BGT checkP 								;checkP also checks if r4 is still positive because the char is not an uppercase ALPHA if not
		add r9, #1 								;increment counter if char was not valid
		BLT loopy								;move on to next char
checkP  cmp	r4, #0								;checks if r4 is still positive because the char is not an uppercase ALPHA if not
		BGT valid   							;if the char is valid we must now go and get the matching char from the end of the string
		sub r4, r3, r5 							;the char may also be lowercase, we subract it from 122 (lowercase z ASCII)
		cmp r8, r4 								;check validity (less than 26)
		BGT checkP2 							;checkP2 will make sure the result of the subrtraction wasn't negative
		add r9, #1 								;increment counter if char is not an alphabet character
		BLT loopy								;move on to next char
checkP2 cmp	r4, #0								;checks if r4 is still positive because the char is not an uppercase ALPHA if not
		BGT valid								;if the char is valid we must now go and get the matching char from the end of the string
		add r9, #1 								;increment counter if char is not an alphabet character
		BLT loopy								;move on to next char

valid	ldrb r6, [r1,r10]						;load current byte starting from the end of the string
		sub r4, r13, r6 						;subtract by uppercase Z ascii to check if it is an uppercase ALPHA char
		cmp r8, r4								;if less than 26 it is an uppercase ALPHA, one more thing must be checked though
		BGT check1 								;check1 also checks if r4 is still positive because the char is not an uppercase ALPHA if not
		sub r10, r10, r0						;reduce counter by 1
		BLT valid 								;move on to next char if invalid
check1  cmp r4, #0 								;checks if r4 is still positive because the char is not an uppercase ALPHA if not
		BGT next 								;if the char is valid we must now see if the 2 chars are the same letter
		sub r4, r3, r6 							;the char may also be lowercase, we subract it from 122 (lowercase z ASCII)
		cmp r8, r4								;check validity (less than 26)
		BGT check2 								;check2 will make sure the result of the subrtraction wasn't negative
		sub r10, r10, r0 						;reduce counter by 1
		BLT valid  								;move on to next char if invalid
check2  cmp r4, #0 								;checks if r4 is still positive because the char is not an uppercase ALPHA if not
		BGT next 								;if the char is valid we must now see if the 2 chars are the same letter
		sub r10, r10, r0 						;reduce by 1
		BLT valid 								;move on to next char if invalid
		
nope	mov r0, #2 								;we come here if the characters are not the same letter, meaning the string is not a palindrome. The program is finished so we trap it.
TRAP    B TRAP 									;Trap the program into an infinite loop

next	cmp r6, r13 							;check if the letter in r6 is lowercase, we want them all in uppercase so they can be compared
		BGT sub32r6 							;convert to uppercase
		cmp r5, r13 							;check if the letter in r5 is lowercase, we want them all in uppercase so they can be compared
		BGT sub32r5 							;convert to uppercase		
		
		cmp r6, r5								;compare the 2 alphabet letters
		BLT nope								;if not equal, string is not a palindrome
		BGT nope								;if not equal, string is not a palindrome, otherwise the 2 letters are the same!
		
		cmp r9, r10	 							;compare the incrementing and decrementing counters, when they meet, that means the entire string has been processed.
		sub r10, r10, r0 						;decrement the big counter
		add r9, #1 								;increment the small counter
		BGE TRAP								;trap program if entire string has been processed
		BLT loopy								;otherwise return and fetch the next 2 bytes to compare
		
sub32r6	sub r6, r6, r14 						;subtracting by 32 converts lowercase ASCII alphabets to uppercase ones
		BGT next								;return once converted

sub32r5 sub r5, r5, r14 						;subtracting by 32 converts lowercase ASCII alphabets to uppercase ones
		BGT next								;return once converted

STRING 	DCB "racecar!!!"  ;string
		END