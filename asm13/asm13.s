section .bss
    inbuf resb 65536

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, inbuf
    mov rdx, 65536
    syscall

    mov r12, rax
    test r12, r12
    jz ok
    
    dec r12
.trim:
    cmp r12, 0
    jl ok
    mov al, [inbuf+r12]
    cmp al, 10
    je .dec
    cmp al, 13
    je .dec
    jmp .start
.dec:
    dec r12
    jmp .trim

.start:
    mov rsi, inbuf
    mov rdi, inbuf
    add rdi, r12

.scan:
    cmp rsi, rdi
    jge ok

    mov al, [rsi]
    mov bl, [rdi]
    cmp al, bl
    jne err

    inc rsi
    dec rdi
    jmp .scan

ok:
    mov rax, 60
    xor rdi, rdi
    syscall

err:
    mov rax, 60
    mov rdi, 1
    syscall
