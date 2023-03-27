%include "io.inc"

section .data
STRIN times 13 dw 0 ; Initialize 12 bit string

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here
input:
    PRINT_STRING "Input 12-bit code: "
    GET_STRING [STRIN], 32
    PRINT_STRING [STRIN]
    
    NEWLINE
    
    cmp byte[STRIN], 0   ; null
    je error_null
    cmp byte[STRIN], 10  ; \n
    je error_null
    cmp byte[STRIN], 13  ; return
    je error_null

    xor EBX, EBX    ; Pointer
    xor ECX, ECX    ; Counter Length
read:    
    cmp byte[STRIN+EBX], 48 ; If 0
    je continue_read
    
    cmp byte[STRIN+EBX], 49 ; If 1
    jne error_binary

continue_read:
    inc EBX ; Pointer
    inc ECX ; Counter

    cmp byte[STRIN+EBX], 0   ; null
    je check_read    
    cmp byte[STRIN+EBX], 10  ; \n
    je check_read
    cmp byte[STRIN+EBX], 13  ; return
    je check_read
    
    jmp read

check_read:
    cmp ECX, 12         ; Check if string is of length 12
    jne error_length

tapos:
    


    xor eax, eax
    ret

error_null:
    PRINT_STRING "Input must not be empty!"
    jmp continue

error_length:
    PRINT_STRING "Input should be 12 bits in length!"
    jmp continue

error_binary:
    PRINT_STRING "Input should be 1's and 0's only!"

continue:
    NEWLINE
    PRINT_STRING "Do you want to continue (Y/N)?"
    GET_CHAR DL
    cmp DL, 89      ; Check if yes
    je input
    cmp DL, 78      ; Check if no
    je tapos
    
    PRINT_STRING "Error, invalid input"
    jmp continue

    