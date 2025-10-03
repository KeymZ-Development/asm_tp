section .bss
    outbuf resb 65

section .data
    eol db 10
    hexmap db "0123456789ABCDEF"
    bflag db "-b", 0

section .text
    global _start

_start:
    mov r12, 16
    mov r13, [rsp+16]

    cmp qword [rsp], 3
    jne .check
    mov rdi, [rsp+16]
    mov rsi, bflag
    call str_eq
    cmp rax, 0
    jne .badflag

    mov r12, 2
    mov r13, [rsp+24]
    jmp .check

.badflag:
    cmp qword [rsp], 3
    je err

.check:
    cmp qword [rsp], 2
    jl err

    mov rsi, r13
    call to_i
    cmp rcx, 1
    je err
    
    test rax, rax
    js err

    mov rdi, outbuf
    mov rsi, r12
    call to_base

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, outbuf
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

str_eq:
    push rsi
    push rdi
.scan:
    mov al, [rdi]
    mov ah, [rsi]
    cmp al, ah
    jne .ne
    cmp al, 0
    je .eq
    inc rsi
    inc rdi
    jmp .scan
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

to_i:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
.scan:
    mov bl, [rsi]
    cmp bl, 0
    je .end
    
    cmp bl, '0'
    jl .error
    cmp bl, '9'
    jg .error
    
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .scan
.error:
    mov rcx, 1
    ret
.end:
    ret

to_base:
    mov r8, rdi
    mov r9, rsi
    add rdi, 64
    mov byte [rdi], 0
    dec rdi
.digits:
    xor rdx, rdx
    div r9
    lea r10, [hexmap]
    mov r10b, [r10+rdx]
    mov [rdi], r10b
    dec rdi
    test rax, rax
    jnz .digits

    inc rdi
    mov rdx, r8
    add rdx, 65
    sub rdx, rdi
    mov rax, rdx

    mov rcx, rax
    mov rsi, rdi
    mov rdi, r8
    rep movsb
    ret
