	    AREA Pointers, CODE, READONLY
	    ENTRY		

		ADR    r1, STRING       ;r1 points to string
   	    ADR    r3, EoS          ;r3 points to end of string
		ADD    r3, #1		    ;r3 points to first open memory address		
		MOV    r4, r3
		LDRB   r2, [r1]         ;load r2 with first byte of string

LoopA	CMP    r2, #96          ;determine if the letter is lower case
		BGT    Lower		    ;translate to upper case
		
		CMP    r2, #64		    ;see if letter is valid
		BLS    Next			    ;skip if not a letter
		CMPGT  r2, #91			;make sure letter is valid
		STRBLT r2, [r3], #1		;store letter in memory
		B      Next				;go to next letter
		
Lower   CMP    r2, #123			;determine if letter is valid
		BHS    Next				;skip if not a letter
		SUBLT  r2, #32			;change to upper case
		STRBLT r2, [r3], #1		;store in memory
		B      Next				;go to next letter


Next   	LDRB   r2, [r1,#1]!		;store letters in r2
		CMP    r2, #0x00		;see if it's at string end
		BNE    LoopA			;continue loop if not at end
		SUBEQ  r3, #1			;r3 points to last letter
		BEQ    Comp				;check for palindrome
 
Comp	LDRB   r5, [r4]      	;first letter stored in r5
		LDRB   r6, [r3]			;last letter stored in r6
		CMP    r5, r6			;compare letters
		BNE    Store			;exit if not the same
		ADD    r4, #1			;move to next letter from left
		SUB    r3, #1			;move to next letter from right
		CMP    r3, r4			;compare addresses
		BGT    Comp				;continue loop if still in word
		B      Store			;exit when last index < first index

Store	CMP   r5, r6			;determine how the loop exited
		MOVEQ r0, #1			;store 1 for palindrome
		MOVNE r0, #2			;store 2 for not

STRING  DCB "He lived as a devil, eh?" ;string
EoS     DCB 0x00    		    ;end of string
		END
