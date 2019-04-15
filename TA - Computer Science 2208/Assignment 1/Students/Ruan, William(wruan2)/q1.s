		AREA   question1, CODE, READWRITE
		ENTRY
		
		LDR		r0, =UPC					;loads the memory location of UPC into register zero
		MOV		r1, #0						;loads the value 0 into register one
		MOV		r2, #1						;loads the value 1 into register two
		MOV 	r7, #0						;loads the value 0 into register seven, used as counter
		
LOOP
		LDRB	r3, [r0, r1]				;loads a byte from the memory location r0 at pointer r1 into r3
		LDRB	r4, [r0, r2]				;loads a byte from the memory location r0 at pointer r2 into r4
		
		SUB		r3, r3, #48					;changes the ASCII value of the byte to an integer
		SUB		r4, r4, #48					;changes the ASCII value of the byte to an integer
		
		ADD		r5, r5, r3					;adds r3 or the odd digits up
		ADD		r6, r6, r4					;adds r4 or the even digits up
		
		ADD		r1, r1, #2					;increments the pointer r1 by 2
		ADD		r2, r2, #2					;increments the pointer r2 by 2
		
		ADD		r7, r7, #1					;adds to counter
		CMP		r7, #6						;checks if we have stored 12 integers or length of UPC
		BNE		LOOP						;branches back to LOOP if UPC is not added fully
		
		MOV		r8, r4						;sets the check digit to r8 for future comparison
		ADD		r5, r5, LSL #1				;multiplies the r5 value by 3 by using a left logical shift
		
		SUB		r6, r6, r8					;subtracts the check digit from r6
		ADD		r1, r5, r6					;adds the odd numbers multiplied by 3 and the even numbers
		SUB		r1, r1, #1					;subtracts 1 from UPC
		
		B		DIV10						;branches to DIV10
		
DIV10
		SUB 	r1, r1, #10					;subtracts 10 from r1
		CMP		r1, #0						;if r1 is 0
		BGE		DIV10						;keeps looping until it is less than 0 to get remainder
		
		ADD		r1, r1, #1					;adds 1 which is equivalent to subtracting 9
		SUB		r1, r9, r1					;makes it positive
		
		B 		CHECK						;branches to check

CHECK
		CMP		r1, r8						;checks of the final value of r1 is equal to check digit
		BEQ		VALID						;branches to VALID if the final value is equal check digit which means that the UPC is valid
		BNE		NOTVALID					;else branches to NOTVALID
VALID	
		MOV		r0, #1						;sets the value of r0 to 1
		B		JUMP						;branches to JUMP
NOTVALID
		MOV		r0, #2						;sets the value of r0 to 2 if NOTVALID
		B		JUMP						;branches to JUMP
JUMP
	
		AREA    question1, DATA, READWRITE
UPC 	DCB 	"013800150738"				;UPC string
BLOOP 	B		BLOOP						
		END              					;end of program