			AREA ques1, CODE, READONLY
			ENTRY
			
			ADR r0, STRING1 							;r0 is a pointer to the string
			ADR r1, STRING2 							;r1 is the address at the end of the string
			SUB r4, r1, r0 								;r1 is the length of the array
			
			
Loop		LDRB r2, [r0], #one							;loads character of string								
			CMP r3, #spc								;checks if character is space
			BEQ equal									;branch if equal 
			
notequal	STRB r2, [r1], #one							;writes the value of the string to the new string
			
equal 		LDRB r2, [r0], #one							;loads next character of string
			CMP r2, #t									;checks if character is t
			BNE notequal								;branches if not equal
			LDRB r2, [r0], #one							;loads next character of string
			CMP r2, #h									;checks if character is h
			BNE notequal								;branches if not equal
			LDRB r2, [r0], #one							;loads next character of string
			CMP r2, #e									;checks if character is e
			BNE notequal								;branches if not equal
			LDRB r2, [r0], #one							;loads next character of string
			BNE notequal								;branches if not equal
			
exit		B exit										;ends program
			
			
			
			AREA ques1, DATA, READWRITE
STRING1		DCB "and the man said they must go"			;string 1
EoS			DCB 0X00									;end of string 1
STRING2		space 0xFF									;just allocating 255 bytes
one			EQU 1										;sets label to value of 1
spc			EQU 0x20									;labels ASCII value of space
t			EQU 0x74									;labels ASCII value of t
h			EQU 0x68									;labels ASCII value of h
e			EQU 0x65									;labels ASCII value of e
			END