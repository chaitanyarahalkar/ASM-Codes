%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro
section .data


msg db "The factorial is:"
len equ $-msg

newline db 10

section .bss


answer resb 16

section .text

global _start
_start:

xor rax,rax

pop rsi
pop rsi
pop rsi

call a2h
mov al,bl
cmp al,00H
jne fact
inc al
inc bl


fact:
dec bl
cmp bl,01H
jbe out
mul rbx
call fact

out:
call h2a
jmp exit


a2h:
xor rbx,rbx
mov rcx,02
l2:
rol bl,04
mov al,byte[rsi]
cmp al,39H
jbe l1
sub al,07H
l1:
sub al,30H
add bl,al
inc rsi
loop l2
ret



h2a:
mov rcx,16
mov rsi,answer
l4:
rol rax,04
mov bl,al
and bl,0FH
cmp bl,09H
jbe l3
add bl,07H
l3:
add bl,30H
mov byte[rsi],bl
inc rsi
loop l4
print msg,len
print answer,16
print newline,1
ret

exit:
mov rax,60
mov rdi,0
syscall
