%macro print 1

mov rdi,formatpf
sub rsp,8
movsd xmm0,[%1]
mov rax,1
call printf
add rsp,8

%endmacro

%macro scan 1

mov rdi,formatsf
sub rsp,8
mov rax,0
mov rsi,rsp
call scanf
mov r8,qword[rsp]
mov qword[%1],r8
add rsp,8

%endmacro



%macro printc 2

mov rdi,formatpfc
sub rsp,8
movsd xmm0,[%1]
movsd xmm1,[%2]
mov rax,2
call printf
add rsp,8

%endmacro


%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro


section .data


formatpf db "%lf",10,0
formatsf db "%lf",0
formatpfc db "%lf + i%lf",10,0

msg1 db "Enter the coefficients",10
len1 equ $-msg1

msg2 db "Root 1:"
len2 equ $-msg2

msg3 db "Root 2:"
len3 equ $-msg3

msg4 db 10
len4 equ $-msg4

section .bss

a resq 1
b resq 1
c resq 1

disc resq 1
bsq resq 1
fac resq 1

four resq 1
two resq 1
one resq 1

root1 resq 4
root2 resq 4

real resq 4
imaginary resq 4

section .text 
extern printf
extern scanf

global main

main:
scall 1,1,msg1,len1
; Get the coefficients
scan a
scan b
scan c 

finit
fldz


; Calculating b square
fld qword[b]
fmul qword[b]
fstp qword[bsq]

; Calculating 4ac
mov qword[four],4

fild qword[four]
fmul qword[a]
fmul qword[c]
fstp qword[fac]


; Calculating b^2-4ac
fld qword[bsq]
fsub qword[fac]
fstp qword[disc]


; Calculating 2a
mov qword[two],2
fild qword[two]
fmul qword[a]
fstp qword[a]

fldz

; Checking whether disc is less than zero or not
btr qword[disc],63 
jc img

realroots:
; real sqrt(b^2-4ac)
fld qword[disc]
fsqrt 
fstp qword[disc]

; Root 1
fsub qword[b]
fadd qword[disc]
fdiv qword[a]
fstp qword[root1]

; Root 2
fldz
fsub qword[b]
fsub qword[disc]
fdiv qword[a]
fstp qword[root2]

scall 1,1,msg2,len2
print root1
scall 1,1,msg4,len4

scall 1,1,msg3,len3
print root2
scall 1,1,msg4,len4


jmp exit


img:

mov qword[one],1
; img sqrt(b^2-4ac)
fild qword[one]
fmul qword[disc]
fsqrt
fstp qword[disc]

; Root 1 Real Part 
fldz
fsub qword[b]
fdiv qword[a]
fstp qword[real]


; Root 1 Imaginary Part

fld qword[disc]
fdiv qword[a]
fstp qword[imaginary]

scall 1,1,msg2,len2
printc real,imaginary
scall 1,1,msg4,len4

; Root 2 Real Part 
fldz
fsub qword[b]
fdiv qword[a]
fstp qword[real]


; Root 2 Imaginary Part
fldz
fsub qword[disc]
fdiv qword[a]
fstp qword[imaginary]

scall 1,1,msg3,len3
printc real,imaginary
scall 1,1,msg4,len4

exit:
mov rax,60
mov rsi,0
syscall
