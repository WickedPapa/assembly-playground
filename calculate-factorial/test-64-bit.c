#include <stdio.h>

extern void _main(void);
extern unsigned char input_number; 
extern unsigned long long factorial;


int main() {
    _main();
    if(factorial == 0)
        printf("Input %u non valido per il calcolo del fattoriale a 64 bit. Valore massimo: 20.\n", input_number);
    else
        printf("Il fattoriale di %u è %llu\n", input_number, factorial);
    return 0;
}