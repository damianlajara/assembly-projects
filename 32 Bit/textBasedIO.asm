; Damian Lajara
; Assembly Project

COMMENT #
1) text-based I/O
	a) Display a message such as "Hello World", on the screen
	b) Prompt the user for the initials of their last name, first name and middle name; Then display the characters on seperate lines on the screen
	c) Prompt the user for their last name, first name and middle name, then display the text strings on speerate lines on the screen
#
INCLUDE Irvine32.inc
.386
.stack 4096
ExitProcess proto, dwExitCode:dword

.data? ;uninitialized data variables
;-----------------------------------------
lInitial BYTE ? ;
fInitial BYTE ? ;
mInitial BYTE ? ;

lName BYTE 50 DUP(?); //allocates 50 bytes that are uninitialized to lName
fName BYTE 50 DUP(?); //allocates 50 bytes that are uninitialized to fName
mName BYTE 50 DUP(?); //allocates 50 bytes that are uninitialized to mName

MAX_LENGTH equ $-lName; //Length of lName - will always update, so if I change it to 52 instead of 50, the length will be 52

.data ;initialized data variables
;-----------------------------------------
initialsMessage BYTE "Your initials are:", 10, 0; //10-is the newline character '\n'  and 0-is the null-terminator
namesMessage BYTE "Your full name is: ", 10, 0;

promptLinitial BYTE "Input the intial for your last name: ", 0
promptFinitial BYTE "Input the intial for your first name: ", 0
promptMinitial BYTE "Input the intial for your middle name: ", 0

promptLname BYTE "Input your last name: ", 0
promptFname BYTE "Input your first name: ", 0
promptMname BYTE "Input your middle name: ", 0

.code
main proc

;//Prompt the user for their last name initial
mov edx, offset promptLinitial; //move the string into the edx register
call writeString; //prints the edx register

; //Get user's last name initial
call readChar; //reads the first character entered on the keyboard and returns the character in the AL register
mov lInitial, al; //make lInitial equal to the character the user entered
call crlf;

;//Prompt the user for their first name initial
mov edx, offset promptFinitial; //move the string into the edx register
call writeString; //prints the edx register

; //Get user's first name initial
call readChar;
mov FInitial, al; //make FInitial equal to the character the user entered
call crlf;

;//Prompt the user for their middle name initial
mov edx, offset promptMinitial; //move the string into the edx register
call writeString; //prints the edx register

; //Get user's middle name initial
call readChar;
mov mInitial, al; //make mInitial equal to the character the user entered
call crlf;
call crlf;


; //Print users initials!
mov edx, offset initialsMessage; //move the message used for initials into the edx register
call writeString; //prints the edx register
mov al, lInitial; //load lInitial into al
call writeChar; //print out al
call crlf;
mov al, fInitial; //load fInitial into al
call writeChar; //print out al
call crlf;
mov al, mInitial; //load mInitial into al
call writeChar; //print out al
call crlf;
call crlf;

;//Prompt the user for their last name
mov edx, offset promptLname; //move the string into the edx register
call writeString; //prints the edx register

;//Get user's last name
mov ecx, MAX_LENGTH; //read strings checks here to see how many characters to read (has to be 1 more than the size of the string)
mov edx, offset lName; //readstring needs this to return the byte count to eax and the string to edx
call readString; //get what the user entered - stores it in edx, where lName is also, so lName also gets it

;//Prompt the user for their first name
mov edx, offset promptFname; //move the string into the edx register
call writeString; //prints the edx register

;//Get user's first name
;//do not need to move the length into ecx again, because ecx already has the length since fName, mName and lName are all the same size
mov edx, offset fName;
call readString; //get what the user entered

;//Prompt the user for their middle name
mov edx, offset promptMname; //move the string into the edx register
call writeString; //prints the edx register

;//Get user's middle name
;//do not need to move the length into ecx again, because ecx already has the length since fName, mName and lName are all the same size
mov edx, offset mName;
call readString; //get what the user entered
call crlf;

; //Print users name!
mov edx, offset namesMessage; //move the message used for initials into the edx register
call writeString; //prints the edx register
mov edx, offset fName;
call writeString;
call crlf;
mov edx, offset lName;
call writeString;
call crlf;
mov edx, offset mName;
call writeString;
call crlf;
call crlf;


	invoke ExitProcess,0
main endp
end main