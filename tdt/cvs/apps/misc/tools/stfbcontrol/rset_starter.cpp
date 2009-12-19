#include "rset.h"
   /*
     *  Print the Usage Template and Exit
     */
char * ProgramName;

static void Usage(void)
{
    Die("\nUsage: %s [options] [mode]\n\n"
	"Valid options:\n"
	"  General options:\n"
	"    -h, --help         : display this usage information\n"
	"    -fb<device>        : processed frame buffer device\n"
	"    -vr                : only print wanted resolution\n",
	ProgramName);
}


int OpenFrameBuffer(bool Opt_verbose, char* framebuffer)
{
	int fh;
    if (Opt_verbose)
	cout << "Opening frame buffer device `" << framebuffer<<" '\n";

    if ((fh = open(framebuffer, O_RDONLY)) == -1)
	Die("open %s: %s\n", framebuffer, strerror(errno));
    return fh;
}


    /*
     *  Close the Frame Buffer Device
     */

void CloseFrameBuffer(int fh)
{
    close(fh);
}


int main (int argc, char *argv[])
{
	struct fb_var_screeninfo var;
	struct fb_fix_screeninfo fix;
	bool fb1 = false;
	bool vr = false;
	int fh;
	ProgramName = argv[0];

	while (--argc > 0) 
	{
		argv++;
		if (!strcmp(argv[0], "-h") || !strcmp(argv[0], "--help"))
	    		Usage();
		else if (!strcmp(argv[0], "-fb1"))
	    		fb1 = true;
		else if (!strcmp(argv[0], "-vr"))
	    		vr = true;

	}

	fbset * rset;

	if(!fb1)
		fh=OpenFrameBuffer(true,"/dev/fb0");
	else
		fh=OpenFrameBuffer(true,"/dev/fb1");
	
	rset = new fbset(true,fh,"/etc/videomode");

	rset->GetVarScreenInfo(&var);
	rset->update_var_screeninfo(&var);

	if(!vr)
	{
		rset->SetVarScreenInfo(&var);
		rset->set_background();
	}

	
	
	CloseFrameBuffer(fh);



	return (0);
}
 
