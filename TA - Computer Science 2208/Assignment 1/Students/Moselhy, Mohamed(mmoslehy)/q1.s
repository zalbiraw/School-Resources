								;This program will validate the check digit of any standard 12-digit barcode
	AREA A3q1, CODE, READONLY	;Header line to specify program name
	ENTRY						;The program will start here

HexToDec	EQU 0x0F			;Mask to decode Hex-encoded bytes into integers
	
	LDR r10, =UPC				;Use register r10 to store a string pointer of the UPC code from memory

StartOdd
	B EveryTwo					;Start looping to add the digits to register r2, used to keep the sum, starting at odd indices

StartEven						;This section initializes the pointer to start at the first even index of the string
	LDR r10, =UPC				;Restart the string pointer in r10 back to the start of the string
	LDRB r1, [r10], #1			;Offset the string pointer by 1 to start pointing at even indices
	MOV r0, #1					;Use register r0 as a flag that we already started calculating even indices when it is 1

EveryTwo						;This loop iterates through the string and stores the sum of the integers into r2
	LDRB r1, [r10], #2			;Use register r1 as a buffer to store the byte that's currently pointed at by r10 then increment the pointer by 2 bytes
	AND r7, r1, #HexToDec		;Decode the byte in r1 from Hex to integer using the mask `HexToDec` and store the integer in r7
	ADD r2, r7					;Add the integer to our sum in r2
	
	CMP	r1, #0					;Test whether we have reached the end of the string (null character)
	BNE EveryTwo				;If we have not yet reached the end of the string, keep iterating through the string
	CMP	r0, #1					;If we got here, then we have reached the end of the string, test whether we already went through even indices by looking at the flag
	
	ADDNE r2, r2, LSL#1			;Multiply the first sum by 3 when we're done calculating it (left-logical shift by 1, then add it to itself)
	BNE	StartEven				;If we have not yet gone through the even indices, then go through them

GetRemainder					;This loop calculates the remainder of r2 when divided by 10
	CMP r2, #10					;Check whether the r2 is less than 10, if it is then we got the remainder
	SUBGE r2, #10				;If it is not less than 10, then subtract 10 from it
	BGE GetRemainder			;Keep doing this until we have a remainder

	CMP r2, #0					;If the sum is a multiple of 10 (remainder is 0), then the check digit is correct, and r0 is already set to 1, which is the correct output for the program
	MOVNE r0, #2				;If it is not a multiple of 10, then the check digit is incorrect, so adjust the output by making r0 equal to 2
	
STP	B STP						;Halt the program using infinite loop
	

UPC	DCB	"013800150738"			;UPC string
	
	END							;The program will end here