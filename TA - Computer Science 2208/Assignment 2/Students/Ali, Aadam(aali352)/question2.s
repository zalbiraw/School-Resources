		AREA calculate, CODE, READONLY
		ENTRY
		
		MOV sp, #0xFF00 ;This creates the stack pointer in order to allow for the pushing of values for registers
		LDR r0, xNum    ;Loads the x value into register 0 so that it can be used as the purpose register
		BL func			;Branch links to the subroutine which solves the equation
		LSL r1, r0, #1	;Shifts left after equation is finished to get proper value

inf		B inf           ;Infinite loop for debugging

func	PUSH {r1, r2, r3, r4, r5, lr} ;Pushes all registers to the stack including link register in order to store in one place
		ADR r1, aNum				  ;Loads variable a into register 1 to assist in solving equation
		LDMIA r1, {r2, r3, r4, r5}	  ;Load multiple registers into r1 to have one source register
		MLA r1, r0, r2, r3			  ;Multiplies and accumulates the numbers in registers to solve first part of the equation
		MLA r1, r0, r1, r4			  ;Does the same thing as the above line but for a different part of the equation
		CMP r5, r1                    ;Compares the two values in order to get the proper value for the equation
		MOVLE r0, r5                  ;Move if it is less than or equal to into proper register to get the answer
		MOVGT r0, r1                  ;Move if it is greater than into the proper register in order to have the proper answer in r0
		POP {r1, r2, r3, r4, r5, pc}  ;Pop all registers and program counter in order to reset the values 

		AREA calculate, DATA, READWRITE
			
aNum    DCD    5 ;a variable
bNum	DCD	   6 ;b variabel
cNum	DCD    7 ;c variable
dNum    DCD    90 ;d variable 
xNum    DCD    3 ;x variable 
		
		END