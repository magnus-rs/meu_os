BITS 16
ORG 0x8000

start:
    mov si, msg

print:
    lodsb
    cmp al, 0
    je hang

    mov ah, 0x0E
    int 0x10
    jmp print

hang:
    jmp $

msg db 'Stage 2 carregado com sucesso!', 0