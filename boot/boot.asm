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

    ; configurar DAP
    mov si, dap

    mov ah, 0x42        ; extensão LBA
    mov dl, 0x80        ; HD
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

; ------------------------
; Disk Address Packet
dap:
    db 0x10             ; tamanho
    db 0x00             ; reservado
    dw 1                ; setores para ler
    dw 0x8000           ; offset destino
    dw 0x0000           ; segmento destino
    dq 1                ; LBA (setor 1 = stage2)

err db 'Erro LBA!', 0

times 510 - ($ - $$) db 0
dw 0xAA55