model small

.stack 512

 
.data
vvod_n db 'vvod n: ','$'
vvod_m db 'vvod m: ','$'
mas_message db 'Massive',10,13,'$'
mas2_message db 'Vvedite elementi massiva',10,13,'$'
;error_message db 'Error','$'
ok_message db 'OK','$'
 
mas db 9 dup(9 dup(?))
mas2 db 9 dup(9 dup(?))
vec db 9 dup(?)
vec2 db 9 dup(?)
n1 dw 0
m1 dw 0
n2 dw 0
m2 dw 0
i dw 0
j dw 0
count dw 0
 
.code

new_line proc 
    push ax
    push dx
    
    mov ah,2
    mov dl,13
    int 21h
    mov ah,2
    mov dl,10
    int 21h
    
    pop dx
    pop ax
    ret
new_line endp

read_int proc 
    push ax
    push dx
    xor bx,bx
read_int_start: 
    mov ah, 8h
    int 21h     ;read
    cmp al,13
    je read_int_ok   ; enter
    cmp al, '9'
    ja read_int_start  ; not num
    cmp al, '0'
    jb read_int_start  ; not num
    
    mov ah,2h  ; 
    mov dl,al  ;
    int 21h    ; print
    
    mov dx, bx ;
    shl bx,3   ;
    add bx,dx  ; bx*10
    add bx,dx  ;
    
    xor ah,ah  ;
    sub al,'0'
    add bx,ax  ; bx + new_cifr
    
    jmp read_int_start
 
read_int_ok:    
    pop dx
    pop ax
    ret
read_int endp


MAIN PROC 
    mov ax, @data
    mov ds, ax
vv_n:   
    call new_line
    ;
    ; READ N, M
    ;
 
    mov ah,9h
    mov dx, offset vvod_n
    int 21h
    call read_int ; read
    mov n1,bx      ; save
    cmp n1,9h
    ja vv_n
 
vv_m:
    call new_line
    
    mov ah,9h
    mov dx, offset vvod_m
    int 21h
    call read_int
    mov m1,bx
    cmp m1,9h
    ja vv_m
     mov ah,9h
     call new_line
    mov dx, offset mas2_message
    int 21h
    xor bx,bx ; pointer
    mov cx,n1 ; init

rows:
    push cx   ; save
    mov cx, m1 ; init
    cols:
        read_start: 
        mov ah, 8h
        int 21h     ;read
        cmp al, '9'
        ja read_start  ; not num
        cmp al, '0'
        jb read_start  ; not num
        
        mov mas[bx], al
        
        mov ah,2h ; 
        mov dl,al ;
        int 21h   ; print
        
        inc bx ; increment pointer          
    loop cols
    add bx, 20 ;
    sub bx, m1  ; set pointer to the next line
    pop cx
    call new_line
    cmp m1,9h
    ja vv_m
loop rows   

call new_line
rows2:
    push cx   ; save
    mov cx, m1 ; init
    cols2:
        read_start: 
        mov ah, 8h
        int 21h     ;read
        cmp al, '9'
        ja read_start  ; not num
        cmp al, '0'
        jb read_start  ; not num
        
        ;mov mas[bx], al
        
        mov ah,2h ; 
        mov dl,al ;
        int 21h   ; print
        
        inc bx ; increment pointer          
    loop cols2
    add bx, 20 ;
    sub bx, m1  ; set pointer to the next line
    pop cx
    call new_line
    cmp m1,9h
    ja vv_m
loop rows  


vv_n1:   
    call new_line
    ;
    ; READ N, M
    ;
 
    mov ah,9h
    mov dx, offset vvod_n
    int 21h
    call read_int ; read
    mov n2,bx      ; save
    cmp n2,9h
    ja vv_n1

vv_m2:
    call new_line
    
    mov ah,9h
    mov dx, offset vvod_m
    int 21h
    call read_int
    mov m2,bx
    cmp m2,9h
    ja vv_m2
 
    call new_line
    ;
    ; vivod matrixx
    ;
    mov ah,9h
    mov dx, offset mas2_message
    int 21h
    xor bx,bx ; pointer
    mov cx,n2 ; init

     call new_line
    ;
    ; vivod matrixx
    ;

rows2:
    push cx   ; save
    mov cx, m2 ; init
    cols2:
        read_start2: 
        mov ah, 8h
        int 21h     ;read
        cmp al, '9'
        ja read_start2  ; not num
        cmp al, '0'
        jb read_start2  ; not num
        
        mov mas2[bx], al
        
        mov ah,2h ; 
        mov dl,al ;
        int 21h   ; print
        
        inc bx ; increment pointer          
    loop cols2
    add bx, 20 ;
    sub bx, m2  ; set pointer to the next line
    pop cx
    call new_line
loop rows2 
    
 
end     main
 
 
