		AREA question_one, CODE, READONLY
		ENTRY
		;Register uses:
		;r0 holds the address of the UPC, it changes to 1 or 2 at the end of the program to be used as verification
		;r1 is the counter for the digit loop
		;r2 is used to load the digits of the UPC from memory
		;r4 is the first sum, containing the sum of the digits at an even index in the UPC
		;r5 is the second sum, containing the sum of the digits at an odd index in the UPC
		;r5 later becomes the combined sum after multiplication, the remainder after the modular division, and the computed digit.
		
		;Initializing values
		LDR r0, =UPC 			;Load address of UPC, first digit is index 0
		MOV r1, #10 			;Initialize counter for "digit" loop to start at index 10, counts down to first digit (0)
		MOV r4, #0 				;Initialize first sum to 0
		MOV r5, #0 				;Initialize second sum to 0
		
		;digit loop, Used to add digits to their appropriate sum depending on their position in the UPC
digit	LDRB r2, [r0,r1]		;Load digit from UPC to be added to appropriate sum
		SUB r2,r2,#0x30 		;Convert digit from ASCII to its numerical value to be accurately added
		TST r1,#1 				;Test if the digit is in an odd or even index in the UPC
		ADDEQ r4,r4,r2 			;If even then add to first sum (r4)
		ADDNE r5,r5,r2 			;If odd then add to second sum (r5)
		SUBS r1,r1,#1 			;Update counter so UPC bounds aren't over stepped
		BPL digit 				;Go back to beginning or exit loop when counter (r1) equals -1
		
		;Properly sum together the 2 sums: r5 = r4*3 + r5 - 1
		ADD r4,r4,r4,LSL #1 	;Multiply first sum (r4) by 3
		ADD r5,r5,r4 			;Add both sums (r4 and r5) together
		SUB r5,r5,#1 			;Subtract 1 from the new sum (r5)
		
		;rem loop, Used to calculate the remainder of the sum (r5) after dividing by 10: r5 = r5 mod 10. Compute check digit.
rem		SUBS r5,r5,#10			;Subtract ten from the sum (r5)
		BPL rem 				;Continue subtacting until negative, once negative all that needs to be done is add 10 and it will be the remainder
		ADD r5,r5,#10			;Finish remainder (r5) by adding 10
		RSB r5,r5,#9			;Subtract 9 by the remainder (r5) to get the final digit of the UPC
		
		;Compare the result to the check digit of the UPC, load r0 with appropriate output
		LDRB r2, [r0,#11]		;Load check digit
		SUB r2,#0x30 			;Convert from ASCII to number
		CMP r5,r2 				;Compare calculated digit (r5) and check digit (r2) for equality
		MOVEQ r0,#1 			;r5 and r2 are the same which means that UPC is valid, load r0 with 1
		MOVNE r0,#2 			;r5 and r2 are not the same which means that UPC is not valid, load r0 with 2
		
loop	B loop

UPC		DCB "013800150739" ;UPC string, it is indexed beginning at 0
		END