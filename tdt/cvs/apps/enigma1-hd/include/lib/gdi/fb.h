#ifndef __FB_H
#define __FB_H

#include <sys/types.h>
#include <config.h>
#include <linux/fb.h>
#include <lib/base/eerror.h>

class fbClass
{
	int fd;
	unsigned int xRes, yRes, stride, bpp;
#if defined(__sh__) 
	unsigned int xResFB, yResFB; 
	int topDiff, leftDiff, rightDiff, bottomDiff; 
	unsigned char *lfb_direct;
#endif
	int available;
	unsigned int videoformat;
	struct fb_var_screeninfo screeninfo, oldscreen;
	fb_cmap cmap;
	__u16 red[256], green[256], blue[256], trans[256];
	static fbClass *instance;
	int locked;
	void init_fbClass(const char *fb);
public:
	unsigned char *lfb;
	int showConsole(int state);
	int SetMode(unsigned int xRes, unsigned int yRes, unsigned int bpp);
	int Available() { return available; }
	void setAvailable(int val) { available=val; }
	unsigned int Stride() { return stride; }
	fb_cmap *CMAP() { return &cmap; }
	struct fb_var_screeninfo *getScreenInfo() { return &screeninfo; }
	void paletteSet(struct fb_cmap *map = NULL);
#if HAVE_DVB_API_VERSION >= 3
	void setTransparency( int tr = 0 );
#endif

#if defined(__sh__) 
	fbClass(const char *fb="/dev/fb0"); 
#else 
	fbClass(const char *fb="/dev/fb/0");
#endif
	~fbClass();
	
	static fbClass *getInstance();

				// low level gfx stuff
	int PutCMAP();

				// gfx stuff (colors are 8bit!)
	void Box(int x, int y, int width, int height, int color, int backcolor=0);
	void NBox(int x, int y, int width, int height, int color);
	void VLine(int x, int y, int sy, int color);
	
#if defined(__sh__)  
//---> "hack" for libeplayer3 fb access
        int getFD() { return fd; }
        unsigned char * getLFB_Direct() { return lfb_direct; }
        int getScreenResX() { return xRes; }
        int getScreenResY() { return yRes; }
//---<
#endif  

	int lock();
	void unlock();
	void blit();
	int fbset(); 
	int islocked() { return locked; }
#if defined(__sh__) 
	void clearFBblit();
	int getFBdiff(int ret);
	void setFBdiff(int top, int right, int left, int bottom);
#endif
};

#endif
