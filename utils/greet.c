#include "./inc/greet.h"
#include "stdio.h"

void greet(const char *name, int arg_len, char **args) {
    puts(name);

    puts("==========[ args ]==========");
    for (char **args_iter = args; args_iter != args + arg_len; args_iter++) {
        printf("\t[ %ld ]: %s\n", args_iter - args, *args_iter);
    }
}

void greetf(FILE *output, const char *name, int arg_len, char **args) {
    fprintf(output, "%s", name);

    fprintf(output, "==========[ args ]==========");
    for (char **args_iter = args; args_iter != args + arg_len; args_iter++) {
        fprintf(output, "\t[ %ld ]: %s\n", args_iter - args, *args_iter);
    }

}

