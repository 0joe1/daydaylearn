#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TSIZE 45

struct film{
	char title[TSIZE];
	int rating;
	struct film * next;
};
void back(struct film*);
char* s_gets(char*st,int n);

int main(void)
{
	struct film* head = NULL;
	struct film* prev,*current;
	char input[TSIZE];

	puts("Enter first movie title:");
	while (s_gets(input,TSIZE) && input[0]!='\0')
	{
	    current=(struct film *)malloc(sizeof(struct film));
		if (head == NULL)
			head = current;
		else
			prev->next=current;
		strcpy(current->title,input);
		puts("Enter your rating <0-10>:");
		scanf("%d",&current->rating);
		while (getchar()!='\n')
			continue;
		puts("Enter next movie title (empty line to stop):");
		prev = current;
	}
	if (head == NULL)
		printf("No data entered. ");
	else
		printf("Here is the movie list:\n");
	current = head;
	while (current != NULL)
	{
		printf("Movie:%s Rating:%d\n",current->title,current->rating);
		current = current->next;
	}
	puts("Next invert list.");
	back(head);
	
	current = head;
	while(current!=NULL)
	{
		head = current->next;
		free(current);
		current = head;
	}
	return 0;
}
void back(struct film* ptr)
{
	if (ptr->next !=NULL)
	    back(ptr->next);
	printf("Movie:%s Rating:%d\n",ptr->title,ptr->rating);
}
char* s_gets(char* st,int n)
{
	char* ret;
    int i=0;

	ret=fgets(st,n,stdin);
	if (ret)
	{
		while (st[i] != '\n' && st[i] !='\0')
			i++;
		if (st[i] == '\n')
			st[i] = '\0';
		else
			while (getchar() != '\n')
				continue;
	}
    return ret;
}
	




