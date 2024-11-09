.MODEL SMALL
.STACK 100H
.DATA
    arr DB 50 dup(0) ; Array to be sorted
    arr_size DW 0                    ; Size of the array
    msg1 db 'Enter length: $'
    msg2 db 'Enter number: $'
    space db ' $'

.CODE

print macro msg
    push ax
    push dx
    lea dx, msg
    mov ah, 09h
    int 21h
    pop dx
    pop ax
endm

main proc
    MOV AX, @DATA
    MOV DS, AX   
    
    print msg1
    call readnum
    mov arr_size, ax
    xor bx, bx
    mov bx, arr_size

    rdnxt:
        print msg2
        call readnum
        mov arr[bx], al
        dec bx
    jnz rdnxt
                       ; Initialize data segment

    MOV CX, 1                        ; Start from the second element (index 1) for insertion sort

OUTER_LOOP:
    CMP CX, arr_size                 ; If CX >= arr_size, stop
    JA END_PROGRAM

    MOV SI, CX                       ; SI points to the current element to be inserted
    MOV AL, arr[SI]                  ; AL = current element (key)

    DEC SI                           ; Move SI to the previous element
INNER_LOOP:
    CMP SI, -1                       ; If SI < 0, break inner loop
    JLE END_INNER_LOOP

    MOV BL, arr[SI]                  ; BL = arr[SI] (previous element)
    CMP BL, AL                       ; Compare arr[SI] with the key (AL)
    JBE END_INNER_LOOP               ; If arr[SI] <= key, break the inner loop

    ; Shift arr[SI] to the right
    MOV arr[SI+1], BL                ; arr[SI+1] = arr[SI]
    DEC SI                           ; Move to the previous element

    JMP INNER_LOOP                   ; Continue inner loop

END_INNER_LOOP:
    MOV arr[SI+1], AL                ; Insert key (AL) into the correct position

    INC CX                           ; Move to the next element in the array
    JMP OUTER_LOOP                   ; Continue outer loop

END_PROGRAM:
    
    mov bx, 1
    mov cx, arr_size
    rdnxt2:
        print space
        xor ax, ax
        mov al, arr[bx]
        call writenum
        inc bx
        cmp bx, cx
    JLE rdnxt2

    ; Program end
    MOV AH, 4CH
    INT 21H


main endp

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

end main
