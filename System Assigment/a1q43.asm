.model small
.stack 300h
.data
arr db 50 dup(0)
msg1 db 'Enter size of array: $'
msg4 db 'Enter number: $'
msg2 db 'Second Largest: $'
msg3 db 'Second Smallest: $'
endl db 0ah,0Dh,'$'
size db 00h

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

    mov si, 0
    print msg1
    call readnum 
    mov size, al
    mov bl, size
    mov bh, 0

    rdnxt:
        print msg4
        call readnum
        mov arr[bx], al
        dec bx
    jnz rdnxt
    mov si, 0
    mov cl, size
    mov ch, 0
    mov bx, cx
    xor ax, ax
    dec bx
    outer:
        mov si, 1
        mov di, 2
        mov cx, bx
        inner: 
            mov al, [arr+si]
            cmp al, [arr+di]
            jbe NoSwap  
            xchg al, [arr+di]
            mov [arr+si], al 
            NoSwap:
            inc di
            inc si
            
        loop inner
        dec bx
    jnz outer

    print msg3
    mov si, 2
    xor ax, ax
    mov al, [arr+si]
    call writenum

    print endl

    print msg2
    mov bl, size
    mov bh, 0
    mov si, bx
    sub si, 1
    xor ax, ax
    mov al, [arr+si]
    call writenum
    
    print endl

    mov ah, 4ch
    int 21h
main endp


writenum proc near
	; this procedure will display a decimal number
	; input : AX
	; output : none

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

	ret                            
writenum endp


readnum proc near
	; this procedure will take a number as input from user and store in AL
	; input : none
	
	; output : AL

	
	push bx
	push cx
	mov cx,0ah
	mov bx,00h
	loopnum: 
		mov ah,01h
		int 21h
		cmp al,'0'
		jb skip
		cmp al,'9'
		ja skip
		sub al,'0'
		push ax
		mov ax,bx
		mul cx
		mov bx,ax
		pop ax
		mov ah,00h
		add bx,ax
	jmp loopnum
	
	skip:
	mov ax,bx
	pop cx
	pop bx
	ret
readnum endp
end main
