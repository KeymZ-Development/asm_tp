section .bss
    buffer resb 20

section .data
    line db 10

section .text
    global _start

_start:
    cmp byte [rsp], 3
    jne exit_failure

    mov rsi, [rsp+16]
    call ascii_to_int
    mov r12, rax

    mov rsi, [rsp+24]
    call ascii_to_int
    mov r13, rax

    add r12, r13

    mov rax, r12
    mov rdi, buffer
    call int_to_ascii

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, line
    mov rdx, 1
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall

ascii_to_int:
    xor rax, rax
    xor rbx, rbx
    mov r10, 1

    cmp byte [rsi], '-'
    jne .loop
    mov r10, -1
    inc rsi

.loop:
    mov bl, [rsi]
    cmp bl, 0
    je .done
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop
.done:
    imul rax, r10
    ret

int_to_ascii:
    mov r8, rdi
    mov r9, 10
    mov r11, 0

    test rax, rax
    jns .convert
    neg rax
    mov r11, 1

.convert:
    add rdi, 19
    mov byte [rdi], 0
    dec rdi
.loop:
    xor rdx, rdx
    div r9
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .loop

    cmp r11, 1
    jne .copy
    mov byte [rdi], '-'
    dec rdi

.copy:
    inc rdi
    mov rdx, r8
    add rdx, 20
    sub rdx, rdi
    mov rax, rdx

    mov rcx, rax
    mov rsi, rdi
    mov rdi, r8
    rep movsb
    ret
