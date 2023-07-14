#include <stdio.h>
#include <limits.h>
#include "2_30.c"

int tsub_ok(int x,int y)
{
    if(-y == y)
        return x>=0?0:1;
    return tadd_ok(x,-y);
}

int main(void)
{
    int a=-666, TMin=INT_MIN;
    printf("a:%d -a:%d",a,-a);
    printf("Tmin:%d -TMin:%d\n",TMin,-TMin);

    if(tsub_ok(a,TMin))
        printf("ok");
    if(tsub_ok(-a,TMin))
        printf("ok");
    return 0;
}
