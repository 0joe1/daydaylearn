#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
char sh[]="/bin/sh";

int init_func(){
    setvbuf(stdin,0,2,0);
    setvbuf(stdout,0,2,0);
    setvbuf(stderr,0,2,0);
    return 0;
}

int func(char* cmd) {
    system(cmd);
    return 0;
}

int main()
{
    init_func();
    char a[8]={};
    char b[8]={};
    puts("input:");
    gets(a);
    printf(a);
    if (b[0]==0x10) {
        func(sh);
    }
    return 0;
}
