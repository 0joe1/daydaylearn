#include <stdio.h>
void copy(int n,int m,double a[n][m],double b[n][m]);
void show(int n,int m,double show[n][m]);
int main(void)
{
    double a[3][5]={
        {2.3,4.4,93.3,5.1,1.2},
        {3.2,6.4,9.2,3.4,3.3},
        {2.2,3.4,1.2,5.3,99.9},
        };
    double b[3][5];

    copy(3,5,a,b);
    show(3,5,a);
    printf("\n");
    show(3,5,b);
    return 0;
}
void copy(int n,int m,double a[n][m],double b[n][m])
{
    for (int i=0;i<n;i++)
        for (int j=0;j<m;j++)
            b[i][j]=a[i][j];
}
void show(int n,int m,double show[n][m])
{
    for (int i=0;i<n;i++)
    {
        for (int j=0;j<m;j++)
            printf("%.2f ",show[i][j]);
        printf("\n");
    }
}