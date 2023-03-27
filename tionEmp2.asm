%include "io.inc"

section .data
STRIN times 14 dw 0 ; Initialize 12 bit string

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here

input:
    PRINT_STRING "Input 12-bit code: "
    GET_STRING [STRIN], 14
    PRINT_STRING [STRIN]
    
    cmp byte[STRIN], 0   ; null
    je error_null
    cmp byte[STRIN], 10  ; \n
    je error_null
    cmp byte[STRIN], 13  ; return
    je error_null
    

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

    