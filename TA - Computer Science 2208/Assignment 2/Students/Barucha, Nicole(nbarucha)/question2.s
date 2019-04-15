			AREA ques2, CODE, READONLY
			ENTRY
			
exit		B exit				;exits program
			
			AREA ques2, DATA, READWRITE
			
a			DCD 5				;define value of a
b			DCD 6				;define value of b 
c			DCD 7				;define value of c
d			DCD 90				;define value of d

			END