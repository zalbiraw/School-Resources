	AREA Assign3Q1, CODE, READONLY
	ENTRY
start
      LDR r0,=STRING	;Load reference to string address into reg1
      MOV r1,r0 		;Load same reference into reg2
						;Register 1 will be the "n" address, counting forward through the word
						;Reg 2 will be the "length-m" address, counting backwards through the word
						;If they meet in the middle without finding any non matching characters while travelling, it is a palindrome
loop  LDRB r2,[r1],#1 	;Load a byte into r2 from STRING and move r1 to the next address
      CMP r2,#0x00 		;See if r1 is at the end of the string
      BNE loop 			;if it isn't keep looking until r1 is
      SUB r1,r1,#2 		;Move back r1 to be on the string after it traverses to the null character
again LDRB r3,[r0] 		;Load the current position of r0 (n) onto r3
	  SUB r3, r3, #65 	;Check if r3 is before the capital letters in ASCII (and therefore not a letter)
	  CMP r3, #0
	  BLT nextf 		;if it is a not a letter move r1 forward and check again for a letter
	  SUB r3, r3, #25	;Check if r3 is a Capital letter
	  CMP r3, #0
	  BLE fixseta		;If it is a capital move on from this loop
	  SUB r3, r3, #7 	;Check if it's a symbol between Capitals and Lowercase in ASCII
	  CMP r3, #0
	  BLT nextf 		;if it is a not a letter move r1 forward and check again for a letter
	  SUB r3, r3, #25 	;Check if it's a symbol after the Lowercase letters in ASCII
	  CMP r3, #0
	  BGT nextf 		;if it is a not a letter move r1 forward and check again for a letter
	ADD r3, r3, #25  	;If it reaches here it is a lowercase letter, add back 25 subtracted before
seta
	LDRB r4,[r1] 		;This follows the exact same process except for the character that is (length-m) in the string
	SUB r4, r4, #65
	  CMP r4, #0
	  BLT nextb 		;Also instead of moving forward upon finding a non-letter, it of course moves further back
	  SUB r4, r4, #25
	  CMP r4, #0
	  BLE fixsetb
	  SUB r4, r4, #7
	  CMP r4, #0
	  BLT nextb
	  SUB r4, r4, #25
	  CMP r4, #0
	  BGT nextb
	  ADD r4, r4, #25
set
      CMP r3,r4 		;Compare the numerical alphabet values of 3 and 4
      BNE not 			;If they are not equal, it is not a palindrome
      CMP r0,r1 
      BEQ ispal 		;If they have reached the middle of the word, all letters were checked and it is a palindrome
      ADD r2,r0,#1 ;
      CMP r2,r1 		;This is the even number check - if a palindrome has an even number of letters they won't meet in the middle without it
      BEQ ispal 		;If they have reached the middle of the word, all letters were checked and it is a palindrome
      ADD r0,r0,#1 		;Move the (n) index forward
      SUB r1,r1,#1 		;Move the (length-m) index backward
      B again 			;loop until a solution is found
ispal	MOV r0,#1 		;It is a palindrome, set r0 to 1 and end program
		B stop
not		MOV r0,#2 		;It is not a palindrome, set r0 to 2 and end program
stop	B stop 			;end loop
nextf	ADD r0,r0,#1 	;This moves the (n) index forward when a letter isn't found
	B again
nextb	SUB r1,r1,#1 	;This moves the (length-m) index backward when a letter isn't found
	B seta
fixseta	ADD r3, r3, #25 ;This corrects an uppercase letter from being negative once it is found 
	B seta
fixsetb ADD r4, r4, #25 ;This corrects an uppercase letter from being negative once it is found 
	B set
STRING DCB "He lived as a devil, eh?" ;Palindrome String
EoS	DCB 0x00 ;end of string
	END
		