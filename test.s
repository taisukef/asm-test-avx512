SECTION .data
	MESSAGE db `Hello World!\n`
	MESSAGE_LEN equ $-MESSAGE

SECTION .text
global _main

_main:
	mov rax, 0x2000004		; syscall 4: write
	mov rdi, 1				;  fd = stdout
	mov rsi, MESSAGE		;  buffer
	mov rdx, MESSAGE_LEN	;  size
	syscall

	mov rax, 0x2000001	; syscall 1: exit
	mov rdi, 0			;  retcode
	syscall
