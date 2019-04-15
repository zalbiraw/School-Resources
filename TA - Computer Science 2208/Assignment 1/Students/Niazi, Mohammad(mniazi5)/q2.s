	AREA palindrome, CODE, READONLY

SWI_Exit EQU 0x11

      ENTRY

start

      LDR   r0,=string

      MOV   r1,r0

loop  LDRB  r2,[r1],#1

      CMP   r2,#0

      BNE   loop

      SUB   r1,r1,#2

      BL    pal

stop  SWI   SWI_Exit

 

pal   MOV   r10,#0x0

again LDRB  r3,[r0] ;get characters and update pointers

      LDRB  r4,[r1]

      CMP   r3,r4 ;compare characters

      BNE   notpal ;if different then fail

 

      CMP   r0,r1 ;next 4 lines find the middle for the phrase

      BEQ   waspal

      ADD   r2,r0,#1

      CMP   r2,r1

      BEQ   waspal

      ADD   r0,r0,#1

      SUB   r1,r1,#1

      B     again

 

waspal      MOV   r0,#1

notpal      MOV   r0,#2

 

string      DCB   "He lived as a devil, eh?",0

      END