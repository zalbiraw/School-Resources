		AREA Question_2, CODE, READONLY
		
		ENTRY
		
		LDR r0, =String		; Load address of String into r0
		
		; Note: I wasent sure how to how to find if a phrase like "He lived as a devil,eh?" was a palidrome.. I figured out how to find words that are palidromes
		; by butting characters of a 4 letter string into registers and compareing them. 
		
		LDRB r1, [r0], #1
		CMP r1, #96			; Check if character is lower case. ie. ASCII value >96
		SUBGT r1, #32		; If character is lower case subtract 32 to get its capital case ASCII value
		
		LDRB r2, [r0], #1
		CMP r2, #96			; Check if character is lower case
		SUBGT r2, #32		; If character is lower case subtract 32 to get its capital case ASCII value
		
		LDRB r3, [r0], #1
		CMP r3, #96			; Check if character is lower case
		SUBGT r3, #32		; If character is lower case subtract 32 to get its capital case ASCII value
		
		LDRB r4, [r0], #1
		CMP r4, #96			; Check if character is lower case
		SUBGT r4, #32		; If character is lower case subtract 32 to get its capital case ASCII value
		
		
		CMP r1, r4			; Compare first and last characters
		BNE Dif				; Branch to 'Dif' when two characters dont match
		
		CMP r2, r3			; Compare 2nd and 3rd characters
		BNE Dif				; Branch to 'Dif' when two characters dont match
	
		MOV r0, #1			; If the program makes it to here then we have a palindrome
		B	exit

Dif		MOV r0, #0			; The string is not a palindrome, store 0 in r0

exit

loop 	b loop


		AREA Asn3Q2, DATA, READWRITE
			
String	DCB "Noon"	
EoS		DCB 0x00	;end of string
		END