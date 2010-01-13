/*
 * dvbsdffosd.c: Implementation of the DVB SD Full Featured On Screen Display
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id: dvbsdffosd.c 2.1 2009/12/29 11:52:48 kls Exp $
 */

#include "dvbsdffosd.h"
#include <linux/dvb/osd.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <sys/unistd.h>
#include "vdr/tools.h"

#ifdef __sh__
/* Dagobert */
#include <sys/mman.h> 
#include <linux/fb.h>

typedef struct
{
	int x;
	int y;
	int width;
	int height;
	int depth;
	
	int numberColors;
	tColor* colors;
	
	bool isOpened;
} tWindows;
#endif
// --- cDvbSdFfOsd -----------------------------------------------------------

#define MAXNUMWINDOWS 7 // OSD windows are counted 1...7
#define MAXOSDMEMORY  92000 // number of bytes available to the OSD (for unmodified DVB cards)

class cDvbSdFfOsd : public cOsd {
private:
#ifdef __sh__
/* Dagobert */
  unsigned char* theMem;	
  struct 	fb_var_screeninfo vinfo; 
  int			screensize;
  int			screenWidth;
  int			screenHeight;
  bool		isFrameBuffer;
  tWindows  windows[MAXNUMWINDOWS];
  int			currentWindow;
  int			bytes_per_line;
#endif

  int osdDev;
  int osdMem;
  bool shown;
  void Cmd(OSD_Command cmd, int color = 0, int x0 = 0, int y0 = 0, int x1 = 0, int y1 = 0, const void *data = NULL);
protected:
  virtual void SetActive(bool On);
public:
  cDvbSdFfOsd(int Left, int Top, int OsdDev, uint Level);
  virtual ~cDvbSdFfOsd();
  virtual eOsdError CanHandleAreas(const tArea *Areas, int NumAreas);
  virtual eOsdError SetAreas(const tArea *Areas, int NumAreas);
  virtual void Flush(void);

#ifdef __sh__
  void fb_Clear(int x, int y, int width, int height);
  void fb_DrawBlock(const void* data, int depth, int x, int y, int width, int height, int width_bmp);
  void fb_DrawRectangle(int x, int y, int width, int height, unsigned char r, unsigned char g, unsigned char b);
  void getRGB(int index, unsigned char* a, unsigned char* r, unsigned char* g, unsigned char* b);
#endif
  };

cDvbSdFfOsd::cDvbSdFfOsd(int Left, int Top, int OsdDev, uint Level)
:cOsd(Left, Top, Level)
{
  osdDev = OsdDev;
  shown = false;
  if (osdDev < 0)
#ifdef __sh__
  {
#endif
     esyslog("ERROR: invalid OSD device handle (%d)!", osdDev);
#ifdef __sh__
/* Dagobert */
  	  osdDev = open("/dev/fb0", O_RDWR);
     esyslog("-> fb0 handle (%d)", osdDev);
	  
     if (ioctl(osdDev, FBIOGET_VSCREENINFO, &vinfo)) 
     {
         esyslog("Error reading variable information.\n");
         exit(1);
     }

     screensize = vinfo.xres * vinfo.yres * vinfo.bits_per_pixel / 8;
	  screenWidth = vinfo.xres;
	  screenHeight = vinfo.yres;
	  bytes_per_line = (vinfo.bits_per_pixel / 8) * screenWidth;

     esyslog("%d %d %d %d\n", screensize, screenWidth, screenHeight, bytes_per_line);

     theMem = (unsigned char *)mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, osdDev, 0);
  	  isFrameBuffer = true;

	  osdMem = screensize;

	  for (int vLoop = 0; vLoop < MAXNUMWINDOWS; vLoop++)
	  	windows[vLoop].isOpened = false;
  }
#endif
  else {
#ifdef __sh__
     /* Dagobert */
     isFrameBuffer = false;
#endif
     osdMem = MAXOSDMEMORY;
#ifdef OSD_CAP_MEMSIZE
     // modified DVB cards may have more OSD memory:
     osd_cap_t cap;
     cap.cmd = OSD_CAP_MEMSIZE;
     if (ioctl(osdDev, OSD_GET_CAPABILITY, &cap) == 0)
        osdMem = cap.val;
#endif
     }
}

cDvbSdFfOsd::~cDvbSdFfOsd()
{
  SetActive(false);
}

void cDvbSdFfOsd::SetActive(bool On)
{
  if (On != Active()) {
     cOsd::SetActive(On);
     if (On) {
        // must clear all windows here to avoid flashing effects - doesn't work if done
        // in Flush() only for the windows that are actually used...
        for (int i = 0; i < MAXNUMWINDOWS; i++) {
            Cmd(OSD_SetWindow, 0, i + 1);
            Cmd(OSD_Clear);
            }
        if (GetBitmap(0)) // only flush here if there are already bitmaps
           Flush();
        }
     else if (shown) {
        cBitmap *Bitmap;
        for (int i = 0; (Bitmap = GetBitmap(i)) != NULL; i++) {
            Cmd(OSD_SetWindow, 0, i + 1);
            Cmd(OSD_Close);
            }
        shown = false;
        }
     }
}

eOsdError cDvbSdFfOsd::CanHandleAreas(const tArea *Areas, int NumAreas)
{
  eOsdError Result = cOsd::CanHandleAreas(Areas, NumAreas);
  if (Result == oeOk) {
     if (NumAreas > MAXNUMWINDOWS)
        return oeTooManyAreas;
     int TotalMemory = 0;
     for (int i = 0; i < NumAreas; i++) {
         if (Areas[i].bpp != 1 && Areas[i].bpp != 2 && Areas[i].bpp != 4 && Areas[i].bpp != 8)
            return oeBppNotSupported;
         if ((Areas[i].Width() & (8 / Areas[i].bpp - 1)) != 0)
            return oeWrongAlignment;
#ifdef __sh__
         if (Areas[i].Width() < 1 || Areas[i].Height() < 1 || Areas[i].Width() > 1920 || Areas[i].Height() > 1080)
#else
         if (Areas[i].Width() < 1 || Areas[i].Height() < 1 || Areas[i].Width() > 720 || Areas[i].Height() > 576)
#endif
            return oeWrongAreaSize;
         TotalMemory += Areas[i].Width() * Areas[i].Height() / (8 / Areas[i].bpp);
         }
     if (TotalMemory > osdMem)
        return oeOutOfMemory;
     }
  return Result;
}

eOsdError cDvbSdFfOsd::SetAreas(const tArea *Areas, int NumAreas)
{
  if (shown) {
     cBitmap *Bitmap;
     for (int i = 0; (Bitmap = GetBitmap(i)) != NULL; i++) {
         Cmd(OSD_SetWindow, 0, i + 1);
         Cmd(OSD_Close);
         }
     shown = false;
     }
  return cOsd::SetAreas(Areas, NumAreas);
}

#ifdef __sh__
void cDvbOsd::getRGB(int index, unsigned char* a, unsigned char* r, unsigned char* g, unsigned char* b)
{
  // esyslog("0x%x", windows[currentWindow].colors[index]);

	*a = (windows[currentWindow].colors[index] & 0xFF000000) >> 24; 
	*b = (windows[currentWindow].colors[index] & 0xFF0000) >> 16; 
	*g = (windows[currentWindow].colors[index] & 0xFF00) >> 8; 
	*r = (windows[currentWindow].colors[index] & 0xFF); 

   // esyslog("0x%x 0x%x 0x%x 0x%x", *a, *r, *g, *b);

}

void cDvbOsd::fb_Clear(int x, int y, int width, int height)
{
	int 	vLoopX, vLoopY;

	esyslog("fb_Clear: x %d, y %d, width %d, height %d\n", x, y, width, height);

	for (vLoopY = y; vLoopY < height + y; vLoopY++) {
			for (vLoopX = x; vLoopX < width + x; vLoopX++) {
				
				   *(theMem + ((vLoopY) * bytes_per_line) + ((vLoopX) * 4) + 0) = 0;
				   *(theMem + ((vLoopY) * bytes_per_line) + ((vLoopX) * 4) + 1) = 0;
				   *(theMem + ((vLoopY) * bytes_per_line) + ((vLoopX) * 4) + 2) = 0;
				   *(theMem + ((vLoopY) * bytes_per_line) + ((vLoopX) * 4) + 3) = 0;
			}
	 }

}

void cDvbOsd::fb_DrawBlock(const void* data, int depth, int x, int y, int width, int height, int width_bmp)
{
	int 	vLoopX, vLoopY;

	esyslog("fb_DrawBlock: depth %d, x %d, y %d, width %d, height %d\n", depth, x, y, width, height);

	for (vLoopY = 0; vLoopY < height; vLoopY++) {
			unsigned char* quelle = (unsigned char*) data + vLoopY * width_bmp;

			for (vLoopX = 0; vLoopX < width; vLoopX++) {
				
					unsigned char index = (unsigned char) (*quelle & 0xff);
					unsigned char r,g,b,a;
					
					getRGB(index, &a, &r, &g, &b);
					
				   *(theMem + ((y + vLoopY) * bytes_per_line) + ((x + vLoopX) * 4) + 0) = b; //b
				   *(theMem + ((y + vLoopY) * bytes_per_line) + ((x + vLoopX) * 4) + 1) = g; //g
				   *(theMem + ((y + vLoopY) * bytes_per_line) + ((x + vLoopX) * 4) + 2) = r; //r
				   *(theMem + ((y + vLoopY) * bytes_per_line) + ((x + vLoopX) * 4) + 3) = a;
				   quelle++;
			}
	 }

}

void cDvbOsd::fb_DrawRectangle(int x, int y, int width, int height, unsigned char r, unsigned char g, unsigned char b)
{
	int 	vLoopX, vLoopY;

	for (vLoopY = 0; vLoopY < height; vLoopY++) {
			for (vLoopX = 0; vLoopX < width; vLoopX++) {
				
				   *(theMem + ((y + vLoopY) * bytes_per_line) + ((x + vLoopX) * 4) + 0) = 128;
				   *(theMem + ((y + vLoopY) * bytes_per_line) + ((x + vLoopX) * 4) + 1) = r;
				   *(theMem + ((y + vLoopY) * bytes_per_line) + ((x + vLoopX) * 4) + 2) = g;
				   *(theMem + ((y + vLoopY) * bytes_per_line) + ((x + vLoopX) * 4) + 3) = b;
			}
	 }

}
#endif
void cDvbSdFfOsd::Cmd(OSD_Command cmd, int color, int x0, int y0, int x1, int y1, const void *data)
{
#ifdef __sh__
  if ((osdDev >= 0) && (!isFrameBuffer)) {
#else
  if (osdDev >= 0) {
#endif
     osd_cmd_t dc;
     dc.cmd   = cmd;
     dc.color = color;
     dc.x0    = x0;
     dc.y0    = y0;
     dc.x1    = x1;
     dc.y1    = y1;
     dc.data  = (void *)data;
     ioctl(osdDev, OSD_SEND_CMD, &dc);
     }
#ifdef __sh__
	else
	{
		/* Dagobert */
		switch (cmd)
		{
			case OSD_Close:
     			esyslog("OSD_Close\n");
				
				windows[currentWindow].isOpened = false;
				fb_Clear( windows[currentWindow].x, windows[currentWindow].y, windows[currentWindow].width, windows[currentWindow].height);
					
			break;
			case OSD_Open:
     			esyslog("OSD_Open %d, %d, %d, %d, %d\n", x0, y0, x1, y1, color);

				windows[currentWindow].isOpened = true;
				windows[currentWindow].x = x0;
				windows[currentWindow].y = y0;
				windows[currentWindow].width = x1 - x0;
				windows[currentWindow].height = y1 - y0;
				windows[currentWindow].depth = color;
				windows[currentWindow].numberColors = 0;
				windows[currentWindow].colors = NULL;

			break;
			case OSD_Show:
				//unused, not supported
			break;
			case OSD_Hide:
				//unused, not supported
			break;
			case OSD_Clear:
     			//esyslog("OSD_Clear\n");
				if (windows[currentWindow].isOpened)
					fb_Clear( windows[currentWindow].x, windows[currentWindow].y, windows[currentWindow].width, windows[currentWindow].height);
			break;
			case OSD_Fill:
				//unused, not supported
			break;
			case OSD_SetColor:
				//unused, not supported
			break;
			case OSD_SetPalette:
				windows[currentWindow].numberColors = x0;
				
				if (windows[currentWindow].colors != NULL)
					free(windows[currentWindow].colors);
				
				windows[currentWindow].colors = (tColor*) malloc(sizeof(tColor) * x0);
				memcpy(windows[currentWindow].colors, data, sizeof(tColor) * x0);

			break;
			case OSD_SetPixel:
				//unused, not supported
			break;
			case OSD_SetRow:
				//unused, not supported
			break;
			case OSD_SetBlock:
     			//esyslog("OSD_SetBlock %d\n", color);
				fb_DrawBlock(data, windows[currentWindow].depth, x0, y0, x1 - x0, y1 - y0, color);
			break;
			case OSD_FillRow:
				//unused, not supported
			break;
			case OSD_FillBlock:
				//unused, not supported
			break;
			case OSD_Line:
				//unused, not supported
			break;
			case OSD_Text:
				//unused, not supported
			break;
			case OSD_SetWindow:
     			//esyslog("OSD_SetWindow %d\n", x0);

				currentWindow = x0 - 1;
			break;
			case OSD_MoveWindow:
     			//esyslog("OSD_MoveWindow %d %d\n", x0, y0);
			break;
			case OSD_OpenRaw:
				//unused, not supported
			break;
			default:
     			esyslog("switch on unknown cmd (%d)\n", cmd);
			break;
		}
	}
#endif
}

void cDvbSdFfOsd::Flush(void)
{
  if (!Active())
     return;
  cBitmap *Bitmap;
  for (int i = 0; (Bitmap = GetBitmap(i)) != NULL; i++) {
      Cmd(OSD_SetWindow, 0, i + 1);
      if (!shown)
         Cmd(OSD_Open, Bitmap->Bpp(), Left() + Bitmap->X0(), Top() + Bitmap->Y0(), Left() + Bitmap->X0() + Bitmap->Width() - 1, Top() + Bitmap->Y0() + Bitmap->Height() - 1, (void *)1); // initially hidden!
      int x1 = 0, y1 = 0, x2 = 0, y2 = 0;
      if (!shown || Bitmap->Dirty(x1, y1, x2, y2)) {
         if (!shown) {
            x1 = y1 = 0;
            x2 = Bitmap->Width() - 1;
            y2 = Bitmap->Height() - 1;
            }
         //TODO Workaround: apparently the bitmap sent to the driver always has to be a multiple
         //TODO of 8 bits wide, and (dx * dy) also has to be a multiple of 8.
         //TODO Fix driver (should be able to handle any size bitmaps!)
         while ((x1 > 0 || x2 < Bitmap->Width() - 1) && ((x2 - x1) & 7) != 7) {
               if (x2 < Bitmap->Width() - 1)
                  x2++;
               else if (x1 > 0)
                  x1--;
               }
         //TODO "... / 2" <==> Bpp???
         while ((y1 > 0 || y2 < Bitmap->Height() - 1) && (((x2 - x1 + 1) * (y2 - y1 + 1) / 2) & 7) != 0) {
               if (y2 < Bitmap->Height() - 1)
                  y2++;
               else if (y1 > 0)
                  y1--;
               }
         while ((x1 > 0 || x2 < Bitmap->Width() - 1) && (((x2 - x1 + 1) * (y2 - y1 + 1) / 2) & 7) != 0) {
               if (x2 < Bitmap->Width() - 1)
                  x2++;
               else if (x1 > 0)
                  x1--;
               }
         // commit colors:
         int NumColors;
         const tColor *Colors = Bitmap->Colors(NumColors);
         if (Colors) {
            //TODO this should be fixed in the driver!
            tColor colors[NumColors];
            for (int i = 0; i < NumColors; i++) {
                // convert AARRGGBB to AABBGGRR (the driver expects the colors the wrong way):
                colors[i] = (Colors[i] & 0xFF000000) | ((Colors[i] & 0x0000FF) << 16) | (Colors[i] & 0x00FF00) | ((Colors[i] & 0xFF0000) >> 16);
                }
            Colors = colors;
            //TODO end of stuff that should be fixed in the driver
            Cmd(OSD_SetPalette, 0, NumColors - 1, 0, 0, 0, Colors);
            }
         // commit modified data:
#ifdef __sh__
         Cmd(OSD_SetBlock, Bitmap->Width(), Left() + x1, Top() + y1, Left() + x2, Top() + y2, Bitmap->Data(x1, y1));
#else
         Cmd(OSD_SetBlock, Bitmap->Width(), x1, y1, x2, y2, Bitmap->Data(x1, y1));
#endif
         }
      Bitmap->Clean();
      }
  if (!shown) {
     // Showing the windows in a separate loop to avoid seeing them come up one after another
     for (int i = 0; (Bitmap = GetBitmap(i)) != NULL; i++) {
#ifdef __sh__
/* Dagobert: we set it directly otherwise we must
 * hold the data in an extra buffer ...
 */
#else
         Cmd(OSD_SetWindow, 0, i + 1);
         Cmd(OSD_MoveWindow, 0, Left() + Bitmap->X0(), Top() + Bitmap->Y0());
#endif
         }
     shown = true;
     }
}

// --- cDvbOsdProvider -------------------------------------------------------

cDvbOsdProvider::cDvbOsdProvider(int OsdDev)
{
  osdDev = OsdDev;
}

cOsd *cDvbOsdProvider::CreateOsd(int Left, int Top, uint Level)
{
  return new cDvbSdFfOsd(Left, Top, osdDev, Level);
}
