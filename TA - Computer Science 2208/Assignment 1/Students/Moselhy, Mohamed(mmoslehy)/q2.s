								;This program will check whether a string stored in memory is a case/special-character-insensitive palindrome
	AREA A3q2, CODE, READONLY	;Header line to specify program name
	ENTRY						;The program will start here

LowBounds		EQU 'a'			;A byte with a value lower than this is not a lowercase letter
UpBounds		EQU 'z'			;A byte with a value higher than this is not a letter
ToLower			EQU	0x20		;A lowercase letter always has 1 in the 6th bit
	
Start
	LDR r1, =STRING				;Let r1 store a pointer to the start of the string address
	LDR r2, =EoS				;Let r2 store a pointer to the end of the string address
	
FromStart						;This loop keeps going until a valid letter byte is stored into the buffer r11
	LDRB r11, [r1], #1			;Let r11 be our buffer register from the start and load the first byte of the string into it (in the first iteration), then increment the pointer by 1 byte
	ORR r11, r11, #ToLower		;Convert it to lowercase format using the mask `ToLower` (make the 6th bit a `1`)
	
	CMP r11, #LowBounds         ;Check whether this byte is not a letter (it is less than `a`)
	BLT FromStart               ;If not, then repeat the loop
	
	CMP r11, #UpBounds			;Check whether this byte is not a letter (it is greater than `z`)
	BGT FromStart				;If not, then repeat the loop

FromEnd							;This loop keeps going until a valid letter byte is stored into the buffer r12
	LDRB r12, [r2], #-1			;Let r12 be our buffer register from the end and load the last byte of the string into it (in the first iteration), then decrement the pointer by 1 byte
	ORR r12, r12, #ToLower		;Convert it to lowercase format using the mask `ToLower` (make the 6th bit a `1`)
	
	CMP r12, #LowBounds         ;Check whether this byte is not a letter (it is less than `a`)
	BLT FromEnd                 ;If not, then repeat the loop
	
	CMP r12, #UpBounds			;Check whether this byte is not a letter (it is greater than `z`)
	BGT FromEnd					;If not, then repeat the loop

Compare							;This loop compares the characters of the two buffer registers and checks whether it is a palindrome so far
	CMP r11, r12				;Compare the characters of both buffers (one from each end)
	MOVNE r0, #2				;If they are not equal, then we do not have a palindrome, and the correct output is to store 2 in r0
LOS	BNE LOS						;If we do not have a palindrome, end the program using an infinite loop

	CMP r1, r2					;If we got to this point then they are equal, and we should check whether our pointers crossed (all ends were checked)
	MOVGE r0, #1				;If our pointers crossed (if the left pointer is now on the right and vice versa), then we have a palindrome since all the bytes were equal at each end, and our correct output is 1 in r0
WIN	BGE	WIN						;Stop the program with an infinite loop

	BLT FromStart				;If our pointers have not yet crossed, then keep setting and comparing the buffers until they have crossed or we have a mismatch


STRING	DCB "He lived as a devil, eh?" 	;string
EoS		DCB 0x00 						;end of string
	
	END									;The program will end here