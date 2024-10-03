; Writed by R4idB0y
; Bootloader for RBladeOS

[BITS 16]           ; Configura o modo 16 bits
[ORG 0x7C00]        ; O bootloader é carregado em 0x7C00

start:
    mov ax, 0x0000  
    mov ds, ax

    ; Lê o kernel do disco
    mov ah, 0x02     ; Função para ler setor
    mov al, 1        ; Número de setores a ler
    mov ch, 0        ; Cabeça 0
    mov cl, 2        ; Setor 2 (setor 1 para o bootloader, setor 2 para o kernel)
    mov dh, 0        ; Cilindro 0
    mov bx, 0x1000   ; Carrega o kernel em 0x1000
    int 0x13         ; Chama a interrupção do BIOS para ler

    jmp 0x1000    

times 510 - ($ - $$) db 0  ; Preenche até 510 bytes
dw 0xAA55                 ; Assinatura do bootloader (NÃO MECHA AQUI!!!)
