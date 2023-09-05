#include <stdio.h>
#include "showbytes.h"

void test_showbytes(int val)
{
    int ival = val;
    float fval = val;
    double dval = val;
    int *pval = &val;

    show_bytes((unsigned char*)&ival,sizeof(int));
    show_bytes((unsigned char*)&fval,sizeof(float));
    show_bytes((unsigned char*)&dval,sizeof(double));
    show_bytes((unsigned char*)&pval,sizeof(void*));

}

int main(void)
{
    test_showbytes(5);
    printf("%x",557);
}
