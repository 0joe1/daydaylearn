#include <stdio.h>
#include <stdint.h>

int32_t x=0x87654321;


void fA(int x)
{
    int ans = x&0xFF;
    printf("0x%x\n",ans);
}
void fB(int x)
{
    int ans = (~x&~0xFF)|(x&0xFF);
    printf("0x%x\n",ans);
}
void betterfB(int x)
{
    int ans = x^~0xFF;
    printf("0x%x\n",ans);
}

void fC(int x)
{
    int ans = x|0xFF;
    printf("0x%x\n",ans);
}


int main(void)
{
    printf("0x%x",x);
    fA(x);
    fB(x);
    betterfB(x);
    fC(x);
    return 0;
}



