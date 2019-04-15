		AREA assignment3_q1, CODE, READONLY
		ENTRY

		LDR r0, =UPC					;loads the UPC address into r0
		mov r1, #0						;sets up the first sum by storing 0 into r1, the odd digits
		mov r2, #0						;sets up the second sum by storing 0 into r2, the even digits
		mov r3, #0						;sets up the array even counter by storing 0 into r3
		mov r4, #1						;sets up the array odd counter by storing 1 into r4
		mov r5, #9						;this will be used as constant when subtracting 9 from the remainder
		mov r6, #5						;sets up loop counter by storing 5 into r6

Loop LDRB r7, [r0, r3]					;load byte from r0 at pointer r1 into r7, load number in odd position
		LDRB r8, [r0, r4]				;load byte from r0 at pointer r2 into r4, load number in event position
		sub r7, r7, #48					;convert from ASCII integer into decimal value
		sub r8, r8, #48					;convert from ASCII integer into decimal value
		add r1, r7						;add odd position numbers to first sum, r1
		add r2, r8						;add even position numbers to second sum, r2
		add r3, r3, #2					;increment and update the array even counter
		add r4, r4, #2					;increment and update the array odd counter
		sub r6, r6, #1					;update the loop counter
		CMP r6, #0						;if the counter goes down to 0, then exit the loop
		BNE Loop						;if the counter doesn't equal to 0, it will continue to go back to the loop

		LDRB r7, [r0, r3]				;load byte from r0 into r7, the last odd digit which the eleventh digit
		sub r7, r7, #48					;convert from ASCII integer into decimal value
		add r1, r7						;add the eleventh digit to the odd digit sum, then update
		add r9, r2, r1, LSL #1			;add second sum and first sum * 2 into r9
		add r9, r1						;add first sum to r9 one more time, so total it is multiplied three times
		sub r9, #1						;subtract 1 from r9, the sum of first and second sum

loop1 sub r9, #10						;this loop will calculate the remainder when r9 is divided by 10
		CMP r9, #10						;continue to subtract 10 from r9, until remainder is less than 10
		BGT loop1						;this will be remainder of loop1

		RSB r10, r9, r5					;subtract 9, stored in r5, from r9, then store into r10

		LDRB r8, [r0, r4]				;get the last digit of the number
		sub r8, r8, #48					;convert from ASCII integer into decimal value
		CMP r8, r10						;compare the last digit and r10
		BEQ equal						;if these two are equal, then valid UPC code and will store into r0

		mov r0, #2						;if the number is not equal, it is not a valid UPC code and will 2 into r0
		b end1							;then stop the program

equal mov r0, #1				;if it is a valid UPC, then store #1 into r0
end1 nop						;then stop the program

		AREA assignmentq3_q1, DATA, READWRITE

UPC DCB "013800150738"			;UPC string

		END