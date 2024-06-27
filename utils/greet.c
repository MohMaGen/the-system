#include "greet.h"
#include "stdio.h"

void greet(const char *name, int arg_len, char **args) {
    puts(name);

    puts("==========[ args ]==========");
    for (char **args_iter = args; args_iter != args + arg_len; args_iter++) {
        printf("\t[ %ld ]: %s\n", args_iter - args, *args_iter);
    }
}


