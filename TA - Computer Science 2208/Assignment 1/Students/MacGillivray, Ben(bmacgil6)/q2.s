	AREA Question2, CODE, READONLY
		ENTRY
		ADR     r1, word     ;add the given palendrome to r0
		ADR		r2, eos -1   ;add the end of string character
lop		CMP     r1, r2	 	 ;compare the adress of the first and last letter
		BGE 	pass		 ;true, is palendrome
		CMPNE	r3, r4		 ;flase, compare the values of the letters at r1 and r0
		MOVNE   r0, #2		 ;fail case 
		BNE		fail		 ;move to the end of th program
l3		LDRB    r3, [r1], #1 ;load the character from the front into r3
		CMP 	r3, #65		 ;if the register isnt a letter 
		BLT		l3			 ;load another character
		CMP 	r3, #97		 ;test if character is lower case or punctuation
		SUBGE	r3, #32      ;if it is lower case ocnvert to upper case
		CMP		r3, #91		 ;test if the number is stil greater than 91 therfor it is punctuation
		BGE		l3			 ;if it is punctuation return to top to load another character
l4		LDRB	r4, [r2], #-1;load the character from the back into r4
		CMP 	r4, #65 	 ;if the register isnt a letter
		BLT		l4			 ;load another character
		CMP 	r4, #97		 ;test if character is lower case or punctuation
		SUBGE	r4, #32      ;if it is lower case ocnvert to upper case
		CMP		r4, #91		 ;test if the number is stil greater than 91 therfor it is punctuation
		BGE		l4			 ;if it is punctuation return to top to load another character

		B lop				 ;return to the beginning of the loop
pass	mov r0, #1			 ;
fail	
word	DCB "Bitchass"
eos		DCB 0x00
		END