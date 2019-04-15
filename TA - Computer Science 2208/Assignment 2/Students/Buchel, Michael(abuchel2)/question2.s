					AREA assign3, CODE, READONLY ; Segment definer for code
					ENTRY ; Entry definition
					
					; Initialize stack pointer
					MOV sp, #STK_SRT ; Sets the stack pointer to 0xF00 to prevent illegal access issues (line 1)
					
					; This block sets the variables and calls the function
					LDR r0, X_VAL ; Loads x into r0 (line 2)
					BL math ; Calls math subroutine (line 3)
					MOV r1, r0, LSL #1 ; Multiplies output by 2 (line 4)

					; Looping
endless			B	endless ; Endless loop to seperate the main code from the function (line 5)

					; math - function to calculate the smaller out of d and y,
					;			where d is a word in memory, and y is given by:
					;			y = a * x^2 + b * x + c, where a b and c are found
					;			in memory
					; @r0 - x value, this value is also our return value or y
math				PUSH {r1-r4, lr} ; Pushes the values in r1-r4 into the stack (line 6)

					; Read data
					LDR r1, = A_VAL ; Loads the address of A_VAL into r1 for the next instruction (line 7)
					LDM r1, {r1-r4} ; Loads words starting from the base register (r1) into registers r1-r4 (line 8)

					; Calculate math
					MLA r1, r0, r1, r2 ; Multiply and add x * a + b (line 9)
					MLA r1, r0, r1, r3 ; Multiply and add again x * (x * a + b) + c (line 10)
					
					; Compare and return
					CMP r4, r1 ; Checks to see if d >= y (line 11)
					MOVGT r0, r1 ; if (d > y) return y (line 12)
					MOVLE r0, r4 ; else return d (line 13)
					POP {r1-r4, pc} ; Pops the registers back from the stack  (line 14)
					
					AREA assign3, DATA, READWRITE ; Data code segment
					
					; Values for A B C D X
A_VAL			DCD 5
B_VAL			DCD 6
C_VAL			DCD 7
D_VAL			DCD 10
X_VAL			DCD 3
	
					; Because we are supposed to use EQU even though it is not always
					; necessary and sometimes impossible to use them like LSL #equ_val
					; will create an A1482E error
STK_SRT		EQU 0xFF00 ; start of stack is chosen arbitrarily
					
					END ; End program