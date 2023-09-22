#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int mmapcopy(char* filename)
{
    int fd = open(filename,O_RDONLY);
    if (fd == -1){
        printf("error when open file");
        return 0;
    }
    struct stat sb;
    if (fstat(fd,&sb) == -1){
        printf("error when get stat");
        return 0;
    }

    void *p = mmap(NULL,sb.st_size,PROT_READ,MAP_PRIVATE,fd,0);
    write(STDOUT_FILENO,p,sb.st_size);
    munmap(p,sb.st_size);

    return 1;
}


int main(int argc,char* argv[])
{
    if (!(argc == 2)){
        puts("wrong parameter");
        return 0;
    }
    mmapcopy(argv[1]);
    return 0;
}

