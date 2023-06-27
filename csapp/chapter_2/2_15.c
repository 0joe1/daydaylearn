#include <stdio.h>
#include <stdint.h>

int isEqual(int32_t x,int32_t y)
{
    return !(x^y);
}

int main(void)
{
    int x=82,y=2;
    printf("%d\n",isEqual(x,y));

    printf("%d",isEqual(x,x));
    return 0;
}
