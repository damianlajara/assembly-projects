include irvine32.inc
.386
.stack 4096
ExitProcess proto,dwExitCode:dword

.data?
Score SDWORD ?

.data
exitProgram BYTE "You can exit the program at any time by entering -1 to quit!",0
inputError BYTE "Nothing! why? Because you enetered an invalid entry",0
belowZero BYTE "Error: Invalid! Below zero", 0;
aboveHundred BYTE "Error: Invalid: Above 100", 0;
PromptValue BYTE "Enter your average: ",0

AplusMessage BYTE "A+", 0;
AMessage BYTE "A", 0;
AminusMessage BYTE "A-", 0;

BplusMessage BYTE "B+", 0;
BMessage BYTE "B", 0;
BminusMessage BYTE "B-", 0;

CplusMessage BYTE "C+", 0;
CMessage BYTE "C", 0;
CminusMessage BYTE "C-", 0;

DplusMessage BYTE "D+", 0;
DMessage BYTE "D", 0;

FMessage BYTE "F", 0;

displayGrade BYTE "You receieved: ",0

.code

gradeCalc proc
push ebp;
mov ebp, esp;
mov eax, [ebp+8]; get first parameter

CMP EAX, 100		
JA errorPrompt; // if score > 100 && < 0, print ERROR

;//If its Lower than 100, then continue

CMP EAX, 97;			
JAE AplusGrade;			// score >= 97 && score <= 100 (97-100)
;//If its Lower than 97, then continue

CMP EAX, 93;			//score >= 93 && score <= 96 (93-96)
JAE Agrade 
;//if its lower than 93 then continue

CMP EAX, 90
JAE AminusGrade;		// score >= 90 && Score <= 92 (90-92)
;//if its lower than 90 then continue

CMP EAX, 87
JAE BplusGrade;			// score >= 87 && Score <= 89 (87-89)
;//if its lower than 87 then continue

CMP EAX, 83
JAE BGrade;				// score >= 83 && Score <= 86 (83-86)
;//if its lower than 83 then continue

CMP EAX, 80
JAE BminusGrade;		// score >= 80 && Score <= 82 (80-82)
;//if its lower than 80 then continue

CMP EAX, 77
JAE CplusGrade;			// score >= 77 && Score <= 79 (77-79)
;//if its lower than 77 then continue

CMP EAX, 73
JAE Cgrade;				// score >= 73 && Score <= 76 (73-76)
;//if its lower than 73 then continue

CMP EAX, 70
JAE CminusGrade;		// score >= 70 && Score <= 72 (70-72)
;//if its lower than 70 then continue

CMP EAX, 67
JAE DplusGrade;			// score >= 67 && Score <= 69 (67-69)
;//if its lower than 67 then continue

CMP EAX, 60
JAE Dgrade;				// score >= 60 && Score <= 66 (60-66)
;//if its lower than 60 then continue

CMP EAX, 0
JAE Fgrade; score >= 0 && score < 60 (0-59)

errorPrompt:
	mov edx, offset inputError
	CALL WriteString
	CALL Crlf;
	JMP Contpt;

AplusGrade:
	mov edx, offset AplusMessage ;= LEA edx, AplusMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
Agrade:
	mov edx, offset AMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
AminusGrade:
	mov edx, offset AminusMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
BplusGrade:
	mov edx, offset BplusMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
Bgrade:
	mov edx, offset BMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
BminusGrade:
	mov edx, offset BminusMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
CplusGrade:
	mov edx, offset CplusMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
Cgrade:
	mov edx, offset CMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
CminusGrade:
	mov edx, offset CminusMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
DplusGrade:
	mov edx, offset DplusMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
Dgrade:
	mov edx, offset DMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
Fgrade:
	mov edx, offset FMessage
	CALL WriteString
	CALL Crlf;
	JMP Contpt;
Contpt:
	call crlf;
	pop ebp
	ret;
gradeCalc endp

main proc

LEA edx, exitProgram;
call writeString;
call crlf;
call crlf;

LOOPER:
	LEA edx, PromptValue;
	call writeString;
	call readInt;
	cmp eax, -1;
	je exitLoop; //exit if user enters -1
	lea edx, displayGrade;
	call writeString;
	mov Score, eax;
	push eax; send to stack
	call gradeCalc;
jmp looper

exitLoop:
	invoke ExitProcess,0
main endp
end main


; JA: Jump if above: LeftOp > RoghtOp
; JNBE: Jump if not below or equal; same as JA
; JAE: Jump if above or equal : LeftOp >= RightOp
; JNB: Jump if not below: same as JAE
; JB: Jump if below: LeftOp < RightOp
; JNAE: Jump if not above or equal: same as JB
; JBE: jump if below or equal: LeftOp <= RightOp
; JNA: Jump not above: same as JBE

; JG: Jump if greater (LeftOp > RightOp)
; JNLE: Jump if not less than or equal (same as Jg)
; JGE: Jump if greater or equal (leftOp >= RightOp)
; JNL: Jump if not less than (same as JGE)
; JL: Jump if less (LeftOp < RightOp)
; JNGE: Jump if not greater or equal (same as JL)
; JLE: Jump if less than or equal (LeftOp <= RightOp)
; JNG: Jump if not greater (same as JLE)

;York grading policy
; A+ 97-100
; A 93-96
; A- 90-92
; B+ 87-89
; B 83 - 86
; B- 80 - 82
; C+ 77-79
; C 73-76
; C- 70-72
; D+ 67 - 69
; D 60-66
; F 0-59
