#include <stdio.h>
#define PINGJUN(X,Y) (1/((1/X)+(1/Y)/2))

int main(void)
{
	double f1,f2;
	scanf("%lf%lf",&f1,&f2);
	printf("%f",PINGJUN(f1,f2));
	return 0;
}
