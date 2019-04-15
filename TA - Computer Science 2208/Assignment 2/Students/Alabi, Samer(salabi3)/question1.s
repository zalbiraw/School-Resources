			AREA theRemover, CODE, READWRITE
			ENTRY	
spaceCode	EQU		32									;represents the space ascii code
nullCode	EQU		0									;represents the null ascii code
	
start
	 		ADR		r0,STRING1							;move register 0 to the address of the first character of STRING1
			ADR		r12,STRING2							;love start of second string into register 12
edit
			LDRB	r3,[r0],#1							;load a byte from STRING1
			CMP		r3,#nullCode						;check if the pointer is at the end of string
			BEQ		finish								;IF at the end of string, end the program
			CMP		r3,#'t'								;check if the current byte is a space character
			BLEQ	check								;IF it is a space character, check if the word is the word 'the'
			STRBNE	r3,[r12],#1							;IF character is not part of the word 'the', store the byte
			B		edit								;LOOP back to branch until end of string
check		
			LDRB	r2,[r0,#-2]							;load byte at current pointer position
			CMP 	r2,#spaceCode						;check if the byte is the character 't'
			CMPNE	r2,#nullCode						;IF not space, check if at the beginning of the string
			LDRBEQ	r2,[r0]								;IF character = space or null, load byte at the current pointer position
			CMPEQ	r2,#'h'								;IF character = space or null, check if the byte is the character 'h'
			LDRBEQ	r2,[r0,#1]							;IF character = 'h', load byte at pointer position + 1
			CMPEQ	r2,#'e'								;IF character = 'h', check if the byte is the character 'e'
			LDRBEQ	r2,[r0,#2]							;IF character = 'e', load byte at pointer position + 2
			CMPEQ	r2,#spaceCode						;IF character = 'e', check if character is a space character
			CMPNE	r2,#nullCode						;IF not space, check if at the end of string
			ADDEQ	r0,r0,#2							;IF the word 'the' is detected, jump the pointer by 2 memory locations to avoid storing 'the'
			BX		LR									;branch back to calling routine	
finish		
			B		finish								;infinite debugging loop
			
			AREA theRemover, DATA, READONLY
			ALIGN
SoS			DCB		0x00								;start of string1
STRING1 	DCB 	" the    the   they must go the" 	;String1
EoS 		DCB 	0x00 								;end of string1
			ALIGN
STRING2 	space	0xFF 								;just allocating 255 bytes 
			
			END
				