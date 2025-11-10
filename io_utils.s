# ============================================
# File: io_utils.s
# Assembly x86-64 (Linux / WSL)
# Libreria di I/O base: caratteri e stringhe
# ============================================

.section .text
.global input
.global output
.global newline
.global outmess
.global outline
.global pause

# --------------------------------------------
# input
# Legge un carattere da tastiera (stdin)
# Ignora '\n' e restituisce la codifica ASCII in %al
# --------------------------------------------
input:
    sub $8, %rsp

.read:
    mov $0, %rax        # syscall read
    mov $0, %rdi        # fd = stdin
    lea (%rsp), %rsi    # buffer
    mov $1, %rdx        # lunghezza
    syscall
    mov (%rsp), %al     # risultato in AL
    cmpb $'\n', %al     # se è newline
    je .read             # leggi di nuovo

    add $8, %rsp
    ret

# --------------------------------------------
# output
# Stampa il carattere in %al su stdout
# --------------------------------------------
output:
    sub $8, %rsp
    mov %al, (%rsp)
    mov $1, %rax        # syscall write
    mov $1, %rdi        # fd = stdout
    lea (%rsp), %rsi
    mov $1, %rdx
    syscall
    add $8, %rsp
    ret

# --------------------------------------------
# newline
# Va a capo (stampa '\n')
# --------------------------------------------
newline:
    movb $0x0A, %al
    call output
    ret

# --------------------------------------------
# outmess
# EBX → indirizzo buffer, CX → lunghezza
# Stampa CX caratteri a partire da [RBX]
# --------------------------------------------
outmess:
    mov $1, %rax        # syscall write
    mov $1, %rdi        # stdout
    mov %rbx, %rsi
    movzx %cx, %rdx
    syscall
    ret

# --------------------------------------------
# outline
# EBX → indirizzo buffer
# Stampa caratteri fino a CR (ASCII 13)
# --------------------------------------------
outline:
    mov %rbx, %rsi
.Loop:
    movb (%rsi), %al
    cmpb $13, %al
    je .Done
    push %rsi
    call output
    pop %rsi
    inc %rsi
    jmp .Loop
.Done:
    ret


# --------------------------------------------
# pause
# Pausa il programma finché non si preme un tasto
# --------------------------------------------
pause:
    push %rax
    push %rdi
    call newline
    mov $'P', %al
    call output
    mov $'r', %al
    call output
    mov $'e', %al
    call output
    mov $'m', %al
    call output
    mov $'i', %al
    call output

    mov $' ', %al
    call output

    mov $'u', %al
    call output
    mov $'n', %al
    call output

    mov $' ', %al
    call output

    mov $'t', %al
    call output
    mov $'a', %al
    call output
    mov $'s', %al
    call output
    mov $'t', %al
    call output
    mov $'o', %al
    call output

    mov $' ', %al
    call output

    mov $'p', %al
    call output
    mov $'e', %al
    call output
    mov $'r', %al
    call output

    mov $' ', %al
    call output

    mov $'c', %al
    call output
    mov $'o', %al
    call output
    mov $'n', %al
    call output
    mov $'t', %al
    call output
    mov $'i', %al
    call output
    mov $'n', %al
    call output
    mov $'u', %al
    call output
    mov $'a', %al
    call output
    mov $'r', %al
    call output
    mov $'e', %al
    call output

    mov $'.', %al
    call output
    mov $'.', %al
    call output
    mov $'.', %al
    call output

    call newline
    call input          # attesa tasto
    pop %rdi
    pop %rax
    ret

.section .note.GNU-stack,"",@progbits
