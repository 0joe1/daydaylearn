#include <stdio.h>
void larger_of(double* x,double* y){
    int larger = *x>*y?*x:*y;
    *y=*x=larger;
}
int main(void)
{
    double a,b;
    scanf("%lf%lf",&a,&b);
    larger_of(&a,&b);
    printf("a:%f\nb:%f",a,b);
}