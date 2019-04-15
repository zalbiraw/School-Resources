        ENTRY

Start   ADR r0, STRING1
        ADR r1, EoS
        ADR r2, STRING2
        ADR r3, STRING0
        MOV r5, #0 
        MOV r7, #0

        LDRB r4, [r0]
        CMP r4, #'t'
        MOV r5, #1
        ADDEQ r0, r0, #1
        MOVEQ r7, #1
        BEQ TEST

Loop    CMP r1, r0                          ;compare pointers
        BLE True                            ;when the pointers are equal or r0 > r1, the execution is complete

        LDRB r4, [r0]                       ;load r4 with a character of source string
        
        B TEST                              ;test to see if the word is " the "


TEST    LDRB r6, [r3, r5]                   ;load and test character specified by test register
        CMP r6, r3

        ADDEQ r0, r0, #1                    ;if character is equal move first strings pointer by one, and move test register by one
        ADDEQ r5, r5, #1
        

        CMP r5, #4                          ;if test passed go to done
        BEQ DONE


        CMP r1, r0                          ;if Eos encountered in test go to store
    

        CMPEQ r5, #3                        ;check for odd case of "... the"
        BEQ DONE                            ;if EOS and odd case dont flush
        BNE STORE                           ;if only EOS flush

        BEQ TEST                            ;if character is equal continue test
        

STORE   CMP r5, #0                          ;check if you have previously tested characters that need to be flushed to new string
        BEQ FLUSH                           ;if more than one character tested without storage go to flush
        STRB r4,[r2]                        ;other wise store 1 character in new string
        ADD r2, r2, #1                      ;move destination string address one byte
        MOV r5, #0                          ;reset test register
        ADD r0, r0, #1                      ;move source string pointer by 1 byte
        B Loop                              ;jump to loop

FLUSH   CMP r5, #0
        BEQ Loop                            ;prevent last ' ' from being flushed and exit requirement
        
        CMP r7, #1                          ;check for odd case "the ..."
        ADDEQ r3, r3, #1                    ;if odd case skip first ' ' from being flushed
        MOVEQ r7, #0                        ;after odd case detected set flag to 0
        
        STRB r3, [r2]                       ;flush value
        
        ADD r3, r3, #1                      ;move test string pointer
        SUBS r5, r5, #1                     ;decrease test register
        ADREQ r3, STRING0                   ;reset test string pointer after flush
        BEQ Loop                            ;jump to loop 


DONE    B DONE                              ;exit simulation

STRING0 DCB " the "                         ;test string
STRING1 DCB "and the man said they must go" ;String1
EoS DCB 0x00                                ;end of string1
STRING2 space 0xFF                          ;just allocating 255 bytes 

