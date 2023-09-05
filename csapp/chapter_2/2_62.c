#include <stdio.h>
#include "showbytes.h"

int int_shift_are_arithmetic()
{
    int x = -1;
    int int_len = (sizeof(int))<<3;

    return x>>int_len & 1;
}

int int_shift_are_arithmetic2()
{
    unsigned int x = -1;
    show_bytes((byte_pointer)&x,sizeof(int));
    int int_len = (sizeof(int))<<3;

    return x>>int_len & 1;
}

int main(void)
{
    printf("%d\n",int_shift_are_arithmetic());
    printf("%d",int_shift_are_arithmetic2());
}
