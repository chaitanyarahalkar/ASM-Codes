%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro 

section .data

array dq 0x0123456789012345,0x9999999999999999,0x8888888888888888,0x1111111111111111,0x4444444444444444,0x3333333333333333,0x7777777777777777,0x5555555555555555,0x6666666666666666,0x999654321012345

posmsg db "Positive numbers:"
poslen equ $-posmsg

negmsg db "Negative numbers:"
neglen equ $-negmsg

newline db 10

section .bss

poscount resb 1
negcount resb 1

section .text

global _start

_start:

mov byte[negcount],0H
mov byte[poscount],0H

mov rcx,10
mov rsi,array
l3:
mov rax,[rsi]
bt rax,63
jc l1
inc byte[poscount]
jmp l2
l1:
inc byte[negcount]
l2:
add rsi,08H
loop l3


add byte[poscount],30H
add byte[negcount],30H

print posmsg,poslen
print poscount,1

print newline,1

print negmsg,neglen
print negcount,1

print newline,1

jmp exit


exit:
mov rax,60
mov rdi,0
syscall
