		AREA q_two, CODE, READONLY
		ENTRY
		ADR		r0, String				; Start of String in r0
		ADR		r1, EoS					; EoS in r1
fwd		CMP		r0, r1					; Compare start and end of String
		BGT		pass					; If r0 > r1
		LDRB	r2, [r0, #1]!			; Load start of String char into r2, increment
		CMP		r2, #65					; Check if less than ASCII value 65
		BLT		fwd						; If less than 0, get next char
bwd		LDRB	r3, [r1, #-1]!			; Load EoS char into r3 and decrement
		CMP		r3, #65					; Check if less than ASCII value 65
		BLT		bwd						; If less than 0, get next char
		CMP		r2, #97					; Check if letter is lowercase
		ADDLT	r2, #32					; If uppercase, convert to lowercase
		CMP		r3, #97					; Check if letter is lowercase
		ADDLT	r3, #32					; If uppercase, convert to lowercase
		CMP		r2, r3					; Compare the chars in r2 and r3
		MOV 	r4, #1					; Store a valid code in r4
		BEQ		fwd						; If they are equal, go to next char
		MOV 	r4, #2					; Store an invalid code in r4
pass	CMP		r4, #0					; Compare valid code in r4 to 0
		MOVNE	r0, r4					; If compare result not 0, use existing valid code
		MOVEQ	r0, #2					; If compare result is 0, set code to 'not valid'
loop	B		loop		
		
		AREA q_two, DATA, READWRITE
String	DCB	"He lived as a devil, eh?"	; string
EoS		DCB	0x00						; end of string
		END