; Vector Table Mapped to Address 0 at Reset
; Linker requires __Vectors to be exported
 
          AREA    RESET, DATA, READONLY
          EXPORT  __Vectors
 
__Vectors 
			DCD  0x20001000     ; Stack pointer value when stack is empty
			DCD  Reset_Handler  ; Teset vector
consta		DCD	 	0x4			; Polynomial value a
constb		DCD		0x7			; Polynomial value b
constc		DCD		0x8			; Polynomial value c
constd		DCD		0x50		; Constant threshold value to compare y
constx		DCD		0x3			; Value of variable x
			ALIGN

; Data area that can be modified (has readwrite permissions)
			AREA Data, DATA, READWRITE
solutiony	DCD		0x0		 	; Allocating bytes to store result if need be
			ALIGN
; Program that calculates a polynomial value
; Linker requires Reset_Handler
 
			AREA    MYCODE, CODE, READONLY
			ENTRY
			EXPORT Reset_Handler
			ALIGN 2
			
polynomial	 	PROC
;; r0 contains value of x to be used for ax^2 + bx + c
		STMFD SP!, {R1-R8, LR}		; Push all registers used in subroutine to prevent corruption
		LDR		r1,consta			; Load values for polynomial constants a, b, c
		LDR		r2,constb			
		LDR		r3,constc
		; Calculate x^2
		MUL		r4,r0,r0
		; Calculate (a times x^2) + c
		MLA		r4,r1,r4,r3
		; Calculate	y = (b times x) + (ax^2 + c)		y is stored in r0
		MLA		r0,r2,r0,r4
		; Load threshold value d
		LDR		r1,constd
		; Compare y > d
		CMP		r0,r1
		; mov d to r0 if y is greater than d else return y in r0
		MOVGT	r0,r1
		LDMFD SP!, {R1-R8, PC}		; Pop all  registers and branch back to main program
				ENDP
		
Reset_Handler

				ALIGN 2
			B		mainprog

mainprog
			LDR			r0,constx		; Load value of variable x
			BL			polynomial		; Call function to calculate value of polynomial
										; Result is returned in reg r0
			MOV			r1,r0,LSL #0x1	; Store 2 times r0 into r1
			B		.					; End program
			END
