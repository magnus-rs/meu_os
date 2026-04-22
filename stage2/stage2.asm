BITS 16
ORG 0x8000

start:
    cli

    ; segmentos base
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; carregar GDT
    lgdt [gdt_descriptor]

    ; ativar modo protegido
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; salto FAR para limpar pipeline
    jmp 0x08:protected_mode

; =========================
; GDT
; =========================

gdt_start:

gdt_null:
    dq 0x0000000000000000

gdt_code:
    dq 0x00CF9A000000FFFF

gdt_data:
    dq 0x00CF92000000FFFF

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; =========================
; MODO PROTEGIDO (32-bit)
; =========================

BITS 32

protected_mode:

    ; carregar segmentos
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000

    ; escrever na tela (modo texto VGA)
    mov edi, 0xB8000

    mov al, 'O'
    mov ah, 0x07
    mov [edi], ax

    mov al, 'K'
    mov ah, 0x07
    mov [edi+2], ax

hang:
    jmp hang