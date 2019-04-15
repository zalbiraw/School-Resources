;Program will take a UPC and determine if the Check Digit is correct
;By Andres Rodriguez
		AREA AddAccumulate, CODE, READONLY
		ENTRY
		MOV r0, #2 			;Defaults as 2, will later be updated to 1 if the check digit is correct
		MOV r6, #3 			;Constant used in MLA command
		ADR r1, UPC 		;Contains the address of the UPC string
		LDRB r7, [r1, #11]  ;Loads register byte information from UPC
		SUBS r7, #48 		;Offsets the value so the Hex corresponds to the numeric value of the UPC

;Loop1 will add up all the digits in the UPC using the provided algorithm
Loop1	LDRB r2, [r1], #1   ;Gets the next digit
		LDRB r3, [r1], #1   ;Gets the next digit
		MLA r5, r2, r6, r5  ;Multiplies the "even" placed numer by 3, uses the constant r6, adds it to a total sum register r5
		ADD r5, r3			;Adds the "odd" placed number to the total sum register r5
		SUBS r5, #192		;Offsets teh value so the HEx correspond to the numeric value of the UPC
		CMP r1, #0x0000005C ;Condition for the loop to be executed exactly six times
		BNE Loop1			;If the condition isnt met, run the loop again
					
		SUBS r5, r7			;Subtracts the Check Digits value from the total sum
		SUBS r5, #1			;Subtracts one from the total sum
		
;Loop2 will continously subtract 10 from the total sum until it finds the remainder
Loop2 	CMP r5, #10			;Condition for the loop to be executed until its value is less than 10
		SUBGT r5, #10 		;Loops thru subtracting 10 until it finds the remainder 
		BGT Loop2			;Repeats the loop if the value is greater than 10
		
		RSB r5, r5, #9 		;Subtracts the r5 value from 9
		CMP r5,r1			;Compares the remaining value to the check digit
		SUBEQ 	r0, r0, #1	;If check digit is correct, subtracts one from the r0

;Data for the program
		AREA AddAccumulate, DATA, READWRITE
UPC 	DCB "013800150738"	;Contains the UPC
		END