#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

#include "video_cs.h"
#include <linux/dvb/video.h>

static const char * FILENAME = "video_cs.cpp";

//EVIL

cVideo * videoDecoder = NULL;
unsigned int system_rev = 0x07;

typedef struct {
	int m_fd_video;
} tPrivate;

#ifndef VIDEO_FLUSH
#define VIDEO_FLUSH                     _IO('o',  82)
#endif

//EVIL END



int cVideo::SelectAutoFormat()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

void cVideo::ScalePic()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

/* constructor & destructor */
//1
cVideo::cVideo(int mode, void * hChannel, void * hBuffer)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
		/*CS_VIDEO_PDATA * privateData;
		VIDEO_FORMAT	    StreamType;
		VIDEO_DEFINITION       VideoDefinition;
		DISPLAY_AR DisplayAR;
		VIDEO_PLAY_MODE SyncMode;
		DISPLAY_AR_MODE                ARMode;
		VIDEO_DB_DR eDbDr;
		DISPLAY_AR PictureAR;
		VIDEO_FRAME_RATE FrameRate;
		bool interlaced;

		unsigned int uDRMDisplayDelay;
		unsigned int uVideoPTSDelay;
		int StcPts;
		bool started;
		unsigned int bStandby;
		bool blank;
		bool playing;
		bool auto_format;
		int uFormatIndex;
		int pic_width, pic_height;
		int jpeg_width, jpeg_height;
		int video_width, video_height;

		bool receivedDRMDelay;
		bool receivedVideoDelay;
		int cfd; // control driver fd
		analog_mode_t analog_mode;

		vfd_icon mode_icon;*/
	
	
	
	
	
}

cVideo::~cVideo(void) {
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void * cVideo::GetDRM(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return NULL;
}

//3
void * cVideo::GetTVEnc()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return NULL;
}

//4
void * cVideo::GetTVEncSD()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return NULL;
}

void * cVideo::GetHandle()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return NULL;
}

//5
void cVideo::SetAudioHandle(void * handle)
{
	printf("%s:%s - handle=0x%08x\n", FILENAME, __FUNCTION__, handle);
}

/* aspect ratio */
int cVideo::getAspectRatio(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }
void cVideo::getPictureInfo(int &width, int &height, int &rate) { printf("%s:%s\n", FILENAME, __FUNCTION__); }
int cVideo::setAspectRatio(int aspect, int mode) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }

/* cropping mode */
int cVideo::getCroppingMode(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }
int cVideo::setCroppingMode(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }

/* stream source */
int cVideo::getSource(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }
int cVideo::setSource(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }

/* blank on freeze */
int cVideo::getBlank(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }
int cVideo::setBlank(int enable) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }

/* get play state */
int cVideo::getPlayState(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }
void cVideo::HandleDRMMessage(int Event, void *pData) { printf("%s:%s\n", FILENAME, __FUNCTION__); }
void cVideo::HandleVideoMessage(void * hHandle, int Event, void *pData) { printf("%s:%s\n", FILENAME, __FUNCTION__); }

/* change video play state */
int cVideo::Start(void * PcrChannel, unsigned short PcrPid, unsigned short VideoPid, void * hChannel)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	int fd = open("/dev/dvb/adapter0/video0", O_RDWR);
	
	if (ioctl(fd, VIDEO_SELECT_SOURCE, VIDEO_SOURCE_DEMUX) < 0)
		printf("VIDEO_SELECT_SOURCE failed(%m)");
	
	if (ioctl(fd, VIDEO_PLAY, 1) < 0)
		printf("VIDEO_PLAY failed(%m)");
		
	close(fd);
	
	return true;
}

int cVideo::Stop(bool blank)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	int fd = open("/dev/dvb/adapter0/video0", O_RDWR);

	if (ioctl(fd, VIDEO_STOP, 1) < 0)
		printf("VIDEO_STOP failed(%m)");
		
	close(fd);
	
	return true;
}

bool cVideo::Pause(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	int fd = open("/dev/dvb/adapter0/video0", O_RDWR);

	if (ioctl(fd, VIDEO_FREEZE, 1) < 0)
		printf("VIDEO_FREEZE failed(%m)");
		
	close(fd);
	
	return true;
}

bool cVideo::Resume(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	int fd = open("/dev/dvb/adapter0/video0", O_RDWR);
	
	if (ioctl(fd, VIDEO_CONTINUE, 1) < 0)
		printf("VIDEO_CONTINUE failed(%m)");
		
	close(fd);
	
	return true;
}


int cVideo::LipsyncAdjust() { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }

int64_t cVideo::GetPTS(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }

int cVideo::Flush(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	int fd = open("/dev/dvb/adapter0/video0", O_RDWR);
	
	if (ioctl(fd, VIDEO_FLUSH, 1) < 0)
		printf("VIDEO_FLUSH failed(%m)");
	
	close(fd);
	
	return 0;
}

/* set video_system */
//2
int cVideo::SetVideoSystem(int video_system, bool remember)
{

	char *aVideoSystems[][2] = {
	{"VIDEO_STD_NTSC", "pal"},
	{"VIDEO_STD_SECAM", "pal"},
	{"VIDEO_STD_PAL", "pal"},
	{"VIDEO_STD_480P", "480p"},
	{"VIDEO_STD_576P", "576p50"},
	{"VIDEO_STD_720P60", "720p60"},
	{"VIDEO_STD_1080I60", "1080i60"},
	{"VIDEO_STD_720P50", "720p50"},
	{"VIDEO_STD_1080I50", "1080i50"},
	{"VIDEO_STD_1080P30", "1080p30"},
	{"VIDEO_STD_1080P24", "1080p24"},
	{"VIDEO_STD_1080P25", "1080p25"},
	{"VIDEO_STD_AUTO" "1080i50"},
	};

	printf("%s:%s - video_system=%s remember=%s\n", FILENAME, __FUNCTION__, 
		aVideoSystems[video_system][0], remember?"true":"false");
		
	int fd = open("/proc/stb/video/videomode", O_RDWR);
	write(fd, aVideoSystems[video_system][1], strlen(aVideoSystems[video_system][1]));
	close(fd);
	return 0;
}

int cVideo::SetStreamType(VIDEO_FORMAT type) {

	char *aVIDEOFORMAT[] = {
	"VIDEO_FORMAT_MPEG2",
	"VIDEO_FORMAT_MPEG4",
	"VIDEO_FORMAT_VC1",
	"VIDEO_FORMAT_JPEG",
	"VIDEO_FORMAT_GIF",
	"VIDEO_FORMAT_PNG"
	};

	printf("%s:%s - type=%s\n", FILENAME, __FUNCTION__, aVIDEOFORMAT[type]);
	
	return 0;
}

//7
void cVideo::SetSyncMode(AVSYNC_TYPE mode)
{
	char *aAVSYNCTYPE[] = {
	"AVSYNC_DISABLED",
	"AVSYNC_ENABLED",
	"AVSYNC_AUDIO_IS_MASTER",
	};

	printf("%s:%s - mode=%s\n", FILENAME, __FUNCTION__, aAVSYNCTYPE[mode]);
}

//8
void cVideo::ShowPicture(const char * fname)
{
	printf("%s:%s - fname=%s\n", FILENAME, __FUNCTION__, fname);
}

void cVideo::StopPicture()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void cVideo::Standby(unsigned int bOn)
{
	printf("%s:%s - bOn=%d\n", FILENAME, __FUNCTION__, bOn);
}

void cVideo::Pig(int x, int y, int w, int h, int osd_w, int osd_h)
{
	printf("%s:%s - x=%d y=%d w=%d h=%d osd_w=%d osd_h=%d\n", FILENAME, __FUNCTION__, 
		x, y, w, h, osd_w, osd_h);
}

void cVideo::setContrast(int val)
{
	printf("%s:%s - val=%d\n", FILENAME, __FUNCTION__, val);
}


void cVideo::SetFastBlank(bool onoff)
{
	printf("%s:%s - onoff=%s\n", FILENAME, __FUNCTION__, onoff?"true":"false");
}

void cVideo::SetTVAV(bool onoff)
{
	printf("%s:%s - onoff=%s\n", FILENAME, __FUNCTION__, onoff?"true":"false");
}

void cVideo::SetWideScreen(bool onoff)
{
	printf("%s:%s - onoff=%s\n", FILENAME, __FUNCTION__, onoff?"true":"false");
}

//9
void cVideo::SetVideoMode(analog_mode_t mode)
{
	char *aANALOGMODESCART[] = {
	"ANALOG_SD_RGB_SCART",
	"ANALOG_SD_YPRPB_SCART",
	"ANALOG_HD_RGB_SCART",
	"ANALOG_HD_YPRPB_SCART",
	};
	
	char *aANALOGMODECINCH[] = {
	"ANALOG_SD_RGB_CINCH",
	"ANALOG_SD_YPRPB_CINCH",
	"ANALOG_HD_RGB_CINCH",
	"ANALOG_HD_YPRPB_CINCH",
	};

	if(mode && 0x80 != 0x80)
		printf("%s:%s\n", FILENAME, __FUNCTION__, aANALOGMODESCART[mode&0x7F]);
	else	
		printf("%s:%s\n", FILENAME, __FUNCTION__, aANALOGMODECINCH[mode&0x7F]);
}

//6
void cVideo::SetDBDR(int dbdr)
{
	char *aDBDR[] = {
	"VIDEO_DB_DR_NEITHER",
	"VIDEO_DB_ON",
	"VIDEO_DB_DR_BOTH"
	};
	
	printf("%s:%s - dbdr=%s\n", FILENAME, __FUNCTION__, aDBDR[dbdr]);
}


