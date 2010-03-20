#include <stdio.h> 
#include <string.h>
#include <stdlib.h> 
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h> 
#include <memory.h>
#include <asm/types.h>
#include <pthread.h>
#include <errno.h>

#include "common.h"
#include "output.h"

#ifndef DEBUG
#define DEBUG	// FIXME: until this is set properly by Makefile
#endif

static const char FILENAME[] = "enigma2.c";

/*
Number, Style, Name,, MarginL, MarginR, MarginV, Effect,, Text

1038,0,tdk,,0000,0000,0000,,That's not good.
1037,0,tdk,,0000,0000,0000,,{\i1}Rack them up, rack them up,{\i0}\N{\i1}rack them up.{\i0} [90]
1036,0,tdk,,0000,0000,0000,,Okay, rack them up.
*/

void replace_all(char ** string, char * search, char * replace) {

	int len = 0;
    char * ptr = NULL;
    char tempString[512];
    char newString[512];
    newString[0] = '\0';
    strncpy(tempString, *string, 511);
    tempString[511] = '\0';

    free(*string);

    

    while ((ptr = strstr(tempString, search)) != NULL) {
        len  = ptr - tempString;
        strncpy(newString, tempString, len);
        newString[len] = '\0';
        strcat(newString, replace);

        len += strlen(search);
	    strcat(newString, tempString+len);

        strcpy(tempString, newString);
    }
	printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
    if(newString[0] != '\0')
        *string = strdup(newString);
    else
        *string = strdup(tempString);

}

int Enigma2ParseASS (char **Line) {
    printf("%s::%s -> Text=%s\n",  FILENAME, __FUNCTION__, *Line);
	printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
    char * Text = strdup(*Line);
    int i;
    char *ptr1;
    
    ptr1 = Text;
    for (i=0; i < 8 && *ptr1 != '\0'; ptr1++) {
        //printf("%s",ptr1);
        if (*ptr1 == ',')
            i++;
    }

    free(*Line);
	printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
    *Line = strdup(ptr1);
    free(Text);

    replace_all(Line, "\\N", "\n");

    replace_all(Line, "{\\i1}", "<i>");
    replace_all(Line, "{\\i0}", "</i>");

    printf("%s::%s <- Text=%s\n",  FILENAME, __FUNCTION__, *Line);
    return;
}

int Enigma2ParseSRT (char **Line) {
    //printf("%s::%s -> Text=%s\n",  FILENAME, __FUNCTION__, *Line);

    replace_all(Line, "\x0d", "");
    replace_all(Line, "\n\n", "\\N");
    replace_all(Line, "\n", "");
    replace_all(Line, "\\N", "\n");

    //printf("%s::%s <- Text=%s\n",  FILENAME, __FUNCTION__, *Line);
    return;
}

int Enigma2ParseSSA (char **Line) {
    //printf("%s::%s -> Text=%s\n",  FILENAME, __FUNCTION__, *Line);

    replace_all(Line, "\x0d", "");
    replace_all(Line, "\n\n", "\\N");
    replace_all(Line, "\n", "");
    replace_all(Line, "\\N", "\n");

    //printf("%s::%s <- Text=%s\n",  FILENAME, __FUNCTION__, *Line);
    return;
}

static pthread_t thread_sub = 0;
void * _smp3 = NULL;
void (*_fkt) (long int, size_t, char *, void *);

int eplayerCreateSubtitleSink()
{
    printf("eplayerCreateSubtitleSink->\n");
  
    return 0;
}

struct sub_t{
    char * text;
    unsigned long long int pts;
    unsigned long int milliDuration;
};

#define PUFFERSIZE 2
static struct sub_t subPuffer[PUFFERSIZE];
static int nextSubPointer = 0;
static int freeSubPointer = 0;


void addSub(Context_t  *context, char ** text, unsigned long long int pts, unsigned long int milliDuration) {
    printf("%s::%s\n",  FILENAME, __FUNCTION__);

    if(context && context->playback && !context->playback->isPlaying)
        return;

    while (subPuffer[freeSubPointer].text != NULL) {
        //List is full, wait till we got some free space

        if(context && context->playback && !context->playback->isPlaying)
            return;

        sleep(1);
    }
    //printf("from mkv: %s pts:%lld milliDuration:%lld\n",text,pts,milliDuration);
	printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
    subPuffer[freeSubPointer].text = strdup(text);
    subPuffer[freeSubPointer].pts = pts;
    subPuffer[freeSubPointer].milliDuration = milliDuration;

    freeSubPointer++;
    freeSubPointer%=PUFFERSIZE;

}

int getNextSub(char ** text, unsigned long long int * pts, long int * milliDuration) {
    printf("%s::%s\n",  FILENAME, __FUNCTION__);
    if (subPuffer[nextSubPointer].text == NULL || 
        subPuffer[nextSubPointer].pts == 0 || 
        subPuffer[nextSubPointer].milliDuration == 0) {

        return -1;
    }
	printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
    *text = strdup(subPuffer[nextSubPointer].text);
    free(subPuffer[nextSubPointer].text);
    subPuffer[nextSubPointer].text = NULL;

    *pts = subPuffer[nextSubPointer].pts;
    subPuffer[nextSubPointer].pts = 0;

    *milliDuration = subPuffer[nextSubPointer].milliDuration;
    subPuffer[nextSubPointer].milliDuration = 0;

    nextSubPointer++;
    nextSubPointer%=PUFFERSIZE;
    //printf("nextSubPointer %d\n",nextSubPointer);

    return 0;
} 

static void Enigma2SubtitleThread(Context_t *context) {
    printf("%s::%s\n",  FILENAME, __FUNCTION__);
    char *                  subText             = NULL;
    long int                subMilliDuration    = 0;
    unsigned long long int  subPts              = 0;
    unsigned long long int  Pts                 = 0;
    
    //wait a little, so isPlaying is set
    sleep(1);

    while ( context && 
            context->playback && 
            context->playback->isPlaying) {

        int curtrackid = -1;
        if (context && context->manager && context->manager->subtitle)
            context->manager->subtitle->Command(context, MANAGER_GET, &curtrackid);

        if (curtrackid >= 0) {
            if (getNextSub(&subText, &subPts, &subMilliDuration) != 0) {
                usleep(500000);
                continue;
            }

            if (context && context->playback)
                context->playback->Command(context, PLAYBACK_PTS, &Pts);
            else return;

           if(Pts > subPts) {
                if(subText != NULL)
                    free(subText);
                continue;
            }
                
            printf("%s::%s %llu < %llu\n", FILENAME, __FUNCTION__, Pts, subPts);

            while ( context && 
                    context->playback && 
                    context->playback->isPlaying && 
                    Pts < subPts) {

                unsigned long int diff = subPts - Pts;
                diff = (diff*1000)/90.0;
                printf("DIFF: %d\n", diff);
                if(diff > 100)
                    usleep(diff);

                if (context && context->playback)
                    context->playback->Command(context, PLAYBACK_PTS, &Pts);
                else return;

                printf("%s::%s cur: %llu wanted: %llu\n", FILENAME, __FUNCTION__, Pts, subPts);
            }

            if (    context && 
                    context->playback && 
                    context->playback->isPlaying &&
                    subText != NULL ) {

                if(_fkt != NULL)
                  _fkt(subMilliDuration, strlen(subText), subText, _smp3);
                else
                  printf("%s::%s \{%ld\} \[%d\] \"%s\"\n", FILENAME,__FUNCTION__, subMilliDuration, strlen(subText), subText);

                free(subText);
            }
                
        } else //Wait
            usleep(500000);

    }
}




static int Write(Context_t  *context, const unsigned char *PLAYERData, const int DataLength, const unsigned long long int Pts, const unsigned char *Private, const int PrivateLength, float Duration, char * type) {
	//printf("%s::%s\n", FILENAME, __FUNCTION__);

	char * Encoding = NULL;
	char * Text = strdup(PLAYERData);

	context->manager->subtitle->Command(context, MANAGER_GETENCODING, &Encoding);

	printf("%s::%s %s\n",       FILENAME, __FUNCTION__, Encoding);
	printf("%s::%s %s [%d]\n",  FILENAME, __FUNCTION__, Text, DataLength);


    if(     !strncmp("S_TEXT/SSA",  Encoding, 10) || 
            !strncmp("S_SSA",       Encoding, 5))
        Enigma2ParseSSA(&Text);
    else if(!strncmp("S_TEXT/ASS",  Encoding, 10) || 
            !strncmp("S_AAS",       Encoding, 5))
        Enigma2ParseASS(&Text);
    else if(!strncmp("S_TEXT/SRT",  Encoding, 10) || 
            !strncmp("S_SRT",       Encoding, 5))
        Enigma2ParseSRT(&Text);
    else
        ;

    //printf("%s::%s %s\n",  FILENAME, __FUNCTION__, Text);

    addSub(context, Text, Pts, Duration * 1000);
    free(Text);
    free(Encoding);

	return 0;
}

static int Enigma2Open(context) {
    printf("%s::%s\n",  FILENAME, __FUNCTION__);
    //Reset all
    nextSubPointer = 0;
    freeSubPointer = 0;
    int i;
	for (i = 0; i < PUFFERSIZE; i++) {
        subPuffer[i].text          = NULL;
        subPuffer[i].pts           = 0;
        subPuffer[i].milliDuration = 0;
    }

    return 0;
}

static int Enigma2Close(context) {
    printf("%s::%s\n",  FILENAME, __FUNCTION__);
    //Reset all
    nextSubPointer = 0;
    freeSubPointer = 0;
    int i;
	for (i = 0; i < PUFFERSIZE; i++) {
        subPuffer[i].text          = NULL;
        subPuffer[i].pts           = 0;
        subPuffer[i].milliDuration = 0;
    }

    return 0;
}

static int Enigma2Play(context) {
    printf("%s::%s\n",  FILENAME, __FUNCTION__);
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    pthread_create (&thread_sub, &attr, &Enigma2SubtitleThread, context);   

    return 0;
}

static int Enigma2Stop(context) {
    printf("%s::%s\n",  FILENAME, __FUNCTION__);
    //pthread_join (&thread_sub, NULL, &sub_loop, NULL);

    return 0;
}

void Enigma2SignalConnect(void (*fkt) (long int, size_t, char *, void *))
{
    printf("%s::%s\n",  FILENAME, __FUNCTION__);

    _fkt = fkt;
}

void Enigma2SignalConnectBuffer(void* smp3)
{
    printf("%s::%s\n",  FILENAME, __FUNCTION__);

    _smp3 = smp3;   
}

static int Command(Context_t  *context, OutputCmd_t command, void * argument) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	
	int ret = 0;

	switch(command) {
		case OUTPUT_OPEN: {
			Enigma2Open(context);
			break;
		}
		case OUTPUT_CLOSE: {
			Enigma2Close(context);
			break;
		}
		case OUTPUT_PLAY: {
			Enigma2Play(context);
			break;
		}
		case OUTPUT_STOP: {
			Enigma2Stop(context);
			break;
		}
		case OUTPUT_SWITCH: {
			//Enigma2Switch(context, (char*)argument);
			break;
		}
		case 222: { //Subtitle function register hack
		    Enigma2SignalConnect(argument);
		    break;
		}
		case 223: { //Subtitle buffer register hack
		    Enigma2SignalConnectBuffer(argument);
		    break;
		}
		/*case OUTPUT_FLUSH: {
			Enigma2Flush(context, (char*)argument);
			break;
		}
		case OUTPUT_PAUSE: {
			Enigma2Pause(context, (char*)argument);
			break;
		}
		case OUTPUT_CONTINUE: {
			Enigma2Continue(context, (char*)argument);
			break;
		}*/

		default:
#ifdef DEBUG
			printf("%s::%s OutputCmd %d not supported!\n", FILENAME, __FUNCTION__, command);
#endif
			break;
	}

#ifdef DEBUG
	printf("%s::%s exiting with value %d\n", FILENAME, __FUNCTION__, ret);
#endif

	return ret;
}


static char *Enigma2Capabilitis[] = { "subtitle", NULL };

struct Output_s Enigma2Output = {
	"Enigma2",
	&Command,
	&Write,
	Enigma2Capabilitis,

};

