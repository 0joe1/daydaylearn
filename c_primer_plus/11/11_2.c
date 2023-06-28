#include <stdio.h>
#include <ctype.h>

void getnc(char* box,int n)
{
    char ch;
    int counter=0;
    while((ch=getchar())!=EOF && n-->0)
    {
        if (isblank(ch))
            break;
        box[counter++]=ch;
    }
    box[counter]='\0';
    
}
int main(void)
{
    int n;
    char box[1000];

    scanf("%d",&n);
    getchar();
    getnc(box,n);
    printf("%s",box);
    return 0;
}