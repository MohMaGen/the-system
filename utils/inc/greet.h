#ifndef _1334_UTILS_GREET_H_
#define _1334_UTILS_GREET_H_

#include <stdio.h>

void greet(const char *name, int arg_len, char **args);
void greetf(FILE *output, const char *name, int arg_len, char **args);

#endif
