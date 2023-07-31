#include <iostream>

struct A{
    int b;
    const char* s;
    char* s2;
};

int main(void)
{
    A a;
    a.s = "hello";
    a.s2="feeffeef";
    a.s[1]='f';
    a.s2[2]='f';

    std::cout << a.s << std::endl;
}

