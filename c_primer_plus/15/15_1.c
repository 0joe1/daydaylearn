#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int btoi(char* str)
{
	int sum=0,k=1;
	for (int i=strlen(str)-1;i>=0;i--)
	{
		if (str[i]-'0')
		{
			sum += k;
		}
		k *= 2;
	}
	return sum;
}
int main(void)
{
	char a[20];
	scanf("%s",a);
	printf("%d\n",btoi(a));
	return 0;
}

