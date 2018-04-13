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

extern count,buffer
section .data

msg db "Number of spaces:",10
len equ $-msg

msg1 db "Number of lines:",10
len1 equ $-msg1

msg2 db "Number of occurences of letter:",10
len2 equ $-msg2

getletter db "Enter the letter",10
lenletter equ $-getletter

newline db 10


section .bss


spacecnt resb 2
linecnt resb 4
lettercnt resb 4
answer resb 4
letter resb 2

section .text


global find


find:

print getletter,lenletter
scan letter,2

mov byte[spacecnt],0H
mov byte[linecnt],0H
mov byte[lettercnt],0H

mov dl,byte[letter]

mov rcx,qword[count]
mov rsi,buffer
l2:
cmp byte[rsi],20H
jnz l1
inc byte[spacecnt]
l1:
cmp byte[rsi],0AH
jnz l3
inc byte[linecnt]
l3:
cmp byte[rsi],dl
jnz l4
inc byte[lettercnt]
l4:
inc rsi
loop l2


print msg,len
cmp byte[spacecnt],09H
jbe l5
add byte[spacecnt],07H
l5:
add byte[spacecnt],30H

print spacecnt,2
print newline,1

print msg1,len1
cmp byte[linecnt],09H
jbe l6
add byte[linecnt],07H
l6:
add byte[linecnt],30H

print linecnt,2
print newline,1

print msg2,len2
cmp byte[lettercnt],09H
jbe l7
add byte[lettercnt],07H
l7:
add byte[lettercnt],30H

print lettercnt,2
print newline,1

ret

