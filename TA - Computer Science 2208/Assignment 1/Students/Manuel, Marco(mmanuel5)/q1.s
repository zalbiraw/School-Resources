		AREA q1, CODE, READWRITE
		ENTRY
		mov r7, #11 ; Step 1: Set register 7 to value 11 to see if 11 digits have been counted
		ADR r9, UPC ; Step 2: load register 9 with the UPC string
Repeat	LDRB r6, [r9], #1 ; Step 3-4: LOOP Repeat, load register 6 with first byte of r9
		SUB r6, r6, #0x30 ; Step 5: subtract register 6 by #0x30 to get the actual value
		CMP r3, r4 ; Step 6: Compare register 3 and 4 to see how many odd or even values have been counted
		ADDEQ r1, r6 ; SubStep 6.1.1: Add the value of register 6 to register 1 (odd value holder)
		ADDEQ r3, #1 ; SubStep 6.1.2: add the value 1 to register 3 (odd counter)
		ADDNE r2, r6 ; Substep 6.2.1: add the value of register 6 to register 1 (even value holder) 
		ADDNE r4, #1 ; Substep 6.2.2: add the value 1 to register 4 (even counter) 
		ADD r7, r3, r4 ; Step 7: add register 3 and 4 together and save it in register 7 ( counter holder) 
		CMP r7, #11 ; Step 8: compare register 7 the the value 11 to see if the program has read 11 digits
		BLT Repeat ; Substep 8.1.1: if the value is less than 11, it means 11 digits have not been read, loop back to Step 3: Repeat
		ADD r1, r1, r1, LSL #1 ; Step 9: multiply the value of r1 by 2, add it to the value of r1 and save the value to r1
		ADD r1, r1, r2 ; Step 10: add the value of r2 to r1
		SUB r1, #1 ; Step 11: subtract r1 by 1 
RepeaT	SUB r1, #10 ; Step 11-12: LOOP RepeaT, subtract r1 by 10
		CMP r1, #10 ; Step 13: Compare r1 to the value 10
		BGT RepeaT ; Substep 13.1.1: if r1 is greater than 10, go back to Step 11: Loop RepeaT
		RSB r2, r1, #9 ; Step 14: Subtract 9 by the value of r1 and save it to r2
		LDRB r6, [r9], #1 ; Step 15: read the byte in r9 and save it in r6
		SUB r6, r6, #0x30 ; Step 16: subtract r6 by #0x30 making it a regular value
		CMP r2, r6 ; Step 17: Compare r2 and r6
		MOVEQ r0, #1 ; Substep 17.1.1: If equal, set r0 the validity checker to 1
		MOVNE r0, #2 ; Substep 17.1.2: If not equal, set r0 the validity checker to 2
Park	B Park ; Step 18: End 
UPC		DCB "060383755577"
		END