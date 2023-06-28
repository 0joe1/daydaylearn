#include <stdio.h>
double dif(double*,int numsSize);
int main(void)
{
    double a[10]={1.2,32.4,3.2,7.5,7.4,75.3,6.7,2.9,56.35,65};
    printf("%f",dif(a,10));
    return 0;
}
double dif(double*a,int numsSize)
{
    double max,min;
    max=min=a[0];
    for (int i=0;i<numsSize;i++)
    {
        if (a[i]>max)
            max=a[i];
        if (a[i]<min)
            min=a[i];
    }
    return max-min;
}