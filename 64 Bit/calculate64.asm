WriteInt64 PROTO; //Displays RAX register
ReadInt64 PROTO; //returns value into RAX reg
WriteString PROTO; //rdx
ReadString PROTO; //input buffer in rdx, rcx the max nums user can input +1, returns count in rax of numbers typed
Crlf PROTO;

ExitProcess PROTO
; do not need cpu designator(.386, etc) or model for 64 bit programming

.data? ; uninitialized variables
Perimeter SQWORD ?
D		  SQWORD ?
Area      SQWORD ?

.data
; qword for 64 bit machine
sum qword 0
A		  SQWORD 5
B 	      SQWORD 10
Cv		  SQWORD 15
Lengths   SQWORD 20
Widths    SQWORD 25

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
Calculate64 PROC
	; //Prompt the user for A
	mov rdx, offset promptA;
	call writeString;

	; //Get user's input for A
	call ReadInt64;
	mov A, rax;

	; //Prompt the user for B
	mov rdx, offset promptB;
	call writeString;

	; //Get user's input for B
	call ReadInt64;
	mov B, rax;

	; //Prompt the user for C
	mov rdx, offset promptC;
	call writeString;

	; //Get user's input for C
	call ReadInt64;
	mov Cv, rax;

	;//Prompt the user for Length
	mov rdx, offset promptLength;
	call writeString;

	; //Get user's input for Length
	call ReadInt64;
	mov Lengths, rax;

	; //Prompt the user for Width
	mov rdx, offset promptWidth;
	call writeString;

	; //Get user's input for Width
	call ReadInt64;
	mov Widths, rax;

	;----------------------------------------------------------------------------;
	; call writeInt64 and call crlf are for debugging reasons. Not really needed ;
	;----------------------------------------------------------------------------;

	; A = B - A
	mov edx, offset promptEquation1;
	call writeString;
	mov rax, B;
	sub rax, A; // B - A
	mov A, rax; //A = B - A
	call writeInt64;
	call crlf;

	; A = -(A + 1)
	mov edx, offset promptEquation2;
	call writeString;
	inc rax; //rax = rax++ = A + 1
	neg rax; //-(rax) = -6
	mov A, rax; //A = -(A+1) = -6
	call writeInt64;
	call crlf;

	; C = A + B
	mov edx, offset promptEquation3;
	call writeString;
	add rax, B; // A+B
	mov Cv, rax; //C = A+B
	call writeInt64;
	call crlf;

	; B = 3B + 7
	mov edx, offset promptEquation4;
	call writeString;
	mov rax, B;
	add rax, B; //B+B
	add rax, B; //B+B + B
	add rax, 7; //B+B + B + 7
	mov B, rax; ////B = B + B + B + 7
	call writeInt64;
	call crlf;

	; A = A - A - 1
	mov edx, offset promptEquation5;
	call writeString;
	mov rax, A;
	sub rax, A; //A - A
	dec rax; //A - A - 1
	mov A, rax; // A = A - A - 1
	call writeInt64;
	call crlf;

	; A = B - A - 1
	mov edx, offset promptEquation6;
	call writeString;
	mov rax, B;
	sub rax, A; //B-A
	dec rax; //B - A - 1
	mov A, rax; //A = B - A - 1
	call writeInt64;
	call crlf;

	; C = 2A + 2B
	mov edx, offset promptEquation7;
	call writeString;
	mov rax, A;
	mov rdx, B;
	add rax, A; //2A
	add rdx, B; //2B
	add rax, rdx; //2A + 2B
	mov Cv, rax; // C = 2A + 2B
	call writeInt64;
	call crlf;

	; A = A - 2B + 4c
	mov edx, offset promptEquation8;
	call writeString;
	mov rdx, B;
	add rdx, B; //2B
	mov rbx, Cv;
	add rbx, Cv; //2c
	add rbx, Cv; //3c
	add rbx, Cv; //4c
	mov rax, A;
	sub rax, rdx; //A-2B
	add rax, rbx; // A-2B + 4C
	mov A, rax; //A = A-2B + 4C
	call writeInt64;
	call crlf;

	; D = 2(-A + B - 1) + C
	mov edx, offset promptEquation9;
	call writeString;
	neg rax; //-A
	add rax, B; //-A + B
	dec rax; //-A + B -1
	add rax, rax; //2(-A + B -1)
	add rax, Cv; //2(-A + B -1) + C
	mov D, rax; //D = 2(-A + B -1) + C
	call writeInt64;
	call crlf;

	; Perimeter = 2 * Length + 2 * Width
	mov edx, offset promptEquation10;
	call writeString;
	mov rax, Lengths;
	mov rdx, Widths;
	add rax, Lengths; //2*Length
	add rdx, Widths; //2*Width
	add rax, rdx; //2*Length + 2*Width
	mov Perimeter, rax; //Perimeter = 2*Length + 2*Width
	call writeInt64;
	call crlf;

	; Area = Length * Width
	mov edx, offset promptEquation11;
	call writeString;
	mov rax, Lengths;
	mov rdx, Widths;
	cmp rax, rdx; //figure out which is greater
	jg raxIsGreater; //if left > right, then go to raxIsGreater (jg -jump if greater, is only for signed numbers)
	jl rdxIsGreater; //if left < right, then go to rdxIsGreater (jl -jump if less, is only for signed numbers)
	raxIsGreater:
	mov rcx, rdx; //move smallest to ecx
	mov rbx, rax; //move biggest to ebx
	jmp next;
	rdxIsGreater:
	mov rcx, rax; //move smallest to ecx
	mov rbx, rdx; //move biggest to ebx
	jmp next;
	next:
	xor rax, rax; //zero out eax
	areaLoop:; //start of loop
	add rax, rbx; //keep adding x for y times = x*y
	loop areaLoop; //loop again until rcx == 0
	; Loop finished, print out rax register with result
	mov Area, rax; //store result in area
	call writeInt64;
	call crlf;

	ret; //return from function
Calculate64 ENDP

main PROC
	call Calculate64; //call custom function(PROC or PROCEDURE) 
	extraCredit:
		call Calculate64;
		jmp extraCredit; //infinite loop repeatedly asking for the values of A,B,C, Length and Width

mov ecx, 0; exit code used for exitprocess
call ExitProcess; //EXIT_SUCCESS

main ENDP
end