section .rodata
    format_int_true: db " is greater than ", 0
    fit_len: equ $-format_int_true
    format_int_false: db " is not greater than ", 0
    fif_len: equ $-format_int_false
    
    input_prompt: db "Please input a number: ", 0
    input_prompt_length: equ $-input_prompt

section .bss
    number1: resb 2
    number2: resb 2
    
section .text
    extern printf
    global _start

_start:
    call read
    call compare
end_if:

    call exit

compare:
    mov eax, dword [number1]
    mov ebx, dword [number2]
    cmp eax, ebx            ; Compare with number2

    ; if not greater then
    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, number1
    mov edx, 0x1
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    
    jg greater_than
    
    ; else
    mov ecx, format_int_false
    mov edx, fif_len
    
    jmp lvif
    
    greater_than:
        mov ecx, format_int_true
        mov edx, fit_len
        
    lvif:    
        int 0x80

    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, number2
    mov edx, 0x1
    int 0x80

    jmp end_if                 ; jump to after the if statement

read:
    mov eax, 0x4          ; write syscall
    mov ebx, 0x1          ; stdout
    mov ecx, input_prompt
    mov edx, input_prompt_length
    int 0x80

    mov eax, 0x3          ; read syscall
    mov ebx, 0
    mov ecx, number1    ; destination
    mov edx, 0x2        ; length
    int 0x80

    mov eax, 0x4          ; write syscall
    mov ebx, 0x1          ; stdout
    mov ecx, input_prompt
    mov edx, input_prompt_length
    int 0x80

    mov eax, 0x3
    mov ebx, 0 
    mov ecx, number2
    mov edx, 0x1
    int 0x80

    ret

exit:
    mov eax, 0x1
    xor ebx, ebx
    int 0x80