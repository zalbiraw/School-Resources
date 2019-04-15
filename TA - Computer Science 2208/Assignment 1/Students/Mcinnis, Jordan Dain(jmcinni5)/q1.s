		AREA Question1, CODE, READONLY
		ENTRY
		ADR r1, UPC ;Create a reference to UPC in register 1
		MOV r2, #6 ;Define amount of times to loop and get characters
Loop	SUBS r2,r2,#1 ;Subtract one from amount of loops left to run
		LDRB r3,[r1],#1 ;load next number of UPC
		SUB r3,r3,#48 ;subtract 48 to convert from ASCII to decimal
		ADD r4,r4,r3 ;add number to sum 1, located in register 4
		LDRB r3,[r1],#1 ;load next number of UPC
		SUB r3,r3,#48 ;subtract 48 .... 
		BEQ Exit ;In the scenario of the last loop, we don't want the check digit apended to sum 2, so catch it if last loop
		ADD r5,r5,r3 ;if not last loop add digit to sum 2
		B Loop ;keep looping until last digit
Exit	MOV r9,r3 ;store check digit in r9 for later confirmation
    	ADD r4,r4,r4,LSL#1 ;multiply by 3 as per check
		ADD r4,r4,r5 ;combine together as per check
		SUB r4,r4,#1 ;subtract 1 as per check
RD      SUBS r4,r4,#10 ;subtract for repeated division of 10 
		CMP r4, #10 ;can we 'divide' again?
		BHI RD ; RD = repeated division
		mov r6,#9 ;move 9 into register to prepare for subtraction
		sub r7,r6,r4 ;subtract remainder from 9 as per check
		add r0,#1 ;add one as both good and bad scenarios need at least one in r0
        cmp r9,r7 ;does the calculated number match check digit? 
		beq good ;if valid jum
		add r0,#1 ;add another 1 if bad result
good
UPC 	DCB "013800150738" ;UPC string
		END