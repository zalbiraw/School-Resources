			AREA question1, CODE, READONLY
			ENTRY
			ADR r1, STRING1 					; load the address of STRING 1's first character into r1
			ADR r2, STRING2 					; load the max space a string can take up dedicate it as a pointer in r2
			LDRB r0, [r1]						; load the first letter of the string whos adress is in r1 into r0
Loop		CMP r0, #Null   					; check if the end of the string through checking for Null char
			BEQ EndOfString						; if the end of string go to EndOfString branch which performs a nop
			CMP r0, #tascii						; check if the character is a t
			BEQ CheckhNext						; if yes branch to checkhnext to continue checking for 'the'
			STRB r0, [r2], #1					; since it didnt branch its not a 't' and store into next spot of adress in r2 and increment to next open space
			LDRB r0, [r1, #1]!					; load the next character into r0 
			B Loop								; go to the beginning of this loop
CheckhNext	STRB r0, [r2], #1       			; store the t in open spot then increment to next space
			LDRB r0, [r1, #1]!					; load the next character into r0
			CMP r0, #hascii						; check if character is 'h'
			BEQ CheckeNext						; if yes go to Checkenext branch to continue checking for 'the'
			B Loop								; not a h in this case so return to original loop to continue
CheckeNext	STRB r0, [r2], #1					; store the h in open spot then increment to next space thats open
			LDRB r0, [r1, #1]!					; load the next character into r0
			CMP r0, #eascii						; check if character is an 'e'
			BEQ spaces							; if it is go to spaces branch to confirm it is word 'the'
			B Loop								; branch to the original loop to continue as the third letter isnt 'e'
spaces		STRB r0, [r2], #1					; store the e in open spot then increment to next space thats open
			LDRB r0, [r1, #1]!					; load character after the possible 'the'
			LDRB r5, [r1, #-4]					; load character before the possible 'the'
			CMP r5, #Null						; if before char is null it comfirms it is 'the'
			BEQ check							; branch to check confirm that this starting word has no other letters after 'the'
check		CMP r0, #spaceascii					; check if the letter after 'the' is a letter or not
			BEQ confirmed						; confirmed space after 'the' making it a forsure 'the' to overwrite branch to confirmed
			B Loop								; return to original loop as there is a letter following 'the' making it not the word 'the'
confirmed	SUB r2, #3 							; this puts the pointer back to the first t of the the which will in turn be overwritten once returning to original loop
			B Loop								; return to original loop to keep writing the string overtop of located 'the'
EndOfString	NOP									; placeholder operation to signify end of program
			AREA question1, DATA, READWRITE			
tascii 		EQU 0x74							;ascii value of t in hexa
Null 		EQU 0x00							;ascii value of null in hexa
hascii		EQU 0x68							;ascii value of h in hexa
eascii		EQU 0x65							;ascii value of e in hexa
spaceascii  EQU 0x20							;ascii value of space in hexa
STRING1 	DCB "the they man said the must go" ;String1
EoS 		DCB 0x00 							;end of string1
			ALIGN
STRING2 	space 0xFF 							;just allocating 255 bytes
			END