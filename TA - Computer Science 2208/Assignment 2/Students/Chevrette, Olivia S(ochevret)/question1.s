		AREA question1, CODE, READONLY
		ENTRY
		
			ADR	r0,STRING1					;set pointer to STRING1
			ADR	r1,STRING2					;set pointer to STRING2
			MOV	r3,#0						;set counter to 0
		
LOOP		LDRB r2,[r0],#1				;load value of first letter of string into r2
			CMP	r3,#0					;check if counter equals 0
			BEQ	SPCHECK					;if counter equals 0 branch to SPCHECK

			CMP	r3,#1					;check if counter equals 1
			BEQ	TCHECK					;if counter equals 0 branch to TCHECK

			CMP	r3,#2					;check if counter equals 2
			BEQ	HCHECK					;if counter equals 0 branch to HCHECK
		
			CMP	r3,#3					;check if counter equals 3
			BEQ	ECHECK					;if counter equals 0 branch to ECHECK
		
			CMP	r3,#4					;check if counter equals 4
			BEQ	SP2CHECK				;if counter equals 0 branch to SP2CHECK

		
SPCHECK		CMP	r2,#0x20				;check if character is a space
			ADDEQ r3,#1					;increment counter if character is space
			BEQ	COPY					;copy value if character is a space
										
			CMP	r2, #0x74				;if character is not a space
										;check if character equals "t"
			ADDEQ r3, #2				;increment counter by 2 if character equals "t"
			B COPY						;copy value
		
TCHECK		CMP	r2, #0x74				;check if character is "t"
			MOVNE r3, #0				;if character not a "t"
										;set counter to 0
			ADDEQ r3, #1				;if chatacter is a "t"
										;increment counter
			B COPY						
		
HCHECK		CMP	r2, #0x68				;check if character is "h"
			MOVNE r3, #0				;if character not an "h"
										;set counter to 0
			ADDEQ r3, #1				;if chatacter is a "t"
										;increment counter
			B COPY
		
ECHECK		CMP	r2, #0x65
			MOVNE r3, #0				;if character not an "e"
										;set counter to 0
			ADDEQ r3, #1				;if character is an "e"
										;increment counter
			B COPY
		
SP2CHECK	CMP	r2, #0x20				;check if character is a space
			CMPNE r2, #Eos				;if chacter not a space
										;check if it is the end of the string
			SUBEQ r1, #3				;if it is the end of the string
										;set pointer back by 3
										
			MOV	r3, #0					;set counter to 0
			B COPY
			
COPY		STRB r2,[r1],#1				;store value of pointed to by r1 in r2
			BNE	LOOP					;if not 0 go back to beginning of loop

;----------------------------------------------------------------
STRING1 	DCB 	"and the main said they must go"	;String1
EoS			DCB 	0x00								;end of string1
STRING2		space 	0xFF								;allocating 255 bytes
	
		END