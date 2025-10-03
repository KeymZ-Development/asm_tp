section .data
    expected db "42", 0x0A
    expected_len equ $ - expected
    output db "1337", 0x0A
    output_len equ $ - output

section .bss
    buffer resb 1024

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1024
    syscall

    cmp rax, 0
    jle exit_failure

    cmp rax, expected_len
    jl exit_failure

    mov rsi, buffer
    mov rdi, expected
    mov rcx, expected_len
    repe cmpsb
    jne exit_failure

    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, output_len
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall
