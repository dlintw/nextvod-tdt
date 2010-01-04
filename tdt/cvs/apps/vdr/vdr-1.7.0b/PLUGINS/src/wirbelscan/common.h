/*
 * common.h: wirbelscan - A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */

#ifndef __WIRBELSCAN_COMMON_H_
#define __WIRBELSCAN_COMMON_H_

#include <linux/types.h>
#include <sys/ioctl.h>

/* generic functions */
void  d(const int level, const char *fmt, ...);
int   IOCTL(int fd, int cmd, void * data);

#define freeAndNull(aPointer) if (aPointer != NULL) { free(aPointer);  aPointer=NULL; }
#define closeIfOpen(aFile)    if (aFile    >= 0)    { close(aFile);    aFile = -1;    }

#endif

