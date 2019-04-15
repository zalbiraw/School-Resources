			AREA trans, CODE, READWRITE
			ENTRY
			ADR r1, STRING1 ;get the address of initial string and string to be stored
			ADR r0, STRING2
			LDRB r2,[r1,r9] ;load the first char before looping
			CMP r2, #"t" ;check if the first char is 't'
			BEQ checkB ;if it is 't' then check if it follows 'h','e' and space
			B    loop
			
			;this loop would check chars that follow the 't'
checkB		ADD  r8,r9,#1 ;get a new pointer pointing to next char
			LDRB r3,[r1,r8]; get char
			CMP  r3, #"h" ; check if it is h
			ADDEQ r8,r8,#1 ; if it is h then check if 'e' follows
			LDRB r3,[r1,r8]
			CMP  r3, #"e" ;if 'e' follows h then check if space follows
			ADDEQ r8,r8,#1
			LDRB r3,[r1,r8]
			CMP  r3,#0x20
			MOVEQ r9,r8 ;if the word is the then move the main pointer to space to skip 'the'
			LDRBNE r3, [r1,r9] ;if the last char is not space then restore r3 to get initial 't'
			B    loop
			
			;this loop check char that are before t
checkF      SUB r8,r9,#1 ;get the address that before 't'
			LDRB r4,[r1,r8];get char
			CMP  r4,#0x20 ; check if it is a space to make sure if it is a whole word starts with t
			BEQ  checkB ;if it is then check the rest of chars

			;mian loop will store all valid chars into specific address and increment pointer
loop		STRB r3,[r0],#1 ;store current char into address r0
			ADD  r9,r9,#1 ;increment pointer to get the next char
			LDRB r3, [r1, r9] ;
			CMP r3, #"t" ;check if the char is t
			BEQ  checkF ;if it is then check the front 
			CMP  r3, #0x00 ; if it is end of string then end ,if not then continue looping
			BNE loop
Loop		B  Loop
STRING1 	DCB "the them athe"
Eos    	    DCB  0x00
STRING2 	space 0xFF
			END