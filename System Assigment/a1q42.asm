.model small
.stack 100h
.data
    arr dw 1988h, 1011h, 6334h, 1672h ; Array elements (16-bit each)
    n equ (($-arr) / 2)           ; Number of elements in the array

.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; Initialize pointers and counters
    mov si, 0               ; SI points to the start of the array
    mov cx, n               ; CX = number of elements in the array
    
    ; Bubble sort to sort the array in ascending order
    mov bx, cx
    dec bx                  ; BX = n-1 for inner loop
OuterLoop:
    mov si, 0               ; SI points to the start of the array
    mov di, 2               ; DI points to the second element (16-bit offset)
    mov cx, bx              ; CX = n-1
InnerLoop:
    mov ax, [arr + si]      ; AX = arr[SI]
    cmp ax, [arr + di]      ; Compare arr[SI] with arr[SI+1]
    jbe NoSwap              ; If arr[SI] <= arr[SI+1], no swap needed
    xchg ax, [arr + di]     ; Swap arr[SI] and arr[SI+1]
    mov [arr + si], ax
NoSwap:
    add si, 2               ; Move to the next 16-bit element
    add di, 2
    loop InnerLoop          ; Repeat for the rest of the array
    dec bx                  ; Decrease outer loop counter
    jnz OuterLoop           ; Repeat until the array is sorted
    

    ; Print second minimum (arr[1])
    mov si, 2
    mov ax, [arr + si]
    call print
    ; Here, you would normally call a procedure to print AX


     ;print newline
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h


    ; Print second maximum (arr[n-2])
    mov si, n
    sub si, 2
    shl si, 1               ; Multiply by 2 to convert to byte offset
    mov ax, [arr + si]
    call print
    ; Here, you would normally call a procedure to print AX
    
    ; Exit program
    mov ah, 4Ch
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
