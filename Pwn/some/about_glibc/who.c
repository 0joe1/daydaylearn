#include <stdio.h>
#include <unistd.h>
#include <dlfcn.h>
#include <stdlib.h>


int puts(const char *message) {
	int (*new_puts)(const char *message);
	int result;
	new_puts = dlsym(RTLD_NEXT, "puts");
    printf("this is id:%d\n",getuid());
	result = new_puts(message);
	return result;
}
