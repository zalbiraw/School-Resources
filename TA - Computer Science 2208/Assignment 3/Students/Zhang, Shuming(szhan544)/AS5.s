	AREA AS3_power, CODE, READONLY
	ENTRY
	MOV sp,#0x10000 ;set up stack pointer
	MOV fp,#0xFFFFFFFF ;set up dummy fp for tracing
	B main ;jump to the function main
power 	SUB sp,sp,#4 ;Create stack frame: decrement sp
		STR fp,[sp] ;push the frame pointer on the stack
		MOV fp,sp ;frame pointer points at the base
result	LDR r9,[fp,#-4]
		SUB sp,sp,#4 ;move sp up 4 bytes for result
		LDR r2,[fp,#4] ;get parameter n from the stack
		LDR r3,[fp,#8] ;get parameter x from the stack
		CMP r2,#0 ;if (n==0)
		BEQ return_1
		LDR r1,[r2] ;if (n & 1) OR if (n%2==1)
		AND r1, #2_0000000000000001
		CMP r1,#1
		BEQ return_A
		MOV r0,r2,LSR #1 ;else
		B power
		MUL r10,r9,r9
		STR r10,[r9]
		B over
return_1 STR r1,[r9] ;store in result
		B over
return_A SUB r2,r2,#1
		STR r2,[fp,#4]
		 B power;return x * power(x, n - 1);
over	MOV sp,fp ;Collapse stack frame created for computing result, restore the stack pointer 
		LDR fp,[sp] ;restore old frame pointer from stack
		ADD sp,sp,#4 ;move stack pointer down 4 bytes
		MOV pc,lr ;return by loading LR into PC
main ;Create stack frame in main for x, n
	SUB sp,sp,#4 ;move the stack pointer up
	STR fp,[sp] ;push the frame pointer on the stack
	MOV fp,sp ;the frame pointer points at the base;
	SUB sp,sp,#8 ;move sp up 8 bytes for 2 integers
	MOV r0,#2 ;x = 2
	STR r0,[fp,#-4] ;put x in stack frame	
	MOV r0,#3 ;y = 3
	STR r0,[fp,#-8] ;put n in stack frame
	LDR r0,[fp,#-8] ;get n from stack frame
	STR r0,[sp,#-4]! ;push n on stack
	LDR r0,[fp,#-4] ;get x from stack frame
	STR r0,[sp,#-4]! ;push x on stack
	BL power ;call power, save return address in LR
	ADD sp,sp,#8 ;Clean the stack from the parameters
	MOV sp,fp ;restore the stack pointer
	LDR fp,[sp] ;restore old frame pointer from stack
	ADD sp,sp,#4 ;move stack pointer down 4 bytes
	END