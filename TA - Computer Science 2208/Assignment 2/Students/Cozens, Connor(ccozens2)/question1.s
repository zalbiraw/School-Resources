	; -- Connor Cozens - 250902936 -- ;
		AREA 	assignment4q1, CODE, READONLY
		ENTRY
		ALIGN
	; -- Setup Function -- ;
setup	ADR		r0, 	STRING1			;Index for the front of string1
		ADR		r1, 	STRING2			;Index for the front of string2
		MOV		r3,		#0x74			;Register storing the hex value of 't'
		LDR		r4,		=0x746865		;Register storing the hex value of 'the'
	; -- Function that indexes through String1 -- ;
indexer	LDRB	r5,		[r0], #0x01		;Get the character currently at current index in string 1 and index it
		CMP		r5,		r3				;Check if the current character is equal to 't'
		STRNEB	r5, 	[r1], #0x01		;If the character isn't equal to 't' store value in string2 and increment the index
		BLEQ	check					;Branch with a link if they are equal
		CMP		r5, 	#0x00			;Check if the current character is the end of the string
		BNE		indexer					;Branch if not at the end
done	B		done					;To prevent errors
	; -- Function that checks values around a chosen index from the index function -- ;
check	MOV		r6,		r0				;store the counter in a temporary register
		LDRB	r7, 	[r6, #-0x02]!	;check the value at 2 before
		CMP		r7,		#0x20			;If the first location does not equal a ' '
		CMPNE	r7, 	#0x00
		BNE		endcheck				;Branch back to the beginning of the copy
		MOV		r8, 	#0x00			;Put 0 into register r8
		MOV		r9, 	#0x03			;Put 3 into register r9
	; -- Second part of the checking function to use to branch partially back -- ;
check2	LDRB	r7,		[r6, #0x01]!	;Load the next value into register r7
		ADD		r8, 	r7, r8, LSL #8	;Add the current value to the end of the string
		SUBS 	r9, 	r9, #0x01		;Subtract 1 from the counter and update the flags
		BNE		check2					;Branch if the new flag is false
		CMP		r8, 	r4				;Check if the string is equal to the string 'the' in hexadecimal
		BNE		endcheck				;If it's not equal then end the loop
		LDRB	r7, 	[r6, #0x01]!	;Increment and check the next character in thes tring
		CMP		r7, 	#0x00			;Check if the character is equal to the null character
		CMPNE	r7, 	#0x20			;Check if the character is equal to a ' '
		MOVEQ	r0, 	r6				;put the temp index back into the normal index if they're equal
	; -- To end the checking functions, if it isn't the letter t then store it in String2 and branch back to the linked branch -- ;
endcheck STRNEB	r3, 	[r1], #0x01		;store a byte into r3 if its not equal
		BX 		r14						;and branch back
				
		AREA 	assignment4q1, DATA, READWRITE
BoS		DCB		0x00
STRING1	DCB		"the the the"		;Test String
EoS		DCB		0x00
STRING2	space	0xFF				;Allocating 255 Bytes
	
		END