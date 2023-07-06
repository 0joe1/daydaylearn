#include <stdio.h>
#include <string.h>


int isLonger(const char* s1,const char* s2)
{
    return strlen(s1)-strlen(s2)>0;
}

int main(void)
{
    const char* s1 = "hello world";
    const char* s2 = "Good morning";
    printf("%d\n",isLonger(s1,s2));
    return 0;
}
