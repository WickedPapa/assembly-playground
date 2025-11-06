.global _main
.global input_number
.global factorial

.data
input_number:      .byte 0x0014 # massimo 20 (0x0014) per evitare overflow
factorial:         .quad 0

# l'esercizio si potrebbe svolgere allo stesso modo del 32-bit,
# cambiando i registri da 32 a 64 bit (eax -> rax, ecx -> rcx)
# Tuttavia, loop decrementa solo %ecx, quindi funzionerebbe, ma implicitamente userebbe solo i 32 bit bassi
# e il comportamento sarebbe misto (32+64 bit), e non conforme all’uso pulito della modalità 64 bit.

.text
_main:
    nop
    mov input_number(%rip), %rcx

    # controlli di validità dell'input
    cmp $1, %ecx
    jle end
    cmp $20, %ecx
    jg end

    mov $1, %rax

factorial_loop:
    cmp $1, %rcx
    je end
    imul %rcx, %rax
    loop factorial_loop

end:
    mov %rax, factorial(%rip)
    ret
