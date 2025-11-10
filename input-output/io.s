# ============================================
# File: main.s
# Demo delle funzioni in io_utils.s
# x86-64 Linux (WSL compatibile)
# ============================================

.section .data
msg:    .ascii "Hello from io_utils!\r"   # terminato con CR (13)
buf:    .space 64                         # buffer per input

.section .text
.global main
.extern input
.extern output
.extern newline
.extern outmess
.extern outline
.extern pause

main:
    # --- Stampa messaggio con outline ---
    lea msg(%rip), %rbx
    call outline
    call newline

    # --- Stampa 5 caratteri con outmess ---
    lea msg(%rip), %rbx
    mov $7, %cx
    call outmess
    call newline

    # --- Legge un carattere e lo ristampa ---
    call input
    call output
    call newline

    # --- Dimostrazione di pausa ---
    call pause
    call newline

    # --- Fine programma ---
    mov $60, %rax   # syscall exit
    xor %rdi, %rdi
    syscall

.section .note.GNU-stack,"",@progbits
