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

//Used by Fileplay
bool cPlayback::Open(playmode_t PlayMode)
{
	char *aPLAYMODE[] = {
		"PLAYMODE_TS",
		"PLAYMODE_FILE"
	};

	printf("%s:%s - PlayMode=%s\n", FILENAME, __FUNCTION__, aPLAYMODE[PlayMode]);
	
	player = (Context_t*) malloc(sizeof(Context_t));

	if(player) {
		player->playback	= &PlaybackHandler;
		player->output		= &OutputHandler;
		player->container	= &ContainerHandler;
		player->manager		= &ManagerHandler;

		printf("%s\n", player->output->Name);
	}

	//Registration of output devices
	if(player && player->output) {
		player->output->Command(player,OUTPUT_ADD, (void*)"audio");
		player->output->Command(player,OUTPUT_ADD, (void*)"video");
		player->output->Command(player,OUTPUT_ADD, (void*)"subtitle");
	}

	return 0;
}

//Used by Fileplay
void cPlayback::Close(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
        
//Dagobert: movieplayer does not call stop, it calls close ;)	
	Stop();

}

//Used by Fileplay
bool cPlayback::Start(char * filename, unsigned short vpid, int vtype, unsigned short apid, bool ac3)
{
	printf("%s:%s - filename=%s vpid=%u vtype=%d apid=%u ac3=%d\n", 
		FILENAME, __FUNCTION__, filename, vpid, vtype, apid, ac3);

	//create playback path
	char file[400] = {""};

	if(!strncmp("http://", filename, 7))
		;
	else if(!strncmp("file://", filename, 7))
		;
	else
		strcat(file, "file://");

	strcat(file, filename);

	//try to open file
	if(player && player->playback && player->playback->Command(player, PLAYBACK_OPEN, file) >= 0) {

		//AUDIO
		if(player && player->manager && player->manager->audio) {
			char ** TrackList = NULL;
			player->manager->audio->Command(player, MANAGER_LIST, &TrackList);
			if (TrackList != NULL) {
				printf("AudioTrack List\n");
				int i = 0;
				for (i = 0; TrackList[i] != NULL; i+=2) {
					printf("\t%s - %s\n", TrackList[i], TrackList[i+1]);

					free(TrackList[i]);
					free(TrackList[i+1]);
				}
				free(TrackList);
			}
        	}

		//SUB
		if(player && player->manager && player->manager->subtitle) {
			char ** TrackList = NULL;
			player->manager->subtitle->Command(player, MANAGER_LIST, &TrackList);
			if (TrackList != NULL) {
				printf("SubtitleTrack List\n");
				int i = 0;
				for (i = 0; TrackList[i] != NULL; i+=2) {
					printf("\t%s - %s\n", TrackList[i], TrackList[i+1]);
					free(TrackList[i]);
					free(TrackList[i+1]);
				}
				free(TrackList);
			}
		}

		if(player && player->output && player->playback) {
        		player->output->Command(player, OUTPUT_OPEN, NULL);
        		player->playback->Command(player, PLAYBACK_PLAY, NULL);

			return true;
		}
	}
		
	return false;
}

//Used by Fileplay
bool cPlayback::Stop(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);

	if(player && player->playback && player->output) {
		player->playback->Command(player, PLAYBACK_STOP, NULL);
		player->output->Command(player, OUTPUT_CLOSE, NULL);
	}

	if(player && player->output) {
		player->output->Command(player,OUTPUT_DEL, (void*)"audio");
		player->output->Command(player,OUTPUT_DEL, (void*)"video");
		player->output->Command(player,OUTPUT_DEL, (void*)"subtitle");
	}

	if(player && player->playback)
		player->playback->Command(player,PLAYBACK_CLOSE, NULL);
	if(player)
		free(player);
	if(player != NULL)
		player = NULL;

	return true;
}

bool cPlayback::SetAPid(unsigned short pid, bool ac3)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	return true;
}

bool cPlayback::SetSpeed(int speed)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return true;
}

bool cPlayback::GetSpeed(int &speed) const
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return true;
}

// in milliseconds
bool cPlayback::GetPosition(int &position, int &duration)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);


	if (player && player->playback && !player->playback->isPlaying) {
		printf("cPlayback::%s !!!!EOF!!!! < -1\n", __func__);
		position = duration + 1000;
		//duration = 0;

		// this is stupid, neutrino is realy realy stupid!
		return false;
	} 

	unsigned long long int vpts = 0;
	if(player && player->playback)
		player->playback->Command(player, PLAYBACK_PTS, &vpts);

	if(vpts <= 0) return false;

	/* len is in nanoseconds. we have 90 000 pts per second. */
	position = vpts/90;

	double length = 0;

	if(player && player->playback)
		player->playback->Command(player, PLAYBACK_LENGTH, &length);

	if(length <= 0) return false;

	duration = length*1000.0;

	return true;
}

bool cPlayback::GetOffset(off64_t &offset)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return true;
}

bool cPlayback::SetPosition(int position, bool absolute)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return true;
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

bool cPlayback::IsPlaying(void) const
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return playing;
}

bool cPlayback::IsEnabled(void) const
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return enabled;
}

int cPlayback::GetCurrPlaybackSpeed(void) const
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return nPlaybackSpeed;
}

