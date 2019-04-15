		AREA q2, CODE, READWRITE
		ENTRY
		ADR r9, STRING ; Step 1: Read String to r9
		ADR r8, EoS ; Step 2: Read EoS to r8
		ADD r0, r0, #1 ; Step 3: Add 1 to r0 
Repeat	LDRB r1, [r9], #1 ; Step 4-5: Loop, read byte from r9 and load it into r1
		CMP r1, #0x00 ; Step 6: compare r1 to #0x00
		BEQ Park ; Step 6.1 If equal, go to Park
		CMP r1, #0x60 ; Step 7: Compare r1 to #0x60
		ADDLT r1, #0x20 ; Step 7.1: if less than, add #0x20
		CMP r1, #0x60 ; Step 8: Compare r1 to #0x60
		BLT Repeat ; Step 8.1: if less than loop to step 4: Loop
		CMP r1, #0x7A ; Step 9: Compare r1 to #0x7A
		BGT Repeat ; Step 9.1: if greater than go to step 4: loop
RepeaT	LDRB r2, [r8], #-1 ; Step 10-11: loop RepeaT, read end of string to r2
		CMP r2, #0x60 ; Step 12: compare r2 to #0x60 
		ADDLT r2, #0x20 ; Step 12.1: if less than add #0x20
		CMP r2, #0x60 ; Step 13: compare r2 to #0x60
		BLT RepeaT ; Step 13.1: if less than loop back to step 10
		CMP r2, #0x7A ; Step 14: compare r2 to #0x7a
		BGT RepeaT ; Step 14.1: if less than go to step 10
		CMP r1, r2 ; Step 15 compare r1 and r2
		ADDNE r0, r0, #2 ; step 15.1: if not equal, set validity counter to 2 (invalid)
		BEQ Repeat
Park	B Park ; Step 16: end
STRING  DCB "dodod" ;string
EoS     DCB 0x00 ;end of string 
		END