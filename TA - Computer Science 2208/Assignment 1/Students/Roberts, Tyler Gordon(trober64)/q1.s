		AREA q1, CODE, READONLY
		ENTRY
		LDR 	r0, =UPC 		;Load the UPC code in register r0
		MOV 	r1,#0 			;counter to go through bites of UPC
SUM
		LDRB 	r2,[r0,r1] 		;load byte from UPC (stored in r0) at counter r1
		SUB 	r2,r2,#48 		;change ASCII number in r2 to integer
		ADD 	r3,r3,r2 		;Add odd numbers 
		ADD 	r1,r1,#1 		;Increase counter by 1 for even sum
		CMP 	r1,#11 			;check to see if counter is at 11 (end of UPC)
		BEQ 	NEXT
	
		LDRB 	r4,[r0,r1] 		;load byte from UPC (stored in r0) at counter
		SUB 	r4,r4,#48 		;change ASCII number in r2 to integer
		ADD 	r5,r5,r4 		;Add even numbers 
		ADD 	r1,r1,#1 		;Increase counter by 1 for odd sum
		B 		SUM
	
NEXT
		ADD 	r3,r3,LSL #1 	;multiplies the odd sum by 3
		ADD 	r6,r5,r3 		;adds the even sum and the odd sum
		SUB 	r6,r6,#1 		;subtracts the total sum by 1
REMAINDER
		SUB 	r6,r6,#10 		;continually subtract 10 until total sum is eqaul to the remainder
		CMP 	r6,#10 			;check to see if total sum is equal to 10  
		BPL 	REMAINDER 		;loop back to remainder
		RSB 	r7,r6,#9 		;subtract the remainder from 9
CHECK
		LDRB 	r8,[r0,#11] 	;get the original check digit from the UPC
		SUB 	r8,r8,#48 		;change the ASCII number into an integer
		CMP 	r7,r8 			;check to see if calculated check digit is eqaul to original UPC check digit
		BEQ 	VALID 			;if they are equal then move to equal block
		MOV 	r0,#2 			;if they are not equal then move "2" into r0 and end the program
		B 		JUMP 			;jump to end of program
VALID
		MOV r0,#1 				;if they are eqaul, move "1" into r0 and end program
JUMP
		AREA q1, CODE, READONLY
UPC 	DCB 	"013800150739"	;UPC string
		END