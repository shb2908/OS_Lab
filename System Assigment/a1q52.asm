.model small
.stack 100h
.data
        prompt db 'Quitting from program . . . $ '
        newline db 13, 10, '$'

.code
main proc

mov ax, @data
mov ds, ax
mov es, ax

lea dx, prompt
mov ah, 09h
int 21h

lea dx, newline
mov ah, 09h
int 21h

mov ah, 4ch
int 21h

main endp
end main
