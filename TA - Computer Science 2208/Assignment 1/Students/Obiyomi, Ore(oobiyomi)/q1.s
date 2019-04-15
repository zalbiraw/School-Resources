		AREA q1, CODE, READONLY
		ENTRY
		mov  r0, #0			; set 0 in register r0 (the counter)
		ldr  r1, =UPC		; add string to register r1
Sums 	add  r0, r0, #2		; counts that two numbers will be added
		ldrb r2, [r1], #1	; move string along, get the next character
		sub  r2, r2, #48	; change chars to number
		add  r4, r4, r2		; add odd numbers to the totals of the first sum
		cmp  r0, #12		; check to see if its the 12th number/check digit
		beq  chkd			; if check digit, set it as the next step
		ldrb r3, [r1], #1	; else, check the next character
		sub  r3, r3, #48	; change character to number
		add  r5, r5, r3		; add even numbers to the totals of the second sum
		B Sums
		
chkd	ldrb r12, [r1], #1	; save check digit in a separate register
		sub  r12, r12, #48	; change check digit character to number
		
		add  r3, r4, r4		; r3 = 2 * r4, double the first sum
		add  r1, r4, r3		; r1 = r4 + r3, double the first sum plus r4, which is triple the first sum
		add  r1, r1, r5		; add tripled first sum to the second sum
		sub  r1, r1, #1		; subtract 1 from the total
		
loop	subs r1, r1, #10	; subtract 10 repeatedly
		bpl loop			; loop and subtract 10 until negative
		add r1, r1, #10		; when negative, add 10 to make it positive again
		B check				; division complete
		
check	mov r11, #9			; set 9 in register r11
		sub r2, r11, r1		; subtract 9 from r11
		cmp r12, r2			; check to see if result is the same as check digit
		beq true			; if numbers are the same, go to true
		B false				; else go to false
		
true	mov r0, #1			; if UPC is valid, set 1 to register r0
false	mov r0, #0			; if UPC is not valid, set 0 to register r0

stop	B stop

UPC		DCB	"013800150738"	; upc string
EoS		DCB 0x00			; end of string
		END
