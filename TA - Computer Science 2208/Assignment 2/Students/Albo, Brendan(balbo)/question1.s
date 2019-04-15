		AREA Question1, CODE, READWRITE
		ENTRY
		
		ADR r0, STRING2		;Load address of first block in register 0

		ADR r1, STRING1		;Load address of first string register 1
		ADR r2, EoS			;Load address of EoS register 0
		SUBS r2, r2, r1		;String 1 counter in register 2
		
		ADR r3, The			;Load address of second string in register 3
		ADR r4, EoS			;Load address of EoS in register 4

Compare	LDRB r5, [r1], #1	;Load next bit of String1 in register 5
		SUBS r2, r2, #1		;Decrease counter by value 1
		CMP r5, r3			;Check if bit is equal to String2
		BEQ Compare			;If yes, check next bit
		
		STRB r0, [r5], #1	;If no, store bit in register 0
		CMP r2, #0			;Check if bit is the last
		BNE Compare			;If no, check next bit
		
Finished B Finished			;If yes, finish


STRING1	DCB "and the man said they must go"	;String1
EoS		DCB 0x00			;End of String1
STRING2	space 0xFF			;Allocating 255 bytes
The		DCB "the"			;String to compare

		END