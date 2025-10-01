section .bss
    inbuf resb 64

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, inbuf
    mov rdx, 64
    syscall
    cmp rax, 1
    jl err

    mov rcx, 0
.skip:
    mov bl, byte [inbuf + rcx]
    cmp bl, ' '
    je .adv
    cmp bl, 9
    je .adv
    cmp bl, 10
    je .adv
    jmp .start
.adv:
    inc rcx
    jmp .skip

.start:
    mov bl, byte [inbuf + rcx]
    cmp bl, '+'
    je .after
    cmp bl, '0'
    jb err
    cmp bl, '9'
    ja err
.after:
    cmp bl, '+'
    jne .have
    inc rcx
.have:
    mov rdx, -1
.digits:
    mov bl, byte [inbuf + rcx]
    cmp bl, '0'
    jb .done
    cmp bl, '9'
    ja .done
    mov dl, bl
    inc rcx
    jmp .digits

.done:
    cmp rdx, -1
    je err

    sub rdx, '0'
    and rdx, 1
    cmp rdx, 0
    je ok
    jmp err

ok:
    mov rax, 60
    xor rdi, rdi
    syscall

err:
    mov rax, 60
    mov rdi, 1
    syscall
