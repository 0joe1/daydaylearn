#include <stdio.h>
#include <limits.h>
#include "showbytes.h"

int all_one(int x)
{
    return !(~x);
}
int all_zero(int x)
{
    return !x;
}
int lsb_one(int x)
{
    x &= 0xff;
    return !(~x & 0xff);
}
int msb_zero(int x)
{
    int shift_val = (sizeof(int)-1)<<3;
    int xright = x >> shift_val;
    xright &= 0xff;
    return !(xright);
}

int main(void)
{
    int x = -1;
    show_bytes((byte_pointer)&x,sizeof(int));
    int a = all_one(x);
    int b = all_zero(x);
    int c = lsb_one(x);
    int d = msb_zero(x);

    printf("%d %d %d %d",a,b,c,d);

    return 0;
}
