		AREA question1, CODE, READONLY
		ENTRY
		
 		LDR r0, =UPC ;Load the upc code into r0
		MOV r1, #0 ;Initialize loop counter in r1
loop	LDRB r4, [r0,r1] ; Load the ith value of the UPC into r4
		SUB r4,#0x30 ; Subtract 0x30 from the value in r4 to convert from ascii
		CMP r1,#11 ; Check to see if r1 contains the last number of the UPC
		BEQ exit ; Leave loop if r1 contains the last number
		TST r1,#1 ;Check if the value in r1 is odd
		ADD r1,#1 ; Increment the loop counter stored in r1
		BNE odd ; If the value in r1 was odd branch to the odd section
		ADD r2,r4 ; Add the value in r4 to the even sum
		B loop ; Repeat loop
odd		ADD r3,r4 ; Add the value in r4 to the odd sum
		B loop ; Repeat loop
		
exit	ADD r2,r2,r2, LSL #1 ; Multiply the even sum by 3

		ADD r2,r2,r3 ; Add the two sums together
		
		SUB r2,r2,#1 ; Subtract 1 from the total
		
divide	SUBS r2,r2,#10 ; Repeatedly subtract 10 from the value in r2
		CMP r2,#10     ; Until the value is less then 10. 
		BGE divide	   ; This represents division
		
		RSB r5,r2,#9 ; Subtract the remainder value in r2 from 9 and store in r5
		SUBS r5,r5,r4 ; Subtract the last number in the UPC code from the value in r5
					  ; To check if they are equal
		BEQ valid ; If they are equal branch to valid
		MOV r0,#2 ; Store 2 in r0 indicating that the UPC is invalid
		B endless ; End the program
valid	MOV r0,#1 ; Store 1 in r0 indicating that the UPC is valid
endless	B endless
UPC		DCB "013800150738" ;UPC string
		END