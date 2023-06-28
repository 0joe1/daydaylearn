#include <stdio.h>
#include <string.h>
char* string_in(char* str1,char* str2)
{
    char* ret;

    for (int i=0;i<strlen(str1)-strlen(str2);i++)
    {
        if (str1[i]!=str2[0])  continue;
        ret = str1+i;
        for (int n=0;n<strlen(str2);n++)
            if (str1[i+n] == str2[n])
                if (n==strlen(str2)-1)
                    return ret;
                else continue;
            else
                break;
    }
    return NULL;
}
int main(void)
{
    char str1[100],str2[20];
    while (gets(str1)!=NULL)
    {
        gets(str2);
        if (string_in(str1,str2))
            puts(string_in(str1,str2));
        else
            puts("wrong");
    }
    return 0;
}