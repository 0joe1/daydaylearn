#include <malloc.h>
#include <errno.h>

#define MAX_HEAP 10086

static char* mem_heap;
static char* mem_brk;
static char* mem_max_addr;

void mem_init(void)
{
    //不加(char*)，就是void*,所以要加上
    mem_heap = (char*)malloc(MAX_HEAP);
    mem_brk = (char*)mem_heap;
    mem_max_addr = (char*)mem_heap + MAX_HEAP;
}

void* mem_sbrk(size_t inc)
{
    char* ret_brk = mem_brk;

    if (inc < 0 || mem_brk+inc > mem_max_addr){
        errno = ENOMEM; //超过进程数据段的最大字节数
        fprintf(stderr,"error increase size\n");
        return (void*)-1;
    }
    mem_brk += inc;
    return (void*)ret_brk;
}

