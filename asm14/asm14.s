section .data
    text db "Hello Universe!", 10
    tlen equ $ - text

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne err

    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 65
    mov rdx, 0644o
    syscall

    cmp rax, 0
    jl err

    mov r12, rax

    mov rax, 1
    mov rdi, r12
    mov rsi, text
    mov rdx, tlen
    syscall

    mov rax, 3
    mov rdi, r12
    syscall

ok:
    mov rax, 60
    xor rdi, rdi
    syscall

err:
    mov rax, 60
    mov rdi, 1
    syscall
