#include <stdio.h>
typedef unsigned char* byte_pointer;

void show_bytes(byte_pointer start,size_t len)
{
    for(size_t i=0;i<len;i++)
        printf(" %.2x",start[i]);
    printf("\n");
}

