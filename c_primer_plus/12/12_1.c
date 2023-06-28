#include <stdio.h>
void critic(int*);

int main(void)
{
	int a = 0;
	printf("How many pounds to a firkin of butter?\n");
	scanf("%d",&a);
	while (a != 56)
		critic(&a);
	printf("You must have looked it up");
	return 0;
}
void critic(int* a)
{
    printf("No luck,my friend.Try again.\n");
	scanf("%d",a);
}

