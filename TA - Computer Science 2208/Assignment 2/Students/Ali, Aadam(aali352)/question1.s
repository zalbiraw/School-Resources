		AREA removeThe, CODE, READONLY
		ENTRY
		
		ADR r0, STRING1 ;This loads the address of String 1 into r0 in order to access what is stored (bitwise) in the strings
		ADR r1, STRING2 ;This loads a space into r1 to be used later on
		MOV r2, r0      ;This is used as a pointer to the first bit 
		
loop    LDRB r4, [r0], #1 ;This is used to increment in order to move to the next bit
		CMP r4, #0x00     ;Compares to see if the first bit is null
		BEQ  inf  		  ;If it is null go to infinite loop
		CMP r4, #'t'      ;Check to see if the first bit is t
		BLEQ func         ;If it is equal branch link to the subroutine to check other letters
		STRB r4,[r1],#1   ;If it is not 't' store the bit in increment
		b loop			  ;Repeat this subroutine
		
inf		
		B inf ;Infinite loop for debugging  

func    LDRB r5, [r0] ;Load the second bit after post increment that is checked
		CMP r5, #'h'  ;Compare to see if it is equal to 'h'
		MOVNE pc,lr   ;If it is not equal move lr to pc in order to move on
		LDRB r5, [r0, #1] ;If it is equal to 'h' the check the bit after without incrementing
		CMP r5, #'e'	  ;Compare to see if it is equal to the letter 'e'
		MOVNE pc,lr       ;If it is not equal move lr to pc in order to move on
		LDRB r5, [r0, #2] ;If it is equal to 'e' then check the position after that 
		CMP r5, #0x20     ;See if it is a space
		CMPNE r5, #0x00	  ;If it is not a space check to see if it is null	
		MOVNE pc,lr       ;If it is not equal move lr to pc in order to move on
		LDRB r5, [r0, #-2];Now check before the first bit 
		CMP r5, #0x20     ;Check if it is a space
		CMPNE r5, #0x00   ;If not a space check if null
		MOVNE pc,lr       ;If it is not equal move lr to pc in order to move on
		ADD	r0,r0,#2      ;Skip if all conditions met 
		B loop            ;Go back to the first loop 
		

		AREA removeThe, DATA, READWRITE
		ALIGN
SoS 	DCB 0x00  ;Makes sure the start of the string is null
STRING1 DCB "the the the 123 the" ;String1
EoS 	DCB 0x00 ;end of string1
		ALIGN
STRING2 space 0xFF ;just allocating 255 bytes 
	
		END