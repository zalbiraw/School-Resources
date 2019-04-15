		AREA q_2, CODE, READONLY
		ENTRY
		ADR r0, STRING-1				;r0 points to STRING
		ADR r1, EoS					;r1 points to EoS string terminator
first		CMP r0, r1					;have the two sides gone too far passed each other
		BGT far						;if r0 is greater than r1 they have passed each other0
		LDRB r2, [r0, #1]!				;load the first character of the string into r2, then increment by 1 
		CMP r2, #65					;is the value less than that of a capital letter
		BLT first					;if less than zero then branch to first to get the next character
last		LDRB r3, [r1, #-1]!				;load the last character in the sting and r3, then decrement by 1
		CMP r3, #65					;is the value less than that of a capital letter
		BLT las						;if less than zero then branch to last to get the character to the left
		CMP r2, #97					;is the (first) letter lowercase
		ADDLT r2, #32					;change uppercase letter to lowercase
		CMP r3, #97					;is the (last) letter lowercase
		ADDLT r3, #32					;change uppercase letter to lowercase
		CMP r2, r3					;compare the first and last characters
		MOV r4, #1					;signify validity in r4, so if it holds true it can go into r0
		BEQ first					;compare the next two characters if the previous ones were the same
		MOV r4, #2					;signify non-validity in r4, so if it holds true, it can go into r0
far		CMP r4, #0					;compare with zero
		MOVNE r0, r4					;if the comparison does not equal 0, use valid code
		MOVEQ r0, #2					;if the comparison is equal to zero, set to non-validity
fi 		B fi						;finish
		AREA q_2, DATA, READWRITE
STRING 		DCB "He lived as a devil, eh?"			;string
EoS		DCB 0x00					;end of string
		END