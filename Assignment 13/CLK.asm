.MODEL TINY
.286
ORG 100H

CODE SEGMENT

	ASSUME CS:CODE,DS:CODE,ES:CODE
	OLD_IP DW 00
	OLD_CS DW 00
JMP INIT
MY_TSR:
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	PUSH ES
MOV AX,0B800H
MOV ES,AX
MOV DI,3650

abc:
MOV AH, 02H
INT 1AH
MOV BX,CX

MOV CL,2
LOOP1:
ROL BH,4
MOV AL,BH
AND AL,0FH
ADD AL,30H
MOV AH,17H
MOV ES:[DI],AX
INC DI
INC DI
DEC CL
JNZ LOOP1

MOV AL,':'
MOV AH,97H
MOV ES:[DI],AX
INC DI
INC DI

MOV CL,2
LOOP2:
ROL BL,4
MOV AL,BL
AND AL,0FH
ADD AL,30H
MOV AH,17H
MOV ES:[DI],AX
INC DI
INC DI
DEC CL
JNZ LOOP2

MOV AL,':'
MOV AH,97H
MOV ES:[DI],AX
INC DI
INC DI

MOV CL,2
MOV BL,DH

LOOP3:
ROL BL,4
MOV AL,BL
AND AL,0FH
ADD AL,30H
MOV AH,17H
MOV ES:[DI],AX
INC DI
INC DI
DEC CL
JNZ LOOP3

MOV AL,':'
MOV AH,97H
MOV ES:[DI],AX
INC DI
INC DI

MOV CL,2
MOV BL,DL
LOOP4:
ROL BL,4
MOV AL,BL
AND AL,0FH
ADD AL,30H
MOV AH,17H
MOV ES:[DI],AX
INC DI
INC DI
DEC CL
JNZ LOOP4

POP ES
POP DI
POP SI
POP DX
POP CX
POP BX
POP AX

INIT:
MOV AX,CS
MOV DS,AX
CLI
MOV AH,35H
MOV AL,08H
INT 21H

MOV OLD_IP,BX
MOV OLD_CS,ES

MOV AH,25H
MOV AL,08H
LEA DX,MY_TSR
INT 21H

MOV AH,31H
MOV DX,OFFSET INIT
STI
INT 21H
CALL MY_TSR


CODE ENDS
END