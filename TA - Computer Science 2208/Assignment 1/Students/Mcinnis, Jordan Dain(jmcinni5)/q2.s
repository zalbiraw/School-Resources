		AREA Question2, CODE, READONLY
		ENTRY ;SEE FLOWCHART FOR DETAILED COMMENTS OF CERTAIN STEPS
		ADR r1, STRING ;Store reference to starting point of string
		ADR r2, EoS		;store reference to ending point of string
Nr3		LDRB r3,[r1],#1 ;Normlize register 3, the first comparative
		CMP r3, #90 ;is the letter possibly a lowercase?
		BLE Skip ; skip if not possibly lowercase
		SUB r3, #32 ; make the possible lowercase into possible upercase
Skip	CMP r3, #65 ; is the possible upper case an upper case letter?
		BGE Nr4 ;it is!
		B Nr3 ;it isn't so ignore and get a new letter
Nr4     SUB r2,r2,#1 ;subtract one from end of string reference so we are looking at the end up string -1 character
		LDRB r4,[r2] ;load character
		CMP r4, #90 ;see above
		BLE Skip2 ;see above
		SUB r4, #32 ;...
Skip2	CMP r4, #65 ;...
		BGE Normal  ;is a letter, so bother registers are normalized!
		B Nr4 ;get a new letter
Normal  CMP r1,r2 ;check to make sure the entire string hasn't been checked yet
		BGE done ;if the string has been fully checked, then it is a palindrome
		CMP r3,r4 ;if more of string left to check, compare two most recent character
		BEQ Nr3 ;if equal grab the next two
		ADD r0, #1 ; not equal so add one to flag the word isn't and go to end
done    ADD r0, #1 ; add 1 to signal either it is, or isn't a palindrome
STRING  DCB "He lived as a devil, eh?" ;string to test
EoS     DCB 0x00 ;end of string 
		END