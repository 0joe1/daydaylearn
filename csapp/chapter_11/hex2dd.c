#include <stdio.h>
#include <malloc.h>
#include <arpa/inet.h>
#include <stdint.h>


char hex2ch(char h)
{
    if (h>'a' && h<'z'){ return h-'a'+10;}
    else if (h>'A' && h<'Z'){ return h-'A'+10;}
    else return h-0x30;
}

uint32_t hstr2u(const char* hstr){
    char* bin = (char*)malloc(sizeof(char)*4);
    const char* pstr = hstr+2*sizeof(char);
    for (int i=0,j=3;i<8;i+=2,j--)
    {
        unsigned char new = (hex2ch(pstr[i]))<<4;
        new |= (hex2ch(pstr[i+1]));
        *(bin+j) = new;
    }

    uint32_t ret = *(uint32_t*)bin;
    free(bin);
    return ret;
}

int main(int argc,char* argv[])
{
    if (!(argc==2)){
        puts("./hex2dd <nethex>");
    }
    char dd[16];
    uint32_t hostlong = hstr2u(argv[1]);
    uint32_t netlong = htonl(hostlong);


    if ((inet_ntop(AF_INET,&netlong,dd,16)) != NULL){
        printf("%s\n",dd);
    }
    return 0;
}


