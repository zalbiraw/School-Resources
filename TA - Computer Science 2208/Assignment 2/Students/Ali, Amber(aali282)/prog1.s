AREA prog1, CODE, READONLY
			ENTRY

			ADR r1, STRING1							; load the address of the start of string 1
			ADR r2, STRING2							; load the address of the start of string 2 				
			MOV r3, #'t'							; Store t in r3, to use for reference
			LDR r4, =0x746865						; Store the in r4 to use for comparison
	
loop		LDRB r5, [r1], #1						; load the current character of string 1 into r6 and increment
			CMP r5, r3								; see if t
			STRNEB r5, [r2], #1						; if it is not t, then store in string2 and increment
			BEQ function							; if it is equal, branch to function
			CMP r5, #0								; see if end of string
			BNE loop								; if it is not, then go back								


function	MOV r10, r1								; copy address of string location from r1 to r10
			LDRB r7, [r10, #-2]!					; load the previous letter of the string in r7 and increment r10
			CMPNE r7, ##0x20						;check for a space	
			BNE end									; If no space, go to the end of the function
			MOV r9, #3								
			MOV r8, #0								
innerLoop	LDRB r7, [r10], #1						; load next character into r7 and increment 
			ADD r8, r7, r8, LSL #8					; add character in r7 into r8 and shift it by 1 byte
			SUBS r9, r9, #1							; subtract 1 from the counter
			BNE innerLoop							; if not zero, go back to the inner loop
			CMP r8, r4								; compare word in r8, with the word
			BNE end									; branch to end if not equal
			LDRB r7, [r10], #1						; load next character in r7 and increment r10
													
			CMPNE r7, #0x20							; check if it is a space
			MOVEQ r1, r10							; if it is a space, in r1 equal to address in r10 
end 		STRNEB r3, [r2], #1						; if not equal, store the letter t in string 2
			BX r14									; exit function

			AREA q_two, DATA, READWRITE
STRING1 DCB "and the man said they must go" ;String1
EoS DCB 0x00 ;end of string1
STRING2 space 0xFF ;just allocating 255 bytes 
			END
