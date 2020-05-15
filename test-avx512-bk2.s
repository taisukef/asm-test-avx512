SECTION .data
	MESSAGE db `Hello World!\n`
	MESSAGE_LEN equ $-MESSAGE

SECTION .text
global _main

_main:
	mov rax, 0x0706050403020100
	movq ymm1, rax
	mov rax, 0x0101010101010101
	movq ymm2, rax
	
	vpaddb ymm0, ymm1, ymm2 ; ymm0 = ymm1 + ymm2 (256bit SIMD add, 8bit * 32)

	movq rax, xmm0     ; only lower 64 bit
	call output_hex
	call output_enter

	mov rax, 0xABCD
	call output_hex
	call output_enter

	mov rax, 1234567890
	call output_number
	call output_enter

	mov rax, 1234567890
	call output_number
	call output_enter

	mov rax, 0x2000001	; syscall 1: exit
	mov rdi, 0			;  retcode
	syscall

output_number: ; only plus!
	xor rdx, rdx
	mov rcx, 10
	div rcx
	or rax, rax
	push rdx
	je output_number_skip
	call output_number
output_number_skip:
  pop rax
	add al, '0'
	jmp output_char

output_char: ; \n -> \r\n
	cmp al, 0x0d
	jne output_char_skip
new_line:
	mov al, 0x0a
	call output_char_skip
	mov al, 0x0d
output_char_skip:
	call syscall_putchar
	ret

output_enter:
	mov al, 0x0d
	jmp output_char

output_hex:
	xor rdx, rdx
	mov rcx, 16 ; bit shift is better
	div rcx
	or rax, rax
	push rdx
	je output_hex_skip
	call output_hex
output_hex_skip:
  pop rax
	mov rsi, HEX
	add rsi, rax
	mov al, [rsi]
	jmp output_char


syscall_putchar:
	mov rsi, putchar_buf		;  buffer
	mov [rsi], al
	mov rax, 0x2000004		; syscall 4: write
	mov rdi, 1				;  fd = stdout
	mov rdx, 1	;  size
	syscall
	ret

section .bss
	putchar_buf resb 1

section .data
	HEX db `0123456789ABCDEF`
