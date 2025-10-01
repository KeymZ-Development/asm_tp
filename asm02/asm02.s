section .data
    needle db "42", 0x0A
    needle_len equ $ - needle
    answer db "1337", 0x0A
    answer_len equ $ - answer

section .bss
    inbuf resb 8

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, inbuf
    mov rdx, 8
    syscall

    cmp rax, needle_len
    jne done_err

    mov rsi, inbuf
    mov rdi, needle
    mov rcx, needle_len
    repe cmpsb
    jne done_err

    mov rax, 1
    mov rdi, 1
    mov rsi, answer
    mov rdx, answer_len
    syscall

done_ok:
    mov rax, 60
    xor rdi, rdi
    syscall

done_err:
    mov rax, 60
    mov rdi, 1
    syscall
