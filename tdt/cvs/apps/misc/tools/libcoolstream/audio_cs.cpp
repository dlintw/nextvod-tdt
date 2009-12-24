#include <stdio.h>

#include "audio_cs.h"

static const char * FILENAME = "audio_cs.cpp";

//EVIL

cAudio * audioDecoder = NULL;

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

	privateData = NULL;
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
	
	return 0;
}

int cAudio::unmute(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	Muted = false;
	
	return 0;
}

int cAudio::SetMute(int enable)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	Muted = enable?true:false;
	
	return 0;
}


/* bypass audio to external decoder */
int cAudio::enableBypass(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

int cAudio::disableBypass(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

/* volume, min = 0, max = 255 */
int cAudio::setVolume(unsigned int left, unsigned int right)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	volume = left;
	
	return 0;
}


/* start and stop audio */
int cAudio::Start(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

int cAudio::Stop(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

bool cAudio::Pause(bool Pcm)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return true;
}

bool cAudio::Resume(bool Pcm)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return true;
}

void cAudio::SetSyncMode(AVSYNC_TYPE Mode)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
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
}

void cAudio::SetSpdifDD(bool enable)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void cAudio::ScheduleMute(bool On)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

