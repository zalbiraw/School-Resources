			AREA assignment2,CODE, READWRITE
			ENTRY
			ADR R1, STRING;			put string into R1
			MOV R2, #0x00;			initialize R2
			MOV R7, #0;				initialize counter R7
			
COUNTER		LDRB R3,[R1,R7]; 		load the element into R3 from r1 pointed by r7
			ADD R7,R7,#1;			increase the counter
			CMP R2, R3; 			get the number of whole elments
			BNE COUNTER;			loop
			SUB R7,#1;
			ADD R8,R1,R7;
			BEQ LOOP;				if equal then goes to get the first element 
			
LOOP 		LDRB R3,[R1];			get the first element
			ADD R1,R1,#1;			increase the counter
			CMP R3, #0x41;			check if bigger than A
			BLT LOOP;				else goes to get next element
			CMP R3, #0x5A;			ccheck if more than Z
			BLT NEXT;				go to get the last element if is between A to Z
			CMP R3, #0x61;			check if more than a
			BLT LOOP;				else go to get the next element
			CMP R3, #0x7A;			check if smaller than z
			BLT CHANGING; 			if between a and z, change it into capital letter
			BGT LOOP;				else go to get another element.
			
CHANGING 	SUB R3,R3,#0x20;		change into capital letter
			B NEXT	
			
NEXT 		SUB R8,#1;				decrease the counter
			LDRB R5,[R8];			get the last element			
			CMP R5, #0x41; 			find the letter same with previous
			BLT NEXT
			CMP R5, #0x5A
			BLT THEN
			CMP R5, #0x61
			BLT NEXT
			CMP R5, #0x7A
			BLT CHANGING2
			BGT NEXT
			
CHANGING2 	SUB R5,R5,#0x20;		change into capital letter
			B THEN 
			
THEN 		CMP R3,R5;				compare the R3 and r5
			BNE NOTP;				if not same, then it's not palindrom
			CMP R8, #0xBC;			if same, compare R8 with 0xBC
			BEQ PALINDROM;			if equal, then it's palindrom
			BNE LOOP;				if not, back to loop get the next element
			

PALINDROM	MOV R0, #1									
			B EXIT															
NOTP		MOV R0, #2									
			B EXIT										
				
EXIT		B EXIT	

			AREA assignment2, DATA, READWRITE
STRING 		DCB "He lived as a devil, eh?"					;string
EoS 		DCB 0x00 										;end of string
			END
