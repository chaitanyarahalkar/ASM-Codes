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


msg db "Enter the first number",10
len equ $-msg

msg2 db "Enter the second number",10
len2 equ $-msg2

menu db "1.Successive addition",10
     db "2.Add and shift",10
     db "3.Exit",10
     db "Enter choice:",10

menulen equ $-menu

result db "Answer:"
lenres equ $-result

newline db 10

section .bss


num1 resb 20
num2 resb 20
temp resb 20
choice resb 2
answer resb 20
count resb 2

section .text

global _start

_start:

up:

print menu,menulen

scan choice,2

cmp byte[choice],'3'
jae exit


print msg,len

scan temp,17
call a2h
mov qword[count],rax

print msg2,len2

scan temp,17
call a2h
mov rbx,rax

cmp byte[choice],'1'
je sa
cmp  byte[choice],'2'
je as


sa:


xor rax,rax
l3:
add rax,rbx
dec byte[count]
jnz l3
call h2a

jmp up



as:
xor rax,rax
mov rcx,64
mov rdx,qword[count]

l8:
shr rbx,01
jnc l7
add rax,rdx
l7:
shl rdx,01
loop l8

call h2a

jmp up

a2h:
xor rax,rax
mov rcx,16
mov rsi,temp
l2:
rol rax,04
mov bl,byte[rsi]
cmp bl,39H
jbe l1
sub bl,07H
l1:sub bl,30H
add al,bl
inc rsi
loop l2
ret


h2a:
mov rcx,16
mov rsi,answer
l6:
rol rax,04H
mov bl,al
and bl,0FH
cmp bl,09H
jbe l5
add bl,07H
l5:
add bl,30H
mov byte[rsi],bl
inc rsi
loop l6
print result,lenres
print answer,16
print newline,1
ret

exit:
mov rax,60
mov rdi,0
syscall
