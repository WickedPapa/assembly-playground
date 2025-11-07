#include <stdio.h>

extern void _main(void);
extern unsigned long long tot;

int main() {
    _main(); 
    printf("Conteggio = %llu\n", tot);
    return 0;
}