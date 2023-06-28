#include <stdio.h>
#include <string.h>

char* mystrncpy(char* s1,char* s2,int n)
{
    for (int i=0;i<n;i++)
        if ((*(s1+i)=*(s2+i))=='\0')
            return s1;
    return s1;
}

int main(void)
{
    char str1[100],str2[100];
    
    while(fgets(str2,100,stdin)!=NULL)
    {
        int n;
        scanf("%d",&n);
        mystrncpy(str1,str2,n);
        for (int i;i<n;i++)
            printf("%c",str1[i]);
    }
    return 0;
}