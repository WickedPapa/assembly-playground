# ============================================
# File: main_nums.s
# Demo funzioni in io_nums.s
# ============================================

.section .data
txt_hex:   .asciz "Inserisci 2 cifre hex: "
txt_byte:  .asciz "\nByte letto = 0x"
txt_dec:   .asciz "\nInserisci numero decimale (max 5 cifre): "
txt_val:   .asciz "\nValore decimale = "
nl:        .byte 10,0

.section .text
.global main
.extern input, output, newline, outline, outmess
.extern inHA1_eco, inbyte, outbyte
.extern inDANB16_eco, B16DAN_out

main:
    # prompt hex
    lea txt_hex(%rip), %rbx
    call outline

    # leggi 2 cifre hex -> AL
    call inbyte

    # stampa "Byte letto = 0x" + byte in hex
    lea txt_byte(%rip), %rbx
    call outline
    call outbyte
    call newline

    # prompt decimale
    lea txt_dec(%rip), %rbx
    call outline

    mov $5, %cx                 # fino a 5 cifre
    call inDANB16_eco           # AX = valore

    lea txt_val(%rip), %rbx
    call outline
    call B16DAN_out             # stampa AX in decimale
    call newline

    # exit(0)
    mov $60, %rax
    xor %rdi, %rdi
    syscall

.section .note.GNU-stack,"",@progbits
