section .bss
    outbuf  resb 32

section .text
    global _start

to_i:
    push rbx
    push rcx
    push rdx
    xor rax, rax
    xor rbx, rbx

    mov dl, byte [rsi]
    cmp dl, '-'
    jne .check_plus
    mov rbx, 1
    inc rsi
    jmp .read_digits
.check_plus:
    cmp dl, '+'
    jne .read_digits
    inc rsi

.read_digits:
    mov rcx, 0
.read_loop:
    mov dl, byte [rsi]
    cmp dl, 0
    je .end_digits
    cmp dl, '0'
    jb .done_err
    cmp dl, '9'
    ja .done_err
    mov r8, rax
    mov rdx, 0
    mov r9, 10
    mul r9
    test rdx, rdx
    jne .done_err
    sub dl, '0'
    movzx r9, dl
    add rax, r9
    jc .done_err
    inc rsi
    inc rcx
    jmp .read_loop

.end_digits:
    cmp rcx, 0
    je .done_err
    test rbx, rbx
    jz .ok
    neg rax
.ok:
    clc
    pop rdx
    pop rcx
    pop rbx
    ret
.done_err:
    stc
    pop rdx
    pop rcx
    pop rbx
    ret

put_i:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10

    lea r10, [rel outbuf+31]
    mov byte [r10], 10
    dec r10

    xor r8d, r8d
    test rax, rax
    jns .abs_ready
    mov r8d, 1
    neg rax
.abs_ready:

    xor ecx, ecx
    cmp rax, 0
    jne .conv_loop
    mov byte [r10], '0'
    dec r10
    inc rcx
    jmp .conv_done
.conv_loop:
    xor rdx, rdx
    mov r9d, 10
.divstep:
    div r9
    add dl, '0'
    mov byte [r10], dl
    dec r10
    inc rcx
    test rax, rax
    jne .divstep
.conv_done:
    test r8d, r8d
    jz .no_sign
    mov byte [r10], '-'
    dec r10
    inc rcx
.no_sign:
    lea rsi, [r10+1]

    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel outbuf+31]
    mov rdx, 1
    syscall

    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret

_start:
    cmp byte [rsp], 3
    jne err
    mov rsi, [rsp+16]
    call to_i
    jc err
    mov r8, rax
    mov rsi, [rsp+24]
    call to_i
    jc err
    add rax, r8
    call put_i
    mov rax, 60
    xor rdi, rdi
    syscall

err:
    mov rax, 60
    mov rdi, 1
    syscall

