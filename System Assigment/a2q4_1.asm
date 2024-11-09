.model small
.stack 300h
.data ; data segment starts
    a dw 5678h, 1234h, 5 dup(0)         ; a is 32-bit number a = 1234 5678
    b dw 1111h, 1111h, 5 dup(0)         ; b is 32-bit number b = 1111 1111
    c dw 4 dup(?)                       ; reserve 4 words for result

.code
start:
    mov ax, @data
    mov ds, ax
    lea si, a
    lea bx, b
    lea di, c                            ; point to first word

    ; Multiply lower 16 bits of a (5678) with lower 16 bits of b (1111)
    mov ax, word ptr [si]               ; take lower 16 bits (5678) of a into ax
    mul word ptr [bx]                   ; multiply ax with lower 16 bits of b (1111)
    mov [di], ax                        ; store result in c[0]
    mov cx, dx                           ; move high word (result) to cx

    ; Multiply higher 16 bits of a (1234) with lower 16 bits of b (1111)
    mov ax, word ptr [si + 2]           ; take higher 16 bits (1234) of a into ax
    mul word ptr [bx]                   ; multiply ax with lower 16 bits of b (1111)
    add cx, ax                           ; cx = cx + ax (accumulate)
    mov [di + 2], cx                     ; store result in c[2]
    mov cx, dx                           ; move high word (result) to cx

    ; Multiply lower 16 bits of a (5678) with higher 16 bits of b (1111)
    mov ax, word ptr [si]               ; take lower 16 bits (5678) of a into ax
    mul word ptr [bx + 2]               ; multiply ax with higher 16 bits of b (1111)
    add word ptr [di + 2], ax            ; add result to c[2]
    adc cx, dx                           ; add carry to cx

    ; Multiply higher 16 bits of a (1234) with higher 16 bits of b (1111)
    mov ax, word ptr [si + 2]           ; take higher 16 bits (1234) into ax
    mul word ptr [bx + 2]               ; multiply ax with higher 16 bits of b (1111)
    add cx, ax                           ; cx = cx + ax
    mov [di + 4], cx                     ; store result in c[4]
    mov dx, 0                            ; clear dx
    adc dx, 0                            ; add carry to dx
    mov [di + 6], dx                     ; store high word in c[6]

    int 3                                 ; halt

end start
