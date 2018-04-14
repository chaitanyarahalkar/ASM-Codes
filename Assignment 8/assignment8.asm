; Bubble sort
%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

err db "Error while opening the file",10
len equ $-err

section .bss

filename1 resb 8
filename2 resb 8
fd resb 8
buffer resb 100
fcount resb 8


section .text
global _start

_start:

pop rsi
pop rsi
pop rsi

cmp byte[rsi],'c'
je copy
cmp byte[rsi],'t'
je type
cmp byte[rsi],'d'
je delete

copy:

pop rbx
mov rsi,filename1
l1:
mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0
jnz l1


mov rax,2
mov rdi,filename1
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt rax,63
jc error

mov rax,0
mov rdi,[fd]
mov rsi,buffer
mov rdx,100
syscall

mov qword[fcount],rax

mov rax,3
mov rdi,[fd]
syscall

pop rbx 
mov rdi,filename2
l2:
mov al,byte[rbx]
mov byte[rdi],al
inc rbx
inc rdi
cmp byte[rbx],0
jnz l2

mov rax,2
mov rdi,filename2
mov rsi,0102o
mov rdx,0666o
syscall

mov qword[fd],rax

mov rax,1
mov rdi,[fd]
mov rsi,buffer
mov rdx,qword[fcount]
syscall

mov rax,3
mov rdi,[fd]
syscall


jmp exit

type:

pop rbx
mov rsi,filename1
l3:
mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0
jnz l3

mov rax,2
mov rdi,filename1
mov rsi,2
mov rdx,0777
syscall

mov qword[fd],rax
bt rax,63
jc error

mov rax,0
mov rdi,[fd]
mov rsi,buffer
mov rdx,100
syscall

mov qword[fcount],rax

mov rax,1
mov rdi,1
mov rsi,buffer
mov rdx,qword[fcount]
syscall

mov rax,3
mov rdi,[fd]
syscall

jmp exit

delete:

pop rbx
mov rsi,filename1
l5:
mov al,byte[rbx]
mov byte[rsi],al
inc rbx
inc rsi
cmp byte[rbx],0
jnz l5

mov rax,2
mov rdi,filename1
mov rsi,2
mov rdx,0777
syscall


mov qword[fd],rax
bt rax,63
jc error

mov rax,87
mov rdi,filename1
syscall


jmp exit

error:
print err,len

exit:
mov rax,60
mov rdi,0
syscall
