		AREA	pal, CODE, READONLY
		ENTRY

OK		EQU		1				;successful return code
FAIL	EQU		2				;failure return code

main	MOV		r0,#OK			;initialize result to success
		ADR		r1,PAL			;reg r1 points at start of palindrome string
		ADR		r2,EoS			;reg r2 temporarily points to last character (null is ok since it is ignored)

First	CMP		r1,r2			;scan first forwards until readable character or first > last
		BGE		EoP				;  no unmatched characters, so is a palindrome

		LDRB	r3,[r1],#1		;  load 1st character to r3 and post increment 1st pointer
		ORR     r3,r3,#0x0020	;  convert to lower case, regardless

		CMP		r3,#'a'   		;  compare read character to 'a'
        RSBGTS 	r5,r3,#'z' 		;  compare read character to 'z'
		BLT		First			;  if char < 'a' or char > 'z', i.e., not a letter, loop back to First
								;  we now have the 1st letter

Last	CMP		r1,r2			;  scan first forwards until readable character or first > last
		BGE		EoP				;  no unmatched characters, so is a palindrome

		LDRB	r4,[r2,#-1]!	;  load last character to r4 and post decrement last pointer
		ORR     r4,r4,#0x0020	;  convert to lower case, regardless

		CMP		r4,#'a' 		;  compare last character to 'a'
		RSBGTS 	r5,r4,#'z' 		;  compare read character to 'z'
		BLT		Last			;  if char < 'a' or char > 'z', i.e., not a letter, loop back to Last
								;  we now have the last letter

CmpChar	CMP		r3,r4			;compare letters
		BEQ		First			;get next set of letters - if matched
		MOV		r0,#FAIL		;if different set result to fail and end program
								
EoP		B		EoP				;infinite end-of-program loop

		AREA	pal, DATA, READONLY
PAL		DCB	"He lived as a devil, eh?"	;Palindrome string
EoS		DCB	0x00						;End of string - REQUIRED!
		END