model small
.stack 256 ; stack segment

.data ; data segment(our program data, constants)

a dw ?
b dw ?
c dw ?
d dw ?


left dw 20
right dw 40

input_message db "Enter one decimal number: $"
input_error_message db "Invalid input data error! Reenter number $"
runtime_error db "Fatal runtime error , overflowing...$"
result db "result: $"

.code ; code segment

.386
main: ; сообщает линкеру стартовую точку

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
mov bx, b
and bx, ax ; bx = a AND b !!
mov ax, c ; result is here
mov cx, c ; our factor
imul cx
jo runtime_error_proc
imul cx
jo runtime_error_proc
imul cx
jo runtime_error_proc
cmp ax, bx ; compare a AND b with c^4
je equals_first
mov ax, c
mov bx, b
add bx, ax ; bx = c + b
jo runtime_error_proc
mov ax, a
mov cx, a
imul cx
jo runtime_error_proc
imul cx ; ax = a ^ 3
jo runtime_error_proc
push ax
mov ax, b
mov cx, b
imul cx
jo runtime_error_proc
imul cx ; ax = b ^ 3
jo runtime_error_proc
pop dx
add ax, dx
jo runtime_error_proc
cmp ax, bx ; compare с + b with a^3 + b^3
je equals_second
jmp finally
equals_second:
mov ax, a
mov bx, b
mov cx, c
add bx, cx
jo runtime_error_proc
xor ax, bx
jmp end_of_program
equals_first: ; res = c / d / b + a
cwd
mov ax, c
mov cx, d
cmp cx, 0
je runtime_error_proc
idiv cx ; ax = c / d
cwd
mov cx, b
cmp cx, 0
je runtime_error_proc
idiv cx ; ax = c / d / b
cwd
mov bx, a
add ax, bx ; ax = c / d / b + a
jo runtime_error_proc
jmp end_of_program
finally: ; this section checks if each number{a, b, c, d} is not out of range [left, right]
mov ax, a
mov bx, left
cmp ax, bx
jl skip_a
mov bx, right
cmp ax, bx
jg skip_a
push ax
jmp accept_a
skip_a:
mov ax, 1
push ax
accept_a:
mov ax, b
mov bx, left
cmp ax, bx
jl skip_b
mov bx, right
cmp ax, bx
jg skip_b
push ax
jmp accept_b
skip_b:
mov ax, 1
push ax
accept_b:
mov ax, c
mov bx, left
cmp ax, bx
jl skip_c
mov bx, right
cmp ax, bx
jg skip_c
push ax
jmp accept_c
skip_c:
mov ax, 1
push ax
accept_c:
mov ax, d
mov bx, left
cmp ax, bx
jl skip_d
mov bx, right
cmp ax, bx
jg skip_d
jmp accept_d
push ax
skip_d:
mov ax, 1
push ax
accept_d:
mov ax, 1
mov cx, 4
loopA:
pop bx
imul bx
jo runtime_error_proc
loop loopA

end_of_program:
push ax
call new_line_proc
mov ah, 9
mov dx, offset result ; print result
int 21h
pop ax
call print_decimal_number_proc
mov ah, 04Ch ; помещаем код вызываемой функции в регистр ah
int 21h ; вызываем прерывание

runtime_error_proc:
xor ax, ax ;AX = 0
call new_line_proc
mov ah, 9
mov dx, offset runtime_error ; print error message
int 21h
mov ah, 04Ch ; помещаем код вызываемой функции в регистр ah
int 21h ; вызываем прерывание

enter_decimal_number_proc: ; procedure for number input
call input_message_proc

mov ah, 01h
int 21h ; in al - 1st symbol

cmp al, '-'
jne positive_input

xor ah, ah ; saved a sign
push ax

mov ah, 01h
int 21h

jmp pseudo_positive

positive_input:

xor dh, dh ; saved a sign
mov dl, '+'
push dx

pseudo_positive:


cmp al, '0' ; if symbol code is less than code of 0 => error
jl input_error
cmp al, '9' ; if symbol code is greater than code of 9 => error
jg input_error
sub al, 30h ; it is first digit
mov ah, 0 ; extension to word
mov bx, 10
mov cx,ax ; cx - first digit
loop_:
mov ah, 01h
int 21h ; next symbol is in al
cmp al, 0dh ; compare with Enter
je end_loop ; end of input
cmp al, '0' ; if symbol code is less than code of 0 => error
jl input_error
cmp al, '9' ; if symbol code is greater than code of 9 => error
jg input_error
sub al, 30h ; next digit is in al
cbw ; extension to word
xchg ax, cx ; now previous digit is in ax,next one is in cx
imul bx ; ax*10
jo input_error ; if overflowing
add cx, ax ; cx=ax*10+cx
jo input_error ; if overflowing
jmp loop_ ; continue input
input_error:
xor ax, ax ;AX = 0
call new_line_proc
mov ah, 9
mov dx, offset input_error_message ; print error message
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


print_decimal_number_proc: ; procedure for number output
xor cx, cx ; cx = 0
mov bx, 10 ; bx = 10 (idividor)
remainder_cycle: ; cycle for remainder of the idivision
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
idiv bx ; AX=(DX:AX)/BX, remainder is in DX
add dl, '0' ; get symbol code
push dx ; save in stack
inc cx ; increase synbol counter
test ax, ax ; check ax
jnz remainder_cycle ; again cycle if remainder != 0
pop_symbols_cycle: ; symbol popping cycle
pop dx ; get symbol from stack
mov ah, 2h ; print a symbol
int 21h
loop pop_symbols_cycle ; cycle command
ret
input_message_proc:
push ax
call new_line_proc
mov ah, 9
mov dx, offset input_message ; print input message
int 21h
pop ax
ret

new_line_proc:
push ax
mov dl, 10
mov ah, 2h ; print new line
int 21h
pop ax
ret
end main