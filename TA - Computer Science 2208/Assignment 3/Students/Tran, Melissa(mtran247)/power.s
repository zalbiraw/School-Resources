				AREA pow, CODE, READONLY							;here are the code directives 
				ENTRY												;here is beginning of the program					
				
				ADR sp, stackad		;(line 1)						;the address of the stack is set here. sp will point to the stackad address
				
				LDR r0, = parameterx	;(line 2)					;this will be the value of the base
				LDR r1, = parametern	;(line 3)					;this will be the value of the exponent 
				LDR r2, result			;(line 4)					;R will be what we will use to store the result. R will not always be a fixed
																	;value and therefore will be DCB instead of EQU
				
				STMEA sp!, {r0-r2}		;(line 5)					;I will be using the empty ascending stack because empty is easier to use and when you are using 
																	;an ascending stack then it will be harder to overwrite data
																	;we will store the registers r0-r2 which has the following x, n , and R values
				BL power				;(line 6)					;this will branch to the function 'power' 
				LDR r0, [sp, #neg_one]	;(line 7)					;neg one will decrement the pointer by one, and store what we have from the memory (stack) into r0 
				
				STR r0, result				;(line 8)					;the result from r0 will be stored into memory R 
				
spinning		B spinning				;(line 10)					;end the program here, as we have the value

power			STMEA sp!, {r0-r2, lr}	;(line 11)					;the linker register will point to the stack data, and then it will increment the pointer to the next address

				LDR r0, [sp, #par_x]	;(line 12)					;from the stack we are going to load the values x and n to the register so that we can
				
				LDR r1, [sp, #par_n]	;(line 13)					;compare the values
				
				CMP r1, #zero			;(line 14)					;we check here to see if it is zero. if it is zero we automatically know that it is
																	;one that is the answer. so we return 1 into the register r0
				MOVEQ r0, #one			;(line 15)					;as done in this line				
				BEQ end_func			;(line 16)					;branch if we get the right value, one, and we will end the function and branch to that address
																	; as we have found that answer.
				
				TST r1, #one			;(line 17)					;here we do a compare operator with a flag. we check to see if the exponent is a 1. if it is then we will
																	;branch to even
				BEQ even				;(line 18)
																	;here we continue the program if it is not even which means that n is an odd number
				SUB r1, #one			;(line 19)					;here we do exactly like the C program which was given to us. we sub
				STMEA sp!, {r0-r2}		;(line 20)					;everytime you do something with the registers you store the values back in again when you make adjustments 
				BL power				;(line 21)					;send the result back into the power function again in order to perform a recursion 
				LDR r2, [sp, #neg_one]	;(line 22)					;once we have recieved the value of r2. we have to make space for it and store it into the stack
				SUB sp, #rm_par			;(line 23)					;you make the stack point to the top of the stack and recieve the value 
				MUL r0, r2, r0			;(line 24)					;we multiply r2 and r0 because r0 contains the value from the previous recursive call 
				B end_func				;(line 25)					;branch to the end functtion where we will result the value 
										

even			LSR r1, #1				;(line 26)					;here we branch to the address of even
																	;we do a LSR because every even exponent is going to have an answer of half its exponent multiplied by half itself. 
																	;for example, 2^4 = (2^2)(2^2) , 3^2 = (3^1)(3^1)
																	;by recursion, once this number goes back into the subroutine it will multiply itself
				STMEA sp!, {r0-r2}		;(line 27)					;we will store this result back into the stack (memory)
				BL power				;(line 28)					;we will do a subroutine back into the power function 
				LDR r2, [sp, #neg_one]	;(line 29)					;point to the next value within the stack and store the result within r2 
				SUB sp, #rm_par			;(line 30)					;you subtract 12 from the from the pointer so that it points to the end of the stack
				MUL r0, r2, r2			;(line 31)					;after you are done the function you multiply all of the registers together and recieve the result. by resursion this is how it works. you get the result
																	;and you store the value within r0, which is the final result

																	;here is the function where when you are done, and found the result of the expression you will store the value and pop off the srtack here 
end_func		STR r0, [sp, #ret]		;(line 32)					;put the result, final answer, r0. We have currently 5 data within the stack, and so each address is by 4. if we want to go back to the top of the stack
																	;we must decrement 4x5 = 20, therefore -20 to the top of the stack because we also have an empty ascending stack which increases as we move downwards
				LDMEA sp!, {r0-r2, pc}	;(line 33)					;we begin popping the stack as we are done with the function 
				
				AREA pow, DATA, READWRITE							;here are the code directives for the data

result			DCD 0												;the result of the R into here. We do DCD  instead because the value can be anything and it is not a fixed defined value						
stackad			SPACE 0xF00											;this is the address at which we store the stack

parameterx		EQU	5												;parameter x is here,it is the base, we use 5 as the value 
parametern		EQU	4												;parameter n is here, is the exponent, we use 4 as the value here 
one				EQU	1												;we use this for testing to see if n the exponent is a 1
zero			EQU 0												;zero here is used to check to see if n is a zero
neg_one			EQU -4												;neg one means that we must decrement the address by one adress, which is essentially -4 which is the size of the word. there are 4 bytes in 32 bits
par_x			EQU -28												;x is exactly below n , and therefore we will get x value using this literal and decremtation
par_n			EQU -24												;n is exactly above x, and therefore we will get the n value using this literal and decrementation
ret				EQU -20												;this is used to go to the top of the stop again. 20 because there are 5 items in the registerx 4 words = 20. we must decreement because we are at the bottom
rm_par			EQU 12												;you remove r0, r1, r2 from the stack using this literal 
				
				END													;here is the end of the the program