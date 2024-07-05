#include "daemon.h"
#include "greet.h"
#include "stdio.h"
#include <stdlib.h>
#include <sys/syslog.h>

char buffer[1024];

int main(int argc, char **argv) {
    if (skeleton_daemon("the-system", "./stream.in", "./stream.out",
                "./stream.err", "./") != 0) {
        fprintf(stderr, "Failde to start daemon");
        exit(EXIT_FAILURE);
    }

    greet("the-system", argc, argv);
    printf("start the-system\n");
    syslog(LOG_NOTICE, "start the-system\n");
    closelog();

    return 0;
}
