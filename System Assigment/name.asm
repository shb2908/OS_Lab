.MODEL SMALL
.STACK 100h
.DATA
    title DB 'Program Title: My Assembly Program', 0
    name DB 'Name: Your Name', 0
.CODE
MAIN PROC
    ; Initialize the data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display the title
    LEA DX, title
    MOV AH, 09h
    INT 21h

    ; Display a new line
    MOV AH, 02h
    MOV DL, 0Dh
    INT 21h
    MOV DL, 0Ah
    INT 21h

    ; Display the name
    LEA DX, name
    MOV AH, 09h
    INT 21h

    ; Exit the program
    MOV AX, 4C00h
    INT 21h
MAIN ENDP
END MAIN

