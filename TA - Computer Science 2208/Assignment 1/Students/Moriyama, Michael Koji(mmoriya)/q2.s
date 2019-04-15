		AREA q2, CODE, READONLY
		ENTRY
		ADR		r9, STRING									;load the string into the r9 register to be parsed later on
		MOV		r1, #1										;create a counter in the form of r1 and set it to 1
loopbeg	LDRB 	r4, [r9, r1]								;load first letter into r4
		ADD		r1, r1, #1									;increment the counter r1
		CMP		r4, #122									;here we check if it is not a capital letter, in ASCII >122 are symbols
		BGT		nextnum										;then check if it is a lowercase letter
		CMP 	r4, #97										;compare against the boundary of lowercase letters in ASCII
		BLT 	nextnum										;again we send it if it is less than we send it to nextnum
		SUB		r4, r4, #32									;if it does happen to be uppercase then we can make it lowercase
nextnum	CMP		r4, #65										;if it is not a lowercase letter, in ASCII <65 are non letters
		BLT		loopbeg										;we want to send it back to the loop to be iterated again
		CMP		r4, #90										;want to check if it is a symbol represented between 91-96 in ASCII
		BGT		loopbeg										;then it is a symbol so send back to the loop
		
		MOV		r2, r1										;since r1 stores the total amount of increments, it is essentially the string length, which we store in r2
loopend	LDRB	r3, [r9, r2]								;so here we work backwards by starting at the last character and storing that in r3
		SUB		r2, r2, #1									;decrement the counter r2 so we can work backwards
		CMP		r3, #122									;here we check if it is not a capital letter using the ASCII boundary
		BGT		next										;then check if it is a lowercase letter
		CMP 	r3, #97										;compare against the boundary of lowercase letters
		BLT 	next										;again we send it if it is less than we send it to next
		SUB		r3, r3, #32									;if it does happen to be uppercase then we can make it lowercase
next	CMP		r3, #65										;if it is not a lowercase letter
		BLT		loopend										;we want to send it back to the loop to be iterated again
		CMP		r3, #90										;want to check if it is a symbol represented between 91-96 in ASCII
		BGT		loopend										;then it is a symbol so send back to the loop
		
check	CMP		r3, r4										;compares the regular string to the reversed string														
		MOVEQ	r0, #1										;if they are equal then store 1 in r0
invalid	MOV		r0, #2										;ELSE store 2 in r0
		BNE 	invalid
		
STRING	DCB	"He lived as a devil, eh?"						;string
EOS		DCB	0x00											;end of string 
		END