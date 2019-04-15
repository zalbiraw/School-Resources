	AREA question1, CODE, READONLY
		ENTRY 
			ADR		R0, STRING1								;Register containing primary pointer to STRING1
			ADR		R1, STRING1								;Register containing temporary pointer to STRING2
			ADR		R4, STRING2								;Register containing pointer to STRING2
			LDRB	r2, [r0]								;Load first byte of string into r2 (r2 acting as temporary byte register)
			B		thecase									;Branch to "thecase" to check first character sequence	
start		LDRB	r2, [r0], #1							;Load first character of string into temporary registerr			
			CMP		r2, #0x00								;Check to see if newline character was loaded
			BEQ		finish									;If newline character is reached, end of string is reached, branch to infinite loop
			CMP		r2, #0x20								;Check to see if current character is a space, indicating a new word following
			STRB	r2, [r4], #1							;If character loaded is not a space, then load the character into the STRING2 memory, incrementing pointer to string2
			LDRBEQ	r2, [r1,#1]!							;Load next letter after space into temporary register r2
			BEQ		thecase									;At the beggining of every new character sequence branch to check case to see if the word is "the" 
			MOV		r1, r0									;Set temporary pointer equal to primary pointer
			B		start									;Branch back to the start to load a new character 	
thecase		CMP		r2, #0x74								;Compare the character stored in r2 with the ascii code for the letter "t" to see if character sequence "the" is a possibility
			LDRBEQ	r2, [r1,#1]!							;If the character is a t: Load next character into temporary register, incrementing and writing back to pointer 
			CMPEQ	r2, #0x68								;Compare if next character is an "h" to see if character sequence "the" is still a possibility
			LDRBEQ	r2, [r1,#1]!							;If next character is an "h" load next character to be examined 
			CMPEQ	r2, #0x65								;Compare character with ascii code for "e" to see if character sequence "the" is still a possibility
			LDRBEQ	r2, [r1,#1]!							;If next letter is an "e" load next character into temporary register 
			CMPEQ	r2, #0x20								;Check if next character is a space, indicating that the character sequence is complete and the word "the" has been identified 
			ADDEQ	r0, #3									;Add 3 to the value of the primary pointer so that the characters "the" will be skipped when loading valid characters into string2
			CMP		r2, #0x00								;Check to see if end of string has now been reached 
			BEQ		finish									;If end of string has been reached, branch to "finish" case
			BNE		start									;If end of string has NOT been reached, branch back to the start of the loop to load and store the next characters of the string
finish		STRB	r2, [r4], #1							;Finish case loads the EOS character to the end of the string in memory
			B realfinish									;Branch to "realfinish" indicating end of program
realfinish	CMP		r2, #0x00								;Compares value in temporary register to EOS character, which will be stored in r2 in order to reach this branch
			BEQ		realfinish								;If equal branch back to realfinish, this infinite loop indicates the end of the program
STRING1		DCB		"and the man said they must go" 		;string1
EOS			DCB		0X00									;end of string character
STRING2		space	0xff									;new memory for STRING2
	END