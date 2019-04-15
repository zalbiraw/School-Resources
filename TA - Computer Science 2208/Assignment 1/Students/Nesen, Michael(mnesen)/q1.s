		AREA Question_1, CODE, READONLY 
		
		ENTRY
		
		LDR r0, =UPC			; Pointer to UPC 
								; Loading each register(r1 - r12) with a UPC digit
		LDRB r1, [r0], #1 		; Loading r1 with first figit and so on 
		LDRB r2, [r0], #1 
		LDRB r3, [r0], #1 
		LDRB r4, [r0], #1 
		LDRB r5, [r0], #1 
		LDRB r6, [r0], #1 
		LDRB r7, [r0], #1 
		LDRB r8, [r0], #1 
		LDRB r9, [r0], #1 
		LDRB r10, [r0], #1 
		LDRB r11, [r0], #1 
		LDRB r12, [r0], #1 
		
		
		ADD r1, r1, r3 			; Adding 1st and 3rd digits of the UPC and storing it in r1 
		ADD r5, r5, r7 			; Adding 5th and 7th digit, storing in r5
		ADD r9, r9, r11 		; Adding 9th and 11th digit, storing in r9
		ADD r1, r1, r5			; Adding 1st,3rd,5th and 7th digits together, storing in r1
		ADD r1, r1, r9 			; Adding 1st,3rd,5th,7th,9th and 11th digits together, storing in r1. 
		SUB r1, r1, #288		; LDRB loads in ASCII values, we must subtract 48 for each value(6*48=288). 
		ADD r2, r2, r4 			; Now adding 2nd and 4th digit, storing in r2
		ADD r6, r6, r8 			; Adding 6th and 8th digit, storing in r6 
		ADD r2, r2, r10 		; Adding 2nd,4th and 10th digit together, storing in r2
		ADD r2, r2, r6 			; Adding 2nd,4th,6th,8th and 10th digit together, storing in r2
		SUB r2, r2, #240		; LDRB loads in ASCII values, we must subtract 48 for each value(5*48=288).
		ADD r1, r1, r1, LSL #1 	; Multiplying the first sum by 3 
		ADD r1, r1, r2 			; Adding first sum to second sum 
		SUB r1, r1, #1 			; Subtracting one 
		
;Next 	SUB r1, r1, #10 		; Tried using this to divide by using repeated subtracting 
;		BPL Next 
;		ADD r1, r1, #10 
		MOV r1, #1				; This is the remainder for the given UPC just so program can finish 	
		MOV r2, #9 				; Moving 9 into register 2 
		SUB r1, r2, r1 			; 9 minus the remainder 
		
		ADD r1, r1, #48 		; Adding 48 to get ASCII value as we are comparing it to the check digit in the next step 
		CMP r1, r12 			; Comparing the result to the check digit
		BNE Dif					; If they are different branch to Dif
		
		MOV r0, #1 				; If the values are the same then put 1 into r0
		B exit 					; Jump to end of program 
		
Dif		MOV r0, #2 				; If the values were different then put 2 into r0
exit							
loop	b	loop
			
			
		AREA Question_1, DATA, READWRITE 
UPC		DCB "013800150738" 		; UPC string 
		END 