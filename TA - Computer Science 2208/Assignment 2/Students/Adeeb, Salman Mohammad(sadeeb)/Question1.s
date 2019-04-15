			AREA	Asn3q2,	CODE,	READONLY
			ENTRY
			;Salman
			
		
			ADR r0, STRING1		; String that is grabbed by pointer
			ADR r2, EoS		
			ADR r1, STRING2		
			MOV r4, #1          ; points to the null ref
			ADD r1, R4 			; adding a byte to null 
			MOV r3, #116		;coparing to t with the value for ascii 
			MOV r5, #104		;used to compare with h later
			MOV r6, #101		;used to check for e
			MOV r7, #32			;space
			MOV r8, #12			; move pointer by 3
			
			BL 	Loop			; Go to loop
			
Loop		LDRB  r1, [r0], r4	; load a part of string, first string
			CMP	  r1, r2		; compare r1 and r2
			BEQ   Done			  
			BNE	  CHECKT		;check if its T 
CHECKT		CMP   r1, r3		 compare r1 to t 
			BEQ   CompTH		
			BNE   Invent		;invenetory for stack 
CompTH		LDRB r1, [r0], r4	;comparing t and h, loadign the next 
			CMP r1, r5			;check to see if its h
			BEQ CompHE			;is it h ? go to the next
			BNE	Invent			
CompHE		LDRB r1, [r0], r4	;....
			CMP r1, r6 			
			BEQ	EMPTY			
			BNE Invent			
EMPTY		LDRB r1, [r0], r4	; check if its blank, same process as before
			CMP r1, r8			 
			BEQ	CHECKTHE		 
			BNE null			 
null		CMP r1, r2			 
			BEQ CHECKTHE		 
			BNE Invent			 
Invent		LDRB r1, [r0], r4	; inventory
			CMP r1, r2			; compare and store 
			BEQ	Done			 
			BNE	Loop			
CHECKTHE	ADD r1, r8			;check the, same process as before as well
			BL Invent			 
			B  	Done			; if its the then its doen
Done		B	Done			 

STRING1 DCB "and the man said they must go" 	; first string
EoS 	DCB 0x00 								; string end
STRING2 space 0xFF								; string 2 is the same as 1 without the			

		END
