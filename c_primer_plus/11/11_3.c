#include <stdio.h>
#include <ctype.h>

void read(char* arr)
{
    char ch;
    int k=0;
    while(scanf(" %c",&ch)!=1)
        continue;
    do
    {
        arr[k++]=ch;
    } while (!isblank(ch=getchar()) && ch!='\n');
    arr[k]='\0';
} 

int main(void)
{
    char arr[1000];
    read(arr);
    puts(arr);
    return 0;
}