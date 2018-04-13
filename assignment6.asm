%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data

msg1 db "In protected mode",10
len1 equ $-msg1

msg2 db 10
len2 equ $-msg2

msg3 db "GDTR Contents-",10
len3 equ $-msg3

msg4 db "LDTR Contents-",10
len4 equ $-msg4

msg5 db "IDTR Contents-",10
len5 equ $-msg5

msg6 db "TR Contents-",10
len6 equ $-msg6

msg7 db "Limit:",10
len7 equ $-msg7

msg8 db "Base Address:",10
len8 equ $-msg8

msg9 db "MSW Contents-",10
len9 equ $-msg9

msg10 db "Mode of operation",10
len10 equ $-msg10



section .bss

gdt resb 6
ans resb 4 
ldt resb 2
idt resb 6
tr resb 2
msw resb 4

section .text

global _start

_start:

print msg10,len10
smsw ax
bt ax,0
jc l1
l1:print msg1,len1

print msg5,len5
print msg7,len7
sidt [idt]
mov dx,word[idt + 4]
call h2a
print msg2,len2
print msg8,len8
mov dx,word[idt + 2]
call h2a
mov dx,word[idt]
call  h2a
print msg2,len2


print msg4,len4
sldt [ldt]
mov dx,word[ldt]
call h2a
print msg2,len2

print msg6,len6
sldt [tr]
mov dx,word[tr]
call h2a
print msg2,len2

print msg3,len3
print msg7,len7
sgdt [gdt]
mov dx,word[gdt + 4]
call h2a
print msg2,len2
print msg8,len8
mov dx,word[gdt + 2]
call h2a
mov dx,word[gdt]
call  h2a
print msg2,len2

print msg9,len9
smsw [msw]
mov dx,word[msw + 4]
call h2a
mov dx,word[msw]
call h2a



jmp exit

h2a:
mov rcx,04
mov rsi,ans
l3:
rol dx,04
mov al,dl
and al,0fh
cmp al,09h
jbe l2
add al,07h
l2:add al,30h
mov byte[rsi],al
inc rsi
loop l3
print ans,4
ret

exit:
mov rax,60
mov rdi,0
syscall
