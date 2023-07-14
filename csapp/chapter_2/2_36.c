#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int tmult_ok(int x,int y)
{
    int64_t a=(int64_t)x*y;
    return a == (int)a;
}

int main(void)
{
    int x=INT_MAX,y=2;
    printf("%d",tmult_ok(x,y));
    return 0;
}
