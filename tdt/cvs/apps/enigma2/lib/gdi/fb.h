#ifndef __FB_H
#define __FB_H

#include <lib/base/eerror.h>
#include <linux/fb.h>

#if defined(__sh__) 
#include <linux/stmfb.h> 
#endif

class fbClass
{
	int fd;
	unsigned int xRes, yRes, stride, bpp;
#if defined(__sh__) 
	unsigned int xResFB, yResFB; 
#endif 
	int available;
	struct fb_var_screeninfo screeninfo, oldscreen;
	fb_cmap cmap;
	__u16 red[256], green[256], blue[256], trans[256];
	static fbClass *instance;
	int locked;

	int m_manual_blit;
	int m_number_of_pages;
#ifdef SWIG
#if defined(__sh__) 
	fbClass(const char *fb="/dev/fb0"); 
#else 
	fbClass(const char *fb="/dev/fb/0");
#endif
	~fbClass();
public:
#else
public:
	unsigned char *lfb;
	void enableManualBlit();
	void disableManualBlit();
	int showConsole(int state);
	int SetMode(unsigned int xRes, unsigned int yRes, unsigned int bpp);
	int Available() { return available; }
	
	int getNumPages() { return m_number_of_pages; }
	
	int setOffset(int off);
	int waitVSync();
	void blit();
	unsigned int Stride() { return stride; }
	fb_cmap *CMAP() { return &cmap; }

#if defined(__sh__) 
	fbClass(const char *fb="/dev/fb0"); 
#else 
	fbClass(const char *fb="/dev/fb/0");
#endif
	~fbClass();
	
			// low level gfx stuff
	int PutCMAP();
#endif
	static fbClass *getInstance();
	
#if defined(__sh__)  
	int directBlit(STMFBIO_BLT_DATA &bltData);
#endif  


	int lock();
	void unlock();
	int islocked() { return locked; }
};

#endif
