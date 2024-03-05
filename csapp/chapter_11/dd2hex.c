#include <stdio.h>
#include <arpa/inet.h>

int main(int argc,char* argv[])
{
    if (argc != 2){
        perror("./dd2hex <dd>");
        return 0;
    }

    uint32_t hex;
    if (inet_pton(AF_INET,argv[1],&hex) != -1){
        printf("%#x\n",ntohl(hex));
    }
    return 0;
}
