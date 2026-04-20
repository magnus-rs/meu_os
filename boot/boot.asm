BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; carregar stage2 para 0x8000
    mov ah, 0x02        ; função: ler setores
    mov al, 1           ; número de setores
    mov ch, 0           ; cilindro
    mov cl, 2           ; setor (1 = MBR, 2 = próximo)
    mov dh, 0           ; head
    mov dl, 0x80        ; disco (HD)
    mov bx, 0x8000      ; destino

    int 0x13
    jc disk_error

    jmp 0x0000:0x8000   ; pula para stage2

disk_error:
    mov si, err

print:
    lodsb
    cmp al, 0
    je hang

    mov ah, 0x0E
    int 0x10
    jmp print

hang:
    jmp $

err db 'Erro ao ler disco!', 0

times 510 - ($ - $$) db 0
dw 0xAA55