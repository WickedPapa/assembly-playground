#include <stdio.h>

extern void _main(void);
extern unsigned char input_number; 
extern unsigned int factorial;


int main() {
    _main();
    if(factorial == 0)
        printf("Input %u non valido per il calcolo del fattoriale a 64 bit. Valore massimo: 12.\n", input_number);
    else
        printf("Il fattoriale di %u è %u\n", input_number, factorial);
    return 0;
}