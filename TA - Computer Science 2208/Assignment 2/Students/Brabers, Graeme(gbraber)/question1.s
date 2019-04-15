		AREA Assignment_4_1_code, CODE, READONLY
		ENTRY
		LDR r0, =STRING1					;Load address of String1 into r0, for modification
		MOV r1, r0							;Copy starting location of String1, for reference
		LDR r2, =STRING2					;Load address of String2 into r2
		LDR r3, =EoS						;Load address of EoS into r3

Load	CMP r0, r3							;Compare character to EoS
		BEQ Loop							;End if finished
		
		BL Examine							;Call function to find "the"
		
		CMP r4, #0							;Check is "the" found
		BEQ Write							;If not found, call Write function
		
		;If "the" found, check if it's the beginning of the string
		CMP r0, r1							;Check if character is the first character of the string
		ADDEQ r0, r0, #3					;Incrememnt r0 by 3 to skip 3 characters if at the beginning of string
		BEQ Load
		
		;If "the" found, check if surrounded by spaces
		LDRB r8, [r0, #-1]					;Load character before 'the' into r7
		LDRB r9, [r0, #3]					;Load character after 'the' into r8
		CMP r8, #' '						;Compare previous character to ' '
		CMPEQ r9, #' '						;Compare next character to ' '
		ADDEQ r0, r0, #3					;Increment r0 by 3 to skip 3 characters if "the" is surrounded by spaces
		BEQ Load							;Branch to next character
		
		;If "the" found, check if at end of string
		CMP r9, #0x00						;Compare fourth character to EoS
		BEQ Loop							;End algorithm if reached EoS
		
		B Write								;Branch to Write function if "the" is part of a word
		
Examine	LDRB r5, [r0]						;Load first character into r5
		LDRB r6, [r0, #1]					;Load second character into r6
		LDRB r7, [r0, #2]					;Load third character into r7
		
		CMP r5, #'t'						;Compare first character to 't'	
		CMPEQ r6, #'h'						;Compare second character to 'h'
		CMPEQ r7, #'e'						;Compare third character to 'e'
		MOVEQ r4, #1						;If "the" found, set r4 to 1
		MOVNE r4, #0						;If "the" not found, set r4 to 0
		MOV pc, lr							;End of function
		
Write	STRB r5, [r2], #1					;Store the character in r1 to the address of r5, and increment
		ADD r0, r0, #1						;Increment to next character
		B Load								;Branch to next character

Loop	B Loop
		
		AREA Assignment_4_1_data, DATA, READWRITE
STRING1	DCB "the the the"					;String1 
EoS		DCB 0x00							;End of String1 
		ALIGN
STRING2	space 0xFF							;Allocation of bytes for String 2
		END