		AREA PalChecker, CODE, READONLY
		ENTRY 								; The start of the program.
		
Start	LDR r0, STRING 						; r0 points to STRING.
While	LDRB r3, [r0], #1 					; Copy the element pointed at by r0 to r3.
		ADD r0, r0, #4 						; Point to the next element in the String.
		CMP r3, #'A' 						; Are we in the range of the capital?
		BGE Convert							; If >= 'A', then branch to convert.
Cont	CMP r3, #EoS						; Check if we have reached the end of the string.
		BNE While 							; If the end of the string hasn't been reached, jump back to the start of the loop.
		TST r5, #1							; Compares both r5 and 1 by ANDing them together.
		BNE Odd								; If r5 is odd branch down to Odd
Even	MOV r0, r2							; Copies the string stored in r2 into r0.
		ADD r0, r0, r5						; Now r0 points to the end of the string.
		LSR r5, r5, #1						; Divides r5 by 2 using a logical shift right. (Now r5 represents the middle)
Loop	LDRB r4, [r2], #1					; Copy the element pointed at by r2 to r4.
		LDRB r7, [r0]						; Copy the elment pointed at by r0 to r7.
		ADD r6, r6, #1						; Increments r6 by 1 (r6 is the loop counter for this loop).
		ADD r2, r2, #4 						; Point to the next element in the String.
		SUB r0, r0, #4						; Move backwards from the end of the string towards the middle.
		CMP r6, r5 							; Does r6 = r5? (Has the middle of the string been reached?)
		BNE Loop							; If they are not equal jump back to the start of the loop.
		CMP r0, r2							; Do r0 and r2 contain the same letters in the same order?
		BNE Invalid							; If they don't, branch to False.
		MOV r0, #1							; r0 and r2 are equal so the string is a palindrome, so store 1 in r0.		
		
stop	B stop 								; Infinite loop at the end of the program to make testing easy.
		
Convert	RSBS r1, r3, #'Z' 					; Check with 'Z' and update the flags.
		ORRGE r3, r3, #0x0020				; If between 'A' and 'Z' inclusive, then set bit 5 to force lower case.
		CMP r3, #'a' 						; Are we in the range of the lower case?
		RSBGES r1, r3, #'z' 				; If >= 'a', then check with 'z' and update the flags.
		ADDGE r2, r2, r3					; Add the lower case letter in r3 to r2.
		ADD r5, r5, #1						; Increment r5 by one (keeps track of how many letters there are in the palindrome string).
		B Cont								; Jumps back to the string.
		
Odd		ADD r5, r5, #1						; Add 1 to r5 thus making it even.
		B Even								; Jump back up to where this even number is processed.
		
Invalid	MOV r0, #2						; r0 and r2 are not equal so the string is not a palindrome.
		B stop								; Jump to the end.
		
STRING 	DCB "He lived as a devil, eh?" 		;string
EoS 	DCB 0x00 							;end of string 

		END 								; End of the program