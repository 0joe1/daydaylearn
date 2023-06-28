#include <stdio.h>
#include <string.h>

struct month{
	char name1[10];
	char name2[5];
	char name3[3];
	int days;
};

int main(void)
{
    struct month months[12]={
		{"January","Jan","1",31},
		{"February","Feb","2",29},
		{"March","Mar","3",31},
		{"April","Apr","4",30},
		{"May","May","5",31},
		{"June","Jun","6",30},
		{"July","Jul","7",31},
		{"August","Aug","8",31},
		{"September","Sep","9",30},
		{"October","Oct","10",31},
		{"November","Nov","11",30},
		{"December","Dec","12",31}
	};
	int days;
	char month[12];
    int sum=0;
	scanf("%s %d",month,&days);
    for (int i=0;i<12;i++)
	{
		if (!strcmp(months[i].name1,month) || !strcmp(months[i].name2,month) || !strcmp(months[i].name3,month) )
		{
            sum += days;
			break;
		}
		else
			sum += months[i].days;
	}
	printf("%d",sum);

	return 0;
}

