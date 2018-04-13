%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro scan 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

array dq 0x0123456789012345,0x1234567890123456,0x2345678901234567,0x3456789012345678,0x4567890123456789,0x0000000000000000,0x0000000000000000,0x0000000000000000

newline db 10

menu db "1. Display array",10
     db	"2. Non overlapping without string instruction",10
     db	"3. Overlapping without string instruction",10
     db	"4. Non overlapping with string instruction",10
     db	"5. Overlapping with string instruction",10
     db	"6. Exit",10

len equ $-menu

section .bss

answer resb 20
count resb 2
choice resb 2

section .text

global _start

_start:

up:
print menu,len

scan choice,2

cmp byte[choice],'1'
je display
cmp byte[choice],'2'
je nwos
cmp byte[choice],'3'
je owos
cmp byte[choice],'4'
je nws
cmp byte[choice],'5'
je ows
cmp byte[choice],'6'
jae exit

display:
mov byte[count],05H

mov rsi,array
l3:
mov rdx,rsi
push rsi
call h2a
pop rsi
mov rdx,[rsi]
push rsi
call h2a
pop rsi
add rsi,08H
dec byte[count]
jnz l3

jmp up

nwos:

mov rcx,05H
mov rsi,array
mov rdi,array+100
l4:
mov rbx,qword[rsi]
mov qword[rdi],rbx
add rsi,08H
add rdi,08H
loop l4

mov byte[count],05H
mov rsi,array+100
l5:
mov rdx,rsi
push rsi
call h2a
pop rsi
mov rdx,[rsi]
push rsi
call h2a
pop rsi
add rsi,08H
dec byte[count]
jnz l5

jmp up


owos:
mov rcx,05
mov rsi,array+24
mov rdi,array+100
l6:
mov rbx,qword[rsi]
mov qword[rdi],rbx
add rsi,08
add rdi,08
loop l6

mov byte[count],05H

mov rsi,array+100

l7:
mov rdx,rsi
push rsi
call h2a
pop rsi
mov rdx,[rsi]
push rsi
call h2a
pop rsi
add rsi,08H
dec byte[count]
jnz l7

jmp up


nws:

mov rcx,05
mov rsi,array
mov rdi,array+100
repnz movsq

mov byte[count],05

mov rsi,array+100
l8:
mov rdx,rsi
push rsi
call h2a
pop rsi
mov rdx,[rsi]
push rsi
call h2a
pop rsi
add rsi,08H
dec byte[count]
jnz l8
jmp up

ows:
mov rcx,05
mov rsi,array+24
mov rdi,array+100
repnz movsq

mov byte[count],05H
mov rsi,array+100

l9:
mov rdx,rsi
push rsi
call h2a
pop rsi
mov rdx,[rsi]
push rsi
call h2a
pop rsi
add rsi,08H
dec byte[count]
jnz l9
jmp up


h2a:
xor rax,rax
mov rsi,answer
mov rcx,16
l2:
rol rdx,04
mov al,dl
and al,0FH
cmp al,09H
jbe l1
add al,07H
l1:add al,30H
mov byte[rsi],al
inc rsi
loop l2
print answer,16
print newline,1
ret


exit:
mov rax,60
mov rdi,0
syscall
