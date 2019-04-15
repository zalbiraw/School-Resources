		AREA question_1, CODE, READONLY
		ENTRY
SPACE	EQU 	32					; ASCII for the space character
t		EQU 	116					; ASCII for the 't' character
h		EQU 	104					; ASCII for the 'h' character
e		EQU		101					; ASCII for the 'e' character
eos		EQU 	0					; ASCII for the NUL character (EoS character)
len		EQU 	4					; Exact length for a "the " string
		
		ADR 	r0, STRING1			; Load location of first (input) string 
		ADR 	r1, EoS				; Load location of end of string
		ADR 	r9, STRING2			; Load location of second (output) string
		LDR 	r13, =Stack			; Point the SP to the allocated memory location
		
Loop	RSBS 	r2, r0, r1			; Check if we are within the address range of string1 = (current string1 address) - (EoS)
		BMI 	end					; If we are outside the range of string1, then we are done, so branch to the end

		LDRB 	r3, [r0], #1		; Load letter from current string1 address to register and increment pointer to next letter
		STR 	r3, [r13], #4		; Push the letter loaded to the stack and increment the stack by 4 (we want to load the bytes as words in the stack for later on)
		ADD 	r10, #1				; Count how many elements are added to the stack for bookkeeping
		
		CMP 	r3, #eos			; If the current letter is EoS (0) then that means that we have read the last word
		CMPNE 	r3, #SPACE			; If the current letter is a space then that means that we have read a word
		BEQ 	check				; If the letter is EoS or a space, then we have a word in the stack and can now check the word
		
		B 		Loop				; If the letter is not Eos or space, then we still have not read a full word, so keep looping
		
check	CMP 	r10, #len			; Check to see if length of the stack is equal to the length of a "the " string (4). If it is, then we can check if it is the word
		BNE 	add					; if it isn't, then we can just automatically assume it is not the word "the" and begin adding it to string2
		
		LDMEA 	r13, {r3-r6}		; If the word is 4 letters long, then we load the letters to 4 registers. Since each is letter is stored as 4 bytes in the stack we can do this
		CMP 	r3, #t				; Check to see if the first letter is t
		CMPEQ 	r4, #h				; Check to see if the second letter is h ONLY IF the first letter is t
		CMPEQ 	r5, #e				; Check to see if the third letter i e ONLY IF the first letter is t AND the second letter is h
		
		STRBEQ 	r6, [r9], #1		; If the word is "the", then we add the 4th letter to string2 (either a space or EOS)
		BEQ 	re					; If the word is "the" then we are done and can loop back to the start
		BNE 	add					; If the word is NOT "the", then we need to add it to string2 still
		
		
add		LDR 	r13, =Stack			; Reset the SP to the base so that we can start reading the letters from left to right
addloop	LDR 	r4, [r13], #4		; Load one letter to register and increment SP by 4 (it is 4 because we previously stored all letter as 4 bytes in the stack)
		STRB 	r4, [r9], #1		; Store the word that is loaded into string2 and increment the string2 pointer to the next (empty) locatio
		SUBS 	r10, r10, #1		; Decrement the stack count
		BNE 	addloop				; Keep looping until the stack is empty

		
re		LDR 	r13, =Stack			; Reset the stack to its base (aka empty the stack)
		MOV 	r10, #0				; Reset the stack counter to 0
		B 		Loop				; Loop back to read another word
		
end		B 		end					
		
STRING1 DCB 	"them   the   the1" ; String1 
EoS     DCB 	0x00                ; End of string1 
STRING2 space 	0xFF                ; Just allocating 255 bytes
		ALIGN						; Just aligning so that our stack starts at an address divisible by 4
Stack	SPACE	80					; Allocating 80 bytes (10 words) for the stack
		END