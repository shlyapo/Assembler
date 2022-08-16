dos_inp macro lbl, sz
_ib_    struc
max db sz
len db ?
bf  db sz dup('$')
_ib_    ends
lbl _ib_ <>
endm
.model small
.stack 256
.data

entr    db 0Dh, 0Ah,'enter  string:$'
crlf    db 0Dh, 0Ah, '$'
rslt    db 0Dh, 0Ah,'result:$'
dos_inp buffer, 80

func1 proc:


;Ввод строки 1
    mov ax, @data
    mov ds, ax
    mov es, ax
 
    mov ah,09h
    lea dx, entr
    int 21h
 
    mov ah,0ah
    lea dx, buffer
    int 21h
 
    mov ah,09h
    lea dx, crlf
    int 21h
