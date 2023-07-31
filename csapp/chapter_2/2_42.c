#include <stdio.h>

int div16(int x)
{
    int bias = x>>31 & 0xf;
    return (x+bias)>>4;
}

int main(void)
{
    int a=17,b=-17;
    printf("%d\n",div16(a));
    printf("%d\n",div16(b));
    return 0;
}
