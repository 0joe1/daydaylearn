#include <stdio.h>
int Fibonacci(int n){
    int cal[1000];
    cal[0]=cal[1]=1;
    for (int i=2;i<n;i++)
    {
        cal[i]=cal[i-1]+cal[i-2];
    }
    return cal[n-1];
}
int main(void)
{
    int n;
    scanf("%d",&n);
    printf("%d",Fibonacci(n));
}