#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <memory.h>
#include <linux/kd.h>

#include <lib/system/econfig.h>
#include <lib/gdi/fb.h>
#include <lib/gdi/grc.h>

#include <config.h>
#if HAVE_DVB_API_VERSION >= 3
#include <linux/fb.h>
#include <linux/stmfb.h>
#endif


fbClass *fbClass::instance;

fbClass *fbClass::getInstance()
{
	return instance;
}

fbClass::fbClass(const char *fb)
{
	init_fbClass(fb);
}
void fbClass::init_fbClass(const char *fb)
{
	instance=this;
	locked=0;
	available=0;
	cmap.start=0;
	cmap.len=256;
	cmap.red=red;
	cmap.green=green;
	cmap.blue=blue;
	cmap.transp=trans;

	int state=0;
	eConfig::getInstance()->getKey("/ezap/osd/showConsoleOnFB", state);

	fd=open(fb, O_RDWR);
	if (fd<0)
	{
		perror(fb);
		goto nolfb;
	}
	if (ioctl(fd, FBIOGET_VSCREENINFO, &screeninfo)<0)
	{
		perror("FBIOGET_VSCREENINFO");
		goto nolfb;
	}
	
	memcpy(&oldscreen, &screeninfo, sizeof(screeninfo));

	fb_fix_screeninfo fix;
	if (ioctl(fd, FBIOGET_FSCREENINFO, &fix)<0)
	{
		perror("FBIOGET_FSCREENINFO");
		goto nolfb;
	}

	available=fix.smem_len;
	eDebug("%dk video mem", available/1024);
	lfb=(unsigned char*)mmap(0, available, PROT_WRITE|PROT_READ, MAP_SHARED, fd, 0);
	if (!lfb)
	{
		perror("mmap");
		goto nolfb;
	}

#if defined(__sh__) 
	//we use 2MB at the end of the buffer, the rest does the blitter 
	lfb_direct = lfb;     
	lfb += 1920*1080*4;     
	topDiff = 0;
	leftDiff = 0;
	rightDiff = 0;
	bottomDiff = 0;
#endif 

	showConsole(state);
	return;
nolfb:
	lfb=0;
	printf("framebuffer not available.\n");
	return;
}

int fbClass::showConsole(int state)
{
	int fd=open("/dev/ttyAS0", O_RDWR);
	return 0;
}

int fbClass::SetMode(unsigned int nxRes, unsigned int nyRes, unsigned int nbpp)
{
	screeninfo.xres_virtual=screeninfo.xres=nxRes;
#if defined(__sh__) 
	screeninfo.yres_virtual=screeninfo.yres=nyRes; 
#else 
	screeninfo.yres_virtual=(screeninfo.yres=nyRes)*2;
#endif
	screeninfo.height=0;
	screeninfo.width=0;
	screeninfo.xoffset=screeninfo.yoffset=0;
	screeninfo.bits_per_pixel=nbpp;

	switch (nbpp) {
	case 16:
		// ARGB 1555
		screeninfo.transp.offset = 15;
		screeninfo.transp.length = 1;
		screeninfo.red.offset = 10;
		screeninfo.red.length = 5;
		screeninfo.green.offset = 5;
		screeninfo.green.length = 5;
		screeninfo.blue.offset = 0;
		screeninfo.blue.length = 5;
		break;
	case 32:
		// ARGB 8888
		screeninfo.transp.offset = 24;
		screeninfo.transp.length = 8;
		screeninfo.red.offset = 16;
		screeninfo.red.length = 8;
		screeninfo.green.offset = 8;
		screeninfo.green.length = 8;
		screeninfo.blue.offset = 0;
		screeninfo.blue.length = 8;
		break;
	}

#if not defined(__sh__) 
	if (ioctl(fd, FBIOPUT_VSCREENINFO, &screeninfo)<0)
	{
		// try single buffering
		screeninfo.yres_virtual=screeninfo.yres=nyRes;
		
		if (ioctl(fd, FBIOPUT_VSCREENINFO, &screeninfo)<0)
		{
			perror("FBIOPUT_VSCREENINFO");
			printf("fb failed\n");
			return -1;
		}
		eDebug(" - double buffering not available.");
	} else
		eDebug(" - double buffering available!");
#endif
	
	ioctl(fd, FBIOGET_VSCREENINFO, &screeninfo);
	
	if ((screeninfo.xres!=nxRes) && (screeninfo.yres!=nyRes) && (screeninfo.bits_per_pixel!=nbpp))
	{
		eDebug("SetMode failed: wanted: %dx%dx%d, got %dx%dx%d",
			nxRes, nyRes, nbpp,
			screeninfo.xres, screeninfo.yres, screeninfo.bits_per_pixel);
	}
#if defined(__sh__) 
	xResFB=nxRes; 
	yResFB=nyRes; 
#endif 
	xRes=screeninfo.xres;
	yRes=screeninfo.yres;
	bpp=screeninfo.bits_per_pixel;
	fb_fix_screeninfo fix;
	if (ioctl(fd, FBIOGET_FSCREENINFO, &fix)<0)
	{
		perror("FBIOGET_FSCREENINFO");
		printf("fb failed\n");
	}
	stride=fix.line_length;
#if not defined(__sh__) 
	memset(lfb, 0, stride*yRes);
#endif
	return 0;
}

void fbClass::blit()
{
	STMFBIO_BLT_DATA  bltData; 
	memset(&bltData, 0, sizeof(STMFBIO_BLT_DATA)); 
	bltData.operation  = BLT_OP_COPY; 
	bltData.srcOffset  = 1920*1080*4; 
	bltData.srcPitch   = xResFB * 4; 
	bltData.dstOffset  = 0; 
	bltData.dstPitch   = xRes*4; 
	bltData.src_top    = 0; 
    bltData.src_left   = 0; 
	bltData.src_right  = xResFB; 
    bltData.src_bottom = yResFB; 
	bltData.srcFormat  = SURF_BGRA8888; 
    bltData.dstFormat  = SURF_BGRA8888;
	bltData.srcMemBase = STMFBGP_FRAMEBUFFER; 
    bltData.dstMemBase = STMFBGP_FRAMEBUFFER; 
	bltData.dst_top    = 0 + topDiff; 
	bltData.dst_left   = 0 + leftDiff; 
	bltData.dst_right  = xRes + rightDiff; 
	bltData.dst_bottom = yRes + bottomDiff; 
	if (ioctl(fd, STMFBIO_BLT, &bltData ) < 0) 
	{ 
		perror("FBIO_BLIT"); 
	} 
}

fbClass::~fbClass()
{
	if (available)
		ioctl(fd, FBIOPUT_VSCREENINFO, &oldscreen);
	if (lfb)
		munmap(lfb, available);
}

int fbClass::PutCMAP()
{
	return ioctl(fd, FBIOPUTCMAP, &cmap);
}

void fbClass::Box(int x, int y, int width, int height, int color, int backcolor)
{
	if (width<=2 || locked)
		return;
	int offset=y*stride+x/2;
	int first=0xF0|((color&0xF0)>>4);
	int last= 0xF0|((backcolor&0xF0)>>4);
	color=(color&0xF)*0x11;
	int halfwidth=width/2;
	for (int ay=y; ay<(y+height); ay++)
	{
		lfb[offset]=first;
		memset(lfb+offset+1, color, halfwidth-2);
		lfb[offset+halfwidth-1]=last;
		offset+=stride;
	}
}

void fbClass::NBox(int x, int y, int width, int height, int color)
{
	if (locked)
		return;
	int offset=y*stride+x/2;
	int halfwidth=width/2;
	for (int ay=y; ay<(y+height); ay++)
	{
		memset(lfb+offset, color, halfwidth);
		offset+=stride;
	}
}

void fbClass::VLine(int x, int y, int sy, int color)
{
	if (locked)
		return;
	int offset=y*stride+x/2;
	while (sy--)
	{
		lfb[offset]=color;
		offset+=stride;
	}
}

int fbClass::lock()
{
	if (locked)
		return -1;
	while (gRC::getInstance().mustDraw())
		usleep(1000);
	locked=1;
	return fd;
}

void fbClass::unlock()
{
	if (!locked)
		return;
	locked=0;
	SetMode(xRes, yRes, bpp);
	PutCMAP();
}

int fbClass::fbset()
{
#ifndef __sh__
        screeninfo.bits_per_pixel = 32;
        int videomode = 0;
	FILE *f=fopen("/etc/videomode", "r");
	if (f){
	  fscanf(f, "%d", &videomode);
	  fclose(f);
	}
        switch (videomode )
        {
                case 0: //PAL
                       screeninfo.xres = screeninfo.xres_virtual = 720;
                       screeninfo.yres = screeninfo.yres_virtual = 576; 
                       screeninfo.pixclock = 74074;
                       screeninfo.left_margin = 69;
                       screeninfo.right_margin = 12;
                       screeninfo.upper_margin = 41;
                       screeninfo.lower_margin = 5;
                       screeninfo.hsync_len = 63;
                       screeninfo.vsync_len = 3;
                       screeninfo.vmode = 1;        
                break;
                case 1: //576p
	               screeninfo.xres = screeninfo.xres_virtual = 720;
            	       screeninfo.yres = screeninfo.yres_virtual = 576; 
            	       screeninfo.pixclock = 37037;
                       screeninfo.left_margin = 68;
                       screeninfo.right_margin = 12;
                       screeninfo.upper_margin = 39;
                       screeninfo.lower_margin = 5;
                       screeninfo.hsync_len = 64;
                       screeninfo.vsync_len = 5;
                       screeninfo.vmode = 0;                     	
                break;
                case 2: //720p50
                	screeninfo.xres = screeninfo.xres_virtual = 1280;
                    	screeninfo.yres = screeninfo.yres_virtual = 720; 
                        screeninfo.pixclock = 13468;
                        screeninfo.left_margin = 220;
                        screeninfo.right_margin = 440;                        
                        screeninfo.upper_margin = 20;
                        screeninfo.lower_margin = 5;
                        screeninfo.hsync_len = 40;
                        screeninfo.vsync_len = 5;
                        screeninfo.vmode = 0;                    	                        
                break;
                case 3: //720p60
                	screeninfo.xres = screeninfo.xres_virtual = 1280;
                    	screeninfo.yres = screeninfo.yres_virtual = 720; 
                        screeninfo.pixclock = 13468;
                        screeninfo.left_margin = 220;
                        screeninfo.upper_margin = 20;
                        screeninfo.right_margin = 110;                        
                        screeninfo.lower_margin = 5;
                        screeninfo.hsync_len = 40;
                        screeninfo.vsync_len = 5;
                        screeninfo.vmode = 0;                    	                        
                break;
                case 4: //1080i50
                	screeninfo.xres = screeninfo.xres_virtual = 1920;
                    	screeninfo.yres = screeninfo.yres_virtual = 1080; 
                        screeninfo.pixclock = 13468; 
                        screeninfo.left_margin = 148;                                           	
                        screeninfo.right_margin = 528;
                        screeninfo.upper_margin = 35;
                        screeninfo.lower_margin = 5;
                        screeninfo.hsync_len = 44;
                        screeninfo.vsync_len = 5;
                	screeninfo.vmode = 1;                        
                break;
                case 5: //1080i60
                	screeninfo.xres = screeninfo.xres_virtual = 1920;
                    	screeninfo.yres = screeninfo.yres_virtual = 1080; 
                        screeninfo.pixclock = 13468; 
                        screeninfo.left_margin = 148;                                           	
                        screeninfo.right_margin = 88;
                        screeninfo.upper_margin = 35;
                        screeninfo.lower_margin = 5;
                        screeninfo.hsync_len = 44;
                        screeninfo.vsync_len = 5;
	        	screeninfo.vmode = 1;                        
                break;
        }
     
/*     eDebug("[%s] geometry : %dx%dx%d \n timings : %dx%dx%dx%dx%dx%dx%dx%dx%d ",__FUNCTION__,
		screeninfo.xres, screeninfo.yres, screeninfo.bits_per_pixel, 
		screeninfo.pixclock, screeninfo.left_margin ,screeninfo.right_margin, screeninfo.upper_margin, screeninfo.lower_margin, 
		screeninfo.hsync_len, screeninfo.vsync_len, screeninfo.sync, screeninfo.vmode);
*/
        xResFB=screeninfo.xres;
        yResFB=screeninfo.yres;
          
        if (ioctl(fd, FBIOPUT_VSCREENINFO, &screeninfo)<0)
	{
		perror("FBIOPUT_VSCREENINFO");
		printf("fb failed\n");
		return -1;
	}

#endif
        return 0;
}

void fbClass::paletteSet(struct fb_cmap *map)
{
	if (locked)
		return;

	if (map == NULL)
		map = &cmap;

	ioctl(fd, FBIOPUTCMAP, map);
}

#if HAVE_DVB_API_VERSION >= 3
void fbClass::setTransparency(int tr)
{
/*	if (tr > 8)
		tr = 8;

	int val = (tr << 8) | tr;
	if (ioctl(fd, AVIA_GT_GV_SET_BLEV, val))
		perror("AVIA_GT_GV_SET_BLEV");
*/
}
#endif

#if defined(__sh__) 
void fbClass::clearFBblit()
{
	//set real frambuffer transparent
	memset(lfb_direct, 0x00, xRes * yRes * 4);
	blit();
}

int fbClass::getFBdiff(int ret)
{
	if(ret == 0)
		return topDiff;
	else if(ret == 1)
		return leftDiff;
	else if(ret == 2)
		return rightDiff;
	else if(ret == 3)
		return bottomDiff;
	else
		return -1;

}

void fbClass::setFBdiff(int top, int left, int right, int bottom)
{
	if(top < 0) top = 0;
	if(top > yRes) top = yRes;
	topDiff = top;
	if(left < 0) left = 0;
	if(left > xRes) left = xRes;
	leftDiff = left;
	if(right > 0) right = 0;
	if(-right > xRes) right = -xRes;
	rightDiff = right;
	if(bottom > 0) bottom = 0;
	if(-bottom > yRes) bottom = -yRes;
	bottomDiff = bottom;
}
#endif


