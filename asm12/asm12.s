section .bss
    inbuf resb 1024

section .data
    eol db 10

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, inbuf
    mov rdx, 1024
    syscall

    mov r12, rax
    dec r12

    mov rsi, inbuf
    mov rdi, inbuf
    add rdi, r12
    dec rdi

.rev:
    cmp rsi, rdi
    jge .done

    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al

    inc rsi
    dec rdi
    jmp .rev

.done:
    mov rax, 1
    mov rdi, 1
    mov rsi, inbuf
    mov rdx, r12
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
