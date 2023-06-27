#include <stdio.h>

int bis(int x,int m){
    return x|m;
}
int bic(int x,int m){
    return x&~m;
}


void f(int n)
{
    if(n)
        f(n/2);
    else
        return;
    printf("%d",n%2);
}
int bool_or(int x,int y)
{
    int result = bis(x,y);
    return result;
}
int bool_xor(int x,int y)
{
    int result = bis(bic(x,y),bic(y,x));
    return result;
}


int main(void)
{
    int x0=0x87654321;
    //test bis and bic
    printf("0x%x\n",bis(x0,0x0ff0f000));
    printf("0x%x\n",bic(x0,0x0ff0f000));

    //test bool_or
    int x1=0b101110;
    int y1=0b110000;
    f(bool_or(x1,y1));
    printf("\n");

    //test bool_xor
    int x2=0b100010010110;
    int y2=0b110011100101;
    f(bool_xor(x2,y2));

    return 0;
}

