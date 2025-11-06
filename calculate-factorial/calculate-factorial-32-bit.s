.global _main
.global input_number
.global factorial

.data
input_number:      .byte 0x05 # massimo 12 (0x0C) per evitare overflow
factorial:         .long 0

.text
_main:
    nop
    movzbl input_number(%rip), %ecx # carica 1 byte → estende a 32 bit con zeri
    
    # controlli di validità dell'input
    cmp $1, %ecx
    jle end
    cmp $12, %ecx
    jg end

    mov $1, %eax

factorial_loop:
    imul %ecx, %eax
    loop factorial_loop

end:
    mov %eax, factorial(%rip)
    ret
