#include <stdio.h>

int uadd_ok(unsigned x,unsigned y)
{
    return (x+y)>=x;
}

int main(void)
{
    unsigned a=0xfffffffe,b=0x00000001,c=0x00000002;
    printf("a+b?%d\n",uadd_ok(a,b));
    printf("a+c?%d",uadd_ok(a,c));
    return 0;
}
