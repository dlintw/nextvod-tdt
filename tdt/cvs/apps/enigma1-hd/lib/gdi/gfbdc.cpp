#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <memory.h>
#include <linux/kd.h>


#include <lib/gdi/gfbdc.h>

#include <lib/dvb/edvb.h>
#include <lib/system/init.h>
#include <lib/system/init_num.h>
#include <lib/system/econfig.h>
#include <linux/stmfb.h>

gFBDC *gFBDC::instance;
static struct stmfbio_var_screeninfo_ex varEx;
static struct stmfbio_output_configuration outputConfig;

gFBDC::gFBDC()
{
	init_gFBDC();
}
void gFBDC::init_gFBDC()
{
	instance=this;
	fb=new fbClass;
	if (!fb->Available())
		eFatal("no framebuffer available");
        setResolution(720,576);  
	reloadSettings();
}

gFBDC::~gFBDC()
{
	delete pixmap;
	delete fb;
	instance=0;
}

void gFBDC::calcRamp()
{
#if 0
	float fgamma=gamma ? gamma : 1;
	fgamma/=10.0;
	fgamma=1/log(fgamma);
	for (int i=0; i<256; i++)
	{
		float raw=i/255.0; // IIH, float.
		float corr=pow(raw, fgamma) * 256.0;

		int d=corr * (float)(256-brightness) / 256 + brightness;
		if (d < 0)
			d=0;
		if (d > 255)
			d=255;
		ramp[i]=d;
		
		rampalpha[i]=i*alpha/256;
	}
#endif
	for (int i=0; i<256; i++)
	{
		int d;
		d=i;
		d=(d-128)*(gamma+64)/(128+64)+128;
		d+=brightness-128; // brightness correction
		if (d<0)
			d=0;
		if (d>255)
			d=255;
		ramp[i]=d;

		rampalpha[i]=i*alpha/256;
	}

	rampalpha[255]=255; // transparent BLEIBT bitte so.
}

void gFBDC::setPalette()
{
	if (!pixmap->clut.data)
		return;
	
	for (int i=0; i<256; ++i)
	{
		fb->CMAP()->red[i]=ramp[pixmap->clut.data[i].r]<<8;
		fb->CMAP()->green[i]=ramp[pixmap->clut.data[i].g]<<8;
		fb->CMAP()->blue[i]=ramp[pixmap->clut.data[i].b]<<8;
		fb->CMAP()->transp[i]=rampalpha[pixmap->clut.data[i].a]<<8;
		if (!fb->CMAP()->red[i])
			fb->CMAP()->red[i]=0x100;
	}
	fb->PutCMAP();
}

void gFBDC::exec(gOpcode *o)
{
	switch (o->opcode)
	{
	case gOpcode::setPalette:
	{
		gPixmapDC::exec(o);
		setPalette();
		break;
	}
        case gOpcode::end:        	
        	fb->blit();
	default:
		gPixmapDC::exec(o);
		break;
	}
}

gFBDC *gFBDC::getInstance()
{
	return instance;
}

void gFBDC::setAlpha(int a)
{
	alpha=a;
	varEx.layerid  = 0;
	varEx.caps     = STMFBIO_VAR_CAPS_OPACITY;
	varEx.activate = STMFBIO_ACTIVATE_IMMEDIATE;
	varEx.opacity  = a;
        setConfigAG();
	calcRamp();
	setPalette();
}

void gFBDC::setBrightness(int b)
{
	brightness=b;

        unsigned long bc;
        if (b <=20) // black
            bc=0x0;
            
        if (b >20 && b<=40) //blue
            bc = 0x000000ff;      

        if (b >40 && b<=60) // red
            bc = 0xffff0000;      

        if (b >60 && b<=80) //green 
            bc = 0xff0ff000;      
        if ( b>80) // white
            bc = 0xffffffff;      

	brightness=b;
#if defined(PLAYER179) || defined(PLAYER191)
	config.outputid = STMFBIO_OUTPUTID_MAIN;
#elif defined(PLAYER131)
        outputConfig.outputid = 1;
#endif
	outputConfig.activate = STMFBIO_ACTIVATE_IMMEDIATE;
	outputConfig.caps = STMFBIO_OUTPUT_CAPS_MIXER_BACKGROUND;
	outputConfig.mixer_background = bc;
        setConfigMix();
	calcRamp();
	setPalette();
}

void gFBDC::setGamma(int g)
{
	gamma=g;
	varEx.layerid  = 0;
	varEx.caps     = STMFBIO_VAR_CAPS_GAIN;
	varEx.activate = STMFBIO_ACTIVATE_IMMEDIATE;
	varEx.gain = g;
        setConfigAG();
	calcRamp();
	setPalette();
}

void gFBDC::setConfigAG()
{
        int fd;  
	fd = open("/dev/fb0", O_RDWR);
	if (fd<0){
	    perror("fb not open");
	}

        if (ioctl(fd, STMFBIO_SET_VAR_SCREENINFO_EX, &varEx)<0)
	{
    	    perror("STMFBIO_VAR_CAPS_OPACITY");
	}
	close(fd); 
}

void gFBDC::setConfigMix()
{
	int fd;  
	fd = open("/dev/fb0", O_RDWR);
	if (fd<0){
	    perror("fb not open");
	}
        if (ioctl(fd, STMFBIO_SET_OUTPUT_CONFIG, &outputConfig)<0)
	{
    	    perror("STMFBIO_SET_OUTPUT_CONFIG");
	}
	close(fd); 
}

void gFBDC::saveSettings()
{
	eConfig::getInstance()->setKey("/ezap/osd/alpha", alpha);
	eConfig::getInstance()->setKey("/ezap/osd/gamma", gamma);
	eConfig::getInstance()->setKey("/ezap/osd/brightness", brightness);
}

void gFBDC::setResolution(int xres, int yres)
{
#ifndef __sh__
    fb->fbset();		
	fb->SetMode(720, 576, 32);
//	for (int y=0; y<576; y++)																		 // make whole screen transparent
//		memset(fb->lfb+y*720*4, 0x00, 720*4);
		
	pixmap=new gPixmap();
	pixmap->x=720;
	pixmap->y=576;
	pixmap->bpp=32;
	pixmap->bypp=4;
	pixmap->stride=720*4;
	pixmap->data=fb->lfb;

	pixmap->clut.colors=256;
	pixmap->clut.data=new gRGB[pixmap->clut.colors];
	memset(pixmap->clut.data, 0, sizeof(*pixmap->clut.data)*pixmap->clut.colors);
#else
	fb->SetMode(xres, yres, 32);

	pixmap         = new gPixmap();
	pixmap->x      = xres;
	pixmap->y      = yres;
	pixmap->bpp    = 32;
	pixmap->bypp   = 4;
	pixmap->stride = xres * 4;
	pixmap->data   = fb->lfb;

	pixmap->clut.colors = 256;
	pixmap->clut.data   = new gRGB[pixmap->clut.colors];
	memset(pixmap->clut.data, 0, sizeof(*pixmap->clut.data)*pixmap->clut.colors);
#endif
}

void gFBDC::reloadSettings()
{

	if (eConfig::getInstance()->getKey("/ezap/osd/alpha", alpha))
		alpha=255;
	if (eConfig::getInstance()->getKey("/ezap/osd/gamma", gamma))
		gamma=255;
	if (eConfig::getInstance()->getKey("/ezap/osd/brightness", brightness))
		brightness=0;
        setConfigAG();
        setConfigMix();        
	calcRamp();
	setPalette();
}

eAutoInitP0<gFBDC> init_gFBDC(eAutoInitNumbers::graphic-1, "GFBDC");
