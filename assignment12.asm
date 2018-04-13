%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro
section .data

array dd 100.02,104.02,701.45,150.87,542.86
dot db '.'
dotlen equ $-dot

mmsg db "Mean:"
mlen equ $-mmsg

vmsg db 10,"Variance:"
vlen equ $-vmsg

smsg db 10,"Standard Deviation:"
slen equ $-smsg

newline db 10

section .bss

mean resd 1
variance resd 1

n resd 1
h resd 1

buffer resd 8

answer resb 4

section .text

global _start

_start:

finit
fldz

mov rcx,05
mov rsi,array
l1:
fadd dword[rsi]
add rsi,04H
loop l1

mov dword[n],05
fidiv dword[n]

fst dword[mean]

print mmsg,mlen
print newline,1
call display

mov dword[variance],0H

mov rcx,05
mov rsi,array
l5:
fld dword[rsi]
fsub dword[mean]
fst st1
fmul st1
fadd dword[variance]
fstp dword[variance]
add rsi,04H
loop l5

fld dword[variance]
fidiv dword[n]
fst dword[variance]

print vmsg,vlen
print newline,1
call display

fld dword[variance]
fsqrt

print smsg,slen
print newline,1
call display

jmp exit


display:
mov dword[h],100
fimul dword[h]
fbstp [buffer]


mov rcx,9
mov rsi,buffer+9
l2:
mov bl,byte[rsi]
push rsi
push rcx
call h2a
pop rcx
pop rsi
dec rsi
loop l2

print dot,dotlen

mov rsi,buffer
mov bl,byte[rsi]
call h2a

ret



h2a:
xor rax,rax
mov rcx,02
mov rsi,answer
l4:
rol bl,04
mov al,bl
and al,0FH
cmp al,09H
jbe l3
add al,07H
l3:
add al,30H
mov byte[rsi],al
inc rsi
loop l4
print answer,2
ret


exit:
mov rax,60
mov rdi,0
syscall







