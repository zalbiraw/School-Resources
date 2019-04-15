		AREA ass3q2, CODE, READONLY
		ENTRY
		LDR r1,=STRING-1;r1 is set to 0 to be FoS (Front of String) pointer
		LDR r2,=EoS		;Load memory address into r2 to be EoS (End of String) pointer
		
CONTINUE

LEFT	LDRB r11,[r1,#1]!;Load the element from the front and post-increment FoS pointer (r11)
		CMP r11,#65		;Compare with the character 'A'
		BLT LEFT		;If it is less than 'A' than it is not a letter 'a-zA-Z' so get the next character ("LEFT")
		CMP r11,#97		;Compare with the character 'a'
		ADDLT r11,#32	;If it is a uppercase, convert to lowercase by adding 32
		CMP r11,#122	;Compare the value to 'z'
		BGT LEFT		;If it is greater than 'z' than it is not a letter 'a-zA-Z' so get the next character ("LEFT")

RIGHT	LDRB r12,[r2,#-1]!;Load the element from the end and post-decrement EoS pointer (r11)
		CMP r12,#65		;Compare with the character 'A'
		BLT RIGHT		;If it is less than 'A' than it is not a letter 'a-zA-Z' so get the next character ("RIGHT")
		CMP r12,#97		;Compare with the character 'a'
		ADDLT r12,#32	;If it is a uppercase, convert to lowercase by adding 32
		CMP r12,#122	;Compare the value to 'z'
		BGT RIGHT		;If it i s greater than 'z' than it is not a letter 'a-zA-Z' so get the next character ("RIGHT")

		CMP r11,r12		;Compare the character in r11 to the character in r12
		BNE INVALID		;If the two values are not equal then the string is invalid, immediatly go to the section marked "INVALID"	

		CMP r1,r2		;Compare the addresses of pointers r1 and r2
		BGT VALID		;If the address difference is greater than 0, then r1 and r2 have crossed paths and iterated thorught the entire string
		B   CONTINUE	;If the string has not had full iteration then (go to) "CONTINUE"

VALID	MOV r0,#1		;The string is a palindrome (valid), set r0 to 1
		B infini		;Skip the invalid section
		
INVALID	MOV r0,#2		;if the string is not a palindrome, set r0 to 2

infini	B infini		;infinte loop

		AREA ass3q2, DATA, READWRITE
STRING	DCB "He lived as a devil, eh?"	;string
EoS		DCB 0x00	;end of string
		; "He lived as a devil, eh?" - string test case 2 - true
		; "MADAM" - string test case 2 - true
		; "noon" - string test case 3 - true
		; "madam, I am Adam." - string test case 4 - false

		END		;end of program