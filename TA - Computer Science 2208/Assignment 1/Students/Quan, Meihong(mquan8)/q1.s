;A Program to compute the check digit
		AREA question1, CODE, READONLY
		ENTRY
		
Start 	ADR 	r0, UPC				;Load the UPC string to register r0
		MOV 	r4, #6				;Initialize r4, the loop counter to 6
		MOV		r1, #0				;Initialize r1 to 0
		
Loop	LDRB	r3, [r0]			;r3 = element pointed at by r0
		SUBS	r3, r3, #30			;Subtract value from ASCII values
		ADD 	r0, r0, #2			;Point to the next element
		ADD 	r1, r1, r3			;Add the next number to r1
		SUBS	r4, r4, #1			;Decrease the loop counter
		BNE		Loop				;Loop until all elements added, and r3 is the second sum

		SUB		r2, #1				;Subtract r2 by 1
MOD		SUBS	r2, #10				;Subtract r2 by 10
		CMP		r2, #10				;Compare r2 with 10
		BGT		MOD					;Repeat the subtraction if r2 is greater than 10
		
		RSB		r2, r2, #9			;9 subtract remainder, r2
		LDRB 	r1, [r0], #1		;Load the last element in UPC
		SUB		r1, #0x30			;Get an integer
		MOV		r0, #1				;Load value 1 into register 0, and assume UPC is valid

		CMP 	r2, r1				;Compare the last element in r1 with the value in r2
		BEQ 	EXIT				;If two value matches, end it
		MOV		r0, #2				;If not, load value 2 to register 0, which means the UPS in valid
EXIT
loop	b		loop				;infinite loop

UPC		DCB 	"013800150738"		;UPC string

		END