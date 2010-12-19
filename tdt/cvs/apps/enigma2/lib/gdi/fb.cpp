#if defined(__sh__) 
	#include <png.h>
#endif 
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <memory.h>
#include <linux/kd.h>

#include <lib/gdi/fb.h>

#if defined(__sh__) 
#include <linux/stmfb.h> 
#endif 

#ifndef FBIO_WAITFORVSYNC
#define FBIO_WAITFORVSYNC _IOW('F', 0x20, __u32)
#endif

#ifndef FBIO_BLIT
#define FBIO_SET_MANUAL_BLIT _IOW('F', 0x21, __u8)
#define FBIO_BLIT 0x22
#endif

fbClass *fbClass::instance;

fbClass *fbClass::getInstance()
{
	return instance;
}

fbClass::fbClass(const char *fb)
{
	m_manual_blit=-1;
	instance=this;
	locked=0;
	available=0;
	cmap.start=0;
	cmap.len=256;
	cmap.red=red;
	cmap.green=green;
	cmap.blue=blue;
	cmap.transp=trans;

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
	lfb += 1920*1080*4;     
#endif 

	showConsole(0);

	enableManualBlit();
	return;
nolfb:
	lfb=0;
	printf("framebuffer not available.\n");
	return;
}

int fbClass::showConsole(int state)
{
#if defined(__sh__) 
	int fd=open("/dev/ttyAS1", O_RDWR); 
#else 
	int fd=open("/dev/vc/0", O_RDWR);
	if(fd>=0)
	{
		if(ioctl(fd, KDSETMODE, state?KD_TEXT:KD_GRAPHICS)<0)
		{
			eDebug("setting /dev/vc/0 status failed.");
		}
		close(fd);
	}
#endif
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
	
	m_number_of_pages = screeninfo.yres_virtual / nyRes;
	
	ioctl(fd, FBIOGET_VSCREENINFO, &screeninfo);
	
	if ((screeninfo.xres!=nxRes) && (screeninfo.yres!=nyRes) && (screeninfo.bits_per_pixel!=nbpp))
	{
		eDebug("SetMode failed: wanted: %dx%dx%d, got %dx%dx%d",
			nxRes, nyRes, nbpp,
			screeninfo.xres, screeninfo.yres, screeninfo.bits_per_pixel);
	}
#if defined(__sh__) 
	/* safe the dimensions of framebuffer (HD or SD Skin) */ 
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

int fbClass::setOffset(int off)
{
	screeninfo.xoffset = 0;
	screeninfo.yoffset = off;
	return ioctl(fd, FBIOPAN_DISPLAY, &screeninfo);
}

int fbClass::waitVSync()
{
	int c = 0;
	return ioctl(fd, FBIO_WAITFORVSYNC, &c);
}

#if defined(__sh__) 
int fbClass::directBlit(STMFBIO_BLT_DATA &bltData)
{
	return ioctl(fd, STMFBIO_BLT, &bltData);
}
#endif

void fbClass::blit()
{
#if defined(__sh__) 
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
	bltData.dst_top    = 0; 
	bltData.dst_left   = 0; 
	bltData.dst_right  = xRes; 
	bltData.dst_bottom = yRes; 
	bltData.srcFormat = SURF_BGRA8888;
	bltData.dstFormat = SURF_BGRA8888;
	bltData.srcMemBase = STMFBGP_FRAMEBUFFER; 
	bltData.dstMemBase = STMFBGP_FRAMEBUFFER; 
	
	if (ioctl(fd, STMFBIO_BLT, &bltData ) < 0) 
	{ 
		perror("FBIO_BLIT"); 
	} 
#else 
	if (m_manual_blit == 1) {
		if (ioctl(fd, FBIO_BLIT) < 0)
			perror("FBIO_BLIT");
	}
#endif
}

fbClass::~fbClass()
{
	if (available)
		ioctl(fd, FBIOPUT_VSCREENINFO, &oldscreen);
	if (lfb)
		munmap(lfb, available);
	showConsole(1);
	disableManualBlit();
}

int fbClass::PutCMAP()
{
	return ioctl(fd, FBIOPUTCMAP, &cmap);
}

int fbClass::lock()
{
	if (locked)
		return -1;
	if (m_manual_blit == 1)
	{
		locked = 2;
		disableManualBlit();
	}
	else
		locked = 1;
	return fd;
}

void fbClass::unlock()
{
	if (!locked)
		return;
	if (locked == 2)  // re-enable manualBlit
		enableManualBlit();
	locked=0;
	SetMode(xRes, yRes, bpp);
	PutCMAP();
}

void fbClass::enableManualBlit()
{
#if not defined(__sh__) 
	unsigned char tmp = 1;
	if (ioctl(fd,FBIO_SET_MANUAL_BLIT, &tmp)<0)
		perror("FBIO_SET_MANUAL_BLIT");
	else
		m_manual_blit = 1;
#endif
}

void fbClass::disableManualBlit()
{
#if not defined(__sh__) 
	unsigned char tmp = 0;
	if (ioctl(fd,FBIO_SET_MANUAL_BLIT, &tmp)<0) 
		perror("FBIO_SET_MANUAL_BLIT");
	else
		m_manual_blit = 0;
#endif
}

