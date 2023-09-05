#include <iostream>
#include <string>
#include "socket.hpp"

char buf[1024];

int main(void)
{
    int lfd = inetListen("7680");
    while (1)
    {
        int cfd = accept(lfd,NULL,0);
        std::string s;
        std::cin >> s ;
        write(cfd,s.c_str(),10);
    }

}
