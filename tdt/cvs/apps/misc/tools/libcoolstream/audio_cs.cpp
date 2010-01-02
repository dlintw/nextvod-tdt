#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/select.h>

#include "audio_cs.h"
#include <linux/dvb/audio.h>

static const char * FILENAME = "audio_cs.cpp";

//EVIL

cAudio * audioDecoder = NULL;

#define AUDIO_BYPASS_ON 0
#define AUDIO_BYPASS_OFF 1

//EVIL END


/* internal methods */
int cAudio::setBypassMode(int disable)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

int cAudio::LipsyncAdjust(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

/* construct & destruct */
cAudio::cAudio(void * hBuffer, void * encHD, void * encSD)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	privateData = (CS_AUDIO_PDATA*)malloc(sizeof(CS_AUDIO_PDATA));
	privateData->m_fd = open("/dev/dvb/adapter0/audio0", O_RDWR);


	cEncodedDataOnSPDIF = 0;
	cEncodedDataOnHDMI = 0;
	Muted = false;

	StreamType = AUDIO_FMT_MPEG;
	SyncMode = AUDIO_NO_SYNC;
	started = false;
	uAudioPTSDelay = 0;
	uAudioDolbyPTSDelay = 0;
	uAudioMpegPTSDelay = 0;
	receivedDelay = false;

	atten = 0;
	volume = 0;

	clip_started = false;
	hdmiDD = false;
	spdifDD = false;
	hasMuteScheduled = false;


}


cAudio::~cAudio(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void * cAudio::GetHandle()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return NULL;
}

void * cAudio::GetDSP()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return NULL;
}

void cAudio::HandleAudioMessage(int Event, void *pData)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void cAudio::HandlePcmMessage(int Event, void *pData)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

/* shut up */
int cAudio::mute(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	Muted = true;
	
	SetMute(Muted);

	return 0;
}

int cAudio::unmute(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	Muted = false;
	
	SetMute(Muted);

	return 0;
}

int cAudio::SetMute(int enable)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	Muted = enable?true:false;
	
	char sMuted[4];
	sprintf(sMuted, "%d", Muted);


	int fd = open("/proc/stb/audio/j1_mute", O_RDWR);
	write(fd, sMuted, strlen(sMuted));
	close(fd);

	return 0;
}


/* bypass audio to external decoder */
int cAudio::enableBypass(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	if (ioctl(privateData->m_fd, AUDIO_SET_BYPASS_MODE, AUDIO_BYPASS_ON) < 0)
		printf("AUDIO_SET_BYPASS_MODE failed(%m)");

	return 0;
}

int cAudio::disableBypass(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	if (ioctl(privateData->m_fd, AUDIO_SET_BYPASS_MODE, AUDIO_BYPASS_OFF) < 0)
		printf("AUDIO_SET_BYPASS_MODE failed(%m)");

	return 0;
}

/* volume, min = 0, max = 255 */
int cAudio::setVolume(unsigned int left, unsigned int right)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	volume = left;

	char sVolume[4];
	sprintf(sVolume, "%d", volume);

	int fd = open("/proc/stb/avs/0/volume", O_RDWR);
	write(fd, sVolume, strlen(sVolume));
	close(fd);
	
	return 0;
}


/* start and stop audio */
int cAudio::Start(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	if (ioctl(privateData->m_fd, AUDIO_PLAY, 1) < 0)
		printf("AUDIO_PLAY failed(%m)");

	return 0;
}

int cAudio::Stop(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	if (ioctl(privateData->m_fd, AUDIO_STOP, 1) < 0)
		printf("AUDIO_STOP failed(%m)");

	return 0;
}

bool cAudio::Pause(bool Pcm)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	if (ioctl(privateData->m_fd, AUDIO_PAUSE, 1) < 0)
		printf("AUDIO_PAUSE failed(%m)");

	return true;
}

bool cAudio::Resume(bool Pcm)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	if (ioctl(privateData->m_fd, AUDIO_CONTINUE, 1) < 0)
		printf("AUDIO_CONTINUE failed(%m)");
	
	return true;
}

void cAudio::SetSyncMode(AVSYNC_TYPE Mode)
{
	char *aAVSYNCTYPE[] = {
		"AUDIO_SYNC_WITH_PTS",
		"AUDIO_NO_SYNC",
		"AUDIO_SYNC_AUDIO_MASTER"
	};

	printf("%s:%s - Mode=%s\n", FILENAME, __FUNCTION__, aAVSYNCTYPE[Mode]);

	int sync = 1;

	if(Mode == AUDIO_NO_SYNC)
		sync = 0;

	if (ioctl(privateData->m_fd, AUDIO_SET_AV_SYNC, sync) < 0)
		printf("AUDIO_SET_AV_SYNC(%m)");

}


/* stream source */
int cAudio::getSource(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

int cAudio::setSource(int source)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	


	return 0;
}

int cAudio::Flush(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}


/* select channels */
int cAudio::setChannel(int channel)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

int cAudio::getChannel(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

int cAudio::PrepareClipPlay(int uNoOfChannels, int uSampleRate, int uBitsPerSample, int bLittleEndian)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

int cAudio::WriteClip(unsigned char * buffer, int size)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

int cAudio::StopClip()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

void cAudio::getAudioInfo(int &type, int &layer, int& freq, int &bitrate, int &mode)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void cAudio::SetSRS(int iq_enable, int nmgr_enable, int iq_mode, int iq_level)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

bool cAudio::IsHdmiDDSupported()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return true;
}

void cAudio::SetHdmiDD(bool enable)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);


	int fd = open("/proc/stb/hdmi/audio_source", O_RDWR);
	if(enable) {
		// do i have to enable bypass for that ?
		// enableBypass();

		write(fd, "spdif", strlen("spdif"));
	}
	else
		write(fd, "pcm", strlen("pcm"));
	close(fd);


}

void cAudio::SetSpdifDD(bool enable)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	if(enable)
		enableBypass();
	else
		disableBypass();
}

void cAudio::ScheduleMute(bool On)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

