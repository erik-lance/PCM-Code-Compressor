%include "io.inc"


section .text
global main
main:
    ;write your code here
    
    ; 89 Y
    ; 78 N

input:
    PRINT_STRING "Input 12-bit code: "
    

tapos:
    xor eax, eax
    ret

error_length:
    PRINT_STRING "Input should be 12 bits in length!"
    jmp continue

error_binary:
    PRINT_STRING "Input should be 1's and 0's only!"

continue:
    NEWLINE
    PRINT_STRING "Do you want to continue (Y/N)?"
    GET_CHAR 1, DL
    cmp DL, 89      ; Check if yes
    je input
    cmp DL, 78      ; Check if no
    je tapos
    
    PRINT_STRING "Error, invalid input"
    jmp continue

    