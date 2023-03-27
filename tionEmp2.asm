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

    xor EBX, EBX    ; Pointer
    xor ECX, ECX    ; Counter
signal_mapping:
    ; Skip sign bit
    inc EBX ; Pointer
    inc ECX ; Counter

    cmp byte[STRIN+EBX], 49 ; If 1
    je printing             ; First instance of 1 is the pattern
    
    cmp ECX, 8              ; Reached signal 0
    je printing
    
    jmp signal_mapping

printing:
    PRINT_STRING "Compressed code: "
    PRINT_CHAR [STRIN]  ; Sign bit
    
    mov AL, 8   ; Register for num of signals
    sub AL, CL  ; Subtract 8 by counter to get signal num
    
    mov CH, 7   ; Counter for print_0
print_0:
    cmp CH, AL  ; Check signal number if same, stop printing 0
    je print_1
    
    PRINT_CHAR "0"
print_1:
    PRINT_CHAR "1"
    xor EBX, EBX
    mov BL, CL ; Start from left off
    inc EBX
print_remaining:
    cmp byte[STRIN+EBX], 0   ; null
    je tapos    
    cmp byte[STRIN+EBX], 10  ; \n
    je tapos
    cmp byte[STRIN+EBX], 13  ; return
    je tapos
    
    mov AH, byte[STRIN+EBX] ; Char to print
    PRINT_CHAR AH
    
    inc EBX ; Pointer
    jmp print_remaining
    
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

    