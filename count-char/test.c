#include <stdio.h>

extern void _main(void); //importo la funzione _main dichiarata nel file assebly
extern unsigned long long count;

int main() {
    _main();  // chiama la routine Assembly
    printf("Conteggio = %llu\n", count);
    return 0;
}