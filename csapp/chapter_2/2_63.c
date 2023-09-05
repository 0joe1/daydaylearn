#include <stdio.h>
#include <limits.h>
#include "showbytes.h"

unsigned srl(unsigned x,int k)
{
    unsigned xsra = (int)x >> k;
    int w = sizeof(int) << 3;
    int mask = (1<<(w-k)) -1;

    return xsra&mask;
}

int sra(int x,int k)
{
    int xsrl = (unsigned)x >> k;
    int w = sizeof(int) << 3;
    int mask = -1 << (w-k);
    int mmask = -1 << (w-1);
    mask &= (-1 + !(mmask&x));

    return xsrl | mask;
}

int main(void)
{
    int a = INT_MIN , k = 3;
    unsigned b= 0x123;
    printf("%u %u\n",b>>k,srl(b,k));
    printf("%d %d\n",a>>k,sra(a,k));
}
