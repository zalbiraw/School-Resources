; Vector Table Mapped to Address 0 at Reset
; Linker requires __Vectors to be exported
 
          AREA    RESET, DATA, READONLY
          EXPORT  __Vectors
 
__Vectors 
			DCD  0x20001000     ; This is the stack pointer value when stack is empty
			DCD  Reset_Handler  ; Reset vector
STRING1 	DCB "the andthe the manthe the the said they must go" ; Test value String1
EoS 		DCB  0x00 ; Indicates the end of String1
SUBSTRING	DCB	"the " ; Indicates the substring that will need to be removed by the program

			
			ALIGN
; This is the data area that can be modified (has readwrite permissions)
			AREA Data, DATA, READWRITE
STRING2 	space 0xFF ;Allocating 255 bytes
			ALIGN
; Program that will remove "the" from a String
; Linker requires Reset_Handler
 
          AREA    MYCODE, CODE, READONLY
 
		ENTRY
		EXPORT Reset_Handler
  
Reset_Handler

			B		mainprog

mainprog
			LDR			r0,=STRING1				; Initialize string pointer registers
			LDR			r1,=SUBSTRING
			LDR			r1,[r1]					; Load key word for search string
			LDR			r8,=STRING2				; Initialize pointer to result string
			MOV			r7,#0x1					; r7 used as flag to indicate if previous char was a space
												; Initialized to 1 for first word match
nextchar
			LDR			r2,[r0]					; Load 4 characters from test string
			CMP			r2,r1					; Compare with key word
			BEQ			foundsubstring			; Branch to check white space character as prefix
copychar
			LDRB		r2,[r0],#1				; Copy character
			STRB		r2,[r8],#1				; Store in result string
			CMP			r2,#" "					; Check if the character is a space
			MOVEQ		r7,#0x1					; Set flag if so
			MOVNE		r7,#0x0					; Clear flag if not
			CMP			r2,#0x0					; Check if end of string
			BNE			nextchar				; Otherwise loop till end of string
			B			.						; End of program
foundsubstring
			; Check if initial character was a space
			; Use r7 as flag
			CMP			r7,#0x1					; Check if previous character was space
			ADDEQ		r0,r0,#0x3				; Skip 3 characters if previous character was a space
			BNE			copychar				; Else copy character it is part of another word
			B			nextchar				; Branch to copy subroutine
			
			END ; End of program