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
    je pre_printing         ; First instance of 1 is the pattern
    
    cmp ECX, 8              ; Reached signal 0
    je pre_printing         
    
    jmp signal_mapping

pre_printing:
    PRINT_STRING "Compressed code: "
    PRINT_CHAR [STRIN]  ; Sign bit

    mov AL, 8   ; Register for num of signals
    sub AL, CL  ; Subtract 8 by counter to get signal num
    
    mov CH, 7   ; Counter for print_0
    
    cmp AL, 0           ; Jumps only if not segment 0
    jne binary_printer  ; This  will print the first 3 bits after sign

    PRINT_STRING "000"    ; For Signal 0

printing:
    xor ECX, ECX
    cmp AL, 0           ; Is segment 0?
    je print_remaining
    
print_1:
    inc EBX

print_remaining:
    cmp ECX, 4  ; Printed all remaining
    jge tapos
    
    mov AH, byte[STRIN+EBX] ; Char to print
    PRINT_CHAR AH
    
    inc EBX ; Pointer
    inc ECX ; Counter
    
    jmp print_remaining
    
tapos:
    NEWLINE
    PRINT_STRING "Segment number: "
    PRINT_UDEC 1, AL


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

binary_printer:
    mov AH, 4   ; 3rd bit
bin_loop:
    mov DH, AL  ; Copy signal num
    and DH, AH  ; Check bit
    
    cmp DH, AH
    je bin_print
    
    PRINT_CHAR "0"  ; Since AND operation failed
    
    cmp AH, 0   ; Finished printing first 4 bits
    je printing
    
    dec AH  ; Subtract 2
    dec AH
    
    jmp bin_loop
    
bin_print:
    
    PRINT_CHAR "1"  ; Since AND operation succeeded
    
    cmp AH, 0   ; Finished printing first 4 bits
    je printing
    
    dec AH  ; Subtract 2
    dec AH
    
    jmp bin_loop