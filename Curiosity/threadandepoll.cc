#include <iostream>
#include <unistd.h>
#include <sys/epoll.h>
#include "socket.hpp"

int sfd;

char buffer[1024];

void* do_epoll(void *) {
    struct epoll_event ev;
    struct epoll_event evlist[3];
    int epfd = epoll_create(3);

    ev.data.fd = sfd;
    ev.events = EPOLLIN;
    epoll_ctl(epfd, EPOLL_CTL_ADD, sfd, &ev);
    while (1) {
        epoll_wait(epfd, evlist, 3, -1);
        read(sfd,buffer,100);
        //printf("%s\n",buffer);
        memset(buffer,0,sizeof(buffer));
    }

    close(epfd);

    return NULL;
}


int main(void)
{
    sfd = inetConnect("127.0.0.1", "7680");
    //epoll 是否会堵塞其他线程的实验
    pthread_t pid;
    if (pthread_create(&pid,NULL,do_epoll,NULL) != 0){
        myerr("creat thread");
    }

    while(1)
    {
        sleep(1);
        printf("hello-world\n");
    }

    return 0;
}
