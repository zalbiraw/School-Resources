		AREA q2, CODE, READONLY
		ENTRY
		ldr  r1, =string				; load string to register r1
		mov  r10, #0					; move 0 to r10 (counter)
count	ldrb r2, [r1], #1				; move to next character in string
		cmp  r2, #EoS					; check if there are characters left
		beq counter						; count the number of letters in the string
		B check							; check if it is a letter
		
check	cmp  r2, #97					; check if ascii value is lower than 97
		add  r2, r2, #22				; if the ascii value is lower than 97 add 22
		subs r2, r2, #97				; checks if the ascii value is still lower than 97
		bmi count						; if number is lower than 97, then not a letter
		add  r2, r2, #97				; reverse earlier subtraction
		subs r2, r2, #122				; if the number is greater than 122, then not a latter
		bpl count						; move to the next character
		add  r2, r2, #122				; reverse the earlier subtraction
		add  r12, r12, #1				; put total number of letters in string in r12
		B count
		
counter	add  r3, r3, #1					; counter for number of letters to test in string
		add  r11, r11, #2				; increase number to match letters
		subs r12, r12, #2				; reduce number of letters in string two at a time
		bpl counter						; if letters still remain, reduce total and add to counter
		subs r3, r3, #1					; reduce counter by one, last one not counted
		B start
		
start	ldr r1, =string					; take string and load it to r1
		mov r5, #0						; reset count to 0
		mov r7, #0						; reset count to 0
		cmp r3, r10						; check that count is not reached
		beq true						; if they are the same, it is a palinedrome, else continue
		B gnc							; get next character to check
		
gnc		ldrb  r4, [r1], #1				; get next character
		cmp   r4, #97					; check if ascii value is lower than 97
		add   r4, r4, #22				; if lower, add 22
		subs  r4, r4, #97				; check if ascii value is still lower than 97
		bmi gnc							; if still lower, then not a letter
		add   r4, r4, #97				; reverse earlier subtraction
		subs  r4, r4, #122				; if number was greater than 122, then not a letter
		bpl gnc							; move to next character
		add   r4, r4, #122				; reverse earlier subtraction
		cmp   r10, #5					; compare number of times gone through to number of times required
		beq gcc							; when number of times match, move on
		add   r5, r5, #1				; increase count by 1
		B gnc							; get the character to compare it to
		
gcc		ldrb  r6, [r1], #1				; moves string along, and get next character
		cmp   r6, #97					; check if ascii value is lower than 97
		add   r6, r6, #22				; if lower, then add 22
		subs  r6, r6, #97				; check if ascii value is still lower than 97
		bmi gcc							; if still lower, then not a letter
		add   r6, r6, #97				; revert earlier subtraction
		subs  r6, r6, #122				; if number was greater than 122, it wasn't a letter
		bmi gcc							; move to next character
		add   r6, r6, #122				; reverse earlier subtractoin
		cmp   r11, r7					; compare number of times gone through to number of time required
		beq gcc							; when number of times match, move on
		add   r7, r7, #1				; increase count by 1
		B comp							; get the character to compare it to

comp	cmp r4, r6						; compare two letters
		bne false						; string not a palindrome
		sub r11, r11, #1				; reducing number required to get last character
		add r10, r10, #1				; increasing matching of letters by 1
		B start							; go back to matching letters
		
true	mov r0, #1						; if a palindrome, set 1 in register r0
false	mov r1, #0						; if not a palindrome, set 0 in register r0

stop	B stop

string	dcb "He lived as a devil, eh?"	; text string
EoS		dcb 0x00						; end of string
		END
