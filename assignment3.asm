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

menu db "1.HEX to BCD",10
     db "2.BCD to HEX",10
     db "3.Exit",10
     db "Enter your choice:",10
len equ $-menu

hexno db "Enter 4 digit HEX number",10
hexlen equ $-hexno

bcdno db "Enter 5 digit BCD number",10
bcdlen equ $-bcdno


section .bss

count resb 2
choice resb 4
number resb 12
answer resb 12

section .text

global _start
_start:

up:
print menu,len


scan choice,4

cmp byte[choice],'3'
jae exit
cmp byte[choice],'1'
je h2b
cmp byte[choice],'2'
je b2h




h2b:

print hexno,hexlen
scan number,4

mov byte[count],0H
call a2h
mov rbx,0AH
l2:
xor rdx,rdx
div rbx
push rdx
inc byte[count]
cmp ax,0H
jne l2


l3:
pop rbx
add bl,30H
mov byte[answer],bl
print answer,1
dec byte[count]
jnz l3

jmp up


b2h:

print bcdno,bcdlen
scan number,5

mov rcx,05H
mov rbx,0AH
xor rax,rax
mov rsi,number
l4:
xor rdx,rdx
mul rbx 
mov dl,byte[rsi]
sub dl,30H
add rax,rdx
inc rsi
loop l4

call h2a


mov byte[choice],0
jmp up



h2a:
mov rcx,04
mov rsi,answer
l6:
rol ax,04H
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
print answer,5
ret

a2h:
xor rax,rax
mov rcx,04
mov rsi,number
l7:
rol ax,04
mov bl,byte[rsi]
cmp bl,39H
jbe l1
sub bl,07H
l1:sub bl,30H
add al,bl
inc rsi
loop l7
ret


exit:
mov rax,60
mov rdi,0
syscall
