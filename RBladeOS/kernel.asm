; Writed by R4idB0y
; Kernel for RBladeOS
; Copyright (C) 2024 - R4idB0Y

[BITS 16]
[ORG 0x1000]

start:
    cli
    mov si, msg
    call print_string
    call print_newline
    call shell
    jmp $

print_string:
    mov ah, 0x0E
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

print_newline:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

shell:
    mov si, prompt
    call print_string
    call read_command
    call print_newline
    call execute_command
    jmp shell

read_command:
    mov di, command_buffer
    xor cx, cx
.read_loop:
    mov ah, 0x00
    int 0x16             
    cmp al, 0x0D         
    je .done_read
    cmp al, 0x08         
    je .handle_backspace
    cmp cx, 150           
    jge .done_read  
    stosb                 
    mov ah, 0x0E
    int 0x10              
    inc cx
    jmp .read_loop

.handle_backspace:
    cmp di, command_buffer
    je .read_loop           
    dec di                 
    dec cx           
    mov ah, 0x0E
    mov al, 0x08           
    int 0x10
    mov al, ' '             
    int 0x10
    mov al, 0x08         
    int 0x10
    jmp .read_loop

.done_read:
    mov byte [di], 0     
    ret

execute_command:
    mov si, command_buffer
    cmp byte [si], 'e'
    je do_echo
    cmp byte [si], 'c'
    cmp byte [si + 1], 'l'
    cmp byte [si + 2], 'e'
    cmp byte [si + 3], 'a'
    cmp byte [si + 4], 'r'
    je do_cls
    cmp byte [si], 'h'
    cmp byte [si + 1], 'e'
    cmp byte [si + 2], 'l'
    cmp byte [si + 3], 'p'
    je help_command
    cmp byte [si], 'r'
    cmp byte [si + 1], 'e'
    cmp byte [si + 2], 'b'
    cmp byte [si + 3], 'o'
    cmp byte [si + 4], 'o'
    cmp byte [si + 5], 't'
    je do_reboot
    cmp byte [si], 's'
    cmp byte [si + 1], 'h'
    cmp byte [si + 2], 'u'
    cmp byte [si + 3], 't'
    je do_shutdown
    jmp unknown_command

do_echo:
    mov si, command_buffer + 5
    call print_string
    call print_newline
    ret

do_reboot:
    db 0x0ea 
    dw 0x0000 
    dw 0xffff 

do_shutdown:
    mov ax, 0x5307    
    mov bx, 0x0001    
    mov cx, 0x0003    
    int 0x15         
    ret

do_cls:
    mov cx, 25
.clear_loop:
    call print_newline
    loop .clear_loop
    ret

unknown_command:
    mov si, unknown_msg
    call print_string
    call print_newline
    ret

help_command:
    mov si, help_msg
    call print_string
    call print_newline
    ret

msg db 'RBladeOS v0.1', 0
prompt db '> ', 0
command_buffer db 150 dup(0)  
unknown_msg db 'Unknown command', 0
help_msg db 'Manual for RBladeOS: echo, clear, help, reboot, shut', 0
dir_msg db 'Listing files:', 0
