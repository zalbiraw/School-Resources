	AREA Question1, CODE, READONLY
	ENTRY
	
	;r0 stores 1 if UPC is valid, 2 if invalid
	;r1 is used as the counter to keep track of the current place in the UPC code
	;r2 is used as a pointer to the next value of the UPC code to be processed
	;r3 holds the current value of the UPC code being processsed
	;r4 holds the current value of the calculations
	MOV r0,#1					;Pre-emptively storing 1 in r0, if the UPC is invalid it will be changed (valid by default)
	MOV r1,#LEN					;Initializing the counter used to keep track of the current number
	ADR r2, UPC					;Initialzing pointer to current number with address of UPC in memory
	
	;Loop processes each value of the UPC code
	;Depending on whether the current index is odd or even, the current value will be multiplied by 3
	;Using an if structure rather than two for loops reduces the amount of instructions needed
TOP LDRB r3,[r2],#1				;Load a byte and then post-increment pointer so next byte is ready to be loaded on next loop
	SUB r3,#'0'					;Subtract the hex value of '0' to get the value being represented by the string (in decimal)
	TST r1,#2_00000001			;Test if current value has odd index (binary # ending in 1 are odd)
	ADDNE r3,r3,r3,LSL #1		;If index is odd, multiply number by 2 and then add it to itself
    ADD r4,r4,r3				;Add the modified (or unmodified) value to the current sum
	SUBS r1,r1,#1				;Decrement the counter by 1 as 1 more value has been processed
	BNE TOP						;If the counter is not yet 0, there are still values that need to be processed (branch back to TOP)
	SUB r4,r4,#1				;Subtract one from the current value
	
	;Division is implemented through subtraction (in a loop)
	;Subtraction will be done until the value in r4 becomes negative
DIV SUBS r4,r4,#10				;Subtract ten from the sum
	BMI NE						;If the new value in the register is negative, ten has been subtracted one too many times (branch out of loop)
	B DIV						;Continually branch back to beginning of loop (will be skipped once sum is negative)
NE	ADD r4,r4,#10				;Add back ten to the sum to get the remainder of the division
	RSB r4,r4,#9				;Subtract the remainder from 9 using RSB (since the larger value is a constant)
	LDRB r3,[r2]				;Load the next byte of the UPC code to get the check digit
	SUB r3,#'0'					;Subtract the ascii value of '0' to get the value being represented by the string (in decimal)
	TEQ r4,r3					;Check if the check digit is equivalent to the calculated value
	MOVNE r0,#2					;If not equivalent store 2 in r0
	
	;UPC code and LEN initialization
UPC DCB "013800150738"			;UPC code as string
LEN EQU 11						;Length of UPC code (without check digit)
	
	END