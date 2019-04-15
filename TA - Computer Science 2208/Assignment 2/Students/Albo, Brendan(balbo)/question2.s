		AREA Question2, CODE, READWRITE
		ENTRY
		
		LDR r0, =3		;Store value 3 in register 0
		BL Math			;Call subroutine Math
		ADD r1, r0, r0	;Double output value and store in register 1

Math	ADR r1, List	;Store list in register 1
		MOV r2, #4		;Store loop counter in register 2
		
		MOV r3, #0		;Clear register 3
		
		LDR r3, [r1], #4;Copy elements from register 1 to register 3
		ADD r3, r0, r0	;Calculate r0^2 in register 3
		SUBS r2, r2, #1	;Decrease counter by value 1
		
		LDR r4, [r1], #3;Copy elements from register 1 to register 4
		MUL r3, r3, r4	;Calculate a*r0^2 in register 3
		SUBS r2, r2, #1	;Decrease counter by value 1
		
		LDR r5, [r1], #2;Copy elements from register 1 to register 5
		MUL r5, r2, r0	;;Calculate b*r0 in register 5
		ADD r3, r3, r5	;Calculate a*r0^2 + b*r0 in register 3
		SUBS r2, r2, #1	;Decrease counter by value 1
		
		LDR r4, [r1], #1;Copy elements from register 1 to register 4
		ADD r3, r3, r4	;Calculate a*r0^2 + b*r0 + c in register 3
		
		CMP r6, r3		;Compare the output and d value
		BGE dOutput		;If yes, output is d
		
		MOV r4, r0		;If no, place y value in register 0
		
		BX lr			;Exit subroutine Math
		
dOutput	MOV r4, r0		;Place d value in register 0
		
		
List	DCD 5, 6, 7, 90
		
		END