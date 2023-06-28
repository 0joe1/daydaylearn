#include <stdio.h>
void add_arr(int a[],int b[],int target[],int numsSize)
{
	for(int i=0;i<numsSize;i++)
		target[i]=a[i]+b[i];
}

int main(void)
{
	int a[]={2,1,4,2,9,90,21};
	int b[]={8,3,1,34,2,1,4};
	int target[7];
	add_arr(a,b,target,7);
    for (int i=0;i<7;i++)
		printf("%d ",target[i]);
	return 0;
}

