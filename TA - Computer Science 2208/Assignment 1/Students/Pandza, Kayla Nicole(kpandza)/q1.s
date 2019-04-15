		AREA question_one, CODE, READONLY
		ENTRY			
		ADR r0,UPC				; is the pointer pointing to the UPC code
Loop 	LDRB r4, [r0], #1		; read character by character
		SUB r4,r4,#0x30			; the character is converted to ASCII
		ADD r7,r7, r4			; the value of every evenly indexed number is added
		ADD r3,r3,#1			; the counter is increased, tracking what index number is being worked on
		CMP r3,#11				; if the 11th digit has been reached, the loop is exited
		BEQ Exit 				; the loop is exited if the 11th digit has been reached
		LDRB r4,[r0], #1		; read the next character in the UPC code
		SUB r4,r4,#0x30			; convert that character to ascii
		ADD r2,r2, r4			; accumulate the value of every odd digit
		ADD r3,r3,#1			; increase the counter
		B Loop					; unless another condition has been hit, loop
Exit	LDRB r3,[r0],#1			; the last character is read and stored for future usage
		SUB r3,r3,#0x30			; the character is converted to ascii
		ADD r7,r7,r7,LSL #1		; the first number, the sum of even indexed digits, is multiplied by three
		ADD r7,r7,r2			; the even and odd indexed numbers are then added together
		SUB r7,r7, #1			; one is subtracted to remain in accordance with UPC standards
Loop2 	MOV r2,r7				; a copy of this number is saved for future usage 
		SUB r7,r7,#10 			; ten is repeatedly subtracted from the number to access the remainder
		CMP r7,#9				; if the number is greater than nine, it loops again
		BGT Loop2				; checking if the result is greater than nine and looping accordingly 
		RSB r7,r7,#9			; subtracting the calculated remainder from nine to reach the final UPC digit
		CMP r7, r3				; compare the last digit of UPC with calculated digit
		BEQ IsValid				; if it is a valid UPC code the program branches to the proper place
		MOV r0,#2				; otherwise, 2 is stored in r0
		B Loop3					; looping to reach the end of the program
IsValid MOV r0,#1				; if the UPC is correct, 1 is stored into the register
Loop3 	B Loop3					; the loop to reach the end of the program
UPC		DCB "013800150738" 		; initializes the UPC code
		END						; the program terminates