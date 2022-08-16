model small

.stack 512

.data

 enter_str_message DB 'Enter any string: $'
    string      DB 128
                DB ?
                DB 128 dup ('$')

    ;new_string      DB 128
                    ;DB ?
                    ;DB 128 dup ('$')            


    CRLF   DB  0AH, 0DH,'$' 

    DelimChar      db      " ",  0
    Chars      db      'euoaiEUIOA', 0
   
    StrLen          dw      $-String 
    SetOfChar       db      (256/8) dup(?)

    msgPressAnyKey  db      'Press any key to exit...', '$'
    resultString db 10,13,'Result: $'
    

.code

.386
main proc

    mov ax, @data
    mov ds, ax

    LEA DX, enter_str_message
    MOV AH, 09h
    INT 21h
    
    MOV AH, 0ah
    LEA DX, string
    INT 21h 

    LEA DI, String + 2
    ;LEA SI, new_string + 2

       mov     ax,     ds
        mov     es,     ax
        mov     cx,     [StrLen]
        lea     si,     [String]
@@WhileDelimiter:
        mov     al,     [si]
        cmp     al,     [DelimChar]
        jne     @@NewWord
        inc     si
        loop    @@WhileDelimiter
 
        jcxz    @@Finish  
@@NewWord:
        ;обнуляем множество символов в обрабатываемом слове
        push    ax
        push    cx
        mov     cx,     256/8
        xor     ax,     ax
        lea     di,     [SetOfChar]
        rep     stosw
        pop     cx
        pop     ax
        ;запоминаем адрес начала слова
        mov     di,     si
        ;устанавливаем признак дублирования символов в слове в FALSE
        mov     dl,     0
        ;пропускаем все буквы слова до разделителя
        ;проверяем каждую букву слова на наличие во множестве
        ;устанавливаем признак наличия символа во множестве
@@WhileWord:
        mov     al,     [si]
        cmp     al,     [DelimChar]
        je      @@Break
        push    cx
        xor     bx,     bx
        mov     bl,     al
        mov     cl,     3
        shr     bx,     cl
        mov     cl,     al
        and     cl,     00000111b
        mov     al,     1
        shl     al,     cl

        mov ah, al
        and ah,     [Chars]
        xor ah, bh
        mov bh, ah
        or dl, ah
        pop     cx
        inc     si              ;переходим к следующему символу
        loop    @@WhileWord
        @@Break:
        xor      dl,     dl
        jnz      @@SkipDelete    ;если в слове нет повторяющихся символов
                                ;то пропускаем удаление
 
        push    cx
        push    di
        cld
        add     [StrLen],       di
        sub     [StrLen],       si
        rep     movsb
        pop     di
        pop     cx
        mov     si,     di
@@SkipDelete:
        jcxz    @@Finish
        jmp     @@WhileDelimiter
 
@@Finish:
        ;вывод результирующей строки

        mov     ah,     40h
        mov     bx,     1
        mov     cx,     [StrLen]
        lea     dx,     [String]
        int     21h
        mov     ah,     09h
        lea     dx,     [CrLf]
        int     21h
 
        ;ожидание нажатия любой клавиши
        mov     ah,     09h
        lea     dx,     [msgPressAnyKey]
        int     21h
 
        mov     ah,     00h
        int     16h
 
        mov     ax,     4C00h
        int     21h
main    endp
 
end     main
