#include <stdio.h> 
#include <string.h>
#include <stdlib.h> 
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h> 
#include <sys/ioctl.h>
#include <linux/dvb/video.h>
#include <linux/dvb/audio.h>
#include <memory.h>
#include <asm/types.h>
#include <pthread.h>
#include <errno.h>

#include "common.h"
#include "output.h"
#include "stm_ioctls.h"

static const char FILENAME[] 	= "linuxdvb.c";

static const char VIDEODEV[] 	= "/dev/dvb/adapter0/video0";
static const char AUDIODEV[] 	= "/dev/dvb/adapter0/audio0";
static const char DVRDEV[] 	= "/dev/dvb/adapter0/dvr0";

static int videofd 	= -1;
static int audiofd 	= -1;
static int dvrfd 	= -1;

static int LinuxDvbPtsStart(Context_t *context);
static pthread_t PtsThread;
unsigned long long int sCURRENT_PTS = 0;
static const unsigned int cSLEEPTIME = 500000;

int LinuxDvbOpen(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);	

	if (video && videofd == -1) {
		videofd = open(VIDEODEV, O_RDWR);
    		ioctl( videofd, VIDEO_CLEAR_BUFFER ,0);
		ioctl( videofd, VIDEO_SELECT_SOURCE, (void*)VIDEO_SOURCE_MEMORY);
		ioctl( videofd, VIDEO_SET_STREAMTYPE, (void*)STREAM_TYPE_PROGRAM);

	}
	if (audio && audiofd == -1) {
		audiofd = open(AUDIODEV, O_RDWR);
    		ioctl( audiofd, AUDIO_CLEAR_BUFFER,0);
		ioctl( audiofd, AUDIO_SELECT_SOURCE, (void*)AUDIO_SOURCE_MEMORY);
		ioctl( audiofd, AUDIO_SET_STREAMTYPE, (void*)STREAM_TYPE_PROGRAM);
	}
	if ((video || audio) && dvrfd == -1)
		dvrfd = open(DVRDEV, O_RDWR);

	return 0;
}

int LinuxDvbClose(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	if (video && videofd != -1) {
		close(videofd);
		videofd = -1;
	}
	if (audio && audiofd != -1) {
		close(audiofd);
		audiofd = -1;
	}
	if ((video || audio) && dvrfd != -1) {
		close(dvrfd);
		dvrfd 	= -1;
	}

	return 0;
}

int LinuxDvbPlay(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	//if (!context->playback->isPlaying) {
		if (video && videofd != -1) {
			char * Encoding = NULL;
			context->manager->video->Command(context, MANAGER_GETENCODING, &Encoding);

			printf("%s::%s V %s\n", FILENAME, __FUNCTION__, Encoding);

			if(!strcmp (Encoding, "V_MPEG2"))
				ioctl( videofd, VIDEO_SET_ENCODING, (void*)VIDEO_ENCODING_AUTO);
			else if(!strcmp (Encoding, "V_MSCOMP") || !strcmp (Encoding, "V_MS/VFW/FOURCC") || !strcmp (Encoding, "V_MKV/XVID"))
				ioctl( videofd, VIDEO_SET_ENCODING, (void*)VIDEO_ENCODING_MPEG4P2);
 			else if(!strcmp (Encoding, "V_MPEG4/ISO/AVC") || !strcmp (Encoding, "V_MPEG2/H264"))
				ioctl( videofd, VIDEO_SET_ENCODING, (void*)VIDEO_ENCODING_H264);
            		else
                		ioctl( videofd, VIDEO_SET_ENCODING, (void*)VIDEO_ENCODING_AUTO);

			ioctl(videofd, VIDEO_PLAY, NULL);
			free(Encoding);
		}
		if (audio && audiofd != -1) {
			char * Encoding = NULL;
			context->manager->audio->Command(context, MANAGER_GETENCODING, &Encoding);

			printf("%s::%s A %s\n", FILENAME, __FUNCTION__, Encoding);

			if(!strcmp (Encoding, "A_AC3"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_AC3);
			else if(!strcmp (Encoding, "A_MP3") || !strcmp (Encoding, "A_MPEG/L3") || !strcmp (Encoding, "A_MS/ACM"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_MP3);
 			else if(!strcmp (Encoding, "A_DTS"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_DTS);
			else if(!strcmp (Encoding, "A_AAC"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_AAC);
			else if(!strcmp (Encoding, "A_WMA"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_WMA);
           		else
                		ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_AUTO);

			ioctl(audiofd, AUDIO_PLAY, NULL);
			free(Encoding);
		}
		
		LinuxDvbPtsStart(context);
	//}

	return 0;
}

int LinuxDvbStop(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	//if (context->playback->isPlaying || context->playback->isPaused) {
		if (video && videofd != -1) {
			ioctl(videofd, VIDEO_CLEAR_BUFFER ,0);
			ioctl(videofd, VIDEO_STOP, NULL);
		}
		if (audio && audiofd != -1) {
			ioctl(audiofd, AUDIO_CLEAR_BUFFER ,0);
			ioctl(audiofd, AUDIO_STOP, NULL);
		}
	//}
	int result=0;
    	if(PtsThread!=NULL)result = pthread_join (PtsThread, NULL);
    	if(result != 0) 
    	{
          printf("ERROR: Stop PtsThread\n");
    	}	
	PtsThread=NULL;
	return 0;
}

int LinuxDvbPause(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	//if (!context->playback->isPaused) {
		if (video && videofd != -1) {
			ioctl(videofd, VIDEO_FREEZE, NULL);
		}
		if (audio && audiofd != -1) {
			ioctl(audiofd, AUDIO_PAUSE, NULL);
		}
	//}

	return 0;
}

int LinuxDvbContinue(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	//if (context->playback->isPaused || context->playback->isForwarding) {
		if (video && videofd != -1) {
			ioctl(videofd, VIDEO_CONTINUE, NULL);
		}
		if (audio && audiofd != -1) {
			ioctl(audiofd, AUDIO_CONTINUE, NULL);
		}
	//}

	return 0;
}

int LinuxDvbFlush(Context_t  *context, char * type) {
	printf("%s::%s ->\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	//if (context->playback->isPlaying || context->playback->isPaused) {
		if (video && videofd != -1) {
			ioctl(videofd, VIDEO_FLUSH ,NULL);
			ioctl(videofd, VIDEO_STOP, NULL);
		}
		if (audio && audiofd != -1) {
			ioctl(audiofd, AUDIO_FLUSH ,NULL);
			ioctl(audiofd, AUDIO_STOP, NULL);
		}
	//}
    printf("%s::%s <-\n", FILENAME, __FUNCTION__);
	return 0;
}

int LinuxDvbFastForward(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	//if (context->playback->isPlaying && !context->playback->isPaused) {
		if (video && videofd != -1) {
			ioctl(videofd, VIDEO_FAST_FORWARD, context->playback->Speed);
		}
		if (audio && audiofd != -1) {
        //not supported
		//	ioctl(audiofd, AUDIO_FAST_FORWARD, context->playback->Speed);
            return -1;
		}
	//}

	return 0;
}

int LinuxDvbAVSync(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	if (audio && audiofd != -1) {
		ioctl(audiofd, AUDIO_SET_AV_SYNC, context->playback->AVSync);
	}

	return 0;
}

int LinuxDvbClear(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	//if (context->playback->isPlaying || context->playback->isPaused) {
		if (video && videofd != -1) {
			ioctl(videofd, VIDEO_CLEAR_BUFFER ,0);
		}
		if (audio && audiofd != -1) {
			ioctl(audiofd, AUDIO_CLEAR_BUFFER ,0);
		}
	//}

	return 0;
}

static void LinuxDvbPtsThread(Context_t *context) {
	printf("%s::%d\n", __FUNCTION__, __LINE__);
	//unsigned long long int VideoTime = 0;

    while(context->playback->isPlaying /*videofd != -1 || audiofd != -1*/) {
    
		if (videofd != -1)
			ioctl(videofd, VIDEO_GET_PTS, (void*)&sCURRENT_PTS);
		else if (audiofd != -1)
			ioctl(audiofd, AUDIO_GET_PTS, (void*)&sCURRENT_PTS);
    	else 
    		sCURRENT_PTS = 0;
    		
    	usleep(cSLEEPTIME);
    }
}


static int LinuxDvbPtsStart(Context_t *context) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
    int error;
    //if (PtsThread == NULL) {
	  pthread_attr_t attr;
	  pthread_attr_init(&attr);
	  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
          if(error=pthread_create(&PtsThread, &attr, (void *)&LinuxDvbPtsThread, context) != 0)
          {
            fprintf(stderr, "Error creating thread in %s error:%d:%s\n", __FUNCTION__,errno,strerror(errno));
	    PtsThread=NULL;
            return -1;
          }
    //}
    return 0;
}

int LinuxDvbPts(Context_t  *context, unsigned long long int* pts) {
	//printf("%s::%s\n", FILENAME, __FUNCTION__);

	//if (context->playback->isPlaying) {
		*((unsigned long long int *)pts)=(unsigned long long int)sCURRENT_PTS;
	
	//} else
	//	*((unsigned long long int *)pts)=(unsigned long long int)0;

	return 0;
}

int LinuxDvbSwitch(Context_t  *context, char * type) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	unsigned char audio = !strcmp("audio", type);

	printf("%s::%s a%d\n", FILENAME, __FUNCTION__, audio);

		if (audio && audiofd != -1) {
			char * Encoding = NULL;
			context->manager->audio->Command(context, MANAGER_GETENCODING, &Encoding);
	
			ioctl(audiofd, AUDIO_STOP ,NULL);
			ioctl(audiofd, AUDIO_CLEAR_BUFFER ,NULL);
			printf("%s::%s A %s\n", FILENAME, __FUNCTION__, Encoding);

			if(!strcmp (Encoding, "A_AC3"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_AC3);
			else if(!strcmp (Encoding, "A_MP3") || !strcmp (Encoding, "A_MPEG/L3"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_MP3);
 			else if(!strcmp (Encoding, "A_DTS"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_DTS);
			else if(!strcmp (Encoding, "A_AAC"))
				ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_AAC);
            		else
                		ioctl( audiofd, AUDIO_SET_ENCODING, (void*)AUDIO_ENCODING_AUTO);

			ioctl(audiofd, AUDIO_PLAY, NULL); 
			free(Encoding);
		}
	return 0;
}

//////////////////////////////////////////////////////////

#define AC3_START_CODE                  0x0b77
#define AC3_START_CODE_MASK             0xffff
#define MP3_START_CODE                  0xffe0
#define MP3_START_CODE_MASK             0xffe0
#define AAC_AUDIO_PES_START_CODE        0xcf
#define AAC_START_CODE                  0xffe0
#define AAC_HEADER_LENGTH       7

typedef struct AACHeader_s
{
    unsigned char       Data[AAC_HEADER_LENGTH];
}AACHeader_t;

#define MPEG_AUDIO_PES_START_CODE               0xc0
#define PES_MAX_HEADER_SIZE                     64
#define PRIVATE_STREAM_1_PES_START_CODE         0xbd
#define MPEG_VIDEO_PES_START_CODE               0xe0
#define H264_VIDEO_PES_START_CODE               0xe2
#define PES_START_CODE_RESERVED_4               0xfd
#define PES_VERSION_FAKE_START_CODE     0x31
#define PCM_PES_START_CODE        		0xbd
    
/*#define BIG_READS*/
#if defined (BIG_READS)
#define BLOCK_COUNT                             8
#else
#define BLOCK_COUNT                             1
#endif
#define TP_PACKET_SIZE                          188
#define BD_TP_PACKET_SIZE                       192
#define NUMBER_PACKETS                          (199*BLOCK_COUNT)
#define BUFFER_SIZE                             (TP_PACKET_SIZE*NUMBER_PACKETS)
#define PADDING_LENGTH                          (1024*BLOCK_COUNT)

#define MAX_PES_PACKET_SIZE                     65400
#define INVALID_PTS_VALUE                       0x200000000ull

typedef struct MKV_BitPacker_s
{
    unsigned char*      Ptr;                                    /* write pointer */
    unsigned int        BitBuffer;                              /* bitreader shifter */
    int                 Remaining;                              /* number of remaining in the shifter */
#ifdef DEBUG_PUTBITS
    int                 debug;
#endif /* DEBUG_PUTBITS */
} MKV_BitPacker_t;
static void MKV_PutBits(MKV_BitPacker_t * ld, unsigned int code, unsigned int length)
{
    unsigned int bit_buf;
    int bit_left;

    bit_buf = ld->BitBuffer;
    bit_left = ld->Remaining;

#ifdef DEBUG_PUTBITS
    if (ld->debug)
        dprintf("code = %d, length = %d, bit_buf = 0x%x, bit_left = %d\n", code, length, bit_buf, bit_left);
#endif /* DEBUG_PUTBITS */

    if (length < bit_left)
    {
        /* fits into current buffer */
        bit_buf = (bit_buf << length) | code;
        bit_left -= length;
    }
    else
    {
        /* doesn't fit */
        bit_buf <<= bit_left;
        bit_buf |= code >> (length - bit_left);
        ld->Ptr[0] = (char)(bit_buf >> 24);
        ld->Ptr[1] = (char)(bit_buf >> 16);
        ld->Ptr[2] = (char)(bit_buf >> 8);
        ld->Ptr[3] = (char)bit_buf;
        ld->Ptr   += 4;
        length    -= bit_left;
        bit_buf    = code & ((1 << length) - 1);
        bit_left   = 32 - length;
    }

#ifdef DEBUG_PUTBITS
    if (ld->debug)
        dprintf("bit_left = %d, bit_buf = 0x%x\n", bit_left, bit_buf);
#endif /* DEBUG_PUTBITS */

    /* writeback */
    ld->BitBuffer = bit_buf;
    ld->Remaining = bit_left;
}

static void MKV_FlushBits(MKV_BitPacker_t * ld)
{
    ld->BitBuffer <<= ld->Remaining;
    while (ld->Remaining < 32)
    {
#ifdef DEBUG_PUTBITS
        if (ld->debug)
            dprintf("flushing 0x%2.2x\n", ld->BitBuffer >> 24);
#endif /* DEBUG_PUTBITS */
        *ld->Ptr++ = ld->BitBuffer >> 24;
        ld->BitBuffer <<= 8;
        ld->Remaining += 8;
    }
    ld->Remaining = 32;
    ld->BitBuffer = 0;
}
int MKV_InsertPesHeader (unsigned char *data, int size, unsigned char stream_id, unsigned long long int pts, int pic_start_code)
{
    MKV_BitPacker_t ld2 = {data, 0, 32};

    if (size>MAX_PES_PACKET_SIZE)
        dprintf("%s: Packet bigger than 63.9K eeeekkkkk\n",__FUNCTION__);

    MKV_PutBits(&ld2,0x0  ,8);
    MKV_PutBits(&ld2,0x0  ,8);
    MKV_PutBits(&ld2,0x1  ,8);  // Start Code
    MKV_PutBits(&ld2,stream_id ,8);  // Stream_id = Audio Stream
    //4
    MKV_PutBits(&ld2,size + 3 + (pts != INVALID_PTS_VALUE ? 5:0) + (pic_start_code ? (5) : 0),16); // PES_packet_length
    //6 = 4+2
    MKV_PutBits(&ld2,0x2  ,2);  // 10
    MKV_PutBits(&ld2,0x0  ,2);  // PES_Scrambling_control
    MKV_PutBits(&ld2,0x0  ,1);  // PES_Priority
    MKV_PutBits(&ld2,0x0  ,1);  // data_alignment_indicator
    MKV_PutBits(&ld2,0x0  ,1);  // Copyright
    MKV_PutBits(&ld2,0x0  ,1);  // Original or Copy
    //7 = 6+1

    if (pts!=INVALID_PTS_VALUE)
        MKV_PutBits(&ld2,0x2 ,2);
    else
        MKV_PutBits(&ld2,0x0 ,2);  // PTS_DTS flag

    MKV_PutBits(&ld2,0x0 ,1);  // ESCR_flag
    MKV_PutBits(&ld2,0x0 ,1);  // ES_rate_flag
    MKV_PutBits(&ld2,0x0 ,1);  // DSM_trick_mode_flag
    MKV_PutBits(&ld2,0x0 ,1);  // additional_copy_ingo_flag
    MKV_PutBits(&ld2,0x0 ,1);  // PES_CRC_flag
    MKV_PutBits(&ld2,0x0 ,1);  // PES_extension_flag
    //8 = 7+1

    if (pts!=INVALID_PTS_VALUE)
        MKV_PutBits(&ld2,0x5,8);
    else
        MKV_PutBits(&ld2,0x0 ,8);  // PES_header_data_length
    //9 = 8+1

    if (pts!=INVALID_PTS_VALUE)
    {
        MKV_PutBits(&ld2,0x2,4);
        MKV_PutBits(&ld2,(pts>>30) & 0x7,3);
        MKV_PutBits(&ld2,0x1,1);
        MKV_PutBits(&ld2,(pts>>15) & 0x7fff,15);
        MKV_PutBits(&ld2,0x1,1);
        MKV_PutBits(&ld2,pts & 0x7fff,15);
        MKV_PutBits(&ld2,0x1,1);
    }
    //14 = 9+5

    if (pic_start_code)
    {
        MKV_PutBits(&ld2,0x0 ,8);
        MKV_PutBits(&ld2,0x0 ,8);
        MKV_PutBits(&ld2,0x1 ,8);  // Start Code
        MKV_PutBits(&ld2,pic_start_code & 0xff ,8);  // 00, for picture start
        MKV_PutBits(&ld2,(pic_start_code >> 8 )&0xff,8);  // For any extra information (like in mpeg4p2, the pic_start_code)
        //14 + 4 = 18
    }

    MKV_FlushBits(&ld2);

    return (ld2.Ptr - data);

}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// dts                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define PES_AUDIO_PRIVATE_HEADER_SIZE   16                                // consider maximum private header size.
#define PES_AUDIO_HEADER_SIZE           (32 + PES_AUDIO_PRIVATE_HEADER_SIZE)
#define PES_AUDIO_PACKET_SIZE           2028
#define SPDIF_AUDIO_PACKET_SIZE         (1024 * sizeof(unsigned int) * 2) // stereo 32bit samples.
static int dts(unsigned char *PLAYERData, int DataLength, unsigned long long int Pts)
{
	//printf("%s::%s\n", FILENAME, __FUNCTION__);
    int i = 0;
    unsigned char               PesHeader[PES_AUDIO_HEADER_SIZE];
    memset (PesHeader, '0', PES_AUDIO_HEADER_SIZE);

    unsigned char * Data = 0;
    Data = (unsigned char *) malloc(DataLength);
    memcpy(Data, PLAYERData, DataLength);

    /* 16-bit byte swap all data before injecting it */
    for (i=0; i<DataLength; i+=2) 
    {
        unsigned char Tmp = Data[i];
        Data[i] = Data[i+1];
        Data[i+1] = Tmp;
    }
                        
    int HeaderLength    = MKV_InsertPesHeader (PesHeader, DataLength, MPEG_AUDIO_PES_START_CODE/*PRIVATE_STREAM_1_PES_START_CODE*/, Pts, 0);
    unsigned char* PacketStart = malloc(DataLength + HeaderLength);
    memcpy (PacketStart, PesHeader, HeaderLength);
    memcpy (PacketStart + HeaderLength, PLAYERData, DataLength);

    int len = write(audiofd,PacketStart,DataLength+HeaderLength);

    free(PacketStart);
    free(Data);

    return len;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// mp3                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static int mp3 (unsigned char *PLAYERData, int DataLength, unsigned long long int Pts)
{
	//printf("%s::%s %llu\n", FILENAME, __FUNCTION__, Pts);

    unsigned char  PesHeader[PES_MAX_HEADER_SIZE];

    int HeaderLength = MKV_InsertPesHeader (PesHeader, DataLength,MPEG_AUDIO_PES_START_CODE, Pts, 0);

        unsigned char* PacketStart = malloc(DataLength + HeaderLength);
    memcpy (PacketStart, PesHeader, HeaderLength);
    memcpy (PacketStart + HeaderLength, PLAYERData, DataLength);

    int len = write(audiofd,PacketStart,DataLength+HeaderLength);

    free(PacketStart);

    //printf("mp3_Write-< len=%d\n", len);
    return len;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// wma                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static int wmaInitialHeaderRequired = 1;

static int wma (unsigned char *PLAYERData, int DataLength, unsigned long long int Pts, void *private_data, unsigned int private_size)
{
	//printf("%s::%s %llu\n", FILENAME, __FUNCTION__, Pts);

    int len = 0;

    if (wmaInitialHeaderRequired) {

        unsigned char  PesHeader[PES_MAX_HEADER_SIZE];
        int HeaderLength = MKV_InsertPesHeader (PesHeader, private_size,MPEG_AUDIO_PES_START_CODE, 0, 0);

        unsigned char* PacketStart = malloc(private_size + HeaderLength);
        memcpy (PacketStart, PesHeader, HeaderLength);
        memcpy (PacketStart + HeaderLength, private_data, private_size);

        len = write(audiofd,PacketStart,private_size+HeaderLength);

        free(PacketStart);

        wmaInitialHeaderRequired = 0;
    }

    if(DataLength > 0 && PLAYERData)
    {
        unsigned char  PesHeader[PES_MAX_HEADER_SIZE];

        int HeaderLength = MKV_InsertPesHeader (PesHeader, DataLength,MPEG_AUDIO_PES_START_CODE, Pts, 0);

        unsigned char* PacketStart = malloc(DataLength + HeaderLength);
        memcpy (PacketStart, PesHeader, HeaderLength);
        memcpy (PacketStart + HeaderLength, PLAYERData, DataLength);

        len = write(audiofd,PacketStart,DataLength+HeaderLength);

        free(PacketStart);
    }

    //printf("wma-< len=%d\n", len);
    return len;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ac3                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static int ac3 (const unsigned char *PLAYERData, const int DataLength, unsigned long long int Pts)
{
	//printf("%s::%s\n", FILENAME, __FUNCTION__);

    unsigned char  PesHeader[PES_MAX_HEADER_SIZE];

    int HeaderLength = MKV_InsertPesHeader (PesHeader, DataLength, PRIVATE_STREAM_1_PES_START_CODE, Pts, 0);

    unsigned char* PacketStart = malloc(DataLength + HeaderLength);
    memcpy (PacketStart, PesHeader, HeaderLength);
    memcpy (PacketStart + HeaderLength, PLAYERData, DataLength);

    int len = write(audiofd,PacketStart,DataLength+HeaderLength);

    free(PacketStart);

    return len;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// aac_mpeg4                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static unsigned char DefaultAACHeader[]    =  { 0xff, 0xf1, /*0x00, 0x00*/0x50, 0x80, 0x00, 0x1f, 0xfc };//Trick: ob es bei allen geht??

int aac_mpeg4 (const unsigned char *PLAYERData, const int DataLength, unsigned long long int Pts, void *private_data, unsigned int private_size)
{
	//printf("%s::%s\n", FILENAME, __FUNCTION__);
    if(private_data==NULL)
    {
      //printf("private_data = NULL\n");
      private_data=DefaultAACHeader;
      private_size=7;
    }
    unsigned char PesHeader[PES_MAX_HEADER_SIZE];
    unsigned char ExtraData[AAC_HEADER_LENGTH];
    unsigned int  PacketLength    = DataLength + AAC_HEADER_LENGTH;

    memcpy (ExtraData, (AACHeader_t*)private_data, AAC_HEADER_LENGTH);
    ExtraData[3]       |= (PacketLength >> 12) & 0x3;
    ExtraData[4]        = (PacketLength >> 3) & 0xff;
    ExtraData[5]       |= (PacketLength << 5) & 0xe0;

    unsigned int  HeaderLength = MKV_InsertPesHeader (PesHeader, PacketLength, AAC_AUDIO_PES_START_CODE, Pts, 0);

    unsigned char* PacketStart = malloc(HeaderLength + sizeof(ExtraData) + DataLength);
    memcpy (PacketStart, PesHeader, HeaderLength);
    memcpy (PacketStart + HeaderLength, ExtraData, sizeof(ExtraData));
    memcpy (PacketStart + HeaderLength + sizeof(ExtraData), PLAYERData, DataLength);

    int len = write(audiofd, PacketStart, HeaderLength + DataLength + sizeof(ExtraData));
    
    free(PacketStart);
    
    return len;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// mpeg2                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static int mpeg2(unsigned char *PLAYERData, int DataLength, long long int Pts)
{
	//printf("%s::%s\n", FILENAME, __FUNCTION__);
    unsigned char               PesHeader[PES_MAX_HEADER_SIZE];
    int len = 0;

    
    int Position = 0;

    while(1) {
        int PacketLength = (DataLength-Position)<=MAX_PES_PACKET_SIZE?(DataLength-Position):MAX_PES_PACKET_SIZE;
        int Remaining = DataLength - Position - PacketLength;
        //dprintf("PacketLength=%d, Remaining=%d, Position=%d\n", PacketLength, Remaining, Position);
        int HeaderLength = MKV_InsertPesHeader (PesHeader, PacketLength, 0xe0, Pts, 0);
            unsigned char* PacketStart = malloc(PacketLength + HeaderLength);
        memcpy (PacketStart, PesHeader, HeaderLength);
        memcpy (PacketStart + HeaderLength, PLAYERData + Position, PacketLength);

        len = write(videofd,PacketStart,PacketLength+HeaderLength);
        free(PacketStart);

        Position += PacketLength;
        Pts = INVALID_PTS_VALUE;
        if (Position == DataLength)
            break;
    }

    return len;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// xvid                                                                        //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static int divx(unsigned char *PLAYERData, int DataLength, long long int Pts, unsigned int mpf)
{
	//printf("%s::%s\n", FILENAME, __FUNCTION__);
    //printf("\tmpf=%f\n", mpf);
    unsigned char  PesHeader[PES_MAX_HEADER_SIZE];

    //XVID IS LIKE DIVX5    

	unsigned char  FakeHeaders[64]; // 64bytes should be enough to make the fake headers
	unsigned int   FakeHeaderLength;
	unsigned char  Version             = 5;
	unsigned int   FakeStartCode       = (Version << 8) | PES_VERSION_FAKE_START_CODE;
	unsigned int   HeaderLength = 0;

	MKV_BitPacker_t ld = {FakeHeaders, 0, 32};
	memset(FakeHeaders, 0, sizeof(FakeHeaders));

    //{{{  Create info record for frame parser
        {
        // divx4 & 5
        // VOS
        //PutBits(&ld, 0x0, 8);
        //PutBits(&ld, 0x0, 8);
        MKV_PutBits(&ld, 0x1b0, 32);      // startcode 
        MKV_PutBits(&ld, 0, 8);           // profile = reserved 
        MKV_PutBits(&ld, 0x1b2, 32);      // startcode (user data)
        MKV_PutBits(&ld, 0x53545443, 32); // STTC - an embedded ST timecode from an avi file
        MKV_PutBits(&ld, mpf , 32);
                                                      // microseconds per frame
        MKV_FlushBits(&ld);
    }
    //}}}

    FakeHeaderLength    = (ld.Ptr - (FakeHeaders));

    HeaderLength        = MKV_InsertPesHeader (PesHeader, DataLength, MPEG_VIDEO_PES_START_CODE, Pts, FakeStartCode);
    unsigned char* PacketStart = malloc(DataLength + HeaderLength + FakeHeaderLength);
    memcpy (PacketStart, PesHeader, HeaderLength);
    memcpy (PacketStart + HeaderLength, FakeHeaders, FakeHeaderLength);
    memcpy (PacketStart + HeaderLength + FakeHeaderLength, PLAYERData, DataLength);

    int len = write(videofd,PacketStart,DataLength+HeaderLength+FakeHeaderLength);

    free(PacketStart);

    //dprintf("xvid_Write-< len=%d\n", len);
    return len;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// h264                                                                        //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static int h264InitialHeaderRequired = 1;
static unsigned int        NalLengthBytes          = 1;
typedef struct avcC_s
{
    unsigned char       Version;                /* configurationVersion        */
    unsigned char       Profile;                /* AVCProfileIndication        */
    unsigned char       Compatibility;          /* profile_compatibility       */
    unsigned char       Level;                  /* AVCLevelIndication          */
    unsigned char       NalLengthMinusOne;      /* held in bottom two bits     */
    unsigned char       NumParamSets;           /* held in bottom 5 bits       */
    unsigned char       Params[1];              /* {length,params}{length,params}...sequence then picture*/
}avcC_t;

const unsigned char Head[]                  = {0, 0, 0, 1};


static int h264(unsigned char *PLAYERData, int DataLength, unsigned long long int Pts, void *private_data, unsigned int private_size, unsigned int TimeDelta, unsigned int TimeScale)
{
	//printf("%s::%s %d %d\n", FILENAME, __FUNCTION__,TimeDelta,TimeScale);

    //unsigned int            TimeDelta = 23976;
    //unsigned int            TimeScale = 1000;

    unsigned char*          PacketStart = NULL;
    unsigned int            PacketStartSIZE = 0;
    unsigned int            HeaderLength;
    unsigned char           PesHeader[PES_MAX_HEADER_SIZE];
    unsigned long long int  VideoPts = Pts;

    int len = 0;

    if (h264InitialHeaderRequired) {
        unsigned char*  HeaderData = malloc(BUFFER_SIZE+PADDING_LENGTH);
        avcC_t*         avcCHeader          = (avcC_t*)private_data;
        int             i;
        unsigned int    ParamSets;
        unsigned int    ParamOffset;
        unsigned int    InitialHeaderLength     = 0;
        unsigned int    ParametersLength;

        if (avcCHeader->Version != 1)
            printf ("%s: Error unknown avcC version (%x). Expect problems.\n",__FUNCTION__, avcCHeader->Version);

#define NALU_TYPE_PLAYER2_CONTAINER_PARAMETERS          24
#define CONTAINER_PARAMETERS_VERSION                    0x00

        ParametersLength                      = 0;
        
        HeaderData[ParametersLength++]        = 0x00;                                         // Start code
        HeaderData[ParametersLength++]        = 0x00;
        HeaderData[ParametersLength++]        = 0x01;
        HeaderData[ParametersLength++]        = NALU_TYPE_PLAYER2_CONTAINER_PARAMETERS;
        // Container message version - changes when/if we vary the format of the message
        HeaderData[ParametersLength++]        = CONTAINER_PARAMETERS_VERSION; 
        HeaderData[ParametersLength++]        = 0xff;                                         // Field separator 

        if( TimeDelta == 0xffffffff )
            TimeDelta       = (TimeScale > 1000) ? 1001 : 1;

        HeaderData[ParametersLength++]        = (TimeScale >> 24) & 0xff;         // Output the timescale
        HeaderData[ParametersLength++]        = (TimeScale >> 16) & 0xff;
        HeaderData[ParametersLength++]        = 0xff;
        HeaderData[ParametersLength++]        = (TimeScale >> 8) & 0xff;
        HeaderData[ParametersLength++]        = TimeScale & 0xff;
        HeaderData[ParametersLength++]        = 0xff;

        HeaderData[ParametersLength++]        = (TimeDelta >> 24) & 0xff;         // Output frame period
        HeaderData[ParametersLength++]        = (TimeDelta >> 16) & 0xff;
        HeaderData[ParametersLength++]        = 0xff;
        HeaderData[ParametersLength++]        = (TimeDelta >> 8) & 0xff;
        HeaderData[ParametersLength++]        = TimeDelta & 0xff;
        HeaderData[ParametersLength++]        = 0xff;
        HeaderData[ParametersLength++]        = 0x80;                                         // Rsbp trailing bits

        HeaderLength = MKV_InsertPesHeader (PesHeader, ParametersLength, MPEG_VIDEO_PES_START_CODE, INVALID_PTS_VALUE, 0);

        PacketStart = malloc(HeaderLength + ParametersLength);
        PacketStartSIZE = HeaderLength + ParametersLength;
        memcpy (PacketStart, PesHeader, HeaderLength);
        memcpy (PacketStart + HeaderLength, HeaderData, ParametersLength);
        len += write (videofd, PacketStart, HeaderLength + ParametersLength);

        NalLengthBytes  = (avcCHeader->NalLengthMinusOne & 0x03) + 1;
        ParamSets       = avcCHeader->NumParamSets & 0x1f;
        printf( "%s: avcC contents:\n", __FUNCTION__);
        printf( "    version:                       %d\n", avcCHeader->Version);
        printf( "    profile:                       %d\n", avcCHeader->Profile);
        printf( "    profile compatibility:         %d\n", avcCHeader->Compatibility);
        printf( "    level:                         %d\n", avcCHeader->Level);
        printf( "    nal length bytes:              %d\n", NalLengthBytes);
        printf( "    number of sequence param sets: %d\n", ParamSets);

        ParamOffset     = 0;
        for (i = 0; i < ParamSets; i++) {
            unsigned int  PsLength = (avcCHeader->Params[ParamOffset] << 8) + avcCHeader->Params[ParamOffset+1];
            dprintf( "        sps %d has length           %d\n", i, PsLength);

            if (HeaderLength + InitialHeaderLength + sizeof(Head) > PacketStartSIZE) {
                PacketStart = realloc(PacketStart, HeaderLength + InitialHeaderLength + sizeof(Head));
                PacketStartSIZE = HeaderLength + InitialHeaderLength + sizeof(Head);
            }

            memcpy (PacketStart + HeaderLength + InitialHeaderLength, Head, sizeof(Head));
            InitialHeaderLength        += sizeof(Head);

            if (HeaderLength + InitialHeaderLength + PsLength > PacketStartSIZE) {
                PacketStart = realloc(PacketStart, HeaderLength + InitialHeaderLength + PsLength);
                PacketStartSIZE = HeaderLength + InitialHeaderLength + PsLength;
            }

            memcpy (PacketStart + HeaderLength + InitialHeaderLength, &avcCHeader->Params[ParamOffset+2], PsLength);

            InitialHeaderLength        += PsLength;
            ParamOffset                += PsLength+2;
        }

        ParamSets                       = avcCHeader->Params[ParamOffset];
        dprintf( "    number of picture param sets:  %d\n", ParamSets);
        ParamOffset++;
        for (i = 0; i < ParamSets; i++) {
            unsigned int  PsLength      = (avcCHeader->Params[ParamOffset] << 8) + avcCHeader->Params[ParamOffset+1];
            dprintf ("        pps %d has length           %d\n", i, PsLength);

            if (HeaderLength + InitialHeaderLength + sizeof(Head) > PacketStartSIZE) {
                PacketStart = realloc(PacketStart, HeaderLength + InitialHeaderLength + sizeof(Head));
                PacketStartSIZE = HeaderLength + InitialHeaderLength + sizeof(Head);
            }

            memcpy (PacketStart + HeaderLength + InitialHeaderLength, Head, sizeof(Head));
            InitialHeaderLength        += sizeof(Head);

            if (HeaderLength + InitialHeaderLength + PsLength > PacketStartSIZE) {
                PacketStart = realloc(PacketStart, HeaderLength + InitialHeaderLength + PsLength);
                PacketStartSIZE = HeaderLength + InitialHeaderLength + PsLength;
            }

            memcpy (PacketStart + HeaderLength + InitialHeaderLength, &avcCHeader->Params[ParamOffset+2], PsLength);
            InitialHeaderLength        += PsLength;
            ParamOffset                += PsLength+2;
        }

        HeaderLength    = MKV_InsertPesHeader (PesHeader, InitialHeaderLength, MPEG_VIDEO_PES_START_CODE, INVALID_PTS_VALUE, 0);
        memcpy (PacketStart, PesHeader, HeaderLength);
                
        len += write (videofd, PacketStart, HeaderLength + InitialHeaderLength);

        h264InitialHeaderRequired           = 0;

        free(PacketStart);
        free(HeaderData);
    }

    unsigned int SampleSize    = DataLength;
    unsigned int NalStart      = 0;
    unsigned int VideoPosition = 0;
                        
    do {
        unsigned int   NalLength;
        unsigned char  NalData[4];
        int           NalPresent       = 1;

        memcpy (NalData, PLAYERData+VideoPosition, NalLengthBytes);
        VideoPosition+= NalLengthBytes;
        NalLength       = (NalLengthBytes == 1) ?  NalData[0] :
        (NalLengthBytes == 2) ? (NalData[0] <<  8) |  NalData[1] :
        (NalLengthBytes == 3) ? (NalData[0] << 16) | (NalData[1] <<  8) |  NalData[2] :
                                (NalData[0] << 24) | (NalData[1] << 16) | (NalData[2] << 8) | NalData[3];

        //printf("NalStart = %u + NalLength = %u > SampleSize = %u\n", NalStart, NalLength, SampleSize);

        if (NalStart + NalLength > SampleSize) {
            printf("%s: nal length past end of buffer - size %u frame offset %u left %u\n",__FUNCTION__,
                NalLength, NalStart , SampleSize - NalStart );
            NalStart    = SampleSize;
        } else {
            NalStart               += NalLength + NalLengthBytes;
            while (NalLength > 0) {
                unsigned int   PacketLength     = (NalLength < BUFFER_SIZE) ? NalLength : BUFFER_SIZE;
                int            ExtraLength      = 0;
                unsigned char* PacketStart;

                NalLength      -= PacketLength;
                    
                if (NalPresent) {
                    PacketStart     = malloc(sizeof(Head) + PacketLength);
                    memcpy (PacketStart+sizeof(Head), PLAYERData+VideoPosition, PacketLength);
                    VideoPosition    += PacketLength;

                    memcpy (PacketStart, Head, sizeof(Head));
                    ExtraLength    = sizeof(Head);
                } else {
                    PacketStart     = malloc(PacketLength);
                    memcpy (PacketStart, PLAYERData+VideoPosition, PacketLength);
                    VideoPosition    += PacketLength;
                }

                PacketLength   += ExtraLength;

//printf ("%s:  pts=%llu\n", __FUNCTION__, VideoPts);

                HeaderLength    = MKV_InsertPesHeader (PesHeader, PacketLength, MPEG_VIDEO_PES_START_CODE, VideoPts, 0);
                                        

                unsigned char*    WritePacketStart = malloc(HeaderLength + PacketLength);
                memcpy (WritePacketStart,              PesHeader,   HeaderLength);
                memcpy (WritePacketStart+HeaderLength, PacketStart, PacketLength);
                free(PacketStart);

                PacketLength   += HeaderLength;
                len += write (videofd, WritePacketStart, PacketLength);
                free(WritePacketStart);

                NalPresent      = 0;
                VideoPts        = INVALID_PTS_VALUE;
            }
        }
    } while (NalStart < SampleSize);

    return len;
}

static int Write(Context_t  *context, const unsigned char *PLAYERData, const int DataLength, const unsigned long long int Pts, const unsigned char *Private, const int PrivateLength, float FrameRate, char * type) {

	//printf("%s::%s DataLength=%u PrivateLength=%u Pts=%llu\n", FILENAME, __FUNCTION__, DataLength, PrivateLength, Pts);

	unsigned char video = !strcmp("video", type);
	unsigned char audio = !strcmp("audio", type);
	unsigned int TimeDelta;
	unsigned int TimeScale;
	//printf("%s::%s v%d a%d\n", FILENAME, __FUNCTION__, video, audio);

	if (video) {
			char * Encoding = NULL;
			context->manager->video->Command(context, MANAGER_GETENCODING, &Encoding);

	//printf("%s::%s %s\n", FILENAME, __FUNCTION__, Encoding);

			if(!strcmp (Encoding, "V_MPEG2") || !strcmp (Encoding, "V_MPEG2/H264"))
				mpeg2(PLAYERData, DataLength, Pts);
			else if(!strcmp (Encoding, "V_MPEG4/ISO/AVC")){
				switch((int)FrameRate){
					case 41708:
						// 23.976fps
						TimeDelta = 23976;
						TimeScale = 1000;
						break;
					case 40000:
						//FIXME asyncron!!!
						// 24.976fps
						TimeDelta = 25000;
						TimeScale = 1000;
						break;
					case 33367:
						// 29.976fps
						TimeDelta = 30000;
						TimeScale = 1000;
						break;
					default:
						TimeDelta = 23976;
						TimeScale = 1000;
						break;
				}
				h264(PLAYERData, DataLength, Pts, Private, PrivateLength,TimeDelta,TimeScale);
			}
 			else if(!strcmp (Encoding, "V_MSCOMP") || !strcmp (Encoding, "V_MS/VFW/FOURCC") || !strcmp (Encoding, "V_MKV/XVID"))
				divx(PLAYERData, DataLength, Pts, FrameRate);
			free(Encoding);
	} else if (audio) {
			char * Encoding = NULL;
			context->manager->audio->Command(context, MANAGER_GETENCODING, &Encoding);

	//printf("%s::%s %s\n", FILENAME, __FUNCTION__, Encoding);

			if(!strcmp (Encoding, "A_AC3"))
				ac3(PLAYERData, DataLength, Pts);
			else if(!strcmp (Encoding, "A_MP3") || !strcmp (Encoding, "A_MPEG/L3") || !strcmp (Encoding, "A_MS/ACM"))
				mp3(PLAYERData, DataLength, Pts);
			else if(!strcmp (Encoding, "A_AAC"))
				aac_mpeg4 (PLAYERData, DataLength, Pts, Private, PrivateLength);
 			else if(!strcmp (Encoding, "A_DTS"))
				dts(PLAYERData, DataLength, Pts);
 			else if(!strcmp (Encoding, "A_WMA"))
				wma(PLAYERData, DataLength, Pts, Private, PrivateLength);
			else printf("unknown audio codec %s\n",Encoding);
			free(Encoding);
	}

	return 0;
}

static int Command(Context_t  *context, OutputCmd_t command, void * argument) {
	//printf("%s::%s\n", FILENAME, __FUNCTION__);

	switch(command) {
		case OUTPUT_OPEN: {
			LinuxDvbOpen(context, (char*)argument);
			break;
		}
		case OUTPUT_CLOSE: {
			LinuxDvbClose(context, (char*)argument);
            h264InitialHeaderRequired = 1;
            wmaInitialHeaderRequired = 1;
            sCURRENT_PTS = 0;
			break;
		}
		case OUTPUT_PLAY: {
            h264InitialHeaderRequired = 1;
            wmaInitialHeaderRequired = 1;
            sCURRENT_PTS = 0;
			LinuxDvbPlay(context, (char*)argument);
			break;
		}
		case OUTPUT_STOP: {
			LinuxDvbStop(context, (char*)argument);
            h264InitialHeaderRequired = 1;
            wmaInitialHeaderRequired = 1;
            sCURRENT_PTS = 0;
			break;
		}
		case OUTPUT_FLUSH: {
			LinuxDvbFlush(context, (char*)argument);
            h264InitialHeaderRequired = 1;
            wmaInitialHeaderRequired = 1;
            sCURRENT_PTS = 0;
			break;
		}
		case OUTPUT_PAUSE: {
			LinuxDvbPause(context, (char*)argument);
			break;
		}
		case OUTPUT_CONTINUE: {
			LinuxDvbContinue(context, (char*)argument);
			break;
		}
		case OUTPUT_FASTFORWARD: {
			return LinuxDvbFastForward(context, (char*)argument);
			break;
		}
		case OUTPUT_AVSYNC: {
			LinuxDvbAVSync(context, (char*)argument);
			break;
		}
		case OUTPUT_CLEAR: {
			LinuxDvbClear(context, (char*)argument);
			break;
		}
		case OUTPUT_PTS: {
			unsigned long long int pts = 0;
			LinuxDvbPts(context, &pts);
			*((unsigned long long int*)argument) = (unsigned long long int)pts;
			break;
		}
		case OUTPUT_SWITCH: {
			LinuxDvbSwitch(context, (char*)argument);
			break;
		}
		default:
			printf("OutputCmd not supported!");
			break;
	}


	return 0;
}

static char *LinuxDvbCapabilities[] = { "audio", "video", NULL };

struct Output_s LinuxDvbOutput = {
	"LinuxDvb",
	&Command,
	&Write,
	LinuxDvbCapabilities,

};
