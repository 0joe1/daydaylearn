#include <stdio.h>
void getnc(char* box)
{
    char ch;
    int counter=0;
    while((ch=getchar())!=EOF)
        box[counter++]=ch;
    box[counter]='\0';
}
int main(void)
{
    char box[1000];
    getnc(box);
    printf("%s",box);
    return 0;
}