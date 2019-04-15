		AREA question2, CODE, READONLY
		ENTRY
		ADR 	r0, EOS						;loading blank space in r0
		ADR 	r1, PLDRM					;loading word into r1
		
		MOV		r2, #0						;setting up loop counter
LOOP 	LDRB	r3, [r1, r2] 				;fetching first letter of word 
		CMP 	r3, #122					;checking to see if letter is out of range from ascii letters
		BGT		NEXT						;branches if not a valid letter
		CMP		r3, #65						;checking if letter is out of range...
		BLT 	NEXT						;branches if out of range...
	
		CMP		r3, #91						;checking for lowercase numbers
		BLT		CONT						;continue if capital number
		SUB		r3, r3, #32					;change it to capital if it is lowercase
		
CONT	CMP		r3, #90						;checking out of bounds...
		BGT		NEXT
		MOV		r5, #0						;setting r5 to 0 to use as a counter for valid letters
		STRB  	r3, [r4, r5]                ;storing letters in r4 at index r5
        ADD     r5, r5, #1					;incrementing r5 by 1 to increase index
		
NEXT	ADD		r2, r2, #1					;incrementing word counter	
		LDRB	r6, [r1, r2]				;loads next letter in r6
        CMP		r6, #0x00					;compares next letter with empty string	
        BNE		LOOP                        ;loops
		MOV		r2, #0						;setting r2 as 0 for first letter
		
COMP	LDRB	r0, [r4, r2]				;fetching first letter to compare
		LDRB	r1, [r4, r5]				;fetching last letter to compare
		CMP 	r0, r1						;comparing to see if equal
		BNE		FAIL						;if they arent equal, fail
		ADD		r2, r2, #1					;incrementing r2 (first letter)
		CMP 	r2, r5						;comparing r2 and r5 to see if process is complete
		BEQ		DONE						;done if equal
		SUB		r5, r5, #1					;decrementing r5 (last letter)
		CMP 	r2, r5						;comparing r2 and r5 to see if process is complete
		BEQ		DONE						;done if equal
		B		COMP						;loop back if not done

DONE	MOV		r0, #1						;if successful, store 1 in r0
		B		BYE

FAIL	MOV 	r0, #2						;if not succesful, store 2 in r0

BYE
		AREA question2, DATA, READONLY
PLDRM 	DCB 	"madam"					    ;string
EOS 	DCB		0x00						;space for new string
		END