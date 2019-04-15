		AREA UPC_Checker, CODE, READONLY ;Morgan O'Brien 2208 Asn 3 Program 1
		ENTRY				;start

		mov r11, #0 		;clear for counter
		mov r12, #1			;counter for even digits
		mov r9, #9 			;easy to rmember which register has 9, aha
		mov r5, #6 			;count down to exit the loop that sums the upc numbers
		ADR r10, UPC 		;UPC address will stay in r10 the whole time

Repeat	ldrb r1, [r10, r11] ;get int from UPC at index r11
		ldrb r2, [r10,r12] 	;get int from UPC at index r12
		add r11,#2 			;increase index counter
		add r12, #2 		;increase index counter
		add r7,r1 			;sum even index digits
		cmp r12,#13 		;if r2 > 13 we are out of bounds and don't want to sum any more integers
		ADDLT r8, r2 		;sum odd index digits only if value in r12 is less than 13
		SUBS r5,r5,#1		;decrease counter
		BNE Repeat			;Go back to fetch next 2 bytes
		SUB r7,#288 		;reduce sum by 48 for each integer that was summed (48x6)
		SUB r8,#240 		;reduce sum by 48 for each integer that was summed (48x5)

		mov r4,r7 			;store original r7 because it will be replaced
		add r7, r7, r7 		;r7*2
		add r7, r7, r4 		;this line with the above 2 lines performs r7=r7*3
		add r7,r7, r8 		;add the other sum
		sub r7,#1 			;reduce by 1 because those are the instructions
		sub r11, #1 		;r11 needs to be 11 to get the check digit and compare it to the computed one
		
RepeaT	SUB r7,#10 			;subtract 10 until less than 10 and that gets your remainder
		CMP r7,#10 			;check if less than 10 otherwise do it again
		BGT RepeaT			;go back 2 lines
		SUB r2, r9, r7		;subtract remainder from 9, this number should be equal to the check digit
		ldrb r3, [r10, r11] ;load check digit
		SUB r3, r3, #48 	;convert from ascii encoding to integer
		CMP r2, r3 			;compare the check digit with the calculated one
		MOVEQ r0,#1			;if they are equal
		MOVNE r0,#2 		;if they are not equal
trap 	B trap 				;trap the program into an infinite loop at the end
UPC  	DCB "060383755577" 	;UPC string 
		END