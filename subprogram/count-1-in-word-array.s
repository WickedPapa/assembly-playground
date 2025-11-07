.global _main
.global tot

.data
.set size, 10
numbers_array: .word 0,0,11,0,0,4,0,0,0,1 # (11 = 1011, 4 = 100, 1 = 1 in binario quindi il totale dei bit a 1 è 5)
tot: .word 0x00

.text
_main: 
    nop
    mov $0, %esi
    mov $0, %cx
    mov $0, %dx

count_loop: 
    # mov numbers_array(, %esi, 2), %ax (32-bit addressing mode)
    lea numbers_array(%rip), %rdi
    mov (%rdi,%rsi,2), %ax
    call count
    inc %esi
    add %cx, %dx
    cmp $size, %esi
    jb count_loop
    mov %dx, tot(%rip)
    xor %rax, %rax
    ret
#---------------------------
# sottoprogramma "conta"
# conta il n. di bit a 1 in una word
# par. ingresso: AX, word da analizzare
# par. uscita: CL, conto dei bit a 1
count: 
    push %ax
    movb $0x00,%cl

comp: 
    cmp $0x00,%ax
    je end
    shr %ax
    adcb $0x0, %cl
    jmp comp

end: 
    pop %ax
    ret
#---------------------------
