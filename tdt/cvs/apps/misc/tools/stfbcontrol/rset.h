#ifndef _RSET_H
#define _RSET_H

#include <stdarg.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <ctype.h>
#include <sys/stat.h>

#include <linux/fb.h>
#include <linux/stmfb.h>
#include <iostream>
#include <fstream>
using namespace std;
void Die(const char *fmt, ...);
class fbset
{
private:
	char * framebuffer;
	char * database;
	bool Opt_verbose;
	int fh;
	ifstream fd;
public:
	fbset(bool ,int, char *);
	void GetVarScreenInfo(struct fb_var_screeninfo *var);
	void SetVarScreenInfo(struct fb_var_screeninfo *var);
	void GetFixScreenInfo(struct fb_fix_screeninfo *fix);
	void update_var_screeninfo(struct fb_var_screeninfo *var);
	int  check_mode();
	void set_background ();
};


#endif /* _RSET_H */
