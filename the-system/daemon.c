#include "daemon.h"
#include <stdio.h>
#include <stdlib.h>
#include <sys/syslog.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <syslog.h>


int skeleton_daemon(const char *name, const char *in, const char *out, const char *err, const char *work_dir) {
    pid_t child;

    if( (child = fork()) < 0 ) { //failed fork
        fprintf(stderr, "error: failed fork\n");
        exit(EXIT_FAILURE);
    }
    if (child > 0) { //parent
        exit(EXIT_SUCCESS);
    }
    if( setsid() < 0 ) { //failed to become session leader
        fprintf(stderr, "error: failed setsid\n");
        exit(EXIT_FAILURE);
    }

    //catch/ignore signals
    signal(SIGCHLD, SIG_IGN);
    signal(SIGHUP, SIG_IGN);

    //fork second time
    if ( (child=fork()) < 0) { //failed fork
        fprintf(stderr, "error: failed fork\n");
        exit(EXIT_FAILURE);
    }
    if( child > 0 ) { //parent
        exit(EXIT_SUCCESS);
    }

    //new file permissions
    umask(0);
    //change to path directory

    //Close all open file descriptors
    int fd;
    for( fd = sysconf(_SC_OPEN_MAX); fd > 0; --fd )
    {
        close(fd);
    }
    chdir(work_dir);

    //reopen stdin, stdout, stderr
    stdin = fopen(in, "r");   //fd=0
    stdout = fopen(out, "w+");  //fd=1
    stderr = fopen(err, "w+");  //fd=2


    //open syslog
    openlog(name, LOG_PID, LOG_DAEMON);

    return 0;
}
