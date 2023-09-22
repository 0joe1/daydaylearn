#include "memlib.c"
#define WSIZE 4
#define DSIZE 8
#define CHUNKSIZE (1<<12)

#define MAX(x,y) ((x)>(y) ? (x):(y))

//将 大小信息和已分配信息 打包成一个word
#define PACK(size,alloc) ((size) | (alloc))

#define GET(pt) (*(unsigned char*)pt)
#define PUT(pt,val) (*(unsigned char*)(pt)= (val))

//得到块的大小(p指向第一个字节)
#define GETSIZE(p) (GET((pt) - WSIZE))

int mm_init(void)
{
    PUT(mem_heap,PACK(WSIZE,1));
    PUT()_
}
