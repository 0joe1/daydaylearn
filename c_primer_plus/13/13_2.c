#include <stdio.h>
#include <stdlib.h>
#define BUF_SIZE 512

int main(int argc,char* argv[])
{
	char buf[BUF_SIZE];
	FILE* in,*out;
	if ((in = fopen(argv[1],"rb")) == NULL)
	{
		printf("fail,file1");
		exit(EXIT_FAILURE);
	}
	if ((out = fopen(argv[2],"wb")) ==NULL)
	{
		printf("fail,file2");
		exit(EXIT_FAILURE);
	}
	size_t bytes;
	while ((bytes=fread(buf,sizeof(char),BUF_SIZE,in)))
	{
		fwrite(buf,sizeof(char),bytes,out);
	}
	fclose(in);
	fclose(out);

	return 0;
}


