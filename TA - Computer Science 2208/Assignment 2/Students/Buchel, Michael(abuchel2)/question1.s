					AREA assign3, CODE, READONLY ; Segment definer for code
					ENTRY ; Entry line
					
					; Initialization block
					LDR r0, = STRING1 ; Sets address for string 1 (line 1)
					LDR r11, = STRING2 ; Sets start address for string 2 (line 2)
					LDR r12,  = THE_WORD ; Checking constant (line 3)
					
					; End location calculation
					ADD r1, r11, #OFFSET ; Sets end address for string 1 (line 4)

					; Loop for code begin
loop				LDRB r2, [r0], #INC_SIZE ; Loads from and post increments r0 (line 5)

					; Fills word
					MOVS r4, r3, LSR #24 ; Gets the highest order byte from the saved word (line 6)
					ORR r3, r2, r3, LSL #8 ; Sets the lowest order byte of the saved word (line 7)
					
					; Store letter
					STRBNE r4, [r11], #INC_SIZE ; If the highest order byte is not 0, then save the highest order byte (line 8)
					
					; Compares word and erase if needed
					EOR r5, r3, r12 ; XORS with the checking constant (line 9)
					CMP r5, #CONTROL ; Checks if the output from the checking constant is less than or equal to 0x20 (line 10)
					CMPLS r4, #CONTROL ; If it is less than or equal to 0x20 then compare if the highest order byte is less than or equal to 0x20 (line 11)
					ANDLS r3, #LOWEST  ; If it is equal or less than, we erase all other characters from the word (line 12)
					
					; Loop for code end
					CMP r0, r1 ; Checks if we are out of bounds (line 13)
					BLO loop ; If r0 >= r1 then we break out of the loop (line 14)
					
					AREA assign3, DATA, READWRITE ; Segment definer for data
					
					; String 1
STRING1		DCB "and the man said they must go 1the the1 the the the"

					; End of string for string 1
EoS				DCB 0x00

					; Allocate string 2
STRING2		SPACE 0xFF
	
					; Definition, should not use EQU unfortunately it says we should use it,
					; even though EQU by default uses a 32 bit value and in a few cases like
					; in LSR #24 will create A1482E error
THE_WORD	EQU 0x74686500 ; same as "the"(null terminator) in hexadecimal
OFFSET		EQU 3 ; gets the real end of the string
INC_SIZE		EQU 1 ; value for post increments
CONTROL	EQU 0x20 ; last control value in the ascii table
LOWEST		EQU 0xFF ; keeps only the lowest order byte
					
					END ; end program