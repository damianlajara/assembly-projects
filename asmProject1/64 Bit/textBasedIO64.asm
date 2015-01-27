; Damian Lajara
; Assembly Project
WriteInt64 PROTO; //Displays RAX register
ReadInt64 PROTO; //returns value into RAX reg
WriteString PROTO; //rdx
ReadString PROTO; //input buffer in rdx, rcx the max nums user can input +1, returns count in rax of numbers typed
Crlf PROTO;
ExitProcess PROTO;

.data? ;uninitialized data variables
;-----------------------------------------
lInitial BYTE 2 DUP(?) ;//allocates 1 byte, which is uninitialized
fInitial BYTE 2 DUP(?) ;//allocates 2 bytes, so the memory addresses wont be next to each other, causing writestring to print two addresses
mInitial BYTE 2 DUP(?) ;

lName BYTE 25 DUP(?); //allocates 25 bytes that are uninitialized to lName
fName BYTE 25 DUP(?); //allocates 25 bytes that are uninitialized to fName
mName BYTE 25 DUP(?); //allocates 25 bytes that are uninitialized to mName

MAX_LENGTH equ $-lName; //Length of lName - will always update, so if I change it to 52 instead of 50, the length will be 52
INITIAL_LENGTH equ $-lInitial + 1;

.data ;initialized data variables
;-----------------------------------------
helloWorld BYTE "Hello World!",10,0;

initialsMessage BYTE "Your initials are:", 10, 0; //10-is the newline character '\n'  and 0-is the null-terminator
namesMessage BYTE "Your full name is: ", 10, 0;

promptLinitial BYTE "Input the intial for your last name: ", 0
promptFinitial BYTE "Input the intial for your first name: ", 0
promptMinitial BYTE "Input the intial for your middle name: ", 0

promptLname BYTE "Input your last name: ", 0 ;//alllocates a byte for every ascii char
promptFname BYTE "Input your first name: ", 0
promptMname BYTE "Input your middle name: ", 0

.code
main proc
;//Print hello world on the screen
mov rdx, offset helloWorld;
call writeString;

;//Prompt the user for their last name initial
mov rdx, offset promptLinitial; //move the string into the edx register
call writeString; //prints the edx register

; //Get user's last name initial
mov rdx, OFFSET lInitial;
	;mov rax, Initial_LENGTH;
	;inc rax;
	;mov rcx, rax; //length+1 to include the null terminator
mov ecx, INITIAL_LENGTH
call readString; //reads it into the address of lInitial

;//Prompt the user for their first name initial
mov rdx, OFFSET promptFinitial;
call writeString;

; //Get user's first name initial
mov rdx, OFFSET fInitial;
	;No need to move the length into the ecx, since all of the initial offsets r the same, we only need to do it once
call readString; //reads it into the address of fInitial

;//Prompt the user for their middle name initial
mov rdx, OFFSET promptMinitial;
call writeString;

; //Get user's middle name initial
mov rdx, OFFSET mInitial;
call readString; //reads it into the address of mInitial

; //display the users initals in this order: Last ,First, Middle each in a newline 
	; //last intial
mov rdx, OFFSET lInitial;
call writeString;
call crlf;
	; //first intial
mov rdx, OFFSET fInitial;
call writeString;
call crlf;
	; //middle intial
mov rdx, OFFSET mInitial;
call writeString;
call crlf;

; //Prompt the user for their last name
mov rdx, offset promptLname;
call writeString;

; //Get user's last name
mov rdx, OFFSET lName;
call readString;

; //Prompt the user for their first name
mov rdx, offset promptFname;
call writeString;

; //Get user's first name
mov rdx, OFFSET fName;
call readString;

; //Prompt the user for their middle name
mov rdx, offset promptMname;
call writeString;

; //Get user's last name
mov rdx, OFFSET mName;
call readString;

; //Display the users last, first and middle name each in a new line
	; //last name
mov rdx, offset lName;
call writeString;
call Crlf;
	; //first name
mov rdx, offset fName;
call writeString;
call Crlf;
	; //middle name
mov rdx, offset mName;
call writeString;
call Crlf;

mov ecx, 0;
call ExitProcess
main endp
end