				AREA UPC_Check, CODE, READWRITE
				ENTRY								;Start of program
		
				LDR		r0, =UPC					;Loads UPC's Memory Location in r0, Allows us to access it

													;SUMUPC loop correctly sums the digits of the UPC 
SUMUPC			LDRB 	r3, [r0, r4]				;As r4 is incremented, r3 will iterate through the UPC digits
				SUB 	r3, r3, #48					;Converts ASCII -> Integer
				TST 	r4, #1						;Checks if r4 is at an even or odd position
				ADDEQ 	r3, r3, r3, LSL #1			;Multiplies 1st, 3rd, 5th, 7th, 9th, and 11th digit by 3, as these make up the "first sum"
				ADD 	r5, r5, r3					;Keeps running sum of all numbers 
				ADD 	r4, r4, #1					;Increments r4 so that it points to the next number in the UPC
				CMP 	r4, #12;					;Accesses all numbers. Includes check digit because I used a slightly different method than the one suggested by the assignment
				BLT 	SUMUPC;						;Loops back until all the digits have been summed
				
													;REMTEM loop determines if r5 is a multiple of 10
REMTEN			CMP 	r5, #0;						;Checks if current sum is <,>, or = to 0. Will affect how program branches
				MOVEQ 	r0, #1;						;If r5 = 0, the sum of the digits is a multiple of 10 and check digit is correct. sets r0 to 1, as per asn instructions
				MOVLT 	r0, #2;						;If r5 is <10, the sum of the digits is not a multiple of 10; check digit is incorrect
				SUBGT 	r5, r5, #10;				;If r5 > 0, we subtract 10 from it and check whether (r5-10) is <,>, or = to 0
				BGT 	REMTEN;						;If r5 > 0, we cannot confirm whether or not its a multiple, so we loops until r5 is < or = to 0.

ENDPROGRAM		B 		ENDPROGRAM					;End program
				
				AREA UPC_Check, DATA, READWRITE
UPC		DCB		"726412175424"						;UPC string
				END