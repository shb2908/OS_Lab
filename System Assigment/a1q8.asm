.model small
.stack 100h
.data
    arr1 dw 1900h, 1000h, 1300h, 1660h
    len dw 0003h   ; This should be the index of the last element, not the count.
    maxVal dw ?
    minVal dw ?
.code
main proc
    mov ax, @data
    mov ds, ax
    
    lea si, arr1       ; Load address of arr1 into SI
    mov cx, len        ; Set loop count to length of array (3 for indexing)
    mov ax, [si]       ; Initialize maxVal and minVal
    mov maxVal, ax
    mov minVal, ax

    mov dx, 1          ; Start index from 1
    add si, 2          ; Move SI to the second element (SI points to arr1[1])

find_extremes:
    mov ax, [si]
    cmp ax, maxVal
    jbe check_min
    mov maxVal, ax

check_min:
    cmp ax, minVal
    jae next_element
    mov minVal, ax

next_element:
    add si, 2          ; Move to the next element in the array (each element is 2 bytes)
    loop find_extremes

    ; Print maxVal
    mov ax, maxVal
    call print

    ; Print newline
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Print minVal
    mov ax, minVal
    call print

    ; Exit program
    mov ah, 4Ch
    int 21h
main endp

print proc near
    mov bx, ax           ; Move value to BX
    mov ch, 04h          ; Number of digits
    mov cl, 04h
    xor dl, dl           ; Clear DL

print_loop:
    rol bx, cl           ; Rotate left 4 bits
    mov dl, bl           ; Move lower nibble to DL
    and dl, 0Fh          ; Mask to get the lower 4 bits
    cmp dl, 09h
    jle convert_digit
    add dl, 37h          ; Convert to ASCII for A-F
    jmp print_char

convert_digit:
    add dl, 30h          ; Convert to ASCII for 0-9

print_char:
    mov ah, 02h
    int 21h              ; Print the character
    dec ch
    jnz print_loop

    ret
print endp

end main
