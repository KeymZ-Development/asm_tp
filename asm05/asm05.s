section .data
    eol db 10

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne err

    mov rsi, [rsp+16]

    mov rdi, rsi
    call str_len
    mov rdx, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, [rsp+16]
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, eol
    mov rdx, 1
    syscall

ok:
    mov rax, 60
    xor rdi, rdi
    syscall

err:
    mov rax, 60
    mov rdi, 1
    syscall

str_len:
    xor rax, rax
.scan:
    cmp byte [rdi+rax], 0
    je .end
    inc rax
    jmp .scan
.end:
    ret
