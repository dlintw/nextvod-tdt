#include <stdio.h>

#include "playback_cs.h"

static const char * FILENAME = "playback_cs.cpp";


//
void cPlayback::Attach(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void cPlayback::Detach(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

bool cPlayback::SetAVDemuxChannel(bool On, bool Video, bool Audio)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	return 0;
}

void cPlayback::PlaybackNotify (int  Event, void *pData, void *pTag)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void cPlayback::DMNotify(int Event, void *pTsBuf, void *Tag)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

bool cPlayback::Open(playmode_t PlayMode)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

void cPlayback::Close(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

bool cPlayback::Start(char * filename, unsigned short vpid, int vtype, unsigned short apid, bool ac3)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

bool cPlayback::Stop(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

bool cPlayback::SetAPid(unsigned short pid, bool ac3)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return 0;
}

bool cPlayback::SetSpeed(int speed)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

bool cPlayback::GetSpeed(int &speed) const
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

bool cPlayback::GetPosition(int &position, int &duration)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

bool cPlayback::GetOffset(off64_t &offset)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

bool cPlayback::SetPosition(int position, bool absolute)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

void * cPlayback::GetHandle(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return NULL;
}

void * cPlayback::GetDmHandle(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return NULL;
}

void cPlayback::FindAllPids(uint16_t *apids, unsigned short *ac3flags, uint16_t *numpida, std::string *language)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}
 
//
cPlayback::cPlayback(int num)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

cPlayback::~cPlayback()
{ 
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}
