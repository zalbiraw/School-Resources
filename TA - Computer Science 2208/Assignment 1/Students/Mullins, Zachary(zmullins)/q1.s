	AREA Assign3Q1, CODE, READONLY
	ENTRY
start	ADR r2,UPC 		;Make r2 a reference to the start of the UPC
	MOV r1,#6 			;There are 6 numbers added up in the Odd section, this counts down
	MOV r4,#0 			;Ensure empty sum area
odd	LDRB r3,[r2],#2		;Save the val r2 is pointing to r3 and move it up 2 bytes to get to next odd position number
	SUBS r3,r3,#48 		;Subtract r3 by dec 48 to get the actual numerical val from ascii
	ADD r4,r4,r3 		;Sum current odd upc number and the running total
	SUBS r1,r1,#1 		;Subtract 1 from counter
	BNE odd 			;loop until counter is done
	ADR r2,UPC 			;Start r2 back at start of UPC code
	ADD r2,r2,#1 		;Move onto even numbers of UPC code (2,4,6,8)
	MOV r5, #0 			;Set the second sum area to 0
	MOV r1, #5 			;Set count to 5 (5 even numbs)
even	LDRB r3,[r2],#2 ;Save val r2 is pointing at to r3 and move forward 2 bytes to get next even position number
	SUBS r3,r3,#48 		;Subtract r3 by dec 48 to get the actual numerical val from ASCII
	ADD r5,r5,r3 		;Add 3 to running sum
	SUBS r1,r1,#1 		;Subract 1 from counter
	BNE even 			;loop until counter reaches 0
ad  LSL r7,r4,#1 		;Multiply 1st sum by 2
	ADD r4,r4,r7 		;Multiply 1st sum by 3 (sum*2+sum)
	ADD r4,r4,r5 		;Add together sums
	SUBS r4,r4,#1 		;Subtract one
div	SUBS r4,r4,#10 		;Find modulus by subtracting 10
	BPL div 			;until sum is no longer positive
	ADD r4,r4,#10		;Add back 10 
	RSB r0,r4,#9 		;Subtract remainder from 9
	LDRB r3,[r2] 		;Save check digit to r3
	SUBS r3,r3,#48 		;Find numerical value of ASCII check digit
	SUBS r0,r0,r3 		;Compare check digit with result
	BEQ yes 			;if they are equal go to yes
no	MOV r0,#2 			;otherwise save r0 as 2
e	B e 				;end
yes	MOV r0,#1 			;save r0 as 1
	B e 				;end
UPC	DCB "065633454712"
	END
		