#include <stdio.h>

int main(void)
{
    int x=771;
    //除法与右移
    printf("%d\n",x/16);
    printf("%d\n",x>>4);

    int y=-771;
    printf("%d\n",y/16);
    printf("%d\n",y>>4);
    //偏置技术 x/y向上取 == (x+y-1)/y 向下取
    printf("%d\n",(y+(1<<4)-1)>>4);

    printf("%d\n",x>0 ? x>>4 : (x+((1<<4) - 1))>>4);
    printf("%d",y>0 ? y>>4 : (y+((1<<4) - 1))>>4);
    return 0;
}
/*总结：
 * C语言在x>0时向下取，在x<0时向上取（总之向0取）
 * x/2^k == x>0 ? x>>k : (x+((1<<k)- 1))>>k
 */
