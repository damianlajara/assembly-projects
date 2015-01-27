Include Irvine32.inc
Include macros.inc; Used for mWrite in chapter 12
.stack 4096
ExitProcess proto,dwExitCode:dword

.data?
N DWORD ?

L DWORD ? ;Length
W DWORD ? ;Width
H DWORD ? ;Height
area DWORD ?

X DWORD ?
Y DWORD ?

grade1 DWORD ?
grade2 DWORD ?
grade3 DWORD ?
grade4 DWORD ?
weight1 DWORD ?
weight2 DWORD ?
weight3 DWORD ?
weight4 DWORD ?
weightedSum DWORD ?
sumOfWeights DWORD ?
weightedAverage DWORD ?

pennies DWORD ?
nickels DWORD ?
dimes DWORD ?
quarters DWORD ?
halfDollars DWORD ?
Dollars DWORD ?
total REAL4 ?
numberOfCoins DWORD ?
numberOfPennies DWORD ?
numberOfNickels DWORD ?
numberOfDimes DWORD ?
numberOfQuarters DWORD ?
numberOfHalfDollars DWORD ?
numberOfDollars DWORD ?



.data
;TODO- CHANGE promptCarry to overflow as well
promptOverflow BYTE "Overflow! Number is way too big!", 0, 10
badInput BYTE "Input must be greater than or equal to 0", 0, 10
tryAgain BYTE "Please try again!", 0, 10

promptN BYTE "Input the value for N: ", 0

printRecursiveSum BYTE "Recursive Sum: ", 0
printSum BYTE "Normal Sum: ", 0
printPowerSum BYTE "PowerSum: ", 0
printFactorial BYTE "Factorial: ", 0

;Area Prompts
promptLength BYTE "Input the value for Length: ", 0
promptWidth  BYTE "Input the value for Width:  ", 0
promptHeight BYTE "Input the value for Height: ", 0
promptCarry BYTE "Number was too big!", 0, 10

AreaDescription BYTE "Area: ",0

;Harmonic Mean Prompts
promptX BYTE "Input the value for X: ",0
promptY BYTE "Input the value for Y: ",0
quotient BYTE "Quotient: ",0
remainder BYTE "Remainder: ",0

;Grade prompts
promptGrade1 BYTE "Input first grade: ",0
promptGrade2 BYTE "Input second grade: ",0
promptGrade3 BYTE "Input third grade: ",0
promptGrade4 BYTE "Input fourth grade: ",0
promptWeight1 BYTE "Input first weight: ",0
promptWeight2 BYTE "Input second weight: ",0
promptWeight3 BYTE "Input third weight: ",0
promptWeight4 BYTE "Input fourth weight: ",0

;Display Grades
gradeDescription1  BYTE "Grade  1: ",0
gradeDescription2  BYTE "Grade  2: ",0
gradeDescription3  BYTE "Grade  3: ",0
gradeDescription4  BYTE "Grade  4: ",0
weightDescription1 BYTE "Weight 1: ",0
weightDescription2 BYTE "Weight 2: ",0
weightDescription3 BYTE "Weight 3: ",0
weightDescription4 BYTE "Weight 4: ",0
weightedSumDescription BYTE "Weighted Sum: ",0
sumOfWeightsDescription BYTE "Sum of Weights: ",0
weightedAverageDescription BYTE "Weighted Average: ",0

;coin collection prompts
promptPennies BYTE "Input the total amount of pennies: ",0
promptNickels BYTE "Input the total amount of nickels: ",0
promptDimes BYTE "Input the total amount of dimes: ",0
promptQuarters BYTE "Input the total amount of quarters: ",0
promptHalfDollars BYTE "Input the total amount of half dollar coins: ",0
promptDollars BYTE "Input the total amount of dollar coins: ",0

;coin collection descriptions
totalValue BYTE "Total Value: $",0
coinAmount BYTE "Number of Coins: ",0
dollarAmount BYTE "Number of Dollar Coins: ",0
halfDollarAmount BYTE "Number of Half-Dollar Coins: ",0
quarterAmount BYTE "Number of Quarters: ",0
dimeAmount BYTE "Number of Dimes: ",0
nickelAmount BYTE "Number of Nickels: ",0
pennyAmount BYTE "Number of Pennies: ",0

;FPU VARS
pennyValue DWORD 1
nickelValue DWORD 5
dimeValue DWORD 10
quarterValue DWORD 25
halfDollarValue DWORD 50
dollarValue DWORD 1
percent DWORD 100


;//Compute the factorial
.code
main proc

InputN:
	;Prompt the user for N
	mov edx, offset promptN; move the string into the edx register
	call writeString;

	;Get users input for N
	call readInt; //returns value in eax
	mov N, eax
	;call Crlf;

	cmp eax, 0;
	jl underZero; Jump if less ( did not use jle, because we need to be able to calculate 0 factorial (0!) )
	jmp mainProgram; Otherwise jump here

	underZero:
		call lessThanZero
		jmp inputN

mainProgram:
	call RecursiveSum;

	call Sum;

	call PowerSum;

	mov edx, offset printFactorial;
	call writeString;
	push N; send parameter to function through stack
	call Factorial
	call WriteDec
	call crlf;

	Call SurfaceArea
	 
	call HarmonicMean

	call Grades

	call coinCollection

	invoke ExitProcess,0
main endp

;Compute N!: 1 * 2 * 3 * 4 *...* N
Factorial Proc

	push ebp; save register
	mov ebp, esp; align base pointer
	mov eax, [ebp+8]; //get first parameter
	cmp eax, 0; is it greater than 0?
	ja L1; if yes, then continue
	mov eax, 1; if not, return 1 as the value of zero factorial
	jmp L2; //return from function

	L1: 
		dec eax
		push eax; Factorial(n-1)
		call Factorial

	ReturnFactorial: ;returns here after Factorial has been done and ret has been called in L2
		mov ebx, [ebp+8]; get first parameter
		mul ebx; EDX:EAX = EAX*EBX

	L2:
		pop ebp; return eax
		ret 4 ; clean up stack and returns to where Factorial was last called
Factorial endp

;Compute the sum: 1 + 2 + 3 + 4 +...+ N
RecursiveSum Proc USES eax ecx edx
	mov eax, 0;
	mov ecx, N;

	L1:
		cmp ecx, 0; check counter value
		jz L2; quit if zero
		add eax, ecx; othewise, add to sum
		dec ecx; decrement counter
		;call RecursiveSum; recursive call
		jmp L1;

	L2:
		;Display Result
		mov edx, offset printRecursiveSum;
		call writeString;
		call WriteDec;
		call Crlf;
		ret
RecursiveSum endp

;Compute the sum using: N(N+1)/2
Sum Proc USES eax ebx edx
	mov eax, N ;eax = N
	mov ebx, eax;
	inc ebx; N+1
	mul ebx ; N(N+1)
	shr eax, 1; n(N+1)/2

	;Display Result
	mov edx, offset printSum;
	call writeString;
	call writeDec;
	call Crlf;

	ret;
Sum endp

;Compute the sum: 1^2 + 2^2 + 3^2 + 4^2 +...+ N^2
PowerSum Proc USES ebx ecx edx ;I push and pop eax manually inside proc
	mov ecx, N;
	mov eax, 0;

	L1:
		cmp ecx, 0; check counter value
		jz L2; quit if zero
		push eax; save eax, so mul will not change it's value
		mov eax, ecx;
		mul ecx; eax * ecx = ecx^2
		mov ebx, eax; store eax in ebx, so we dont alter the sum
		pop eax; restore eax
		add eax, ebx; add to sum
		;pop eax; restore eax
		dec ecx; decrement counter
		jmp L1;
		;call PowerSum; recursive call

	L2:
		;Display Result
		mov edx, offset printPowerSum;
		call writeString;
		call WriteDec;
		call Crlf;
		ret
PowerSum endp

;Compute the area: 2(LH + WH + LW)
SurfaceArea Proc USES eax ebx ecx edx

getLength:
	;Prompt the user for length
	call Crlf;
	mov edx, offset promptLength; move the string into the edx register
	call writeString; //Prints the edx register

	;Get users input for Length
	call readInt; //returns value in eax
	mov L, eax

	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_l; Jump if less							;
	jmp getWidth; Otherwise proceed to get width			;
															;
	underZero_l:											;
		call lessThanZero									;
		jmp getLength										;
	;--------------------------------------------------------

getWidth:
	;Prompt the user for width
	mov edx, offset promptWidth; move the string into the edx register
	call writeString; //Prints the edx register

	;Get users input for Width
	call readInt; //returns value in eax
	mov W, eax
	
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_w; Jump if less							;
	jmp getHeight; Otherwise proceed to get height			;
															;
	underZero_w:											;
		call lessThanZero									;
		jmp getWidth										;
	;--------------------------------------------------------

getHeight:
	;Prompt the user for height
	mov edx, offset promptHeight; move the string into the edx register
	call writeString; //Prints the edx register

	;Get users input for height
	call readInt; //returns value in eax
	mov H, eax
	Call Crlf;

	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_h; Jump if less							;
	jmp calculate; Otherwise proceed to do calculations		;
															;
	underZero_h:											;
		call lessThanZero									;
		jmp getHeight										;
	;--------------------------------------------------------
calculate:
	mov eax, L;
	mul W; EDX:EAX = L*W
	jc carry; jump if carry - CF = 1 - number was too big
	mov ebx, eax; ebx = L*W
	mov eax, W; 
	mul H; EDX:EAX = W*H
	jc carry;
	mov ecx, eax; ecx = W*H
	mov eax, L;
	mul H; L*H
	jc carry;
	add ecx, ebx; W*H + L*W
	add eax, ecx; L*H + W*H + L*W
	shl eax, 1; multiply by 2  
	mov Area, eax;

	mov edx, offset AreaDescription; move the string into the edx register
	call writeString; //Prints the edx register
	Call WriteDec;
	Call Crlf;
	Call Crlf;

	ret; return from function so it wont execute carry 

	carry: 
		;Prompt the user about the Carry flag
		mov edx, offset promptCarry; move the string into the edx register
		call writeString; //Prints the edx register
		ret
SurfaceArea endp

;Compute the harmonic mean(x,y): (2xy)/(x+y)
HarmonicMean Proc USES eax ebx edx
	;Prompt the user for x
	mov edx, offset promptX; move the string into the edx register
	call writeString; //Prints the edx register

	;Get users input for x
	call readInt; //returns value in eax
	mov X, eax

	;Prompt the user for y
	mov edx, offset promptY; move the string into the edx register
	call writeString; //Prints the edx register

	;Get users input for y
	call readInt; //returns value in eax
	mov Y, eax
	call crlf;

	mov eax, X;
	mul Y; x*y
	jc overflow;
	shl eax, 1; 2*x*y
	mov ebx, X;
	add ebx, Y; x+y
	div ebx; (2xy)/(x+y) quotient in eax, remainder in edx
	mov ebx, edx; move remainder so it wont interfere with writeString
	mov edx, offset quotient;
	call writeString; display "Quotient: "
	call WriteDec;
	call Crlf;
	mov edx, offset remainder;
	call writeString; display "Remainder: "
	mov eax, ebx;
	call WriteDec;
	call Crlf;
	ret

	overflow: 
		;Prompt the user about the overflow
		mov edx, offset promptOverflow; move the string into the edx register
		call writeString; //Prints the edx register
		ret;

HarmonicMean endp

Grades Proc USES eax ebx ecx edx esi
	;Prompt and get the users grades
getGrade1:
	call crlf;
	mov edx, offset promptGrade1;
	call writeString;
	call readInt; //returns value in eax
	mov grade1, eax
		
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_g1; Jump if less							;
	jmp getGrade2; Otherwise proceed to get grade2			;
															;
	underZero_g1:											;
		call lessThanZero									;
		jmp getGrade1										;
	;--------------------------------------------------------

getGrade2:
	mov edx, offset promptGrade2;
	call writeString;
	call readInt; //returns value in eax
	mov grade2, eax
			
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_g2; Jump if less							;
	jmp getGrade3; Otherwise proceed to get grade3			;
															;
	underZero_g2:											;
		call lessThanZero									;
		jmp getGrade2										;
	;--------------------------------------------------------

getGrade3:
	mov edx, offset promptGrade3;
	call writeString;
	call readInt; //returns value in eax
	mov grade3, eax
			
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_g3; Jump if less							;
	jmp getGrade4; Otherwise proceed to get grade4			;
															;
	underZero_g3:											;
		call lessThanZero									;
		jmp getGrade3										;
	;--------------------------------------------------------

getGrade4:
	mov edx, offset promptGrade4;
	call writeString;
	call readInt; //returns value in eax
	mov grade4, eax
			
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_g4; Jump if less							;
	jmp getWeight1; Otherwise proceed to get weight1		;
															;
	underZero_g4:											;
		call lessThanZero									;
		jmp getGrade4										;
	;--------------------------------------------------------

	;Prompt and get the users weights
getWeight1:
	mov edx, offset promptWeight1;
	call writeString;
	call readInt; //returns value in eax
	mov weight1, eax
				
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_w1; Jump if less							;
	jmp getWeight2; Otherwise proceed to get weight2		;
															;
	underZero_w1:											;
		call lessThanZero									;
		jmp getWeight1										;
	;--------------------------------------------------------

getWeight2:
	mov edx, offset promptWeight2;
	call writeString;
	call readInt; //returns value in eax
	mov weight2, eax
					
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_w2; Jump if less							;
	jmp getWeight3; Otherwise proceed to get weight3		;
															;
	underZero_w2:											;
		call lessThanZero									;
		jmp getWeight2										;
	;--------------------------------------------------------

getWeight3:
	mov edx, offset promptWeight3;
	call writeString;
	call readInt; //returns value in eax
	mov weight3, eax
					
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO--------;
	cmp eax, 0;												;
	jl underZero_w3; Jump if less							;
	jmp getWeight4; Otherwise proceed to get weight4		;
															;
	underZero_w3:											;
		call lessThanZero									;
		jmp getWeight3										;
	;--------------------------------------------------------

getWeight4:
	mov edx, offset promptWeight4;
	call writeString;
	call readInt; //returns value in eax
	mov weight4, eax
					
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO-----------;
	cmp eax, 0;												   ;
	jl underZero_w4; Jump if less							   ;
	jmp calculateValues; Otherwise proceed to calculate values ;
														       ;
	underZero_w4:											   ;
		call lessThanZero									   ;
		jmp getWeight4										   ;
	;-----------------------------------------------------------
calculateValues:
	;Compute weighted sum
	mov eax, grade1;
	mul weight1; grade1*weight1
	jc overflow;
	mov ebx, eax; ebx = grade1*weight1
	mov eax, grade2;
	mul weight2; grade2*weight2
	jc overflow;
	mov ecx, eax; ecx = grade2*weight2
	mov eax, grade3;
	mul weight3; grade3*weight3
	jc overflow;
	mov esi, eax; esi = grade3*weight3
	mov eax, grade4;
	mul weight4; grade4*weight4
	jc overflow;
	add eax, esi; eax = grade3*weight3 + grade4*weight4
	add eax, ecx; eax = grade2*weight2 + grade3*weight3 + grade4*weight4
	add eax, ebx; eax = grade1*weight1 + grade2*weight2 + grade3*weight3 + grade4*weight4
	mov weightedSum, eax;

	;compute sum of weights
	mov eax, weight1;
	mov ebx, weight2;
	add eax, ebx; eax = weight1 + weight2
	mov ebx, weight3
	add eax, ebx; eax = weight1 + weight2 + weight 3
	mov ebx, weight4
	add eax, ebx; eax = weight1 + weight2 + weight3 + weight4
	mov sumOfWeights, eax;

	;compute weighted average
	mov ebx, weightedSum;
	xchg eax, ebx; eax = weightedSum, ebx = sumOfWeights
	div ebx; weightedSum/sumOfWeights
	mov weightedAverage, eax; weightedAverage = weightedSum/sumOfWeights

	;Display weighted average, weighted sum, sum of weights
	call Crlf;
	mov edx, offset weightedAverageDescription
	call writeString
	mov eax, weightedAverage;
	call writeDec; 
	call Crlf;
	mov edx, offset weightedSumDescription
	call writeString
	mov eax, weightedSum
	call writeDec;
	call Crlf;
	mov edx, offset sumOfWeightsDescription
	call writeString;
	mov eax, sumOfWeights
	call writeDec
	call Crlf;

	;Display Grades
	mov edx, offset gradeDescription1
	call writeString;
	mov eax, grade1
	call writeDec
	call Crlf;
	mov edx, offset gradeDescription2
	call writeString;
	mov eax, grade2
	call writeDec
	call Crlf;
	mov edx, offset gradeDescription3
	call writeString;
	mov eax, grade3
	call writeDec
	call Crlf;
	mov edx, offset gradeDescription4
	call writeString;
	mov eax, grade4
	call writeDec
	call Crlf;

	;Display weights
	mov edx, offset weightDescription1
	call writeString;
	mov eax, weight1
	call writeDec
	call Crlf;
	mov edx, offset weightDescription2
	call writeString;
	mov eax, weight2
	call writeDec
	call Crlf;
	mov edx, offset weightDescription3
	call writeString;
	mov eax, weight3
	call writeDec
	call Crlf;
	mov edx, offset weightDescription4
	call writeString;
	mov eax, weight4
	call writeDec
	call Crlf;
	call Crlf;

	ret;


	overflow: 
		;Prompt the user about the overflow
		mov edx, offset promptOverflow; move the string into the edx register
		call writeString; //Prints the edx register
		ret;

Grades endp

coinCollection Proc USES eax edx

	finit ;initialize FPU

	; To Find value of coin you have to
	; multiply number by value, then divide by 100
	; ex: (6 Quarters * 25) /100 = 1.5 dollars
	; FPU Stack works in postfix format: 6 25 * 100 /

getPennies:
	mov edx, offset promptPennies;
	call writeString; 
	call readInt; //returns value in eax

	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO---------------;
	cmp eax, 0;												       ;
	jl underZero_penny; Jump if less							   ;
	jmp calculatePennyValue; Otherwise proceed to calculate pennies;
														           ;
	underZero_penny:											   ;
		call lessThanZero									       ;
		jmp getPennies										       ;
	;---------------------------------------------------------------

calculatePennyValue:
	mov numberOfPennies, eax
	mov numberOfCoins, eax; numberOfCoins = all pennnies

	fild pennyValue; push integer to top of fpu stack. st(0) = pennyValue
	fwait; Wait for pendng exceptions
	fild numberOfCoins; st(0) = numberOfCoins, st(1) = pennyValue
	fwait;
	fmul; multiply st(0) and st(1), then pops them leaving the answer in st(0)
	fild percent; st(0) = percent, st(1) = pennyValue*numberOfCoins
	fwait;
	fdiv; divides st(1) by st(0) = (pennyValue*numberOfCoins) / 100  = pennyTotal - and pops them leaving only the result
	fstp total; stores the value from st(0) into total, and pops it off the stack (pennyValue*numberOfCoins) / 100
	;call ShowFPUStack; stack should be empty here

	;---------------------------------------------------------------
getNickels:
	mov edx, offset promptNickels;
	call writeString; 
	call readInt; //returns value in eax
	
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO----------------;
	cmp eax, 0;												        ;
	jl underZero_nickel; Jump if less							    ;
	jmp calculateNickelValue; Otherwise proceed to calculate nickels;
														            ;
	underZero_nickel:											    ;
		call lessThanZero									        ;
		jmp getNickels										        ;
	;----------------------------------------------------------------

calculateNickelValue:
	mov numberOfNickels, eax
	
	fild nickelValue; push integer to top of fpu stack. st(0) = nickelValue
	fwait;
	fild numberOfNickels; st(0) = numberOfNickels, st(1) = nickelValue
	fwait;
	fmul; multiply st(0) and st(1), then pops them leaving the answer in st(0)
	fild percent; st(0) = percent, st(1) = nickelValue*numberOfCoins
	fwait;
	fdiv; divides st(1) by st(0) = (nickelValue*numberOfNickels) / 100 = nickelTotal
	fadd total; st(0) += total - pennyTotal + nickelTotal
	fstp total; = (nickelValue*numberOfNickels) / 100
	
	add numberOfCoins, eax; numberOfCoins = pennies + nickels
	mov eax, numberOfCoins;

	;-------------------------------------------------------------------
getDimes:
	mov edx, offset promptDimes;
	call writeString; 
	call readInt; //returns value in eax

	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO-------------;
	cmp eax, 0;												     ;
	jl underZero_dime; Jump if less							     ;
	jmp calculateDimeValue; Otherwise proceed to calculate dimes ;
														         ;
	underZero_dime:											     ;
		call lessThanZero									     ;
		jmp getDimes										     ;
	;-------------------------------------------------------------

calculateDimeValue:
	mov numberOfDimes, eax

	fild dimeValue; st(0) = dimeValue
	fwait;
	fild numberOfDimes; st(0) = numberOfDimes, st(1) = dimeValue
	fwait;
	fmul; multiply st(0) and st(1), then pops them leaving the answer in st(0)
	fild percent; st(0) = percent, st(1) = dimeValue*numberOfCoins
	fwait;
	fdiv; divides st(1) by st(0) = (dimeValue*numberOfDimes) / 100 = dimeTotal
	fadd total; st(0) += total:  pennyTotal + nickelTotal + dimeTotal
	fstp total; = (dimeValue*numberOfDimes) / 100

	add numberOfCoins, eax; numberOfCoins = pennies + nickels + Dimes
	mov eax, numberOfCoins;
	;---------------------------------------------------------------------
getQuarters:
	mov edx, offset promptQuarters;
	call writeString; 
	call readInt; //returns value in eax
			
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO-------------------;
	cmp eax, 0;												           ;
	jl underZero_quarter; Jump if less							       ;
	jmp calculateQuarterValue; Otherwise proceed to calculate quarters ;
														               ;
	underZero_quarter:											       ;
		call lessThanZero									           ;
		jmp getQuarters										           ;
	;-------------------------------------------------------------------

calculateQuarterValue:
	mov numberOfQuarters, eax

	fild quarterValue; st(0) = quarterValue
	fwait;
	fild numberOfQuarters; st(0) = numberOfQuarters, st(1) = quarterValue
	fwait;
	fmul; multiply st(0) and st(1), then pops them leaving the answer in st(0)
	fild percent; st(0) = percent, st(1) = quarterValue*numberOfCoins
	fwait;
	fdiv; divides st(1) by st(0) = (quarterValue*numberOfQuarters) / 100 = quarterTotal
	fadd total; st(0) += total:  pennyTotal + nickelTotal + dimeTotal + quarterTotal
	fstp total; = (quarterValue*numberOfQuarters) / 100

	add numberOfCoins, eax; numberOfCoins = pennies + nickels + Dimes + Quarters
	mov eax, numberOfCoins;
	;-----------------------------------------------------------------------
getHalfDollars:
	mov edx, offset promptHalfDollars;
	call writeString; 
	call readInt; //returns value in eax
				
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO----------------------;
	cmp eax, 0;												              ;
	jl underZero_halfDollar; Jump if less							      ;
	jmp calculateHalfDollarValue; Otherwise proceed to calculate 50-cents ;
														                  ;
	underZero_halfDollar:											      ;
		call lessThanZero									              ;
		jmp getHalfDollars										          ;
	;----------------------------------------------------------------------

calculateHalfDollarValue:
	mov numberOfHalfDollars, eax

	fild halfDollarValue; st(0) = halfDollarValue
	fwait;
	fild numberOfHalfDollars; st(0) = numberOfHalfDollars, st(1) = halfDollarValue
	fwait;
	fmul; multiply st(0) and st(1), then pops them leaving the answer in st(0)
	fild percent; st(0) = percent, st(1) = halfDollarValue*numberOfCoins
	fwait;
	fdiv; divides st(1) by st(0) = (halfDollarValue*numberOfHalfDollars) / 100 = halfDollarTotal
	fadd total; st(0) += total:  pennyTotal + nickelTotal + dimeTotal + quarterTotal + halfDollarTotal
	fstp total; = (halfDollarValue*numberOfHalfDollars) / 100

	add numberOfCoins, eax; numberOfCoins = pennies + nickels + Dimes + Quarters + half dollars
	mov eax, numberOfCoins;
	;--------------------------------------------------------------------------
getDollars:
	mov edx, offset promptDollars;
	call writeString; 
	call readInt; //returns value in eax
					
	;-----CHECK IF USER ENTERED VALUE LESS THAN ZERO----------------------;
	cmp eax, 0;												              ;
	jl underZero_dollar; Jump if less							          ;
	jmp calculateDollarValue; Otherwise proceed to calculate dollar coins ;
														                  ;
	underZero_dollar:											          ;
		call lessThanZero									              ;
		jmp getDollars										              ;
	;----------------------------------------------------------------------

calculateDollarValue:
	mov numberOfDollars, eax

	;Dollars are full values, no need to convert
	fild numberOfDollars; st(0)
	fwait;
	fld total; st(0) = total, numberOfDollars = st(1)
	fadd; adds total and numberOfDollars, and pops everything out leaving it at st(0)
	fstp total; load the calculated value into total, and clear the stack

	add numberOfCoins, eax; numberOfCoins = pennies + nickels + Dimes + Quarters + half dollars + dollars
	;mov eax, numberOfCoins;

	;--------------------------------------------------------
	;Display Coin Collection Results

	call crlf;
	mov edx, offset totalValue
	call writeString;
	fld total; push total onto stack, so writeFloat can use it
	call writeFloat; writes st(0) to the console in exponential form
	fstp total; pop it back out into total, clearing the stack
	call Crlf;

	mov edx, offset coinAmount
	call writeString;
	mov eax, numberOfCoins
	call writeDec
	call Crlf;

	mov edx, offset dollarAmount
	call writeString;
	mov eax, numberOfDollars
	call writeDec
	call Crlf;

	mov edx, offset halfDollarAmount
	call writeString;
	mov eax, numberOfHalfDollars
	call writeDec
	call Crlf;

	mov edx, offset quarterAmount
	call writeString;
	mov eax, numberOfQuarters
	call writeDec
	call Crlf;
	mov edx, offset dimeAmount
	call writeString;
	mov eax, numberOfDimes
	call writeDec
	call Crlf;

	mov edx, offset nickelAmount
	call writeString;
	mov eax, numberOfNickels
	call writeDec
	call Crlf;

	mov edx, offset pennyAmount
	call writeString;
	mov eax, numberOfPennies
	call writeDec
	call Crlf;

	ret;

coinCollection endp

lessThanZero Proc USES edx
	mov edx, offset badInput
	call writeString
	call Crlf;
	mov edx, offset tryAgain
	call writeString
	call Crlf;
	ret
lessThanZero endp
end main