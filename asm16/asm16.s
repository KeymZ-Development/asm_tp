section .bss
    inbuf resb 16384

section .data
    needle db "1337"
    repl db "H4CK"
    patched db "H4CK"

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne err

    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 2
    syscall
    cmp rax, 0
    jl err
    mov r12, rax

    mov rax, 0
    mov rdi, r12
    mov rsi, inbuf
    mov rdx, 16384
    syscall
    mov r13, rax

    mov rdi, inbuf
    mov rsi, patched
    mov rcx, r13
    mov rdx, 4
    call find
    
    cmp rax, 0
    jne .is_patched

    mov rdi, inbuf
    mov rsi, needle
    mov rcx, r13
    mov rdx, 4
    call find

    cmp rax, 0
    je .close_ok

    mov rdi, rax
    mov rsi, repl
    mov rcx, 4
    rep movsb

    mov rax, 8
    mov rdi, r12
    xor rsi, rsi
    xor rdx, rdx
    syscall

    mov rax, 1
    mov rdi, r12
    mov rsi, inbuf
    mov rdx, r13
    syscall

.is_patched:
    mov rax, 3
    mov rdi, r12
    syscall
    jmp err

.close_ok:
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

find:
    sub rcx, rdx
    inc rcx
.scan:
    test rcx, rcx
    jz .miss

    push rdi
    push rsi
    push rcx
    mov rcx, rdx
    repe cmpsb
    pop rcx
    pop rsi
    pop rdi
    je .hit

    inc rdi
    dec rcx
    jmp .scan

.hit:
    mov rax, rdi
    ret

.miss:
    xor rax, rax
    ret
