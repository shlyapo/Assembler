.model small
.stack 100h
.data
vvod_n db 'Enter n: ','$'
vvod_m db 'Enter m: ','$'
mas_message db 'Result aray',10,13,'$'
mas3_message db 'Vector',10,13,'$'
mas2_message db 'Enter array',10,13,'$'
error_message db ' Error.Try again','$'
ok_message db 'OK','$'
 
mas db 9 dup(9 dup(?))
n dw 0
m dw 0
i dw 0
j dw 0


.code
assume ds:@data,es:@data
          
main:
mov ax,@data
mov ds,ax
vv_n:   
    mov ah,9h
    mov dx, offset vvod_n
    int 21h
    call read_int ; read
    mov n,bx      ; save
    cmp n,9h
    mov ah,9h
    call newLine
    ja vv_n
    ;call newLine
vv_m:
    
    mov ah,9h
    mov dx, offset vvod_m
    int 21h
    call read_int
    mov m,bx
    cmp m,9h
    call newLine
    ja vv_m
    ;jmp exit
    mov ah,9h
    mov dx, offset mas2_message
    int 21h
    xor bx,bx ; pointer
    mov cx,n ; init
rows:
    push cx   ; save
    mov cx, m ; init
    cols:
        read_start: 
        mov ah, 8h
        int 21h     ;read
        cmp al, '9'

        ja read_start  ; not num
        cmp al, '0'
        jb read_start  ; not num
        
        mov mas[bx],al
        
        mov ah,2h ; 
        mov dl,al ;
        int 21h   ; print
        
        inc bx ; increment pointer          
    loop cols
    add bx, 20 ;
    sub bx, m  ; set pointer to the next line
    pop cx
    call newLine
loop rows   

mov ah,9h
    mov dx, offset mas3_message
    int 21h
    xor bx,bx ; pointer
     mov cx, m ; init
    cols2:
        read_start2: 
        mov ah, 8h
        int 21h     ;read
        cmp al, '9'

        ja read_start2  ; not num
        cmp al, '0'
        jb read_start2  ; not num
        
        mov mas[bx],al
        
        mov ah,2h ; 
        mov dl,al ;
        int 21h   ; print
        
        inc bx ; increment pointer          
    loop cols2
    call newLine

xor bx,bx ; pointer
    ;mov cx,n ; init
;rows1:
   vv_n1:   
    mov ah,9h
    mov dx, offset vvod_n
    int 21h
    call read_int ; read
    mov n,bx      ; save
    cmp n,9h
    mov ah,9h
    call newLine
    ja vv_n1
    ;call newLine
vv_m1:
    
    mov ah,9h
    mov dx, offset vvod_m
    int 21h
    call read_int
    mov m,bx
    cmp m,9h
    call newLine
    ja vv_m1
    ;jmp exit
    mov ah,9h
    mov dx, offset mas2_message
    int 21h
    xor bx,bx ; pointer
    mov cx,n ; init
rows1:
    push cx   ; save
    mov cx, m ; init
    cols1:
        read_start1: 
        mov ah, 8h
        int 21h     ;read
        cmp al, '9'

        ja read_start1  ; not num
        cmp al, '0'
        jb read_start1  ; not num
        
        mov mas[bx],al
        
        mov ah,2h ; 
        mov dl,al ;
        int 21h   ; print
        
        inc bx ; increment pointer          
    loop cols1
    add bx, 20 ;
    sub bx, m  ; set pointer to the next line
    pop cx
    call newLine
loop rows1

mov ah,9h
    mov dx, offset mas3_message
    int 21h
    xor bx,bx ; pointer
    inc m
    inc m
     mov cx, m; init
    cols3:
        read_start3: 
        mov ah, 8h
        int 21h     ;read
        cmp al, '9'

        ja read_start3  ; not num
        cmp al, '0'
        jb read_start3  ; not num
        
        mov mas[bx],al
        
        mov ah,2h ; 
        mov dl,al ;
        int 21h   ; print
        
        inc bx ; increment pointer          
    loop cols3
    call newLine
    jmp exit

newLine proc near
    mov dl,0ah
    mov ah,2
    int 21h 
    ret
newLine endp

error_mes:
    mov ah,2h  ; 
    mov dl,al  ;
    int 21h
    mov ah,9h
    mov dx, offset error_message 
    int 21h
    call newLine
    mov ah,9h
    mov dx, offset vvod_n
    int 21h
    jmp read_int_start

read_int proc near  
    push ax
    push dx
    xor bx,bx
read_int_start: 
    mov ah, 8h
    int 21h     ;read
    cmp al,13
    je read_int_ok   ; enter
    cmp al, '9'
    
    ;error_message 
    ja error_mes  ; not num
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
                         
exit:
mov ah,4ch
int 21h
end main