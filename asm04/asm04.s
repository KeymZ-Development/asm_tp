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

    cmp rcx, 1
    je done_bad
    cmp rcx, 2
    je done_bad

    test rax, 1
    jnz done_odd

done_ok:
    mov rax, 60
    xor rdi, rdi
    syscall

done_odd:
    mov rax, 60
    mov rdi, 1
    syscall

done_bad:
    mov rax, 60
    mov rdi, 2
    syscall

to_i:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx
    
    mov bl, [rsi]
    cmp bl, '-'
    jne .loop
    mov rdx, 1
    inc rsi
    
.loop:
    mov bl, [rsi]
    cmp bl, 10
    je .done
    cmp bl, 0
    je .done

    cmp bl, '0'
    jl .error
    cmp bl, '9'
    jg .error

    sub bl, '0'
    
    mov r8, rax
    imul rax, 10
    jo .overflow
    add rax, rbx
    jo .overflow
    
    cmp rax, r8
    jl .overflow
    
    inc rsi
    jmp .loop

.overflow:
    mov rcx, 2
    jmp .done

.error:
    mov rcx, 1
.done:
    test rdx, rdx
    jz .positive
    neg rax
.positive:
    ret
