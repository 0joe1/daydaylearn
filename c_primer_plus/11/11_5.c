#include <stdio.h>
#include <string.h>

char* search(char*str,char goal)
{
    while (*str != '\0')
    {
        if (*str==goal)
            return str;
        else
            str++;
    }
    return NULL;
}

int main(void)
{
    char goal=' ';
    char source[100];
    char* position;

    fgets(source,100,stdin);
    while(goal!=EOF)
    {
        while((goal=getchar())=='\n')  continue;
        if ((position=search(source,goal))!=NULL)
            printf("%s",position);
        else
            printf("no goal in the string");
        
    }
    return 0;
}