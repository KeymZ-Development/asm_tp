section .bss
    inbuf resb 5

section .data
    magic db 0x7f, "ELF"

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne err

    mov rax, 2
    mov rdi, [rsp+16]
    xor rsi, rsi
    syscall

    cmp rax, 0
    jl err
    mov r12, rax

    mov rax, 0
    mov rdi, r12
    mov rsi, inbuf
    mov rdx, 5
    syscall

    mov rax, 3
    mov rdi, r12
    syscall

    mov rsi, inbuf
    mov rdi, magic
    mov rcx, 4
    repe cmpsb
    jne err

    cmp byte [inbuf+4], 2
    jne err

ok:
    mov rax, 60
    xor rdi, rdi
    syscall

err:
    mov rax, 60
    mov rdi, 1
    syscall
