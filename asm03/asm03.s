section .data
    key db "42", 0
    msg db "1337", 10
    msg_len equ $ - msg

section .text
    global _start

_start:
    mov rsi, [rsp+16]
    cmp byte [rsp], 2
    jne err

    mov rdi, key
    call str_equal
    cmp rax, 0
    jne err

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

ok:
    mov rax, 60
    xor rdi, rdi
    syscall

err:
    mov rax, 60
    mov rdi, 1
    syscall

str_equal:
    push rsi
    push rdi
.loop:
    mov al, [rdi]
    mov ah, [rsi]
    cmp al, ah
    jne .ne
    cmp al, 0
    je .eq
    inc rsi
    inc rdi
    jmp .loop
.eq:
    pop rdi
    pop rsi
    xor rax, rax
    ret
.ne:
    pop rdi
    pop rsi
    mov rax, 1
    ret
