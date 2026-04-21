BITS 16
ORG 0x8000

start:
    cli
    xor ax, ax
    mov ds, ax
    sti

    mov ax, 0x8000
    mov es, ax
    mov di, 0x1000       ; buffer longe do código

    xor ebx, ebx

.loop:
    mov eax, 0xE820
    mov edx, 0x534D4150  ; "SMAP"
    mov ecx, 20

    int 0x15
    jc .done

    cmp eax, 0x534D4150
    jne .done

    ; imprime tipo
    mov ax, [es:di + 16]
    call print_hex

    mov al, 13
    call putc
    mov al, 10
    call putc

    add di, 20

    cmp ebx, 0
    jne .loop

.done:
    jmp $

; --------
putc:
    mov ah, 0x0E
    int 0x10
    ret

print_hex:
    mov cx, 4
.hex:
    rol ax, 4
    mov dl, al
    and dl, 0x0F

    cmp dl, 9
    jbe .num
    add dl, 7
.num:
    add dl, '0'

    mov al, dl
    call putc

    loop .hex
    ret