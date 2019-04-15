		AREA palindrome, CODE, READWRITE
		ENTRY
			
		ADR r0, EoS				;loads memory location of EoS into r0
		ADR r1, STRING			;loads memory location of STRING into r1
			
		MOV	r2, #0x0			;moves the value of EoS into r2
			
LOOP
		LDRB r3, [r1,r4]		;loads a byte from the memory location stored in r1 at pointer r4
		
		CMP r3, #0x40			;checks if the value stored in r3 is greater than the hexadecimal value 40 which equals A
		BLE NEXT				;branches to NEXT if less than or equal to
		
		CMP r3, #0x7B			;checks if the value stored in r3 is less than the hexadecimal value 7B which equals (
		BGE NEXT				;branches to NEXT is greater than or equal to
		
		CMP r3, #0x5A			;checks if the value stored in r3 is greater than the hexadecimal value 5A
		BLE CNVRT				;branches to CNVRT if less than or equal to
		
		CMP r3, #0x61			;checks if the value stored in r3 is greater than the hexadecimal value 61
		BLT NEXT				;branches to NEXT is less than
		
CNVRT
		CMP r3, #0x5B			;checks if the value of r3 is less than 5B
		ADDLT r3, #0x20			;if less than 5B, adds 20 hexadecimal to it and makes it lowercase

		STRB r3, [r0,r5]		;stores the byte value into the location stored in r0 and pointer by r5
		ADD r5,r5, #1			;increments the pointer r5
		
NEXT
		ADD r4,r4, #1			;increments the pointer r4
		LDRB r6, [r1,r4]		;loads then next byte
		CMP r6,r2				;checks if the byte is equal to 0x00, the end of the string
		BNE LOOP				;returns to LOOP if the end of the string has not yet been reached
		
		MOV r1,r5				;sets the value of r1 to the value of r5
		MOV r2,	#0				;sets the value of r2 to 0
		SUB r1,r1, #1			;decrements the pointer r1
		
CALC
		LDRB r3, [r0,r2]		;loads a byte from the location in r0 pointer by r2
		LDRB r4, [r0,r1]		;loads a byte from the location in r0 pointer by r1
		
		ADD r2,r2, #1			;increments the pointer r2
		SUB r1,r1, #1			;decrements the pointer r1
		
		CMP r3,r4				;checks if r3 and r4 are equal
		BNE INVALID				;if r3 and r4 are not equal branch to INVALID
		
		CMP r2,r1				;checks if the value of r2 is less than that of r1
		BLT CALC				;if less than return to CALC
		B PASS					;otherwise branch to PASS
		
INVALID
		MOV r0, #2				;sets r0 to the value 2
		B SKIP					;branch to SKIP
		
PASS
		MOV r0, #1				;sets r0 to the value 1

SKIP
		AREA palindrome, DATA, READWRITE
STRING	DCB	"madam", 0			;string
EoS		DCB	0x00				;end of string
		END