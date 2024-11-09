.model small
.stack 300h
.data
pr1 db 'Enter number : $'
pr2 db 'First is greater$'
pr3 db 'Second is greater$'
space db ' $'
endl db 0AH, 0DH, '$'

val1 dw ?
val2 dw ?

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

    start:

        print pr1

        call readnum
        mov val1, ax

        print pr1

        call readnum
        mov val2, ax

        mov ax, val1
        mov bx, val2
        cmp ax, bx
        jg second
        print pr3
        jmp en
        second:
        print pr2
        en:
        mov ah, 4Ch
        int 21h
        main endp

readnum proc near

    push bx
    push cx

    mov cx, 0AH
    mov bx, 00h
    loopn:
        mov ah, 01h
        int 21h
        cmp al, '0'
        jb skip
        cmp al, '9'
        ja skip
        sub al, '0'
        push ax
        mov ax, cx
        mul cx
        mov bx, ax
        pop ax
        mov ah, 00h
        add bx, ax
    jmp loopn

    skip:
    mov ax, bx
    pop cx
    pop bx
    ret
readnum endp

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
