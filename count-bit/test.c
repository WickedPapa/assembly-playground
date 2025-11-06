#include <stdio.h>

extern void _main(void); //importo la funzione _main dichiarata nel file assebly
extern unsigned char conteggio;

int main() {
    _main();  // chiama la routine Assembly
    printf("Conteggio = %u\n", conteggio);
    return 0;
}
