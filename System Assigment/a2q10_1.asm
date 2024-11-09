.model small
.stack 300h
.data
msg1 db 0AH,0DH,'Prime numbers from 2 to 100: $'
space db ' $'
val db 2  ; Start checking from 2

.code
print macro msg
        push ax
        push dx
        mov ah, 09h
        lea dx, msg
        int 21h
        pop dx
        pop ax
endm

main proc
        mov ax, @data
        mov ds, ax

        print msg1

        ; Main loop to check for primes from 2 to 100
        loop2:
            mov cl, 2        ; Start checking from 2
            mov bl, val      ; Current number to check

            ; Skip even numbers greater than 2
            cmp bl, 2
            je isp           ; 2 is prime
            test bl, 1       ; Check if number is odd
            jz not_prime      ; If even, it's not prime

            ; Check if the number in BL is prime
            mov ax, bl       ; Copy the number to AX for division
            mov ah, 0        ; Clear AH for division
            mov di, 2        ; Start divisor from 2

        check_loop:
            cmp di, ax       ; Compare divisor with the number
            jge isp          ; If divisor >= number, it's prime
            xor dx, dx       ; Clear DX before division
            div di           ; AX / DI, result in AL, remainder in DX
            cmp dx, 0        ; Check if remainder is zero
            je not_prime     ; If zero, not prime
            inc di           ; Increment divisor
            jmp check_loop   ; Check next divisor

        isp:    
            call writenum     ; Print the prime number
            print space       ; Print a space
            jmp next_number    ; Go to next number

        not_prime:
        next_number:
            inc val           ; Move to the next number
            cmp val, 100      ; Check if we reached 100
            jle loop2         ; Loop if val <= 100

        exit:
            mov ah, 4ch
            int 21h
main endp

writenum proc near
        ; This procedure will display a decimal number in AX
        push ax
        push bx
        push cx
        push dx

        xor cx, cx
        mov bx, 10

        @output:
            xor dx, dx
            div bx           ; Divide AX by 10
            push dx          ; Push remainder onto the stack
            inc cx           ; Increment digit count
            test ax, ax
            jnz @output

        mov ah, 02h        ; Set output function

        @display:
            pop dx          ; Pop a value (remainder) from stack to DX
            add dl, '0'     ; Convert decimal to ASCII
            int 21h         ; Print the character
            loop @display

        pop dx
        pop cx
        pop bx 
        pop ax

        ret
writenum endp
end main
