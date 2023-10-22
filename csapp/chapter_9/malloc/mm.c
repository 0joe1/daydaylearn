#include "memlib.c"
#define WSIZE 4
#define DSIZE 8
#define CHUNKSIZE (1<<12)

#define MAX(x,y) ((x)>(y) ? (x):(y))

//将 大小信息和已分配信息 打包成一个word
#define PACK(size,alloc) ((size) | (alloc))

#define GET(pt) (*(unsigned char*)pt)
#define PUT(pt,val) (*(unsigned char*)(pt)= (val))

#define GETSIZE(p) (GET(p) & ~0x7)
#define GETALLOC(p) (GET(p) & 0x1)

//头尾
#define HDRP(bp) ((char*)(bp)-WSIZE)
#define FTRP(bp) ((char*)(bp)+GETSIZE(HDRP(bp))-DSIZE)

//移动
#define PREV_BLKP(bp) ((char*)(bp) - GETSIZE((char*)(bp) - DSIZE))
#define NEXT_BRKP(bp) ((char*)(bp) + GETSIZE((char*)(bp) - WSIZE))

static char* heap_lisp;
static void* extend_heap(size_t words);
static void* coalesce(void* bp);
static void* find_fit(size_t asize);
static void  place(void* bp,size_t asize);


int mm_init(void)
{
    if ((heap_lisp = mem_sbrk(4*WSIZE)) == (void*)-1){
        return -1;
    }
    PUT(heap_lisp,0);
    PUT(heap_lisp+1*WSIZE,PACK(DSIZE,1));
    PUT(heap_lisp+2*WSIZE,PACK(DSIZE,1));
    PUT(heap_lisp+3*WSIZE,PACK(0,1));
    heap_lisp += 2*WSIZE;

    if (extend_heap(CHUNKSIZE/WSIZE) == NULL){
        return -1;
    }
    return 0;
}

static void* extend_heap(size_t words)
{
    char* bp;

    size_t size = words%2 ? (words+1)*WSIZE : words*WSIZE;
    if ((long)(bp == mem_sbrk(words*WSIZE)) == -1){
        return NULL;
    }
    PUT(HDRP(bp),PACK(size,0));
    PUT(FTRP(bp),PACK(size,0));
    PUT(FTRP(bp)+WSIZE,PACK(0,1));

    return coalesce(bp);
}


static void* coalesce(void* bp)
{
    size_t pre_alloc = GETALLOC(HDRP(PREV_BLKP(bp)));
    size_t nxt_alloc = GETALLOC(HDRP(NEXT_BRKP(bp)));
    size_t size = GETSIZE(HDRP(bp));

    if (pre_alloc && nxt_alloc)
        return bp;
    else if (pre_alloc && !nxt_alloc)
    {
        size += GETSIZE(HDRP(NEXT_BRKP(bp)));
        PUT(HDRP(bp),PACK(size,0));
        PUT(FTRP(bp),PACK(size,0));
    }
    else if (!pre_alloc && nxt_alloc)
    {
        size += GETSIZE(HDRP(PREV_BLKP(bp)));
        PUT(HDRP(PREV_BLKP(bp)),PACK(size,0));
        PUT(FTRP(bp),PACK(size,0));
        bp = PREV_BLKP(bp);
    }
    else
    {
        size += GETSIZE(HDRP(PREV_BLKP(bp))) + GETSIZE(HDRP(NEXT_BRKP(bp)));
        PUT(HDRP(PREV_BLKP(bp)),PACK(size,0));
        PUT(FTRP(NEXT_BRKP(bp)),PACK(size,0));
        bp = PREV_BLKP(bp);
    }
    return bp;
}

void mm_free(void* bp)
{
    size_t size = GETALLOC(HDRP(bp));

    PUT(HDRP(bp),PACK(size,0));
    PUT(FTRP(bp),PACK(size,0));
    coalesce(bp);
}

void* mm_malloc(size_t size)
{
    size_t asize;
    size_t extend_size;

    if (size == 0){
        return NULL;
    }
    if (size <= DSIZE)
        asize = 2*DSIZE;
    else
        asize = DSIZE*((size + (DSIZE) + (DSIZE-1))/DSIZE);

    char* bp;
    if ((bp = find_fit(asize)) != NULL){
        place(bp,asize);
        return bp;
    }

    extend_size = MAX(asize,CHUNKSIZE); //每次扩张至少有CHUNKSIZE
    if ((bp = extend_heap(asize)) == NULL){
        return NULL;
    }
    place(bp,asize);

    return bp;
}

static void* find_fit(size_t asize)
{
    void* p = heap_lisp;
    while (GETALLOC(HDRP(p)) || GETSIZE(HDRP(p)) < asize)
    {
        if (GETALLOC(HDRP(p)) && GETSIZE(HDRP(p))==0)
            return NULL;
        else
            p = NEXT_BRKP(p);
    }
    return p;
}
static void place(void* bp,size_t asize)
{
    size_t remain_size = GETSIZE(HDRP(bp))-asize;
    PUT(HDRP(bp),PACK(asize,1));
    PUT(FTRP(bp),PACK(asize,1));

    if (remain_size < 2*DSIZE)
        return;

    PUT(HDRP(NEXT_BRKP(bp)),PACK(remain_size,0));
    PUT(FTRP(NEXT_BRKP(bp)),PACK(remain_size,0));
}

