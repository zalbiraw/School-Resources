         AREA Question2, CODE, READONLY
         ENTRY

t         EQU 0x74          ;ASCII value of t
h         EQU 0x68          ;ASCII value of h
e         EQU 0x65          ;ASCII value of e
NULL      EQU 0x00          ;ASCII value of NULL
SPACE     EQU 0x20          ;ASCII value of SPACE

         ADR r0, String1    ;Load address of string 1
         ADR r1, String2    ;Load address of string 2

         LDRB r2, [r0]      ;Load first character
         CMP r2, #t         ;is it t
         ADDEQ r0,r0,#1     ;  only increment the pointer if it is t
         MOVEQ r4, r0       ;  set a temperorary pointer if it is t
         BEQ checkH         ;  go to check the h if it is t

NextChar LDRB r2, [r0],#1   ;Check the space
         CMP r2, #SPACE
         BNE notThe
         STRB r2, [r1],#1

         LDRB r2, [r0],#1   ;check the t
         CMP r2, #t
         BNE notThe
         MOV r4, r0

checkH   LDRB r3, [r4],#1   ;check the h
         CMP r3, #h
         BNE notThe

         LDRB r3, [r4],#1   ;check the e
         CMP r3, #e
         BNE notThe

         LDRB r3, [r4]     ;check the terminator
         CMP r3, #SPACE
         CMPNE r3, #NULL
         MOVEQ r0, r4
         BEQ NextChar

notThe   STRB r2, [r1],#1 ;write a letter to the output
         CMP r2, #NULL
         BNE NextChar

Infin    B Infin

         AREA Question2, DATA, READWRITE

         ALIGN
String1  DCB "these the clothes"
EoS      DCB NULL
         ALIGN
String2  SPACE 0xFF

         END