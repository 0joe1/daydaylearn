#include <stdio.h>

int main(void)
{
    short int v = -12345;
    unsigned short uv = (unsigned short)v;

    /*v的表示为最高位为1,|最高位值|-|其他位和值|==12345
     *转成unsigned后，|最高位值|+|其他位和值|==对应的unsigned值
     *最终值==|最高位值|+|最高位值|-|其他位和值|*/
    printf("predict %d\nreal ",65536+v);
    printf("v=%d,uv=%u",v,uv);

    return 0;
}

