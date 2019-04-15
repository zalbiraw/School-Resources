AREA  Quest1, CODE, READONLY
	ENTRY
	ADR     r1, UPC        ;move the upc code into r0
	MOV     r2, #5         ;set loop counter to 5
lop LDRB    r5, [r1], #1   ;load one byte from memory into r4 and increment adress
	SUB     r5, #0x30      ;convert string to integer
	ADD     r3, r3, r5     ;add the loaded byte into sum1
	LDRB    r5, [r1], #1   ;load another byte from memory into r4
	SUB     r5, #0x30      ;convert string to integer
	ADD     r4, r4, r5     ;add the loaded byte into sum2
	SUBS    r2, #1         ;decrement counter
	BNE     lop
	LDRB    r5, [r1], #1   ;load the next byte from memory into r4
	SUB     r5, #0x30      ;convert string to an integer value
	ADD     r3, r3, r5     ;add to sum1
	ADD     r3, r3, LSL #1 ;multiply sum1 by three by adding it to a left shifted version of itself
	ADD     r3, r4, r3     ;add the sums together 
	SUB     r3, r3, #1     ;subtract 1 from the sum
dv  SUBS    r3, #10        ;loop to do division
	BPL     dv             ;retrun to the top fo the loop untill it is negative
	ADD     r3, r3, #10    ;add back ten to get to the reaminder
	RSB     r3, r3, #9     ;subtract r3 from 9
	LDRB    r5, [r1]       ;load the final value into the register
	SUB     r5, #0x30      ;convert the symbol into an integer
	CMP     r3, r5         ;compare the last item with the sum generate
	MOVEQ   r0, #1         ;store 1 in r0 if it is a proper code
	MOVNE   r0, #2         ;if it isnt a proper code 0 is already stored in r0
	 
	
UPC DCB "160383758783"
	END
