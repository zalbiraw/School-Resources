		AREA UPC_Checker, CODE, READONLY
		ENTRY 								; The start of the program.

Start	LDR r0, UPC 						; r0 points to UPC.
While	LDRB r3, [r0], #1 					; Copy the element pointed at by r0 to r3.
		ADD r0, r0, #4 						; Point to the next element in the UPC.
		ADD r1, r1, #1 						; Increment the loop counter.
		TST r1, #1 							; Compares both r1 and 1 by ANDing them together.
		BNE Odd 							; Zero flag not set meaning it's odd.
		ADD r4, r4, r3 						; Add the even placed number into r4 (The second sum).
		CMP r1, #12 						; Does r1 = 12?
		BNE While 							; If r1!= 12 then jump back to the start of the loop.
		ADD r2, r2, r2, LSL #1 				; Multiplies r2 (The first sum) by 3.
		ADD r4, r4, r2 						; Adds the value of r2 (The first sum) to r4 (The second sum).
Loop 	CMP r4, #10 						; Compares r4 to 10. (This loop uses repeated substituton to divide r4 by 10).
		BLT Check 							; If r4 is less then 10, jump to check.
		SUB r4, r4, #10 					; Subtracts 10 from r4.
		B Loop 								; Jumps back to the start of the loop.
Check	CMP r4, #0 							; Checks to see if r4 (The second sum) is equal to zero.
		BNE NotVal 							; Since r3 doesn't equal zero then the UPC must not be valid so jump to NotVal.
Valid 	MOV r0, #1 							; The UPC is valid so it moves 1 into r0.
		B stop 								; Branches to the end of the code so to skip the next command.
NotVal	MOV r0, #2 							; The UPC is not valid so it moves 2 into r0.

stop	B stop 								; Infinite loop at the end of the program to make testing easy.
Odd 	ADD r2, r2, r3 						; Add the odd placed number into r2 (The first sum).
		B While 							; Jump back to the start of the loop.
UPC		DCB "013800150738"					;UPC string.

		END ; End of the program
			