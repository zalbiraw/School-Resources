		AREA	q2, CODE, READONLY
		ENTRY

		ADR		r0, Eos							;have register r0 to point to Eos's memory position
		ADR		r1, STRING						;loads the memory location of STRING into register r1 
		MOV		r2, #0x0						;transfers the value of EoS into register r2
REPEAT
		LDRB	r3, [r1, r4]					;loads a byte from the memory location stored in register r1 at pointer r4
		B		CHKLOWER						;branches to CHKLOWER
CHKLOWER	
		CMP		r3, #0x40						;checks if register r3's value is above the hexadicimal value 40, which equals to @
		BGT		CHKUPPER						;branches to CHKUPPER if value of register r3 is larger
		B		NEXT							;branches to NEXT if its smaller
CHKUPPER		
		CMP		r3, #0x7B						;checks if register r3's value is smaller than the hexadicimal value 7B, which equals to {
		BLT		CHECK1							;branches to CHECK1 if the value of r3 is smaller
		B		NEXT							;branches to NEXT if its larger
CHECK1
		CMP		r3, #0x5A						;checks if r3's value is larger or the same or smaller than 5A hexadicimal
		BGT		CHECK2							;branches to CHECK2 if it is larger
		BLE		CHANGE							;branches to CHANGE if it is smaller or the same
CHECK2
		CMP		r3, #0x61						;checks if register r3's value is larger, the same or smaller than 61 hexadicimal
		BGE		CHANGE							;branches to CHANGE if larger
		BLT		NEXT							;branches to NEXT if it is not
CHANGE
		CMP 	r3, #0x5B						;checks if the the value of register r3 is smaller than hexadecimal 5B
		ADDLT	r3, #0x20						;if yes, then add 20 hexadicimal to it which makes it lowercase
STORE
		STRB	r3, [r0, r5]					;stores the byte value into the location stored in register r0 and pointed by r5
		ADD		r5, r5, #1						;increments the pointer r5 by 1
NEXT
		ADD		r4, r4, #1						;incements the pointer r4 by 1
		LDRB	r6, [r1, r4]					;loads the next byte 
		CMP		r6, r2							;checks if the byte is equal to 0x00 (the same as Eos)
		BNE		REPEAT							;if it is not, then it will branch back to REPEAT
	
		MOV		r1, r5							;sets the value of register r1 to the value of register r5
		MOV		r2, #0							;sets the value of register r2 to 0
		SUB		r1, r1, #1						;decrement pointer r1 by 1
COUNT
		LDRB 	r3, [r0, r2]					;loads a byte from the location in register r0 pointer by r2
		LDRB	r4, [r0, r1]					;loads a byte from the location in register r0 pointer by r1
		ADD		r2, r2, #1						;increments the pointer r2
		SUB		r1, r1, #1						;decrements the pointer r1
		CMP		r3, r4							;checks if the bytes in r3 and r4 are the same
		BEQ		COUNTCHK						;if they are, it branches to COUNTCHK
		BNE		INVALID							;if they are not, it branches to INVALID
COUNTCHK
		CMP		r2, r1							;checks if the value of register r2 is less than r1
		BLT		COUNT							;if yes, it branches back to COUNT
		B		VALID							;if no, then it branches to VALID
INVALID
		MOV		r0, #1							;sets the value of register r0 to 1 if not a palindrome
		B		AREPEAT							;branches to AREPEAT
VALID	
		MOV		r0, #0							;sets the value of register r0 to 0 if a palindrome
AREPEAT	B		AREPEAT
		
		AREA 	q2, CODE, READONLY
STRING 	DCB 	"He lived as a devil, eh?"		;string
Eos		DCB		0x00							;end for new string
		END