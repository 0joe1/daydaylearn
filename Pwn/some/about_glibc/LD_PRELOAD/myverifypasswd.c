#include <stdio.h>
#include <string.h>
#include "mystrcmp.h"

int main(int argc,char **argv) {
    char passwd[] = "password";
    if (argc < 2) {
        printf("usage: %s <password>\n",argv[0]);
        return 0;
    }
    if (!mystrcmp(passwd,argv[1])) {
        printf("Correct Password!\n");
        return 0;
    }
    printf("Invalid Password!\n");
}
