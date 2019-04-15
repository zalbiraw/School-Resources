    AREA Question3, CODE, READONLY
        ENTRY

        LDR R0,x            ;Load the x value to R0
        ADR SP,stack         ;define the stack
        BL Func              ;call the subroutine
        MOV R1,R0,LSL#1      ;double the returned value
loop    B loop             ;infinite loop

Func    STMFD SP!,{R1-R6,LR} ;save R1-R6, as well as LR
        ADR R1,a             ;Store the address of parameter a in R1
        LDMFD R1,{R3-R6}     ;load all the coefficients (a-d) to R3-R6
        MLA R2,R3,R0,R4      ;R2 <--  ax+b
        MLA R1,R2,R0,R5      ;R1 <--  a(ax+b)+d
        CMP R1,R6            ;test if the result is greater than d
        MOVGT R0,R6          ;return d, if R0 > d
        MOVLE R0,R1          ;otherwise, return the calculated value
        LDMFD SP!,{R1-R6,PC} ;load the saved register back and return

    AREA Question3, DATA, READWRITE
a       DCD 5                ;variable a value
b       DCD 6                ;variable b value
c       DCD 7                ;variable c value
d       DCD 50               ;variable d value
x		DCD 3
        space 0x20           ;Stack body
stack   DCD 0x00             ;TOS

        END
