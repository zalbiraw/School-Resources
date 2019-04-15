	AREA remove_the, CODE, READWRITE
	ENTRY

	LDR r0, = ST1							;load index of first char of string 1
	LDR r1, = ST2							;load index of first char of string 2
	
	LDR r3, =0x20746865						;store ' the'
	MOV r4, #0x20							;store ' ', needed because 'the' could be the first word
	
st	LDRB r2, [r0], #1						;start of loop: load in char, then move pointer
	STRB r2, [r1], #1						;store char, then move pointer
	
	CMP r2, #0								;check if at EOS
	BEQ lp									;if yes then exit the loop

	ADD r4, r2, r4, LSL #8					;slide the string of 4 chars over to the left and add new char
	CMP r3, r4								;check if the string is ' the'
	BNE st									;if not, then goto beginning of loop
	LDRB r2, [r0]							;if yes, then load in next char, don't update pointer
	CMP r2, #0								;check if EOS
	CMPGT r2, #32							;or if ' '
	BNE st									;if neither, then goto beginning of loop
	
	STRB r5, [r1, #-1]!						;if yes, then
	STRB r5, [r1, #-1]!						;remove 'the'
	STRB r5, [r1, #-1]!						;from string 2, and set pointer to the correct location
	
	B st									;goto beginning of loop
	
lp 	B lp									;exit point for loop, loops indefinitely
	
	AREA remove_the, DATA, READWRITE
	
ST1 DCB "the the   the 123    the" 			;String1
EOS DCB 0x00 								;end of string1
ST2 space 0xFF 								;just allocating 255 bytes
	
	END