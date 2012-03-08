#include <rset.h>
using namespace std;


static struct {
    int mode;
    char * name;
    const int xres;
    const int yres;
    const int vxres;
    const int vyres;
    const int bit;

    const int pixclock;
    const int left;
    const int right;
    const int upper;
    const int lower;
    const int hslen;
    const int vslen;

    const int sync;
    const int vmode;

} Options[] = {
    { 13, "1080p30", 1920, 1080, 1920, 1080, 16, 13468, 148,  88, 36, 4, 44, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_CONUPDATE},
    { 12, "1080p29", 1920, 1080, 1920, 1080, 16, 13481, 148,  88, 36, 4, 44, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_CONUPDATE},
    { 11, "1080p25", 1920, 1080, 1920, 1080, 16, 13468, 148, 528, 36, 4, 44, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_CONUPDATE},
    { 10, "1080p24", 1920, 1080, 1920, 1080, 16, 13468, 148, 638, 36, 4, 44, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_CONUPDATE},
    {  9, "1080p23", 1920, 1080, 1920, 1080, 16, 13481, 148, 638, 36, 4, 44, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_CONUPDATE},

    { 8, "1080i60", 1920, 1080, 1920, 1080, 16, 13468, 148,  88, 35, 5, 44, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_INTERLACED | FB_VMODE_CONUPDATE},
    { 7, "1080i59", 1920, 1080, 1920, 1080, 16, 13481, 148,  88, 35, 5, 44, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_INTERLACED | FB_VMODE_CONUPDATE},
    { 6, "1080i50", 1920, 1080, 1920, 1080, 16, 13468, 148, 528, 35, 5, 44, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_INTERLACED | FB_VMODE_CONUPDATE},

    { 5, "720p60", 1280, 720, 1280, 720, 16, 13468, 220, 110, 20, 5, 40, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_NONINTERLACED | FB_VMODE_CONUPDATE},
    { 4, "720p50", 1280, 720, 1280, 720, 16, 13468, 220, 440, 20, 5, 40, 5, 
FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT, FB_VMODE_NONINTERLACED | FB_VMODE_CONUPDATE},

    { 3, "576p50", 720, 576, 720, 576, 16, 37037, 68, 12, 34, 10, 64, 5, 0, 
FB_VMODE_NONINTERLACED | FB_VMODE_CONUPDATE},

    { 2, "576i50", 720, 576, 720, 576, 16, 74074, 68, 12, 38, 5, 64, 6, 0, 
FB_VMODE_INTERLACED | FB_VMODE_CONUPDATE},
    { 1, "pal", 720, 576, 720, 576, 16, 74074, 68, 12, 38, 5, 64, 6, 0, 
FB_VMODE_INTERLACED | FB_VMODE_CONUPDATE},
    { 0, NULL,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
};


/*
mode "720x576-50i" 
    # D: 13.500 MHz, H: 15.625 kHz, V: 50.000 Hz
    geometry 720 576 720 576 16
    timings 74074 68 12 38 5 64 6
    laced true
endmode

mode "720x576-50"
    # D: 27.000 MHz, H: 31.250 kHz, V: 50.000 Hz
    geometry 720 576 720 576 16
    timings 37037 68 12 34 10 64 5
endmode

mode "1280x720-50"
    # D: 74.250 MHz, H: 37.500 kHz, V: 50.000 Hz
    geometry 1280 720 1280 720 16
    timings 13468 220 440 20 5 40 5
    hsync high
    vsync high
endmode

mode "1280x720-60"
    # D: 74.250 MHz, H: 45.000 kHz, V: 60.000 Hz
    geometry 1280 720 1280 720 16
    timings 13468 220 110 20 5 40 5
    hsync high
    vsync high
endmode

mode "1920x1080-50i"
    # D: 74.250 MHz, H: 28.125 kHz, V: 50.000 Hz
    geometry 1920 1080 1920 1080 16
    timings 13468 148 528 35 5 44 5
    hsync high
    vsync high
    laced true
endmode

mode "1920x1080-60i"
    # D: 74.250 MHz, H: 33.750 kHz, V: 60.000 Hz
    geometry 1920 1080 1920 1080 16
    timings 13468 148 88 35 5 44 5
    laced true
    hsync high
    vsync high
endmode
*/



    /*
     *  Print an Error Message and Exit
     */
void Die(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    exit(1);
}

fbset::fbset(bool Opt_verbose = true,int file=0, char *db = "/etc/videomode")
{
	//framebuffer = strdup(fb);
	fh=file;
	database = strdup(db);
	this->Opt_verbose = Opt_verbose;
}

    /*
     *  Get the Variable Part of the Screen Info
     */

void fbset::GetVarScreenInfo(struct fb_var_screeninfo *var)
{
    if (ioctl(fh, FBIOGET_VSCREENINFO, var))
	Die("ioctl FBIOGET_VSCREENINFO: %s\n", strerror(errno));
}

    /*
     *  Set (and Get) the Variable Part of the Screen Info
     */

void fbset::SetVarScreenInfo(struct fb_var_screeninfo *var)
{
printf( "DEBUG1:\n"
	"%d %d %d %d %d %d %d\n"
	"%d %d\n",
	var->pixclock,var->left_margin,var->right_margin,var->upper_margin,var->lower_margin,
	var->hsync_len,var->vsync_len,
	var->sync,var->vmode);
	


if (ioctl(fh, FBIOPUT_VSCREENINFO, var))
	Die("ioctl FBIOPUT_VSCREENINFO: %s\n", strerror(errno));

printf( "DEBUG2:\n"
	"%d %d %d %d %d %d %d\n"
	"%d %d\n",
	var->pixclock,var->left_margin,var->right_margin,var->upper_margin,var->lower_margin,
	var->hsync_len,var->vsync_len,
	var->sync,var->vmode);

}

    /*
     *  Get the Fixed Part of the Screen Info
     */

void fbset::GetFixScreenInfo(struct fb_fix_screeninfo *fix)
{
    if (ioctl(fh, FBIOGET_FSCREENINFO, fix))
	Die("ioctl FBIOGET_FSCREENINFO: %s\n", strerror(errno));
}

int fbset::check_mode()
{
	int vLoop = 0;
	fd.open(database);
	//char * mode;
	char mode[32];
	fd >> mode;
	for (int handler = 99; handler != 1 ; vLoop++)
	{
		handler = Options[vLoop].mode;
		if (!strcmp(Options[vLoop].name, mode))
			break;
		/* without this the vLoop++ command is executed at the end
		 * of the loop and you get an error when no mode is defined in
		 * /etc/videomode */
 		if(handler==1)break;
	}
	cout << "MODE: " << Options[vLoop].name << endl;
	return vLoop;
}

void fbset::update_var_screeninfo(struct fb_var_screeninfo *var)
{
	int val = check_mode();
	var->xres = Options[val].xres;			/* visible resolution		*/
	var->yres = Options[val].yres;
	var->xres_virtual = Options[val].vxres;		/* virtual resolution		*/
	var->yres_virtual = Options[val].vyres;
	
	var->pixclock = Options[val].pixclock;	
	var->left_margin = Options[val].left;
	var->right_margin = Options[val].right;
	var->upper_margin = Options[val].upper;
	var->lower_margin = Options[val].lower;
	var->hsync_len = Options[val].hslen;
	var->vsync_len = Options[val].vslen;
	var->sync = Options[val].sync;
	var->vmode = Options[val].vmode;

	return;
}


void fbset::set_background()
{
	struct stmfbio_output_configuration config;
#if defined(PLAYER131)
	config.outputid = 1;
#else
	config.outputid = STMFBIO_OUTPUTID_MAIN;
#endif
	if (ioctl(fh,STMFBIO_GET_OUTPUT_CONFIG,&config))
		Die("ioctl STMFBIO_GET_OUTPUT_CONFIG: %s\n", strerror(errno));
	printf("config.outputid=%d\n",config.outputid);
	
	config.caps = STMFBIO_OUTPUT_CAPS_MIXER_BACKGROUND;
	config.activate = STMFBIO_ACTIVATE_IMMEDIATE;
	config.mixer_background = 0xFF000000; // put your colour in here

	if (ioctl(fh,STMFBIO_SET_OUTPUT_CONFIG,&config))
		Die("ioctl STMFBIO_SET_OUTPUT_CONFIG: %s\n", strerror(errno));
}

