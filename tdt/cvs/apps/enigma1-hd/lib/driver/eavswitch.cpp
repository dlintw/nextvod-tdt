#include <lib/driver/eavswitch.h>

#include <config.h>
#if HAVE_DVB_API_VERSION < 3
#define VIDEO_DEV "/dev/dvb/card0/video0"
#define AUDIO_DEV "/dev/dvb/card0/audio0"
#include <ost/audio.h>
#include <ost/video.h>
#else
#define VIDEO_DEV "/dev/dvb/adapter0/video0"
#define AUDIO_DEV "/dev/dvb/adapter0/audio0"
#include <linux/dvb/audio.h>
#include <linux/dvb/video.h>
#endif

#include <unistd.h>
#include <fcntl.h>
#include <dbox/avs_core.h>
#include <sys/ioctl.h>
#include <lib/base/eerror.h>
#include <lib/base/estring.h>
#include <lib/system/econfig.h>
#include <lib/system/info.h>
#include <lib/dvb/decoder.h>

#define VIDEO_SYSTEM_PAL        0
#define VIDEO_SYSTEM_NTSC       1
#define VIDEO_SYSTEM_PALM       4

#define VIDEO_FORMAT_4_3   0
#define VIDEO_FORMAT_16_9  1
#define VIDEO_FORMAT_221_1 2

#define SAA_MODE_RGB    0
#define SAA_MODE_FBAS   1
#define SAA_MODE_COMPONENT 2


eAVSwitch *eAVSwitch::instance=0;

eAVSwitch::eAVSwitch()
{
	init_eAVSwitch();
}

void eAVSwitch::init_eAVSwitch()
{
	input=0;
	active=0;
	audioChannel=0;
	if (!instance)
		instance=this;

	avsfd=open("/dev/dbox/avs0", O_RDWR);

	useOst =
		eSystemInfo::getInstance()->getHwType() >= eSystemInfo::DM7000;
}

void eAVSwitch::init()
{
	loadScartConfig();

	reloadSettings();  // only Colorsettings...

	if (eConfig::getInstance()->getKey("/elitedvb/audio/mute", mute))
		mute=0;

	if (eConfig::getInstance()->getKey("/elitedvb/audio/VCRvolume", VCRVolume))
		VCRVolume=10;

	if (eConfig::getInstance()->getKey("/elitedvb/audio/volume", volume))
		volume=10;

	if (eConfig::getInstance()->getKey("/elitedvb/video/videoformat", videoformat ))
	        videoformat = 0;	

	setInput(0);
	setActive(1);
	changeVolume(0,0);
}

eAVSwitch *eAVSwitch::getInstance()
{
	return instance;
}

eAVSwitch::~eAVSwitch()
{
	eConfig::getInstance()->setKey("/elitedvb/audio/volume", volume);
	eConfig::getInstance()->setKey("/elitedvb/audio/VCRvolume", VCRVolume);
	eConfig::getInstance()->setKey("/elitedvb/audio/mute", mute);

	if (avsfd>=0)
		close(avsfd);

	if (instance==this)
		instance=0;
}

void eAVSwitch::reloadSettings()
{
	unsigned int colorformat;
	eConfig::getInstance()->getKey("/elitedvb/video/colorformat", colorformat);
	setColorFormat((eAVColorFormat)colorformat);
	setVSystem(system);
}

void eAVSwitch::selectAudioChannel( int c )
{
	audio_channel_select_t chan=AUDIO_STEREO;

	switch(c)
	{
		case 0: // Mono Left
			chan = AUDIO_MONO_LEFT;
			break;
		case 1: // Stereo
			break;
		case 2: // Mono Right
			chan = AUDIO_MONO_RIGHT;
			break;
	}
	audioChannel=c;
	
	int fd = Decoder::getAudioDevice();

	if ( fd == -1 )
		fd = open( AUDIO_DEV, O_RDWR );
/*
	int ret=ioctl(fd, AUDIO_CHANNEL_SELECT, chan);

	if(ret == -1)
		eDebug("AUDIO_CHANNEL_SELECT failed (%m)\nST LINUX return -EINVAL");
*/
	if (Decoder::getAudioDevice() == -1)
		close(fd);

}

int eAVSwitch::setVolume(int vol)
{
//      eDebug("[%s] volume = %d ", __FUNCTION__, vol);
	vol=63-vol/(65536/64);
	if (vol<0)
		vol=0;
	if (vol>63)
		vol=63;

	FILE *f;
	if((f = fopen("/proc/stb/avs/0/volume", "wb")) == NULL) {
		eDebug("cannot open /proc/stb/avs/0/volume(%m)");
		return -1;
	}

	fprintf(f, "%d", vol); /* in -1dB */

	fclose(f);
	return 0;
}

void eAVSwitch::changeVolume(int abs, int vol)
{
//      eDebug("[%s] abs = %d vol = %d mute = %d ",__FUNCTION__, abs, vol, mute); 
	switch (abs)
	{
		case 0:
			volume+=vol;
			break;
		case 1:
			volume=vol;
			break;
	}

	if (volume<0)
		volume=0;

	if (volume>63)
		volume=63;

	if ( (!mute && volume == 63)
           || (mute && volume != 63 ) )
			toggleMute();

	sendVolumeChanged();
	setVolume( (63-volume) * 65536/64 );
}

void eAVSwitch::changeVCRVolume(int abs, int vol)
{
	switch (abs)
	{
		case 0:
			VCRVolume+=vol;
		break;
		case 1:
			VCRVolume=vol;
		break;
	}

	if (VCRVolume<0)
		VCRVolume=0;

	if (VCRVolume>63)
		VCRVolume=63;

	setVolume( (63-VCRVolume) * 65536/64 );

	/*emit*/ volumeChanged(mute, VCRVolume);
}

void eAVSwitch::muteOstAudio(bool b)
{
//      eDebug("[%s] b = %d", __FUNCTION__, b);  
	FILE *f;
	if((f = fopen("/proc/stb/audio/j1_mute", "wb")) == NULL) {
		eDebug("cannot open /proc/stb/audio/j1_mute(%m)");
		return;
	}
	
	fprintf(f, "%d", b?1:0);

	fclose(f);
}

void eAVSwitch::sendVolumeChanged()
{
	/*emit*/ volumeChanged(mute, volume);
}

void eAVSwitch::toggleMute()
{
	if ( input == 1 ) 
	{
		return;
	}
	if (mute)
	{
		if ( useOst )
			muteOstAudio(0);
		else
			muteAvsAudio(0);

		mute = 0;
	}
	else
	{
		if ( useOst )
			muteOstAudio(1);
		else
			muteAvsAudio(1);

		mute = 1;
	}
	sendVolumeChanged();
}

void eAVSwitch::muteAvsAudio(bool m)
{
	if ( input == 1 ) //Scart 
	{
		return;
	}
	int a;

	if(m)
		a=AVS_MUTE;
	else
		a=AVS_UNMUTE;
}

int eAVSwitch::setTVPin8(int vol)
{
//      eDebug("eAVSwitch [%s] vol = %d",__FUNCTION__, vol);  
	int fnc;
	if ( vol == -1 ) // switch to last aspect
		vol = aspect == r169?6:12;
	return ioctl(avsfd, AVSIOSFNC, &fnc);

}
int eAVSwitch::setColorFormat(eAVColorFormat c)
{
	/*
	0-CVBS
	1-RGB
	2-S-Video
	*/
	
	const char *cvbs="cvbs";
	const char *rgb="rgb";
	const char *svideo="svideo";
	const char *yuv="yuv";
	int fd;
	
	if((fd = open("/proc/stb/avs/0/colorformat", O_WRONLY)) < 0) {
		printf("cannot open /proc/stb/avs/0/colorformat\n");
		return -1;
	}

	switch(c) {
		case 0:
			write(fd, cvbs, strlen(cvbs));
			break;
		case 1:
			write(fd, rgb, strlen(rgb));
			break;
		case 2:
			write(fd, yuv, strlen(yuv));
			break;
	}	
	close(fd);

	return 0;
}

int eAVSwitch::setInput(int v)
{
//	eDebug("[eAVSwitch] setInput %d", v);
	/*
	0-encoder
	1-scart
	2-aux
	*/

	const char *input[] = {"encoder", "scart", "aux"};

	int fd;
	
	if((fd = open("/proc/stb/avs/0/input", O_WRONLY)) < 0) {
		eDebug("cannot open /proc/stb/avs/0/input");
		return -1;
	}

	write(fd, input[v], strlen(input[v]));
	close(fd);
	return 0;
}

int eAVSwitch::setAspectRatio(eAVAspectRatio as)
{
//      eDebug("eAVSwitch [%s] as = %d", __FUNCTION__, as);  

	unsigned int disableWSS = 0;
	unsigned int pin8 = 1;	
	eConfig::getInstance()->getKey("/elitedvb/video/disableWSS", disableWSS );
	eConfig::getInstance()->getKey("/elitedvb/video/pin8", pin8);
        int ratio;
        ratio = as;
	/*
	0-4:3 Letterbox
	1-4:3 PanScan
	2-16:9
	3-16:9 forced ("panscan")
	*/
	
	const char *aspect[] = {"4:3", "4:3", "16:9"};
	const char *policy[] = {"letterbox", "panscan", "letterbox", "panscan" };

	int fd;
	
	eDebug("[%s] ratio = %d ", __FUNCTION__, ratio);
	if((fd = open("/proc/stb/video/aspect", O_WRONLY)) < 0) {
		eDebug("cannot open /proc/stb/video/aspect");
		return -1;
	}
	eDebug("set aspect to %s", aspect[ratio]);
	write(fd, aspect[ratio], strlen(aspect[ratio]));
	close(fd);

	if((fd = open("/proc/stb/video/policy", O_WRONLY)) < 0) {
		eDebug("cannot open /proc/stb/video/policy");
		return -1;
	}
	eDebug("set ratio to %s", policy[pin8]);
	write(fd, policy[pin8], strlen(policy[pin8]));
	close(fd);
        return 0; 
        
}

void eAVSwitch::setVSystem(eVSystem _system)
{
	system = _system;
}

int eAVSwitch::setActive(int a)
{
	active=a;
	return setTVPin8((active && (!input))?((aspect==r169)?6:12):0);
}

bool eAVSwitch::loadScartConfig()
{
	FILE* fd = fopen(CONFIGDIR"/scart.conf", "r");
	if(fd)
	{
		eDebug("[eAVSwitch] loading scart-config (scart.conf)");

		char buf[1000];
		fgets(buf,sizeof(buf),fd);

		eString readline_scart = "_scart: %d %d %d %d %d %d\n";
		eString readline_dvb = "_dvb: %d %d %d %d %d %d\n";

		int i=0;
		while ( fgets(buf,sizeof(buf),fd) != NULL && (i < 3) )
		{
			if ( !(1&i) && sscanf( buf, readline_scart.c_str(), &scart[0], &scart[1], &scart[2], &scart[3], &scart[4], &scart[5] ) == 6)
				i |= 1;
			else if ( !(2&i) && sscanf( buf, readline_dvb.c_str(), &dvb[0], &dvb[1], &dvb[2], &dvb[3], &dvb[4], &dvb[5]) == 6 )
				i |= 2;
		}

		if ( i != 3 )
			eDebug( "[eAVSwitch] failed to parse scart-config (scart.conf), using default-values" );

		eDebug("[eAVSwitch] readed scart conf : %i %i %i %i %i %i", scart[0], scart[1], scart[2], scart[3], scart[4], scart[5] );
		eDebug("[eAVSwitch] readed dvb conf : %i %i %i %i %i %i", dvb[0], dvb[1], dvb[2], dvb[3], dvb[4], dvb[5] );
	
		fclose(fd);
	}
	else
		eDebug("[eAVSwitch] failed to load scart-config (scart.conf), using default-values");

	return 0;
}

void eAVSwitch::setVideoFormat( int format )
{
//	eDebug("eAVSwitch [%s] format = %d ",__FUNCTION__, format );
        saafd=Decoder::getVideoDevice();
	if ( saafd == -1 )
	    saafd = open ( VIDEO_DEV, O_RDWR );

	if (ioctl(saafd, VIDEO_SET_DISPLAY_FORMAT, format))
		perror("VIDEO SET DISPLAY FORMAT:");
	if (Decoder::getVideoDevice() == -1)
	    close(saafd);	
}

