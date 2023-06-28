#include <stdio.h>
#include <ctype.h>
void read(void);
int ctoi(char a){
    int alpha=toupper(a);
    if (isalpha(a))
        return alpha-'A'+1;
    else 
        return -1;
}
int main(void)
{
    read();
    return 0;
}
void read(void)
{
    char ch;
    while((ch=getchar())!=EOF)
    {
        if (ch=='\n')
            continue;
        if (~ctoi(ch))
            printf("%d ",ctoi(ch));
        else 
            printf("n");
    }
}