#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netdb.h>
#include <sys/types.h>
#include <dirent.h>
#include <pthread.h>
#include <errno.h>

//#ifndef DEBUG
//#define DEBUG	// FIXME: until this is set properly by Makefile
//#endif

static const char FILENAME[] = "text_srt.c";
#define TEXTSRTOFFSET 100

#include "common.h"
static pthread_t thread_sub = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct {
    char * File;
    int Id;
} SrtTrack_t;

#define TRACKWRAP 20
static SrtTrack_t * Tracks;
static int TrackCount = 0;
static int CurrentTrack = -1; //no as default.

static void SrtManagerAdd(Context_t  *context, SrtTrack_t track) {
#ifdef DEBUG
	printf("%s::%s %s %d\n", FILENAME, __FUNCTION__, track.File, track.Id);
#endif

	if (Tracks == NULL) {
		Tracks = malloc(sizeof(SrtTrack_t) * TRACKWRAP);
	}
	
	if (TrackCount < TRACKWRAP) {
#ifdef DEBUG
		printf("2strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
		Tracks[TrackCount].File       = strdup(track.File);
        Tracks[TrackCount].Id         = track.Id;
        TrackCount++;
	} else {
		//Track_t * tmp_Tracks = realoc(sizeof(Tracks));
	}
}

static char ** SrtManagerList(Context_t  *context) {
	char ** tracklist = NULL;
#ifdef DEBUG
	printf("%s::%s\n", FILENAME, __FUNCTION__);
#endif
	if (Tracks != NULL) {
		int i = 0, j = 0;
		tracklist = malloc(sizeof(char *) * ((TrackCount*2) + 1));
		for (i = 0, j = 0; i < TrackCount; i++, j+=2) {
#ifdef DEBUG
			printf("2strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
      tracklist[j]    = strdup(Tracks[i].Id);
			tracklist[j+1]    = strdup(Tracks[i].File);
		}
    tracklist[j] = NULL;
	}

	return tracklist;
}

static void SrtManagerDel(Context_t * context) {

    int i = 0;
    if(Tracks != NULL) {
        for (i = 0; i < TrackCount; i++) {
		    free(Tracks[i].File);
            Tracks[i].File = NULL;
	    }
	    free(Tracks);
        Tracks = NULL;
    }

    TrackCount = 0;
    CurrentTrack = -1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

static void getExtension(char * FILENAMEname, char ** extension) {

	int i = 0;
	int stringlength = (int) strlen(FILENAMEname);
#ifdef DEBUG
	printf("%s::%s\n", FILENAME, __FUNCTION__);
#endif
	for (i = 0; stringlength - i > 0; i++) {
		if (FILENAMEname[stringlength - i - 1] == '.') {
#ifdef DEBUG
			printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
			*extension = strdup(FILENAMEname+(stringlength - i));
			break;
		}
	}
}

static void getParentFolder(char * Filename, char ** folder) {
#ifdef DEBUG
	printf("%s::%s\n", FILENAME, __FUNCTION__);
#endif

	int i = 0;
	int stringlength = strlen(Filename);

	for (i = 0; stringlength - i > 0; i++) {
		if (Filename[stringlength - i - 1] == '/') {
      char* sTmp = (char *)malloc(stringlength - i);
			strncpy(sTmp, Filename, stringlength - i - 1);
      sTmp[stringlength - i -1] = '\0';
#ifdef DEBUG
			printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
      *folder = strdup(sTmp);
      free(sTmp);
			break;
		}
	}
}

static void SrtGetSubtitle(Context_t  *context, char * Filename) {
#ifdef DEBUG
		printf("%s::%s\n", FILENAME, __FUNCTION__);
#endif

    struct dirent *dirzeiger;
    DIR  *  dir;
    int     i                    = TEXTSRTOFFSET;
    char *  FilenameExtension    = NULL;
    char *  FilenameFolder       = NULL;
    char *  FilenameShort        = NULL;
    int     FilenameLength          = 0;
    int     FilenameShortLength     = 0;
    int     FilenameFolderLength    = 0;
    int     FilenameExtensionLength = 0;

    FilenameLength = strlen(Filename);

#ifdef DEBUG
    printf("%s::%s %s %d\n", FILENAME, __FUNCTION__, Filename, FilenameLength);
#endif

    getParentFolder(Filename, &FilenameFolder);
    FilenameFolderLength = strlen(FilenameFolder);

#ifdef DEBUG
    printf("%s::%s %s %d\n", FILENAME, __FUNCTION__, FilenameFolder, FilenameFolderLength);
#endif

    getExtension(Filename, &FilenameExtension);
    FilenameExtensionLength = strlen(FilenameExtension);

#ifdef DEBUG
    printf("%s::%s %s %d\n", FILENAME, __FUNCTION__, FilenameExtension, FilenameExtensionLength);
#endif

    FilenameShortLength = FilenameLength - FilenameFolderLength - 1 /* / */ - FilenameExtensionLength - 1 /* . */;
    FilenameShort = (char*) malloc(FilenameShortLength + 1 /* \0 */);
    strncpy(FilenameShort, Filename + (strlen(FilenameFolder) + 1 /* / */), FilenameShortLength);
    FilenameShort[FilenameShortLength] = '\0';

#ifdef DEBUG
    printf("%s::%s %s %d\n", FILENAME, __FUNCTION__, FilenameShort, FilenameShortLength);
    printf("%s\n%s | %s | %s\n", Filename, FilenameFolder, FilenameShort, FilenameExtension);
#endif

    if((dir=opendir(FilenameFolder)) != NULL) {
        while((dirzeiger=readdir(dir)) != NULL) {
            char * extension = NULL;

#ifdef DEBUG
            printf("%s\n",(*dirzeiger).d_name);
#endif
            getExtension((*dirzeiger).d_name, &extension);

            if(extension != NULL) {
                if(!strncmp(extension, "srt", 3)) {
                    //often the used language is added before .srt so check
                    char * name = NULL;
                    char * subExtension = NULL;
                    char * language = NULL;
                    int nameLength = strlen((*dirzeiger).d_name) - 4;

                    name = (char*) malloc(nameLength + 1);
                    strncpy(name, (*dirzeiger).d_name, nameLength);
                    name[nameLength] = '\0';
                    
                    getExtension(name, &subExtension);
#ifdef DEBUG
                    printf("%s %s\n",name, subExtension);
#endif

                    if(subExtension == NULL) {
#ifdef DEBUG
												printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
                        language = strdup("und");

                    } else {
                        int tmpLength = strlen(name)/* - strlen(subExtension) - 1*/; //Trick: FIX sub "test.test.srt"
                        char * tmpName = (char*) malloc(tmpLength + 1);
                        strncpy(tmpName, name, tmpLength);
                        tmpName[tmpLength] = '\0';

                        free(name);
#ifdef DEBUG
												printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
                        name = strdup(tmpName);
                        free(tmpName);
#ifdef DEBUG
												printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
                        language = strdup(subExtension);
                        free(subExtension);
                    }

#ifdef DEBUG
                    printf("%s %s %d\n",name, FilenameShort, FilenameShortLength);
#endif

                    if(!strncmp(name, FilenameShort, FilenameShortLength)) {
                        char * absSubtitleFilenam = (char*) malloc(strlen(FilenameFolder) + 1 + strlen((*dirzeiger).d_name));
                        strcpy(absSubtitleFilenam, FilenameFolder);
                        strcat(absSubtitleFilenam, "/");
                        strcat(absSubtitleFilenam, (*dirzeiger).d_name);

                        SrtTrack_t SrtSubtitle = {
				            absSubtitleFilenam,
				            i,
			            };
                        SrtManagerAdd(context, SrtSubtitle);

                        Track_t Subtitle = {
				            language,
				            "S_TEXT/SRT",
				            i++,
			            };
                        context->manager->subtitle->Command(context, MANAGER_ADD, &Subtitle);
                    }

                }

                free(extension);
            }
        }
    }

    free(FilenameExtension);
    free(FilenameFolder);
    free(FilenameShort);

}


FILE * fsub = NULL;
#define MAXLINELENGTH 80

static int SrtOpenSubtitle(Context_t *context, int trackid) {

    if(trackid < TEXTSRTOFFSET) {
        return -1;
    }

    trackid %= TEXTSRTOFFSET;

#ifdef DEBUG
    printf("%s::%s %s\n", FILENAME, __FUNCTION__, Tracks[trackid].File);
#endif

    fsub = fopen(Tracks[trackid].File, "rb");
#ifdef DEBUG
    printf("%s::%s %s\n", FILENAME, __FUNCTION__, fsub?"fsub!=NULL":"fsub==NULL");
#endif
    if(!fsub)
        return -1;

    return 0;
}

static int SrtCloseSubtitle(Context_t *context) {

    if(fsub)
        fclose(fsub);

    fsub = NULL;

    return 0;
}


static void SrtSubtitleThread(Context_t *context) {
#ifdef DEBUG
		printf("%s::%s\n", FILENAME, __FUNCTION__);
#endif
    int pos = 0;
    char  Data[MAXLINELENGTH];
    unsigned long long int Pts = 0;
    float Duration = 0;
    char * Text = NULL;

    while(context->playback->isPlaying && fsub && fgets(Data, MAXLINELENGTH, fsub)) {
#ifdef DEBUG
				printf("%s::%s pos=%d\n", FILENAME, __FUNCTION__, pos);
#endif
        if(pos == 0) {
            //int numScene = 0;
            //ret = sscanf(line, "%li", &numScene);
            pos++; 

        } else if(pos == 1) {
            int ret, horIni, minIni, secIni, milIni, horFim, minFim, secFim, milFim;

            ret = sscanf(Data, "%d:%d:%d,%d --> %d:%d:%d,%d", &horIni, &minIni, &secIni, &milIni, &horFim, &minFim, &secFim, &milFim);

            Pts = (horIni*3600 + minIni*60 + secIni)*1000 + milIni;
	        Duration = ((horFim*3600 + minFim*60 + secFim) * 1000  + milFim - Pts) / 1000.0;
	        Pts = Pts * 90;

            pos++;

        } else if(pos == 2) {
#ifdef DEBUG
            printf("Data[0] = %d \'%c\'\n", Data[0], Data[0]);
#endif
            if(Data[0] == '\n' || Data[0] == '\0' || Data[0] == 13 /* ^M */) {
#ifdef DEBUG
                printf("--> Text= \"%s\"\n", Text);
#endif
                context->output->subtitle->Write(context, Text, strlen(Text), Pts, NULL, 0, Duration, "subtitle");
#ifdef DEBUG
                printf("<-- Text= \"%s\"\n", Text);
#endif
                free(Text);
                Text = NULL;
                pos = 0;
                continue;
            }
            
            if(!Text) {
#ifdef DEBUG
								printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
                Text = strdup(Data);
                
                Text[-1] = '\0';
            } else {
                int length = strlen(Text) /* \0 -> \n */ + strlen(Data) + 2 /* \0 */;
#ifdef DEBUG
                printf("Alloc: %d\n", length);
								printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
#endif
                char * tmpText = strdup(Text);
                free(Text);
                Text = (char*)malloc(length);
                strcpy(Text, tmpText);
                strcat(Text, "\n");
                strcat(Text, Data);
                free(tmpText);
            }

            int len = strlen(Text);
        }
    }
    if(Text) {
        free(Text);
        Text = NULL;
    }

}

static int SrtPlay(Context_t *context) {
#ifdef DEBUG
    printf("%s::%s\n",  FILENAME, __FUNCTION__);
#endif

    int curtrackid = -1;
    context->manager->subtitle->Command(context, MANAGER_GET, &curtrackid);

    if(SrtOpenSubtitle(context, curtrackid) == 0){
	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
        pthread_create (&thread_sub, &attr, &SrtSubtitleThread, context);   
    }
    return 0;
}

static int SrtSwitchSubtitle(Context_t *context, int* arg) {

    SrtCloseSubtitle(context);

    if(SrtOpenSubtitle(context, *arg)==0){
	 pthread_attr_t attr;
	 pthread_attr_init(&attr);
	 pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
         pthread_create (&thread_sub, &attr, &SrtSubtitleThread, context);   
    }
    return 0;
}

static int SrtDel(Context_t *context) {

    SrtCloseSubtitle(context);
    SrtManagerDel(context);
    return 0;
}

static int Command(Context_t  *context, ContainerCmd_t command, void * argument) {
#ifdef DEBUG
	printf("%s::%s\n", FILENAME, __FUNCTION__);
#endif

	switch(command) {
		case CONTAINER_INIT: {
			char * filename = (char *)argument;
			SrtGetSubtitle(context, filename);
			break;
		}
		case CONTAINER_PLAY: {
			SrtPlay(context);
			break;
		}
		case CONTAINER_DEL: {
			SrtDel(context);
			break;
		}
		case CONTAINER_SWITCH_SUBTITLE: {
#ifdef DEBUG
        printf("%s::%s CONTAINER_SWITCH_SUBTITLE id=%d\n", FILENAME, __FUNCTION__, *((int*) argument));
#endif

		    SrtSwitchSubtitle(context, (int*) argument);
			break;
		}
		default:
#ifdef DEBUG
			printf("%s::%s ConatinerCmd not supported! %d\n", FILENAME, __FUNCTION__, command);
#endif
			break;
	}

	return 0;
}

static char *SrtCapabilities[] = { "srt", NULL };

Container_t SrtContainer = {
	"SRT",
	&Command,
	SrtCapabilities,
};
