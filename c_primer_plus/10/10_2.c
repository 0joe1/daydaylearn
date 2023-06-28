#include <stdio.h>
void copy_arr(double[],double[],int numsSize);
void copy_ptr(double*,double*,int numsSize);
void copy_ptrs(double*,double*, double*);    
int main(void)
{
	double source[7] = {1.1,2.2,3.3,4.4,5.5,6.6,7.7};
	double target2[7];
	double target3[7];
	double target4[7];
    copy_arr(target2,source,7);
    copy_ptr(target3,source,7);
    copy_ptrs(target4,source,target4+7);
    printf("%d ",source[1]);
}
void copy_arr(double target2[],double source[],int numsSize){
	for (int i=0;i<numsSize;i++)
		target2[i]=source[i];
}
void copy_ptr(double* target3,double* source,int numsSize){
    for (int i=0;i<numsSize;i++){
        *(target3+i)=*(source+i);
    }
}
void copy_ptrs(double* target4,double* source,double* end){
    double*ptr = target4;
    while (ptr !=end ){
        *ptr++ = *(source++);
    }
}    
	

