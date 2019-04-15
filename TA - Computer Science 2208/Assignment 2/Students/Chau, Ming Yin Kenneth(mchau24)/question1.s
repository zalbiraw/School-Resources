		AREA question1, CODE, READONLY
		ENTRY
		LDR r0,SPACE  						;load r0 with space 
		LDR r1,THE							;load r0 with the 
		LDR r2,EoS							;load r2 with EoS
		LDR r3,STRING1  					;load r3 with STRING1

;------------------STARTING LOOP----------------------------
loop 	LDRB r5,[r3],#1		   				;This will be the loop that check if the next byte is space or EoS 
		CMP r5,r0							;This will check if the word have ended 
		CMPEQ r5,r1							;Compare the word and the
		MOVNE r4,r3							;This will move the byte if it is not equal to the
		MOV r5,#0							;reset r3
		CMP r5,r2							;Check if the byte equal to Eos
		ADD r5,r5,#2						;move the pointer to next byte so the loop will go on 
		BNE loop 							;The loop will end if it is EoS

;-------------------STORING ALL BYTE IN R4 to string 2------
		STR r4,STRING2						;Store the temporal byte to r4

;------------------DATA AREA--------------------------------
STRING1 DCB "and the man said they must go"	;String 1
SPACE   DCB " "								;This is the SPACE 
THE     DCB "the"							;this is the
EoS		DCB 0x00							;end of string 1
STRING2 space 0xFF							;just allocating 255 byte 
		END