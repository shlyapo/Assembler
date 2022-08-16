.model small
.stack 256
.data

a dw ?
b dw ?
c dw ?
d dw ?
ab dw ?
ac dw ?
ad dw ?
bc dw ?
bd dw ?
cd dw ?
inputString db 'Enter number: $'

input_message db "Enter one decimal number: $"
input_error_message db "Reenter number $"
runtime_error db "Fatal runtime error$"
result db "result: $"

.code

.386
main:
mov ax, @data    
mov ds, ax
    
call enter_decimal_number_proc
mov a, ax
call enter_decimal_number_proc
mov b, ax
call enter_decimal_number_proc
mov c, ax
call enter_decimal_number_proc
mov d, ax

mov ax, a
mov bx, a
imul bx
jo runtime_error_proc
mov cx, ax;a^2

mov ax, b                  
mov bx, ax
imul ax
jo runtime_error_proc
imul bx
jo runtime_error_proc
mov bx, ax; b^3
;Если a ^ 2<> b ^ 3 то
cmp cx, bx
jne lebel_if
;Результат = a * b + c/d
mov ax, a
mov cx, b
imul cx;A*B
jo runtime_error_proc
mov bx, ax
mov dx, 0
mov ax, c
mov cx, d
cmp cx, 0
je runtime_error_proc
cwd
idiv cx;C/D
mov cx, ax
add bx, cx;A*B+C/D  
mov ax, bx
jo runtime_error_proc
jmp end_of_program


lebel_if:
 ;Если  c * d = a / b то
 mov ax, c
 mov dx, d
 imul dx;c*d
jo runtime_error_proc
 mov bx, ax
 mov dx, 0
mov ax, a
 mov cx, b
 cmp cx, 0
je runtime_error_proc
 idiv cx; a/b
cmp bx, ax
je lebel_if2
;произведения
mov ax, a
mov bx, b
imul bx
jo runtime_error_proc
mov ab, ax ;a*b
mov ax, a
mov bx, c
imul bx
jo runtime_error_proc
mov ac, ax;a*c
mov ax, a
mov bx, d
imul bx
jo runtime_error_proc
mov ad, ax;a*d
mov ax, b
mov bx, c
imul bx
jo runtime_error_proc
mov bc, ax;b*c
mov ax, b
imul d
jo runtime_error_proc
mov bd, ax;b*d
mov ax, c
mov bx, d
imul bx
jo runtime_error_proc
mov cd, ax;c*d
mov ax, ab
mov bx, ac
cmp ax, bx; 
jl lebel_j1
mov bx, ad
cmp ax, bx
jl lebel_j2
mov bx, bc
cmp ax, bx
jl lebel_j3
mov bx, bd
cmp ax, bx
jl lebel_j4
mov bx, cd
cmp ax, bx
jl lebel_j5
jmp end_of_program

lebel_j1:; ac
mov ax, bx
mov bx, ad
cmp ax, bx
jl lebel_j2
mov bx, bc
cmp ax, bx
jl lebel_j3
mov bx, bd
cmp ax, bx
jl lebel_j4
mov bx, cd
cmp ax, bx
jl lebel_j5
jmp end_of_program

lebel_j2: ;ad
mov ax, bx
mov bx, bc
cmp ax, bx
jl lebel_j3
mov bx, bd
cmp ax, bx
jl lebel_j4
mov bx, cd
cmp ax, bx
jl lebel_j5
jmp end_of_program

lebel_j3:
mov ax, bx;bc
mov bx, bd
cmp ax, bx
jl lebel_j4
mov bx, cd
cmp ax, bx
jl lebel_j5
jmp end_of_program

lebel_j4:
mov ax, bx;bd
mov bx, cd
cmp ax, bx
jl lebel_j5
jmp end_of_program

lebel_j5:
mov ax, bx
jmp end_of_program

lebel_if2:
mov ax, a
mov bx, b
xor ax, bx
jmp end_of_program
 
end_of_program:
push ax
call new_line_proc
mov ah, 9
mov dx, offset result 
int 21h
pop ax
call print_decimal_number_proc
mov ah, 04Ch 
int 21h 

runtime_error_proc:
xor ax, ax 
call new_line_proc
mov ah, 9
mov dx, offset runtime_error 
int 21h
mov ah, 04Ch 
int 21h 

enter_decimal_number_proc: ; procedure for number input
call input_message_proc

mov ah, 01h
int 21h 

cmp al, '-'
jne positive_input

xor ah, ah 
push ax

mov ah, 01h
int 21h

jmp pseudo_positive

positive_input:

xor dh, dh 
mov dl, '+'
push dx

pseudo_positive:


cmp al, '0' 
jl input_error
cmp al, '9' 
jg input_error
sub al, 30h 
mov ah, 0 
mov bx, 10
mov cx,ax 
loop_:
mov ah, 01h
int 21h 
cmp al, 0dh 
je end_loop 
cmp al, '0' 
jl input_error
cmp al, '9' 
jg input_error
sub al, 30h 
cbw 
xchg ax, cx 
imul bx 
jo input_error 
add cx, ax 
jo input_error 
jmp loop_ 
input_error:
xor ax, ax 
call new_line_proc
mov ah, 9
mov dx, offset input_error_message 
int 21h
call enter_decimal_number_proc
end_loop :

pop ax

cmp al, '-'
jne pos_input

neg cx

pos_input:

mov ax, cx
ret


print_decimal_number_proc: 
xor cx, cx ; 
mov bx, 10 ; 
remainder_cycle: ; 
cmp ax, 0
jg positive

push ax
mov dl, '-'
mov ah,2h
int 21h
pop ax
neg ax

positive:

xor dx, dx ; dx = 0
cwd
idiv bx ; 
add dl, '0' ; 
push dx ; 
inc cx ; 
test ax, ax 
jnz remainder_cycle 
pop_symbols_cycle: 
pop dx ; 
mov ah, 2h ; 
int 21h
loop pop_symbols_cycle ; 
ret
input_message_proc:
push ax
call new_line_proc
mov ah, 9
mov dx, offset input_message 
int 21h
pop ax
ret

new_line_proc:
push ax
mov dl, 10
mov ah, 2h 
int 21h
pop ax
ret
end main