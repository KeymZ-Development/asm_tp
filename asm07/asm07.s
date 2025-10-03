section .bss
    inbuf resb 16

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, inbuf
    mov rdx, 16
    syscall

    mov rsi, inbuf
    call to_i
    
    test rax, rax
    js done_fail

    call is_p
    cmp rax, 1
    je done_ok

done_fail:
    mov rax, 60
    mov rdi, 1
    syscall

done_ok:
    mov rax, 60
    xor rdi, rdi
    syscall

to_i:
    xor rax, rax
    xor rbx, rbx
    xor rdx, rdx
    
    cmp byte [rsi], '-'
    jne .scan
    mov rdx, 1
    inc rsi
    
.scan:
    mov bl, [rsi]
    cmp bl, 10
    je .end
    cmp bl, 0
    je .end
    cmp bl, '0'
    jb .bad
    cmp bl, '9'
    ja .bad
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .scan
.end:
    test rdx, rdx
    jz .pos
    neg rax
.pos:
    ret
.bad:
    mov rax, 60
    mov rdi, 2
    syscall

is_p:
    cmp rax, 2
    jb .not
    cmp rax, 2
    je .yes
    
    mov rbx, rax
    mov rcx, 2
    
.trial:
    mov rax, rbx
    xor rdx, rdx
    div rcx
    cmp rdx, 0
    je .not
    
    inc rcx
    mov rax, rcx
    imul rax, rax
    cmp rax, rbx
    jbe .trial
    
.yes:
    mov rax, 1
    ret
.not:
    xor rax, rax
    ret
