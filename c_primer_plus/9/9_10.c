#include <stdio.h>
void base_to_n(double ,int);
int main(void)
{
    double num;
    int base;
    printf("Please input an int and the base(2~10)\n");
    scanf("%lf%d",&num,&base);
    base_to_n(num,base);
    return 0;
}
void base_to_n(double number,int base)
{
    int nums1[1000];
    int counter=0;
    int a=(int)number;
    double b;
    b=number-a;
    while(a>0)
    {
        nums1[counter]=a%base;
        a/=base;
        counter++;
    }
    for (int i=counter-1;i>=0;i--)
        printf("%d",nums1[i]);
    printf(".");
    double remain;
    
    for (int i=0;i<8;i++)
    {
        b*=base;
        printf("%d",(int)b);
        b-=(int)b;
    }
}