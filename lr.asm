model small

.STACK 512

.DATA

    enter_str_message DB 'Enter any string:YOU ARE clever!!!!$'
    string      DB 128
                DB ?
                DB 128 dup ('$')

    new_string      DB 128
                    DB ?
                    DB 128 dup ('$')            

new_stringg db "   YOU ARE !!!!"

    CRLF   DB  0AH, 0DH,'$' 

.CODE

.386
main:

    MOV AX, @data
    MOV DS, AX

    LEA DX, enter_str_message
    MOV AH, 09h
    INT 21h
    
    ;MOV AH, 0ah
    ;LEA DX, string
    ;INT 21h 

    LEA DI, string + 2
    LEA SI, new_string + 2

MAIN_CYCLE:
    MOV AL, [DI]
    CMP AL, '$'
    JZ PRINT
    CALL is_consonant

    PUSH SI

    LEA SI, string + 2
    MOV CX, DI
    SUB CX, SI

    POP SI
    
    CALL is_index_even
    CMP AH, '1'
    JZ SUBST
    MOV AL, [DI]
    MOV [SI], AL
    INC DI
    INC SI
JMP MAIN_CYCLE        
SUBST:
    PUSH SI

    LEA SI, string + 2
    MOV CX, DI
    SUB CX, SI

    POP SI

    ;=============
    MOV AX, CX
    XOR CX, CX               ; cx = 0
    MOV BX, 10               ; bx = 10 (dividor)
remainder_cycle:                  ; cycle for remainder of the division
    XOR DX, DX               ; dx = 0
    DIV BX                  ; AX=(DX:AX)/BX, remainder is in DX
    ADD DL, '0'              ; get symbol code
    PUSH DX                 ; save in stack
    INC CX                  ; increase synbol counter
    TEST AX, AX              ; check ax
    JNZ remainder_cycle           ; again cycle if remainder != 0
pop_symbols_cycle:                  ; symbol popping cycle
    POP DX                  ; get symbol from stack
    MOV [SI], DL
    INC SI
    LOOP pop_symbols_cycle          ; cycle command

    INC DI
JMP MAIN_CYCLE    

PRINT:

    LEA DX, CRLF; возьми другую строку                   
        MOV AH, 09H							 
        INT 21H
    
    LEA DX, new_stringg + 2
    MOV AH, 09h
    INT 21h

    MOV AH, 04ch
    INT 21h

endl: ; function prints empty line in console
    PUSH AX;
    PUSH DX;
    MOV DL, 0AH
    MOV AH, 02h
    INT 21h
    POP DX;
    POP AX;
RET

is_consonant: ; function determines if symbol is consonant 'letter'

    ; symbol to check is in AL registry
    MOV AH, '0'

    CMP AL, 'b'
    JE if_consonant
    CMP AL, 'c'
    JE if_consonant
    CMP AL, 'd'
    JE if_consonant
    CMP AL, 'f'
    JE if_consonant
    CMP AL, 'g'
    JE if_consonant
    CMP AL, 'h'
    JE if_consonant
    CMP AL, 'j'
    JE if_consonant
    CMP AL, 'k'
    JE if_consonant
    CMP AL, 'l'
    JE if_consonant
    CMP AL, 'm'
    JE if_consonant
    CMP AL, 'n'
    JE if_consonant
    CMP AL, 'p'
    JE if_consonant
    CMP AL, 'q'
    JE if_consonant
    CMP AL, 'r'
    JE if_consonant
    CMP AL, 's'
    JE if_consonant
    CMP AL, 't'
    JE if_consonant
    CMP AL, 'v'
    JE if_consonant
    CMP AL, 'w'
    JE if_consonant
    CMP AL, 'x'
    JE if_consonant
    CMP AL, 'z'
    JE if_consonant

    CMP AL, 'B'
    JE if_consonant
    CMP AL, 'C'
    JE if_consonant
    CMP AL, 'D'
    JE if_consonant
    CMP AL, 'F'
    JE if_consonant
    CMP AL, 'G'
    JE if_consonant
    CMP AL, 'H'
    JE if_consonant
    CMP AL, 'J'
    JE if_consonant
    CMP AL, 'K'
    JE if_consonant
    CMP AL, 'L'
    JE if_consonant
    CMP AL, 'M'
    JE if_consonant
    CMP AL, 'N'
    JE if_consonant
    CMP AL, 'P'
    JE if_consonant
    CMP AL, 'Q'
    JE if_consonant
    CMP AL, 'R'
    JE if_consonant
    CMP AL, 'S'
    JE if_consonant
    CMP AL, 'T'
    JE if_consonant
    CMP AL, 'V'
    JE if_consonant
    CMP AL, 'W'
    JE if_consonant
    CMP AL, 'X'
    JE if_consonant
    CMP AL, 'Z'
    JE if_consonant

    JMP if_not_consonant
    
if_consonant:
    XOR AH, AH
    MOV AH, '1'
if_not_consonant:    

RET

is_index_even:
    ; index is in CX
    MOV BH, AH
    XOR DX, DX
    MOV AX, CX
    MOV CX, 2
    DIV CX
    CMP DX, 0
    MOV AH, BH
    JNZ if_not_even

    JMP if_even

if_not_even:
    MOV AH, '0'
if_even:
RET    

END main