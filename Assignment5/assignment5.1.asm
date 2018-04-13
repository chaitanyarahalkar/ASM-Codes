%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

global buffer,count
section .data

filename db 'sample.txt',0

msg db "File opened successfully",10
len equ $-msg



section .bss


fd resb 8
buffer resb 100
count resb 4

section .text

extern find

global _start

_start:

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

mov qword[count],rax

call find

mov rax,3
mov rdi,[fd]
syscall


exit:
mov rax,60
mov rdi,0
syscall
