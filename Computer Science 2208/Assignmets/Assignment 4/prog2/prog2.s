		AREA	prog2, CODE, READWRITE
		ENTRY

		ADR		r0, STRING2									;Identifies the pointer the free memory location			
		LDR		r1, =STRING1								;Loads the pointer of STRING1 to r1		 
		
		MOV		r7, #0x74									;Moves the value of the character "t" in hexadecimal into r7
		MOV		r8, #0x68									;Moves the value of the character "h" in hexadecimal into r8
		MOV		r9, #0x65									;Moves the value of the character "e" in hexadecimal into r9
LOOP
		LDRB	r3, [r1, r4]								;Loads a byte into r3 from the memory location appointed by r1 in position r4
		
T		CMP		r3, r7										;Checks if the value stored in r3 is "t"
		BNE		STORE										;If it is not then it branches to STORE
		
		CMP		r4, #0										;Checks if r4 contains 0
		BNE		CHECK										;If it does, then it branches to CHECK
		B		H											;Else it branches to H
		
CHECK														;Tests if the character previous to "t" is a space
		SUB		r11, r4, #1									;Subtracts 1 from the value of r4 and stores it into r11.
		LDRB	r10, [r1, r11]								;Loads a byte into r10 from the memory location appointed by r1 in position r11
		CMP		r10, #0x20									;Compares the value of r10 to 0x20, which is the equal to the character " " in hexadecimal
		BEQ		H											;If it is equal then branch to H
		B		STORE										;Else it branches to STORE

H		ADD		r4, r4, #1									;Increments r4.
		LDRB	r3, [r1, r4]								;Loads a byte into r3 from the memory location appointed by r1 in position r4
		
		BL		COM											;Branches to the compare function.
		
		CMP		r3, r8										;Compares r3 to r8, which contains the hexadecimal value of the character "h"
		BEQ		E											;If it is equal, branch to E
		STRB	r7, [r0, r5]								;Else store the byte containing the value of the character "t" in the memory
		ADD		r5, r5, #1									;Increments r5
		BNE		STORE										;If it is not then it branches to STORE

E		ADD		r4, r4, #1									;Increments r4.
		LDRB	r3, [r1, r4]								;Loads a byte into r3 from the memory location appointed by r1 in position r4
	
		BL		COM											;Branches to the compare function.

		CMP		r3, r9										;Compares r3 to r9, which contains the hexadecimal value of the character "e"
		BEQ		SN											;If it is equal, branch to SN
		STRB	r7, [r0, r5]								;Else store the byte containing the value of the character "t" in the memory
		ADD		r5, r5, #1									;Increments r5
		STRB	r8, [r0, r5]								;Store the byte containing the value of the character "h" in the memory
		ADD		r5, r5, #1									;Increments r5
		B		STORE										;If it is not then it branches to STORE

SN		ADD		r4, r4, #1									;Increments r4
		LDRB	r3, [r1, r4]								;Loads a byte into r3 from the memory location appointed by r1 in position r4
		CMP		r3, r2										;Compares the newly loaded byte to 0x00, null.
		BEQ		NUL											;If equal then, branch to NUL
		B		SPC											;Else branch to SPC

NUL		STRB	r3, [r0, r5]								;Stores the null value as the last character of the string.
		B		DONE										;Ends the program
		
SPC		CMP		r3, #0x20									;Checks if the content of r3 is the character " "
		BEQ		STORE										;If it is then it branches to STORE
		STRB	r7, [r0, r5]								;Stores the byte containing the value of the character "t" in the memory
		ADD		r5, r5, #1									;Increments r5
		STRB	r8, [r0, r5]								;Stores the byte containing the value of the character "h" in the memory
		ADD		r5, r5, #1									;Increments r5
		STRB	r9, [r0, r5]								;Stores the byte containing the value of the character "e" in the memory
		ADD		r5, r5, #1									;Increments r5	
				
STORE	STRB	r3, [r0, r5]								;Stores a the byte contained in r3 into r0
		ADD		r5, r5, #1									;Increments r5
		
NEXT	ADD		r4, r4, #1									;Increments r4		
		LDRB	r6, [r1, r4]								;Loads a byte into r6 from the memory location appointed by r1 in position r4					
		CMP		r6, r2										;Compares r6 to  r2, which contains the hexadecimal value 0x0, which equals to the character "null"		
		BNE		LOOP										;If it is not then keep looping.						
		
DONE	STRB	r2, [r0, r5]								;Stores a the byte contained in r2, "null", into r0

ILOOP	B		ILOOP

COM		CMP		r3, r2										;Compares the newly loaded byte to 0x00, null.
		BEQ		DONE										;Ends the program
		MOV		PC, lr										;Branches back to where it was called from.
		
		AREA 	prog2, DATA, READWRITE
STRING1 DCB 	"their and they said another the clothe those the th t the"	 			;String1 
EoS 	DCB 	0x00										;end of string1 
		align
STRING2 space 	0xFF
		END