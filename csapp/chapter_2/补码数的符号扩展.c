#include <stdio.h>
#include <arpa/inet.h>
#include "showbytes.h"

int main(void)
{
    short sx=-12345;
    unsigned short usx=sx;
    int x=sx;
    unsigned ux=usx;

    x=htonl(x);
    ux=htonl(ux);

    printf("sx = %d\n",sx);
    show_bytes((byte_pointer)&sx,2);
    printf("usx = %d\n",usx);
    show_bytes((byte_pointer)&usx,2);
    printf("x = %d\n",ntohl(x));
    show_bytes((byte_pointer)&x,4);
    printf("ux = %d\n",ntohl(ux));
    show_bytes((byte_pointer)&ux,4);


    return 0;
}
