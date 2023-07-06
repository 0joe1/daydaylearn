#include <stdio.h>

int main(void)
{
    int a=0x66;
    printf("%d\n",a>>3);
    printf("%d\n",a>>35);
    printf("%d\n",a<<3);
    printf("%d\n",a<<35);
}
