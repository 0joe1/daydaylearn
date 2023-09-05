#include <stdio.h>
#include "showbytes.h"

int add_odd_one(unsigned x)
{
    int mask = 0x55555555;
    return !!(x&mask);
}

int main(void)
{
    int x=0xa;
    printf("%d",add_odd_one(x));
    return 0;
}
