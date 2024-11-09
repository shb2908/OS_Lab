.model small
.stack 300h
.data
msg1 db 0AH,0DH,'Enter number: $'
msg2 db 0AH,0DH,'Number is prime $ '
msg3 db 0AH,0DH,'Number is not prime $'
endl db 0AH,0DH,'$'
space db ' $'
val db ?

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
        mov ax,@data
        mov ds,ax

        start:

        mov val, 2


        loop2:
        mov cl, 02h
        mov bl, 00h
        loop1:
                mov al, val
                mov ah,00h
                div cl
                cmp ah, 00h
                jz ext
                inc cl
                cmp cl, val
        jne loop1
        isp:    
        mov ah, 00h
        mov al, val
        call writenum
        print endl
        ext:

        inc val
        mov al, 100
        cmp al, val
        jne loop2
    exit:
    mov ah, 4ch
    int 21h
main endp
writenum proc near
        ; this procedure will display a decimal number
        ; input : AX
        ; output : none

        push ax
        push bx
        push cx
        push dx
        xor cx, cx
        mov bx, 0ah

        @output:
                xor dx, dx
                div bx                       ; divide AX by BX
                push dx                      ; push remainder onto the STACK
                inc cx
                or ax, ax
        jne @output

        mov ah, 02h                      ; set output function

        @display:
                pop dx                       ; pop a value(remainder) from STACK to DX
                or dl, 30h                   ; convert decimal to ascii code
                int 21h
        loop @display

        pop dx
        pop cx
        pop bx 
        pop ax

        ret
writenum endp
end main
