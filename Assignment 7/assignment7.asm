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


filename db 'numbers.txt',0
msg db "File opened successfully",10
len equ $-msg

msg1 db "Sorted numbers written to file successfully",10
len1 equ $-msg1

menu db "1.Ascending order",10
     db "2.Descending order",10
     db "3.Exit",10

menulen equ $-menu

section .bss

fd resb 8
buffer resb 100
fcount resb 8
choice resb 2
flag resb 2

section .text


global _start:

_start:
mov byte[flag],0

print menu,menulen

scan choice,2

cmp byte[choice],'1'
je set
cmp byte[choice],'2'
je sort
cmp byte[choice],'3'
jae exit


set:
mov byte[flag],1


sort:
mov rax,2
mov rdi,filename
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt rax,63
jc exit


print msg,len

mov rax,0
mov rdi,[fd]
mov rsi,buffer
mov rdx,100
syscall

mov qword[fcount],rax

l3:
mov rcx,04
mov rsi,buffer
mov rdi,buffer+1
l2:
mov bl,byte[rsi]
cmp byte[flag],1
je l5
l4:
cmp bl,byte[rdi]
ja l1
mov dl,byte[rdi]
mov byte[rdi],bl
mov byte[rsi],dl
jmp l1
l5:
cmp bl,byte[rdi]
jb l1
mov dl,byte[rdi]
mov byte[rdi],bl
mov byte[rsi],dl
l1:
inc rsi
inc rdi
loop l2
dec byte[fcount]
jnz l3


mov qword[fcount],rax

mov rax,1
mov rdi,[fd]
mov rsi,buffer
mov rdx,qword[fcount]
syscall

print msg1,len1

mov rax,3
mov rdi,[fd]
syscall

exit:
mov rax,60
mov rdi,0
syscall
