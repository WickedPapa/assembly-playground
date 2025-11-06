# In assembly solo i nomi dei dati e delle etichette sono case sensitive
# tutto il resto per convenzione si scrive minuscolo, tranne le costanti

.global _main           # Punto di ingresso del programma. Dichiaro il sottoprogramma _main (o main) come visibile globalmente
                        # La direttiva .global (o .globl) serve a rendere visibile un simbolo all’esterno del file assembly,
                        # cioè a esportarlo in modo che il linker possa trovarlo.
.global conteggio

.section .data          # Questa direttiva serve solo ad indicare che questa è la sezione "data" (dati inizializzati)
                        # Con alcuni assembler funziona anche senza .section ma lo standart GAS vuole .section
dato: .long 0x0F0F0101
conteggio: .byte 0x00

.section .text          # Questa direttiva serve solo ad indicare che questa è la sezione "text" (codice eseguibile)
                        # Con alcuni assembler funziona anche senza .section ma lo standard GAS vuole .section
_main:   
    nop
    movb $0x00, %cl
    movl dato(%rip), %eax

comp:   
    cmpl $0x00, %eax    # comparo 0 al contenuto di eax, ovvero dato
    je fine             # se è 0 salto a "fine" (che è dichiarato dopo...funziona ma meglio dichiararlo prima)
    shrl %eax           # shifto a dx eax, dopo al max 32 giri rimarranno solo zeri e andro a "fine"
    adcb $0x0, %cl      # aggiungo a %cl 0 + il valore del carryflag
    jmp comp            # ritorno su a "comp" (equivalente GOTO)

fine:   
    movb %cl, conteggio(%rip)
    ret
    