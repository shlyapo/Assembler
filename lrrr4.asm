model   small
.stack  100h
.code

.const 
    prob  db  'aeiuoy', 0
    prob2 db 'qwrtpsdfghjklzxcvbnm'
;ввод 
begin: 
 mov ax,@data
    mov ds,ax
    mov ah,9
    lea dx,dbEnt
    int 21h

.data
dbEnt   db  10,13,'Enter string:$'

.code
    mov ah,10
    lea dx,dbMax
    int 21h

.data
dbMax   db  255
dbLen   db  ?
dbStr   db  255 dup(?)

.code
    lea si,dbLen
    push    si
    mov cl,[si+1]
    xor ch,ch
    add si,cx
    mov byte ptr[si],' '
    pop si
    xor di,di
    mov al,' '

@@01:   inc si
    cmp al,[si]
    loopz   @@01
    inc cx
    mov bx,-1

@@02:   inc bx
    cmp al,[bx+si]
    loopnz  @@02
    inc cx
    cmp bx,4
    jl  @@03
    inc di

@@03:   add si,bx
    loop    @@01

@@04:   mov ah,9
    lea dx,dbRes
    int 21h

.data
dbRes   db  10,13,'Result:$'

.code
    mov ax,10
    xchg    ax,di
    xor cx,cx
@@05:   xor dx,dx
    div di
    push    dx
    inc cx
    or  ax,ax
    jnz @@05
@@06:   pop ax
    or  al,'0'
    int 29h
    loop    @@06
    mov ax,4C00h
    int 21h
end begin
  ;Определяет, принадлежит ли символ в al разделителям слов
;на входе
; al - символ
;на выходе
; ah -  1 (не разделитель), 0 (разделитель)
IsDelimChar     proc
        push    esi
        push    edi
        push    ecx
 
        mov     ah,     1
        lea     edi,    [DelimChars]
        mov     ecx,    [LenDelimChars]
        repne   scasb
        jcxz    @@Skip
        jnz     @@Skip
        mov     ah,     0
@@Skip:
        pop     ecx
        pop     edi
        pop     esi
        ret
IsDelimChar     endp