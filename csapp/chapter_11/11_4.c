#include <stdio.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

int main(int argc,char* argv[])
{
    struct addrinfo *p,*result,hints;
    if (argc != 2){
        fprintf(stderr,"Usage: %s <domain name>",argv[0]);
        return 0;
    }

    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    if (getaddrinfo(argv[1],NULL,&hints,&result) != 0){
        perror("getaddrinfo");
        exit(0);
    }

    for (p=result ; p ; p = p->ai_next)
    {
        char dst[20];
        struct sockaddr_in *addr = (struct sockaddr_in*)p->ai_addr;
        inet_ntop(AF_INET,&addr->sin_addr,dst,20);
        printf("%s\n",dst);
    }
    freeaddrinfo(result);
}
