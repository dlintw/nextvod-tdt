/*
 * common.c: wirbelscan - A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */


/*
   Generic functions which will be used in the whole plugin.
*/

#include <stdarg.h>
#include <stdlib.h>
#include <sys/ioctl.h>

#include "common.h"
#include "menusetup.h"



void d(const int level, const char *fmt, ...) {
  char t[BUFSIZ];
  va_list ap;
  time_t  now;
  if (WirbelscanSetup.verbosity >= level){
    va_start(ap, fmt);
    switch (WirbelscanSetup.logFile) {
      case STDOUT : time(&now);
                    vsnprintf(t + 9, sizeof t - 9, fmt, ap);
                    strftime(t, sizeof t, "%H:%M:%S", localtime(&now));
                    t[8] = ' ';
                    printf("\r%s\033[K\r\n", t);
                    fflush(stdout);
                    break;
      case SYSLOG : vsnprintf(t, sizeof t, fmt, ap);
                    syslog(LOG_DEBUG, "%s", t);
                    break;
      }
    va_end(ap);
    }
}


int IOCTL(int fd, int cmd, void * data) {
  int retry;
    
  for (retry=10;retry>=0;) {
    if (ioctl(fd, cmd, data) != 0) {
      /* :-( */
      if (retry){
        usleep(10000); /* 10msec */
        retry--;
        continue;
        }
      return -1;       /* :'-((  */
      }
    else
      return 0;        /* :-)    */
    }
  return 0;
}




