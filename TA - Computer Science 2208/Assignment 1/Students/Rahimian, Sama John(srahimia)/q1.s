		AREA ass3q1, CODE, READONLY
		ENTRY
		LDR r0,=UPC	;Load address location of UPC in r0
		MOV r11,#0	;The pointer to a single element in the UPC

GET_NUM_LOOP LDRB r3,[r0,r11]	;Loop for adding the elements of UPC array r0 to respective container (r3 for odd and r4 for even)
								;Retrive the next "odd" element from the UPC array r0
		SUB r3,r3,#48	;Convert the character into an integer to be added added to r1
		ADD r1,r1,r3	;r1 will keep a summation of the "odd" elements from the UPC
		ADD r11,r11,#1	;Increment the pointer to r11
		
		LDRB r3,[r0,r11];Retrive the next "even" element from the UPC array r0; r3 will also store the check digit when we exit the loop
		SUB r3,r3,#48	;Convert the character into an integer to be added to r2
		ADD r2,r2,r3	;r2 will keep the summation of the "even" elements from the UPC
		ADD r11,r11,#1	;Increment the pointer to r11

		CMP r11,#12		;Compare to see if the value from r11 equals 1
		BNE GET_NUM_LOOP;If the CMP does not return 0, then continue the loop "GET_NUM_LOOP"
		
		ADD r1,r1,LSL#1	;Multiply the r1 sum by 3 
		ADD r1,r1,r2	;Add value in r2 to the value in r1
		
CHECK	SUBS r1,r1,#10	;Calculate the remainder of the of the value in r1 by subtracting 10
		BGT CHECK		;If the result is greater than 0 continue subtracting
		CMP r1,#0		;To see if the value is valid we need to compare what is stored in r1 to 0
		BEQ VALID		;If the value is valid then go to "VALID"	
		
		MOV r0,#2		;If the value is invalid, then set r0 to 2
		B infin			;Skip the valid section and go to "FIN"

VALID	MOV r0,#1		;If the value is valid, then set r0 to 1	
		
infin	B infin			;infinte loop

		AREA ass3q1, DATA, READWRITE
UPC		DCB "013800150738" ;UPC string - true
;"060383755577" - UPC string additional test case 1 - true
;"065633454712" - UPC string additional test case 2 - true
;"010101010105" - UPC string additional test case 2 - true

		END		;end of program
