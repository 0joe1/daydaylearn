#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    printf("%d:", argc);
    if (argc == 1)
        printf("%s", *argv);
    for (int i = 1; i < argc; i++) {
        for (int j = 0; argv[i][j]; j++)
            putchar(argv[i][j] - i);
        putchar(' ');
    }
    putchar('\n');
    return EXIT_SUCCESS;
}
