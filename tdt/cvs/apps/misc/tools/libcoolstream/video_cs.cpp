#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/select.h>

#include "video_cs.h"
#include <linux/dvb/video.h>
#include <linux/fb.h>
#include <linux/stmfb.h>

static const char * FILENAME = "video_cs.cpp";

//EVIL

cVideo * videoDecoder = NULL;
unsigned int system_rev = 0x07;



#ifndef VIDEO_FLUSH
#define VIDEO_FLUSH                     _IO('o',  82)
#endif

// this are taken from e2, the player converts them to falid values
#define VIDEO_STREAMTYPE_MPEG2 0
#define VIDEO_STREAMTYPE_MPEG4_H264 1
#define VIDEO_STREAMTYPE_VC1 3
#define VIDEO_STREAMTYPE_MPEG4_Part2 4
#define VIDEO_STREAMTYPE_VC1_SM 5
#define VIDEO_STREAMTYPE_MPEG1 6

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
	
	privateData = (CS_VIDEO_PDATA*)malloc(sizeof(CS_VIDEO_PDATA));

	Open();
}

cVideo::~cVideo(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	Close();

	free(privateData);
}

bool cVideo::Open()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	privateData->m_fd = open("/dev/dvb/adapter0/video0", O_RDWR);
	if(privateData->m_fd > 0)
		return true;
	return false;
}

bool cVideo::Close()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	close(privateData->m_fd);

	return true;
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
	
	if (ioctl(privateData->m_fd, VIDEO_SELECT_SOURCE, VIDEO_SOURCE_DEMUX) < 0)
		printf("VIDEO_SELECT_SOURCE failed(%m)");
	
	if (ioctl(privateData->m_fd, VIDEO_PLAY, 1) < 0)
		printf("VIDEO_PLAY failed(%m)");
		
	return true;
}

int cVideo::Stop(bool blank)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	if (ioctl(privateData->m_fd, VIDEO_STOP, 1) < 0)
		printf("VIDEO_STOP failed(%m)");
	
	return true;
}

bool cVideo::Pause(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	if (ioctl(privateData->m_fd, VIDEO_FREEZE, 1) < 0)
		printf("VIDEO_FREEZE failed(%m)");
		
	return true;
}

bool cVideo::Resume(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	if (ioctl(privateData->m_fd, VIDEO_CONTINUE, 1) < 0)
		printf("VIDEO_CONTINUE failed(%m)");
		
	return true;
}


int cVideo::LipsyncAdjust() { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }

int64_t cVideo::GetPTS(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }

int cVideo::Flush(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	if (ioctl(privateData->m_fd, VIDEO_CLEAR_BUFFER, 1) < 0)
		printf("VIDEO_CLEAR_BUFFER failed(%m)");
	
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
	
	int streamtype = VIDEO_STREAMTYPE_MPEG2;

	switch(type)
	{
	default:
	case VIDEO_FORMAT_MPEG2:
		streamtype = VIDEO_STREAMTYPE_MPEG2;
		break;
	case VIDEO_FORMAT_MPEG4:
		streamtype = VIDEO_STREAMTYPE_MPEG4_H264;
		break;
	case VIDEO_FORMAT_VC1:
		streamtype = VIDEO_STREAMTYPE_VC1;
		break;
	}

	if (ioctl(privateData->m_fd, VIDEO_SET_STREAMTYPE, streamtype) < 0)
		printf("VIDEO_SET_STREAMTYPE failed(%m)");

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

	int fd_avs = open("/proc/stb/avs/0/standby", O_RDWR);
	int fd_hdmi  = open("/dev/fb0",   O_RDWR);

	struct stmfbio_output_configuration outputConfig = {0};
	outputConfig.outputid = 1;
	if(ioctl(fd_hdmi, STMFBIO_GET_OUTPUT_CONFIG, &outputConfig)<0)
		printf("Getting current output configuration failed\n");
  
	outputConfig.caps = 0;
	outputConfig.activate = STMFBIO_ACTIVATE_IMMEDIATE;
	outputConfig.analogue_config = 0;

	outputConfig.caps |= STMFBIO_OUTPUT_CAPS_HDMI_CONFIG;

	if (bOn) {
		outputConfig.hdmi_config |= STMFBIO_OUTPUT_HDMI_DISABLED;
	} else {
		outputConfig.hdmi_config &= ~STMFBIO_OUTPUT_HDMI_DISABLED;
	}

	if(outputConfig.caps != STMFBIO_OUTPUT_CAPS_NONE)
	{
		if(ioctl(fd_hdmi, STMFBIO_SET_OUTPUT_CONFIG, &outputConfig)<0)
			printf("setting output configuration failed\n");
	}

	int fd_avs_input = open("/proc/stb/avs/0/input", O_RDWR);

	if (bOn)
	{
		write(fd_avs, "on", 2);
		write(fd_avs_input, "encoder", 7);
	}
	else
	{
		write(fd_avs, "off", 3);
		write(fd_avs_input, "scart", 5);
	}
	close(fd_avs_input);
	close(fd_avs);
	close(fd_hdmi);
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

	const char *wss_auto_off="auto(4:3_off)";
	const char *wss_auto="auto";

	int fd = open("/proc/stb/denc/0/wss", O_RDWR);
	if(onoff)
		write(fd, wss_auto, strlen(wss_auto));
	else
		write(fd, wss_auto_off, strlen(wss_auto_off));
	close(fd);
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
		printf("%s:%s - mode=%s\n", FILENAME, __FUNCTION__, aANALOGMODESCART[mode&0x7F]);
	else	
		printf("%s:%s - mode=%s\n", FILENAME, __FUNCTION__, aANALOGMODECINCH[mode&0x7F]);
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


