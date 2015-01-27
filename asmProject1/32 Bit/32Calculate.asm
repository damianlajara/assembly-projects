; Damian Lajara
; Assembly Project

COMMENT @
2) Arithmetic Operations
	a) Use only ADD, SUB, INC, DEC and NEG operations in the source code
	b) Prompt the user for the values of A, B, C, Length, Width
	c) Write the source code that performs each of the following manipulations:
		A = B-A
		A = -(A+1)
		C = A + B
		B = 3B + 7
		A = A - A - 1
		A = B - A - 1
		C = 2A + 2B
		A = A - 2B + 4c
		D = 2(-A + B -1) + C
		Perimeter = 2*Length + 2*Width
		Area = Length * Width
	d) (Extra Credit) - Write the source code that repeatedly prompts for the values of A, B, C, Length and Width and then performs the calculations in (2c)
@
INCLUDE Irvine32.inc
.386
.stack 4096
ExitProcess proto,dwExitCode:dword; //prototype

.data? ;uninitialized variables
;Using SDWORD for 32-bit signed variables so it can be stored in the registers
Perimeter SDWORD ?
A		  SDWORD ?
B 	      SDWORD ?
Cv		  SDWORD ?
D		  SDWORD ?
Lengths   SDWORD ?
Widths    SDWORD ?
Area      SDWORD ?

.data ;initialized variables

promptA BYTE "Input the value for A: ", 0
promptB BYTE "Input the value for B: ", 0
promptC BYTE "Input the value for C: ", 0
promptLength BYTE "Input the value for Length: ", 0
promptWidth BYTE "Input the value for Width: ", 0

promptEquation1 BYTE "A = B-A = ", 0
promptEquation2 BYTE "A = -(A+1) = ", 0
promptEquation3 BYTE "C = A+B = ", 0
promptEquation4 BYTE "B = 3B+7 = ", 0
promptEquation5 BYTE "A = A-A-1 = ", 0
promptEquation6 BYTE "A = B-A-1 = ", 0
promptEquation7 BYTE "C = 2A+2B = ", 0
promptEquation8 BYTE "A = A-2B+4C = ", 0
promptEquation9 BYTE "D = 2(-A+B-1)+C = ", 0
promptEquation10 BYTE "Perimeter = 2*Length+2*Width = ", 0
promptEquation11 BYTE "Area = Length*Width = ", 0

.code
	;custom function
	Calculate PROC

		; //Prompt the user for A
		mov edx, offset promptA; //move the string into the edx register
		call writeString; //prints the edx register

		; //Get user's input for A
		call readInt; //reads the first number(sign is optional) entered on the keyboard and returns the number in the eax register
		mov A, eax; //make lInitial equal to the character the user entered

		; //Prompt the user for B
		mov edx, offset promptB; //move the string into the edx register
		call writeString; //prints the edx register

		; //Get user's input for B
		call readInt; //reads the first number(sign is optional) entered on the keyboard and returns the number in the eax register
		mov B, eax; //make lInitial equal to the character the user entered

		; //Prompt the user for C
		mov edx, offset promptC; //move the string into the edx register
		call writeString; //prints the edx register

		; //Get user's input for C
		call readInt; //reads the first number(sign is optional) entered on the keyboard and returns the number in the eax register
		mov Cv, eax; //make lInitial equal to the character the user entered

		;//Prompt the user for Length
		mov edx, offset promptLength; //move the string into the edx register
		call writeString; //prints the edx register

		; //Get user's input for Length
		call readInt; //reads the first number(sign is optional) entered on the keyboard and returns the number in the eax register
		mov Lengths, eax; //make lInitial equal to the character the user entered

		; //Prompt the user for Width
		mov edx, offset promptWidth; //move the string into the edx register
		call writeString; //prints the edx register

		; //Get user's input for Width
		call readInt; //reads the first number(sign is optional) entered on the keyboard and returns the number in the eax register
		mov Widths, eax; //make lInitial equal to the character the user entered
		call crlf;
		
		;call dumpregs; //debugging - prints out register contents
		;xor eax, eax; //zero out eax

		;A = B-A
		mov edx, offset promptEquation1;
		call writeString;
		mov eax, B;
		sub eax, A; // B - A
		mov A, eax; //A = B - A
		call writeInt; //debug maybe writeDec
		call crlf;

		;A = -(A+1)
		mov edx, offset promptEquation2;
		call writeString;
		inc eax; //eax = eax++ = A + 1
		neg eax; //-(eax) = -6
		mov A, eax; //A = -(A+1) = -6
		call writeInt; //displays eax register
		call crlf;

		;C = A+B
		mov edx, offset promptEquation3;
		call writeString;
		add eax, B; // A+B
		mov Cv, eax; //C = A+B
		call writeInt;
		call crlf;

		;B = 3B + 7
		mov edx, offset promptEquation4;
		call writeString;
		mov eax, B;
		add eax, B; //B+B
		add eax, B; //B+B + B
		add eax, 7; //B+B + B + 7
		mov B, eax; ////B = B + B + B + 7
		call writeInt;
		call crlf;

		;A = A - A - 1
		mov edx, offset promptEquation5;
		call writeString;
		mov eax, A;
		sub eax, A; //A - A
		dec eax; //A - A - 1
		mov A, eax; // A = A - A - 1
		call writeInt;
		call crlf;

		;A = B - A - 1
		mov edx, offset promptEquation6;
		call writeString;
		mov eax, B;
		sub eax, A; //B-A
		dec eax; //B - A - 1
		mov A, eax; //A = B - A - 1
		call writeInt;
		call crlf;
	 
		;C = 2A + 2B
		mov edx, offset promptEquation7;
		call writeString;
		mov eax, A;
		mov edx, B;
		add eax, A; //2A
		add edx, B; //2B
		add eax, edx; //2A + 2B
		mov Cv, eax; // C = 2A + 2B
		call writeInt;
		call crlf;

		;A = A - 2B + 4c
		mov edx, offset promptEquation8;
		call writeString;
		mov edx, B;
		add edx, B; //2B
		mov ebx, Cv;
		add ebx, Cv; //2c
		add ebx, Cv; //3c
		add ebx, Cv; //4c
		mov eax, A;
		sub eax, edx; //A-2B
		add eax, ebx; // A-2B + 4C
		mov A, eax; //A = A-2B + 4C
		call writeInt;
		call crlf;

		;D = 2(-A +B-1) + C
		mov edx, offset promptEquation9;
		call writeString;
		neg eax; //-A
		add eax, B; //-A + B
		dec eax; //-A + B -1
		add eax, eax; //2(-A + B -1)
		add eax, Cv; //2(-A + B -1) + C
		mov D, eax; //D = 2(-A + B -1) + C
		call writeInt;
		call crlf;

		;Perimeter = 2*Length + 2*Width
		mov edx, offset promptEquation10;
		call writeString;
		mov eax, Lengths;
		mov edx, Widths; 
		add eax, Lengths; //2*Length
		add edx, Widths; //2*Width
		add eax, edx; //2*Length + 2*Width
		mov Perimeter, eax; //Perimeter = 2*Length + 2*Width
		call writeInt;
		call crlf;

		;Area = Length * Width
		mov edx, offset promptEquation11;
		call writeString;
		mov eax, Lengths;
		mov edx, Widths;
		cmp eax, edx; //figure out which is greater
		jg eaxIsGreater; //if left > right, then go to eaxIsGreater (jg -jump if greater, is only for signed numbers)
		jl edxIsGreater; //if left < right, then go to edxIsGreater (jl -jump if less, is only for signed numbers)
		eaxIsGreater:
			mov ecx, edx; //move smallest to ecx
			mov ebx, eax; //move biggest to ebx
			jmp next;
		edxIsGreater:
			mov ecx, eax; //move smallest to ecx
			mov ebx, edx; //move biggest to ebx
			jmp next;
		next:
			xor eax, eax; //zero out eax
			areaLoop:; //start of loop
				add eax, ebx; //keep adding x for y times = x*y
			loop areaLoop; //loop again until ecx == 0
			;Loop finished, print out eax register with result
			mov Area, eax; //store result in area
			call writeInt;
			call crlf;
			call crlf;

		COMMENT @
		;Another way of doing the above statements for (Area = Length * Width) using directives like .IF and .ENDIF, etc
		;put the smallest number in ecx, and biggest in ebx
		.IF eax > edx
			mov ecx, edx;
			mov ebx, eax;
		.ELSE 
			mov ecx, eax;
			mov ebx, edx;
		.ENDIF

		xor eax, eax; //zero out eax

		;adding x for y times = x*y
		.WHILE ecx > 0
			add eax, ebx; //edx not ebx
			dec ecx;
		.ENDW
		mov Area, eax; //store result in area
		@

		ret; //return from function

	Calculate ENDP; //end proc

;Main function(like the main.cpp in c++)
main proc
	call Calculate; //call custom function(PROC or PROCEDURE) 
	extraCredit:
		call Calculate;
		jmp extraCredit; //infinite loop repeatedly asking for the values of A,B,C, Length and Width
	invoke ExitProcess,0
main endp
end main