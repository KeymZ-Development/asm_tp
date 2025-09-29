section .data
    msg db "1337", 10
    len equ $ - msg

section .text
    global _start

_start:
    ; write(stdout, "1337\n", len)
    mov rax, 1      ; sys_write
    mov rdi, 1      ; stdout
    mov rsi, msg
    mov rdx, len
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall
