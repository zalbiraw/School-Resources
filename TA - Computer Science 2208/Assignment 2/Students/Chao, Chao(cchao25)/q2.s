			AREA func, CODE, READONLY
			ENTRY
			ADR r11, stack ;initial a stack pointer to store initial value of registers
			ADR r10, top ;initial another pointer to load data from memory to registers
			BL Func	
			LSL r1,r0,#1 ;double the return value
Loop		B   Loop

Func		STMFA r10!,{r0-r4}
			LDMFA r10!,{r0-r4};load value from memory stack to r0-r4
			MLA r2, r1,r0,r2; calculate a*x+b
			MLA r0, r2,r0,r3; calculate (a*x+b)*x+c
			CMP r0,r4 ; check if greater than d
			MOVGT r0,r4 ;return d if greater
			STMFA r11!,{r1-r4}
			LDMFA r11!,{r1-r4};restore registers' value
			mov r15, #12
			
			
stack       space 50	
top			space 0x0	
xx			DCD 3
aa			DCD 5
bb    	 	DCD 6
cc			DCD 7
dd			DCD 90	
			END