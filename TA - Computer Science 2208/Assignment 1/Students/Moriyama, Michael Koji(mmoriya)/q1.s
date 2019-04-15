		AREA q1, CODE, READONLY
		ENTRY
start	ADR 	r9, UPC										;r9 points to the UPC code, loads register r9 with 32 bit address of UPC
		LDRB 	r1, [r9], #1								;loads r1 as the first digit in the string
		SUB		r1, #48										;since the UPC is a string, to convert to an integer I will subtract by ascii '0'
		LDRB 	r2, [r9], #2								;r2 is the second digit in the string
		SUB 	r2, #48										;same thing as above what we did to r1
		MOV		r3, r1										;r3 now has the value of r1, so that r1 can change, but its value will be stored in r3
		MOV		r4, r2										;r4 now has the value of r2, so that r2 can change, but its value will be stored in r4
		
		MOV 	r0, #5										;want the first loop to decrement 5 times, this will get all of the odd digits	
loop1	LDRB 	r1, [r9], #2								;get next odd digit and store in r1
		SUB		r1, #48										;subtract by 48 to get the decimal #
		ADD 	r3, r3, r1									;continue summing by storing the sum in r4 and adding the current odd number
		SUBS 	r0, r0, #1									;decrement loop by 1
		BNE		loop1										;continue decrementing until you hit zero
		
		MOV 	r0, #4										;want the second loop to decrement 4 times, because we want all even except for the 12th
loop2	LDRB	r2, [r9], #2								;get next even digit
		SUB		r2, #48										;need to subtract by 48 to get its non-ASCII i.e. its decimal #
		ADD		r4, r4, r2									;continue summing by storing the sum in r4 and adding the current even number
		SUBS 	r0, r0, #1									;decrement loop by 1
		BNE 	loop2										;continue until zero

SUM		ADD 	r5, r3, r3, LSL #1							;calculates r1 = r3 + r3 * 2 ... so essentially the odd numbers * 3
		ADD 	r5, r5, r4									;sums the even and odd numbers			
		SUBS 	r5, r5, #1									;subtracts 1 from the sum

		MOV 	r10, #10									;make r10 = 10 for comparison
loop3	CMP		r10, r5										;compare r10 to r5
		BPL		true										;if 10 is greater than or equal to the sum then goto True
		SUBS	r5, r5, #10									;lessen the sum by 10
		B	 	loop3										;continue through loop3, because we want to replicate a "mod 10" type of equation	
true	RSB		r7, r5, #9									;r7 = 9 - r5, so r7 now has check number, here r5 represents the remainder of the mod 10 simulation

check	LDRB 	r8, [r9], #12								;stores the UPC check number in r8, thus the last and 12th digit of the UPC stored in r9
		CMP		r7, r8										;compares the check numbers																									
		MOVEQ	r0, #1										;if they are equal then store 1 in r0
		B		invalid										;if it is not valid(they are not equal) then go to invalid
invalid	MOV	 	r0, #2										;ELSE store 2 in r0
		BNE		invalid										;if not equal branch to the else part
	
UPC		DCB 	"013800150738"								;UPC string		
		END