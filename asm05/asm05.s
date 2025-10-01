section .data
    lf db 10

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne err
    mov rsi, [rsp+16]
    mov rdi, rsi
    call strlen
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, lf
    mov rdx, 1
    syscall
    mov rax, 60
    xor rdi, rdi
    syscall
err:
    mov rax, 60
    mov rdi, 1
    syscall

strlen:
    mov rax, 0
.l:
    cmp byte [rdi+rax], 0
    je .d
    inc rax
    jmp .l
.d:
    ret
