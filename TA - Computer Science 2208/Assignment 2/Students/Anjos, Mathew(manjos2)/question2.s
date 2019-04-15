		AREA question_2, CODE, READONLY
		ENTRY
		
		LDR 	r0, x					; Load x value
		ADR 	r13, Stack				; Point the SP to the allocated memory location
		
		BL 		func					; Call the func subroutine
		ADD 	r1, r0, r0				; Double the balue of r0 and store it in r1
		
end		B 		end						; Infinite loop so that we don't accidentally execute the subroutine without calling it
		
func	STMFA 	r13!, {r1-r6, r14}		; Store all registers into memory so that we can restore the values at the end, including the link to the main program
		ADR 	r1, a					; Point to the address of a
		LDM		r1!, {r2-r5}			; Starting from the address of a, load the next 4 words into registers (a, b, c, d), so r2 = a, r3 = b, r4 = c, r5 = d
		
		MUL 	r6, r0, r0				; Calculate x^2
		MLA 	r6, r2, r6, r4			; Calculate a * (x^2) + c
		MLA 	r0, r3, r0, r6			; Calculate b*x + (a*x^2 + c), and start storing it in r0 since we no longer need the value of x to do our calculations
		CMP 	r0, r5					; Compare y and d	
		MOVGT 	r0, r5					; If y > d then we set r0 to the value of d, otherwise we can keep the value of r0 as it is, since it is by default the value of y because we stored our calculations there
		LDMFA 	r13!, {r1-r6, r15}		; Restore the previous register values as well as load the link to the main problem to the PC so that we can return
		
x		DCD		5						; Stores the value of x
a		DCD 	2						; Stores the value of y
b		DCD 	3						; Stores the value of b
c		DCD 	4						; Stores the value of c
d		DCD 	70						; Stores the value of d
Stack	SPACE	48						; Allocates 48 bytes (6 words) for the stack. We allocate 6 words because we use 6 registers in our subroutine, and so we need 6 words in order to store the values of the registers
		END