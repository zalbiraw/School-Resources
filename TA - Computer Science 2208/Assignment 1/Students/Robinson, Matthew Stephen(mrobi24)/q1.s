		AREA upc_codes, CODE, READWRITE
		ENTRY

		LDR r0, =UPC				;loads memory location of UPC into register zero
		MOV r1, #0					;loads the value 0 into register 1
		MOV r2, #1					;loads the value 1 into register 2

LOOP
		LDRB r3, [r0,r1]			;loads a byte from memory location r0 at pointer r1 into r3
		LDRB r4, [r0,r2]			;loads a byte from the memory location r0 at pointer r2 into r4

		SUB r3,r3,#48				;changes the ACSII value of the byte to an integer
		SUB r4,r4,#48				;changes the ACSII value of the byte to an integer

		ADD r5,r5,r3				;adds up the integers at odd indexes in the UPC code
		ADD r6,r6,r4				;adds up the integers at even indexes in the UPC code

		ADD r1,r1,#2				;increments the pointer r1 by 2
		ADD r2,r2,#2				;increments the pointer r2 by 2

		CMP r1,#12					;checks if r1 is equal to 12, meaning the UPC code has been searched entirely
		BNE LOOP					;returns to LOOP if r1 is not 12 yet

		ADD r5,r5,LSL#1				;multiplies the r5 value by 3 by using a left logical shift
		ADD r1,r5,r6				;adds the values stored in r5 and r6
		
MODULUS
		CMP r1,#9					;checks if r1 is equal to 9
		SUBGT r1,r1,#10				;subtract 10 from the value in r1 if r1 is greater than 9
		BGT	MODULUS					;if the value in r1 is greater than 10 return to MODULUS


		CMP r1,#0					;checks if the value in r1 is 0
		BNE INVALID					;if r1 does not equal 0 then branch to INVALID
		MOV r0, #1					;sets the value of r0 to 1
		B SKIP						;Branch to SKIP
	
INVALID
		MOV r0,#2					;sets the value of r0 to 2

SKIP
		AREA upc_codes, DATA, READWRITE
UPC 	DCB "013800150738", 0		;UPC code string
EoS		DCB	0x00					;end of string
		END							;end of program