section .bss
    inbuf resb 65536
    outbuf resb 32

section .data
    vset db "aeiouyAEIOUY"
    eol db 10
    dec10 dq 10

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, inbuf
    mov rdx, 65536
    syscall

    mov r11, rax
    mov r12, 0
    mov r13, inbuf
    mov r10, 0
.scan:
    cmp r10, r11
    jge .done
    mov r14b, [r13]
    cmp r14b, 10
    je .done
    cmp r14b, 0
    je .done

    mov r15, 0
.match:
    cmp r15, 12
    je .adv
    mov bl, [vset+r15]
    cmp r14b, bl
    je .hit
    inc r15
    jmp .match

.hit:
    inc r12

.adv:
    inc r13
    inc r10
    jmp .scan

.done:
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

    mov rax, 60
    xor rdi, rdi
    syscall

to_a:
    mov r8, rdi
    add rdi, 31
    mov byte [rdi], 0
    dec rdi
.digits:
    xor rdx, rdx
    div qword [dec10]
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .digits
    inc rdi
    mov rsi, rdi
    mov rdi, r8
    mov rcx, 32
    rep movsb
    mov rax, rsi
    sub rax, r8
    ret
