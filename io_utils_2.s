# ============================================
# File: io_nums.s
# I/O numerico di base (hex e decimale)
# Dipendenze: input, output
# ============================================

.section .text
.global inDA1_eco
.global inHA1_eco
.global HA1B4
.global HA2B8
.global inbyte
.global B4HA1
.global B8HA2
.global outbyte
.global inDANB16_eco
.global B16DAN_out

.extern input
.extern output

# inDA1_eco: legge UNA cifra decimale '0'..'9' con eco; ritorna ASCII in AL
inDA1_eco:
.L_d_loop:
    call input
    cmp $'0', %al
    jb .L_d_loop
    cmp $'9', %al
    ja .L_d_loop
    push %rax
    call output
    pop %rax
    ret

# inHA1_eco: legge UNA cifra esadecimale 0..9 A..F (accetta anche a..f), eco, AL=ASCII
inHA1_eco:
.L_h_loop:
    call input
    # toUpper: se 'a'..'z' azzera bit 5
    mov %al, %ah
    cmp $'a', %al
    jb .L_chk_upper
    cmp $'z', %al
    ja .L_chk_upper
    and $0xDF, %al
.L_chk_upper:
    # '0'..'9' oppure 'A'..'F'
    cmp $'0', %al
    jb .L_h_loop
    cmp $'9', %al
    jbe .L_ok_hex
    cmp $'A', %al
    jb .L_h_loop
    cmp $'F', %al
    ja .L_h_loop
.L_ok_hex:
    push %rax
    call output
    pop %rax
    ret

# HA1B4: AL=ASCII hex -> AL=valore 0..15
HA1B4:
    # uppercase
    cmp $'a', %al
    jb .L_h1_case
    cmp $'z', %al
    ja .L_h1_case
    and $0xDF, %al
.L_h1_case:
    cmp $'0', %al
    jb .L_h1_ret0
    cmp $'9', %al
    jbe .L_h1_dec
    sub $'A', %al
    add $10, %al
    ret
.L_h1_dec:
    sub $'0', %al
    ret
.L_h1_ret0:
    xor %al, %al
    ret

# HA2B8: AX contiene due ASCII hex [AH=hi][AL=lo] -> AL=byte 0..255
HA2B8:
    push %rbx
    mov %ah, %bl         # salva hi ASCII
    # converti hi
    mov %bl, %al
    call HA1B4
    shl $4, %al
    mov %al, %bl         # hi_nibble<<4
    # converti lo
    mov %ah, %al         # riprendo lo ASCII in AL? no: lo era in AL iniziale
    # ricostruiamo correttamente: AH aveva hi ASCII, AL aveva lo ASCII all'ingresso
    # ma abbiamo sovrascritto. Recuperiamo lo da stack? Non necessario se salviamo subito:
    # Correzione: ricarichiamo lo da [rsp]? useremo %bh per lo.
    pop %rbx             # ripristino ma abbiamo usato. Rifacciamo correttamente:

# --- versione corretta, senza confusione ---
# Rientro pulito:
HA2B8:
    push %rbx
    mov %ax, %bx         # BX = [AH=hi ASCII][AL=lo ASCII]
    mov %bh, %al         # AL = hi ASCII
    call HA1B4           # AL = hi_val 0..15
    shl $4, %al          # AL = hi<<4
    mov %al, %ah         # AH = hi<<4
    mov %bl, %al         # AL = lo ASCII
    call HA1B4           # AL = lo_val
    or  %ah, %al         # AL = (hi<<4)|lo
    pop %rbx
    ret

# inbyte: legge due hex con eco, ritorna AL=byte
inbyte:
    push %rax
    call inHA1_eco       # AL = hi ASCII
    xchg %al, %ah        # AH = hi ASCII
    call inHA1_eco       # AL = lo ASCII
    # AX = [AH=hi ASCII][AL=lo ASCII]
    call HA2B8           # AL=byte
    pop %rax
    mov %al, %al         # no-op per chiarezza
    ret

# B4HA1: AL=0..15 -> AL=ASCII hex
B4HA1:
    cmp $10, %al
    jb .L_b4_dec
    add $'A'-10, %al
    ret
.L_b4_dec:
    add $'0', %al
    ret

# B8HA2: AL=byte -> [AH=ASCII hi][AL=ASCII lo]
B8HA2:
    push %rax
    mov %al, %ah           # copia byte
    and $0x0F, %al         # lo nibble
    call B4HA1             # AL = ASCII lo
    xchg %al, %ah          # AH=ASCII lo, AL=orig byte
    shr $4, %al            # hi nibble
    call B4HA1             # AL=ASCII hi
    xchg %al, %ah          # AH=ASCII hi, AL=ASCII lo
    pop %rcx               # scarta vecchio RAX
    ret

# outbyte: AL=byte -> stampa due cifre hex
outbyte:
    push %rax
    call B8HA2
    # stampa AH poi AL
    push %rax
    mov %ah, %al
    call output
    pop %rax
    call output
    pop %rax
    ret

# inDANB16_eco: CX=numero cifre da leggere (1..5). Ritorna AX=valore (16 bit)
inDANB16_eco:
    xor %eax, %eax        # AX=0
    test %cx, %cx
    jz .L_id_done
.L_id_loop:
    push %rcx
    call inDA1_eco        # AL = ASCII decimale
    sub $'0', %al         # AL = valore 0..9
    movzx %ax, %ax        # EAX=AX zero-extend
    lea (%rax,%rax,4), %eax   # eax = ax*5
    shl $1, %eax              # eax = ax*10
    add %al, %al              # somma nibble? no: serve 16 bit:
    # Correzione: dobbiamo aggiungere il digit a 16 bit:
    movzx %al, %edx           # EDX=digit
    add %edx, %eax            # eax = eax + digit
    pop %rcx
    dec %cx
    jnz .L_id_loop
.L_id_done:
    mov %ax, %ax           # ritorna in AX
    ret

# B16DAN_out: AX=valore -> stampa in decimale senza newline
B16DAN_out:
    push %rbx
    push %rcx
    push %rdx
    push %rsi
    movzx %eax, %ax        # EAX = AX
    cmp $0, %eax
    jne .L_b16_conv
    mov $'0', %al
    call output
    jmp .L_b16_done

.L_b16_conv:
    sub $16, %rsp          # buffer 16B su stack (abbastanza per 5 cifre)
    mov %rsp, %rsi         # rsi = buffer base
    xor %ecx, %ecx         # count = 0
.L_div10:
    xor %edx, %edx
    mov $10, %ebx
    div %ebx               # EDX=rem, EAX=quot
    add $'0', %dl
    mov %dl, (%rsi,%rcx)   # buffer[count] = '0'+rem
    inc %ecx
    test %eax, %eax
    jne .L_div10

    # stampa in ordine inverso
.L_print_rev:
    dec %ecx
    mov (%rsi,%rcx), %al
    call output
    test %ecx, %ecx
    jnz .L_print_rev

    add $16, %rsp
.L_b16_done:
    pop %rsi
    pop %rdx
    pop %rcx
    pop %rbx
    ret
