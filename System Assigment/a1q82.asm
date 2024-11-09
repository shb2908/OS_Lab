.model small
.stack 100h
.data 
  arr1 dw 1988h, 1021h, 6341h, 1772h
  len dw 0003h
  max dw ?
  min dw ?

.code
main proc
    mov ax, @data
    mov ds, ax
    
    lea si, arr1
    mov cx, len
    mov ax, [si]
    mov max, ax
    mov min, ax
    
    mov dx, 1
    add si, 2
    
find_extremes:
    mov ax, [si]
    cmp ax, max
    jbe check_min
    mov max, ax
    
check_min:
    cmp ax, min
    jae next_element
    mov min, ax

next_element:
    add si, 2
    loop find_extremes
    
    ;print max
    mov ax, max
    call print
    
    ;print newline
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    ;print min
    mov ax, min
    call print
    
    exit:
    mov ah,4Ch
    int 21h
main endp

print proc near
    mov bx, ax
    mov ch, 04h
    mov cl, 04h
    xor dl, dl
    
print_loop:
    rol bx, cl
    mov dl, bl
    and dl, 0Fh
    cmp dl, 09h
    jle convert
    add dl, 37h
    jmp print_char
    
convert:
    add dl, 30h
    
print_char:
    mov ah, 02h
    int 21h
    dec ch
    jnz print_loop
    
    ret
print endp
end main
