			AREA question1, CODE, READWRITE
			ENTRY
			
			LDR sp, =stack1				;Initializing the stack pointer, the main() part of the function
			BL power					;Calling the power function
loop		B loop						;Program is finished

power		STMIB sp, {r0-r12}			;Store the original registers into the stack
			LDR sp, =stack2				;Initializing the stack pointer to where the values are being passed
			LDMIB sp!, {r1-r2}			;Load the value of x and n into respective registers
			LDR r12, =n					;Set up the terminal condition of the stack to the bottom of the stack
			MOV r3, #OddC				;Used to check if n is odd (n & 1), indicated as OddCondition
			MOV r4, #EvenC				;Used to check if n is even, the else part

back		MOV r0, #1					;Base case, return 1
			CMP r2, #0					;Check if n is zero - the terminal condition for the recursive function
			BEQ terminal				; if it is start popping and storing value
			
			ANDS r3, r2, #Odd			;Check if n is odd
			BEQ elsec					;If not go to the else condition
			SUBNE r2, r2, #1			;If it is odd, n - 1
			STR r3, [sp, #4]!			;Remembers the odd condition, used to return x*power(x, n-1), then updates the relative position of the stack pointer to be used lfor the next call
			B back						;Recursively calls back to the power function

elsec		MOV r2, r2, LSR #1			;divides n by 2 using logical shift n >> 2
			STR r4, [sp, #4]!			;Remembers the even condition used to return y*y, then updates the relative position of the stack pointer to be used for the next call
			B back						;Recursively calls back to the power function
		
terminal	STR r0, [sp, #4]			;Once the terminal condition is reached, stores the base case on the stack
popc		CMP sp, r12					;Used to determine if the stack is fully returned
			BEQ done					;Once the stack is fully returned, it goes to the end to store the result and load back the registers
			LDR r5, [sp]				;Use another pointer to check for the conditions remembered on the stack
			ANDS r5, #Odd				;When popping the stack, check the condition previously remembered, if it is one, it is the odd case, otherwise it is even
			LDRNE r6, [sp,#4]			;If it is odd, load back the value to calculate the first condition
			BEQ condition2				;If it is not odd, go to the second condition
			MUL r6, r1, r6				;x*power(x,n-1), performes the calculation and use a temporary register to store the value
			STR r6, [sp], #-4			;Return and stores it on the stack to be used for the next recursive call
			B popc						;Pops the next item on the stack by going back
condition2	LDR r6, [sp,#4]				;When it is not odd, use the item being popped
			MOV r7, r6					;Use another temporary register to store the item, used for y = power(x, n>>1)
			MUL r6, r7, r6				;calculates y * y
			STR r6, [sp], #-4			;Return and stores it on the stack to be used for the next recursive call
			B popc						;Pops the next item on the stack by going back
			
			
			
done		LDR sp, =stack1				;Once the calculation is over, return to the stack where the value of the registers were previously stored
			LDMIB sp, {r0-r12}			;Load them back into their original registers
			MOV pc, lr					;Link back to the main function

			AREA A5Q1, DATA, READWRITE
OddC		EQU 1						;Used to remember the odd condition
EvenC		EQU 2						;Used to remember the even condition
Odd			EQU 0x1						;Used to check if n or the condition is odd
stack1		DCD 0x00					;First stack to store the original values of the register
			SPACE 0x40					;Space created to store the values
stack2		DCD 0x00					;Used to pass down the parameters
x			DCD 2						;parameter x
n			DCD 11						;parameter n
result		DCD 0x00					;The beginning of the calculation stack, also where the returned result will be stored
			END