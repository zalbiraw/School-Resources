;A program to determine whether a string of printable ASCII letters stored in memory is a palindrome
			AREA question2, CODE, READONLY
			ENTRY
		
			LDR		r0, =STRING					;Set r0 = String
			MOV		r1, #0						;Initialize r1 to 0
		
loopSize	LDRB	r2, [r0, r1]				;r2 = element pointed at by r0 and r1

STRING		DCB		"He lived as a devil, eh?"	;String
EoS			DCB		0x00						;End of string

			END