			;CS2208 Assignment 4
			;question1
			;Nicholas Bzowski
			;
			;This is a program that will scan a given string and remove any
			;occurances of the word "the". The edited string will be saved 
			;in a different memory location, leaving the original unedited.
			
			AREA question1,CODE,READONLY
			ENTRY
		
			ADR r1,STRING1								;set up the pointer to the first string
			ADR r2,STRING2								;set up the pointer to the area of memory to be the second string
			LDRB r3,EoS									;load the "end of string" character
		
Loop		LDRB r4,[r1],#con1								;get the current character pointed at in the first string, then post-increment 
			
			STRB r4,[r2],#con1								;push the current character to the second string
		
			CMP r4,r3									;check if the current character is the "end of string" character
			BEQ Exit									;if it is, exit the loop
		
			ADD r5,r5,#con1								;increment the counter that tracks the sequential letters of "the"
		
CheckT		TEQ r5,#con1									;if the counter is 1, then
			CMPEQ r4,#t									;check if the current charater is 't'
			BEQ Loop									;if it is, move to the next character
		
CheckH		TEQ r5,#con2									;if the counter is 2, then
			CMPEQ r4,#h									;check if the current character is 'h'
			BEQ Loop									;if it is, move to the next character
		
CheckE		TEQ r5,#con3									;if the counter is 3, then
			CMPEQ r4,#e									;check if the current character is 'e'
			BEQ Loop									;if it is, move to the next character
		
LastCheck	TEQ r5,#con4									;if the counter if 4, then
			BEQ Final									;branch to the final check to see if the previous word is "the"
		
CheckWS		CMP r4,#WS									;check if the current character is space
			
			MOVNE r5,#-con1								;if it's not, set the counter to -1
			MOVEQ r5,#con0									;if it is, set the counter to zero
			B Loop										;move to the next character
		
Final		CMP r4,#WS									;for the final check, check if the current character is space
			SUBEQ r2,r2,#con4								;if it is, move back the pointer of the second string 4 places and
			SUBEQ r1,r1,#con1								;then move back the point of the first string one place
			MOV r5,#-con1									;set the counter to -1
			
			B Loop										;move to the next character
		
Exit		CMP r5,#con3									;check if the counter is at 3, indicating that the last word is "the"
			STRBEQ r3,[r2,#-con4]!							;if so, replace the 't' with the "end of string' character
		
infLoop		B infLoop									;infinite loop to terminate program execution
		
t			EQU 0x74									;t
h			EQU 0x68									;h
e			EQU 0x65									;e
WS			EQU 0x20									;space
	
con1		EQU 1										;constants
con2		EQU 2										;
con3		EQU 3										;
con4		EQU 4										;
con0		EQU 0										;
	
			ALIGN										;align string1 to 32-bit boundary
	
;Test		DCB "and the man said they must go"			;strings
STRING1		DCB "the the  the 123    the"				;
;Test		DCB	""										;
;Test		DCB "The"									;
;Test		DCB "them  the  the1"						;
;Test		DCB "the the the"							;

EoS			DCB 0x00									;end of string

			ALIGN										;align string2 to 32-bt boundary
			
STRING2		SPACE 0xFF									;allocating 255 bytes for string2
	
			END