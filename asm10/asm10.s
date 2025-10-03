section .bss
    outbuf resb 32

section .data
    eol db 10
    dec10 dq 10

section .text
    global _start

_start:
    cmp qword [rsp], 4
    jne err

    mov rsi, [rsp+16]
    call to_i
    mov r12, rax

    mov rsi, [rsp+24]
    call to_i
    cmp r12, rax
    jge .s1
    mov r12, rax
.s1:

    mov rsi, [rsp+32]
    call to_i
    cmp r12, rax
    jge .s2
    mov r12, rax
.s2:

    mov rax, r12
    mov rdi, outbuf
    call to_a

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

to_i:
    xor rax, rax
    xor rbx, rbx
    xor r10, r10
    
    cmp byte [rsi], '-'
    jne .scan
    mov r10, 1
    inc rsi
    
.scan:
    mov bl, [rsi]
    cmp bl, 0
    je .end
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .scan
.end:
    test r10, r10
    jz .pos
    neg rax
.pos:
    ret

to_a:
    mov r8, rdi
    mov r11, 0
    
    test rax, rax
    jns .conv
    neg rax
    mov r11, 1
    
.conv:
    add rdi, 31
    mov byte [rdi], 0
    dec rdi
.scan:
    xor rdx, rdx
    div qword [dec10]
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .scan

    cmp r11, 1
    jne .cpy
    mov byte [rdi], '-'
    dec rdi

.cpy:
    inc rdi
    mov rdx, r8
    add rdx, 32
    sub rdx, rdi
    mov rax, rdx

    mov rcx, rax
    mov rsi, rdi
    mov rdi, r8
    rep movsb
    ret
