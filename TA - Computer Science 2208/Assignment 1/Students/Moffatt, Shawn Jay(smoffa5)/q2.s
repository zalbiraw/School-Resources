		AREA mySecondQuestion, CODE, READONLY
		ENTRY
Start	ADR 	r1,STRING					;Stores the pointer representing the beginning of the string in r1
		ADR 	r2,EoS-1					;Stores the pointer representing the end of the string in r2

Loop	LDRB	r3,[r1],#1					;loads the current left character
		CMP 	r3,#97						;checks if the left character is lower case or higher according to ascii
		SUBGE	r3,#32						;subtracts 32 to convert to upper case when it is a letter, and to puncuation when it is not a letter
		CMP		r3,#91						;checks if the character is a symbol
		BGE		Loop						;restarts the loop
		CMP		r3,#65						;checks if the character is a symbol
		BLT		Loop						;restarts the loop
		B		Loop2						;starts the next loop
		
Loop2	LDRB	r4,[r2],#-1					;loads the current right character
		CMP		r4,#97						;checks if the right character is lower case or higher according to ascii
		SUBGE	r4,#32						;subtracts 32 to convert to upper case when it is a letter, and to puncuation when it is not a letter
		CMP 	r4,#91						;checks if the character is a symbol
		BGE		Loop2						;restarts the loop
		CMP		r4,#65						;checks if the character is a symbol
		BLT		Loop2						;restarts the loop
		B		Test						;sends the program to the test portion
		
Test	CMP		r1,r2						;checks if the left and right pointer addresses have surpassed each other
		BGT		PASS						;ends program with success
		CMP		r3,r4						;checks if the left character and right character equal 
		BEQ		Loop						;starts the fisrt loop to get new characters
		B		FAIL						;ends program with failure

PASS	MOV		r0,#1						;signals success
		B		EndLoop						;calls endless loop to finish program
FAIL	MOV		r0,#2						;signals failure

EndLoop	B	EndLoop							;end of program

STRING 	DCB 	"He lived as a devil, eh?"		;string
EoS		DCB		0x00						;end of string
		END