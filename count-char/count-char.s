.global _main
.global count

.data
str:    .asciz "this is a test str with 260 target char: zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
char:   .byte 'z'               # character to search
count:  .quad 0                 # variable to store result (64-bit)

.text
_main:
    nop
    mov  $0, %rcx               # RCX = counter = 0
    lea  str(%rip), %rsi        # RSI = address of string
    mov  char(%rip), %al        # AL = target character (8-bit)

loop_compare:
    # MOVZBQ loads one byte from memory and zero-extends it to 64 bits.
    # We use it instead of 'movb (%rsi), %dl' because that instruction
    # would update only the lowest 8 bits of RDX, leaving the upper 56 bits
    # unchanged (potentially containing garbage from a previous iteration).
    # MOVZBQ ensures the entire RDX register is clean: all upper bits are zero.
    movzbq (%rsi), %rdx

    # TEST performs a bitwise AND between DL and itself.
    # Effect: it sets the Zero Flag (ZF) if DL == 0.
    # Since strings in C end with a null byte (0x00),
    # this check efficiently detects the end of the string without altering DL.
    test   %dl, %dl
    je     end                   # if DL == 0 → end of string

    cmp    %al, %dl              # compare current byte with target char
    jne    next                  # skip if not equal
    inc    %rcx                  # if equal, increment counter

next:
    inc    %rsi                  # move to next byte in string
    jmp    loop_compare

end:
    mov    %rcx, count(%rip)     # store final count
    ret
