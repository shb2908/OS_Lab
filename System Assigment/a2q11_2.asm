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

    XOR SI, SI                       ; Initialize SI to 0 for outer loop
OUTER_LOOP:
    MOV CX, arr_size                 ; CX = size of the array
    DEC CX                           ; Adjust CX for array indexing
    MOV DI, SI                       ; DI points to the current outer element
    MOV BX, SI                       ; BX keeps track of the index of the minimum value

INNER_LOOP:
    INC DI                           ; Move to the next element
    CMP DI, arr_size                 ; If DI >= arr_size, exit inner loop
    JG END_INNER_LOOP

    MOV AL, arr[BX]                  ; AL = arr[BX] (current minimum)
    CMP AL, arr[DI]                  ; Compare current minimum with arr[DI]
    JLE CONTINUE_INNER_LOOP          ; If arr[BX] <= arr[DI], continue

    MOV BX, DI                       ; Update BX to the new minimum index

CONTINUE_INNER_LOOP:
    JMP INNER_LOOP

END_INNER_LOOP:
    CMP SI, BX                       ; If the current minimum is at the same index, no need to swap
    JE NO_SWAP

    ; Swap arr[SI] and arr[BX]
    MOV AL, arr[SI]                  ; AL = arr[SI]
    MOV DL, arr[BX]                  ; DL = arr[BX]
    MOV arr[SI], DL                  ; arr[SI] = arr[BX]
    MOV arr[BX], AL                  ; arr[BX] = arr[SI]

NO_SWAP:
    INC SI                           ; Move to the next element
    CMP SI, arr_size - 1             ; If SI >= arr_size - 1, stop outer loop
    JL OUTER_LOOP
    
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
