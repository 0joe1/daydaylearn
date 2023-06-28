#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void quicksort(int* a,int left,int right)
{
    int i,j,t,temp;

	if (left > right)
		return;
	temp = a[left];
	i = left;
	j = right;
	while (i != j)
	{
		while (a[j]<=temp && i<j)
			j--;
		while (a[i]>=temp && i<j)
			i++;
		
		if (i<j)
		{
			t=a[i];
			a[i]=a[j];
			a[j]=t;
		}
	}
	a[left] = a[i];
	a[i] = temp;
    
	quicksort(a,left,i-1);
	quicksort(a,i+1,right);
	return;
}

int main(void)
{
    int ins[100];

	srand((unsigned int) time(0));
    for (int i=0;i<100;i++)
	{
		ins[i] = rand()%10+1;
	}
    quicksort(ins,0,100);
	for (int i=0;i<100;i++)
		printf("%d ",ins[i]);
	return 0;
}
				
