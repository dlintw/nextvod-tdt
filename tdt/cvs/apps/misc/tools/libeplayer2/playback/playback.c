#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netdb.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>

#include "playback.h"
#include "common.h"

static const char FILENAME[] = "playback.c";

//little helper functions
static int getline(char** pbuffer, size_t* pbufsize, int fd)
{
	size_t i = 0;
	int rc;
	while (1) {
		if (i >= *pbufsize) {
			char *newbuf = (char*)realloc(*pbuffer, (*pbufsize)+1024);
			if (newbuf == NULL)
				return -1;
			*pbuffer = newbuf;
			*pbufsize = (*pbufsize)+1024;
		}
		rc = read(fd, (*pbuffer)+i, 1);
		if (rc <= 0 || (*pbuffer)[i] == '\n')
		{
			(*pbuffer)[i] = '\0';
			return rc <= 0 ? -1 : i;
		}
		if ((*pbuffer)[i] != '\r') i++;
	}
}

int openHttpConnection(Context_t  *context, char** content,off_t off)
{
	char* url=context->playback->uri;
	char host[256];
	int port = 80;
	char uri[512];
	int x;
	int slash = 0;
	for(x=7;x<strlen(url)-1;x++){
		if(url[x]=='/'){
			slash=x;
			break;
		}
	}
	if (slash > 0) {
		strncpy(host,url+7,slash-7);
		host[slash-7]='\0';
		strcpy(uri,url+slash);
	} else {
		strcpy(host,url+7);
		strcpy(uri,"/");
	}
	int dp=0;
	for(x=0;x<strlen(host)-1;x++){
		if(host[x]==':'){
			dp=x;
			break;
		}
	}
	if (dp > 0) {
		port = atoi(host+dp+1);
		//host = host.substr(0, dp);
		host[dp]='\0';
	}
	//printf("URL: %s\n",url);
	//printf("Host: %s\n",host);
	//printf("URI: %s\n",uri);
	//printf("Port: %d\n",port);

	struct hostent* h = gethostbyname(host);
	if (h == NULL || h->h_addr_list == NULL){
		printf("hotlookup failed\n");
		return NULL;
	}
	int fd = socket(PF_INET, SOCK_STREAM, 0);
	if (fd == -1){
		printf("creating socket failed");
		return NULL;
	}
	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = *((in_addr_t*)h->h_addr_list[0]);
	addr.sin_port = htons(port);

	printf("connecting to %s\n", url);

	if (connect(fd, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
		printf("connect failed for: %s\n", url);
		return NULL;
	}
	char request[1024];
	strcpy(request,"GET ");
	strcat(request,uri);
	strcat(request," HTTP/1.1\r\n");
	strcat(request,"Host: ");
	strcat(request,host);
	if(port!=80){
		char p[16];
		sprintf(p,"%d",port); 
		strcat(request,":");
		strcat(request,p);
	}
	strcat(request,"\r\n");
	
	char b[32];
	sprintf(b,"%ld",off); 
	strcat(request,"Range: bytes=");
	strcat(request,b);
	strcat(request,"-\r\n");
	
	//strcat(request,"User-Agent: VLC mediaplayer - version 1.0.2\r\n");
	//strcat(request,"Range: bytes=0-\r\n");
	//strcat(request,"Icy-MetaData: 1\r\n");
	strcat(request,"Accept: */*\r\n");
	strcat(request,"Connection: close\r\n");
	strcat(request,"\r\n");
	printf("sending:\n%s",request);
	write(fd, request, strlen(request));

	int rc,ext_found=0;
	size_t buflen = 1000;
	char* linebuf = (char*)malloc(1000);

	rc = getline(&linebuf, &buflen, fd);
	printf("RECV(%d): %s\n", rc, linebuf);
	if (rc <= 0)
	{
		close(fd);
		free(linebuf);
		return NULL;
	}

	char proto[100];
	int statuscode = 0;
	char statusmsg[100];
	rc = sscanf(linebuf, "%99s %d %99s", proto, &statuscode, statusmsg);
	if (statuscode == 303){
		printf("redirecting.\n");
		printf("got: %s\n",linebuf);
		while (rc > 0)
		{
			rc = getline(&linebuf, &buflen, fd);
			if(!strncmp("Location: ", linebuf, 10)){
				close(fd);
				free(context->playback->uri);
				context->playback->uri=strdup(linebuf+10);
				return openHttpConnection(context, content,off);
			}
			printf("RECV(%d): %s\n", rc, linebuf);
		}
		free(linebuf);
		close(fd);
		return NULL;
	}
	if (rc != 3 || (statuscode != 200 && statuscode != 206)) {
		printf("wrong response: \"200 OK\" expected.\n");
		printf("got: %s\n",linebuf);
		while (rc > 0)
		{
			rc = getline(&linebuf, &buflen, fd);
			printf("RECV(%d): %s\n", rc, linebuf);
		}
		free(linebuf);
		close(fd);
		return NULL;
	}	
	printf("proto=%s, code=%d, msg=%s\n", proto, statuscode, statusmsg);
	while (rc > 0)
	{
		rc = getline(&linebuf, &buflen, fd);
		printf("RECV(%d): %s\n", rc, linebuf);
		if(!strncmp("Content-Length: ", linebuf, 16)){
				long int pos;
				sscanf(linebuf+16,"%ld",&pos);
				context->playback->size=pos+off;
		}
		if(rc == 24) { //ContentType
			int ret = 0;
			printf("Content-Type: ");
			if(!(ret = strncmp("audio/mpeg", linebuf+14, 10))) {
				printf("mp3");
				printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
				*content = strdup("mp3");
				ext_found=1;
			} else  {
				printf("Unknown (%s) %d", linebuf, ret);
			}
			printf("\n");
		} else if(rc == 23) {
			int ret = 0;
			printf("Content-Type: ");
			if(!(ret = strncmp("audio/mpeg", linebuf+13, 10))) {
				printf("mp3");
				printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
				*content = strdup("mp3");
				ext_found=1;
			}if(!(ret = strncmp("video/mp4", linebuf+14, 9))) {
				printf("mp4");
				printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
				*content = strdup("mp4");
				ext_found=1;
			} else  {
				printf("Unknown (%s) %d", linebuf, ret);
			}
			printf("\n");
		} else {
			
		}
	}
	free(linebuf);
	if(!ext_found){
		//default mp3
		printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
		*content = strdup("mp3");
	}
	return fd;
}

static int openMmsConnection(char* url, char** content)
{
	char host[256];
	int port = 80;
	char uri[512];
	int x;
	int slash = 0;
	for(x=6;x<strlen(url)-1;x++){
		if(url[x]=='/'){
			slash=x;
			break;
		}
	}
	if (slash > 0) {
		strncpy(host,url+6,slash-6);
		host[slash-6]='\0';
		strcpy(uri,url+slash);
	} else {
		strcpy(host,url+6);
		strcpy(uri,"/");
	}
	int dp=0;
	for(x=0;x<strlen(host)-1;x++){
		if(host[x]==':'){
			dp=x;
			break;
		}
	}
	if (dp > 0) {
		port = atoi(host+dp+1);
		//host = host.substr(0, dp);
		host[dp]='\0';
	}
	printf("URL: %s\n",url);
	printf("Host: %s\n",host);
	printf("URI: %s\n",uri);
	printf("Port: %d\n",port);

	struct hostent* h = gethostbyname(host);
	if (h == NULL || h->h_addr_list == NULL){
		printf("hotlookup failed\n");
		return NULL;
	}
	int fd = socket(PF_INET, SOCK_STREAM, 0);
	if (fd == -1){
		printf("creating socket failed");
		return NULL;
	}
	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = *((in_addr_t*)h->h_addr_list[0]);
	addr.sin_port = htons(port);

	printf("connecting to %s\n", url);

	if (connect(fd, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
		printf("connect failed for: %s\n", url);
		return NULL;
	}
	printf("connected!\n");
	char request[1024];
	strcpy(request,"GET ");
	strcat(request,uri);
	strcat(request," HTTP/1.1\n");
	strcat(request,"Host: ");
	strcat(request,host);
	strcat(request,"\n");
	strcat(request,"Accept: */*\n");
	strcat(request,"Connection: close\n");
	strcat(request,"\n");
	printf("sending:\n%s",request);
	write(fd, request, strlen(request));

	int rc;
	size_t buflen = 1000;
	char* linebuf = (char*)malloc(1000);

	rc = getline(&linebuf, &buflen, fd);
	printf("RECV(%d): %s\n", rc, linebuf);
	if (rc <= 0)
	{
		close(fd);
		free(linebuf);
		return NULL;
	}

	char proto[100];
	int statuscode = 0;
	char statusmsg[100];
	rc = sscanf(linebuf, "%99s %d %99s", proto, &statuscode, statusmsg);
	if (rc != 3 || statuscode != 200) {
		printf("wrong response: \"200 OK\" expected.\n");
		printf("got: %s\n",linebuf);
		free(linebuf);
		close(fd);
		return NULL;
	}	
	printf("proto=%s, code=%d, msg=%s\n", proto, statuscode, statusmsg);
	while (rc > 0)
	{
		rc = getline(&linebuf, &buflen, fd);
		//printf("RECV(%d): %s\n", rc, linebuf);
		if(rc == 24) { //ContentType
			int ret = 0;
			printf("Content-Type: ");
			if(!(ret = strncmp("audio/mpeg", linebuf+14, 10))) {
				printf("mp3");
				printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
				*content = strdup("mp3");
			} else  {
				printf("Unknown (%s) %d", linebuf, ret);
			}
			printf("\n");
		}
	}
	free(linebuf);

	return fd;
}

static void getExtension(char * FILENAMEname, char ** extension) {

	int i = 0;
	int stringlength = (int) strlen(FILENAMEname);
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	for (i = 0; stringlength - i > 0; i++) {
		if (FILENAMEname[stringlength - i - 1] == '.') {
			printf("strdup in %s::%s:%d\n", FILENAME, __FUNCTION__,__LINE__);
			*extension = strdup(FILENAMEname+(stringlength - i));
			break;
		}
	}
}

static void getParentFolder(char * Filename, char ** folder) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);

	int i = 0;
	int stringlength = (int) strlen(Filename);

	for (i = 0; stringlength - i > 0; i++) {
		if (Filename[stringlength - i - 1] == '/') {
            *folder = (char *)malloc(stringlength - i - 1);
			strncpy(*folder, Filename, stringlength - i - 1);
			break;
		}
	}
}

static pthread_t DummyThread1;
static pthread_t DummyThread2;
static pthread_t DummyThread3;
static void DummyThread(Context_t *context) {
	printf("dummy thread started\n");
	usleep(10000);
}

static int PlaybackOpen(Context_t  *context, char * uri) {
	printf("%s::%s URI=%s\n", FILENAME, __FUNCTION__, uri);
	/* make sure that 3 thread are created
	   if the first file we play is a file without subtitles (no subtitles thread is created)
	   on playback of the second file pthread_create fails with cannot allocate memory
	   because we did not create the subtitle thread 
	   so we need to make sure that we created 3 threads before starting the first file.
	   this is a quick and dirty fix and needs to be investigated if there is a better solution*/
	int error;
	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
        if(error=pthread_create(&DummyThread1, &attr, (void *)&DummyThread, NULL) != 0)
        {
           fprintf(stderr, "Error creating thread in %s error:%d:%s\n", __FUNCTION__,errno,strerror(errno));
	   DummyThread1 = NULL;
        }
	if(error=pthread_create(&DummyThread2, &attr, (void *)&DummyThread, NULL) != 0)
        {
           fprintf(stderr, "Error creating thread in %s error:%d:%s\n", __FUNCTION__,errno,strerror(errno));
	   DummyThread2 = NULL;
        }
	if(error=pthread_create(&DummyThread2, &attr, (void *)&DummyThread, NULL) != 0)
        {
           fprintf(stderr, "Error creating thread in %s error:%d:%s\n", __FUNCTION__,errno,strerror(errno));
	   DummyThread2 = NULL;
        }
	printf("joining dummy threads\n");
	if(DummyThread1!=NULL)error = pthread_join (DummyThread1, NULL);
	if(DummyThread2!=NULL)error = pthread_join (DummyThread2, NULL);
	if(DummyThread3!=NULL)error = pthread_join (DummyThread3, NULL);
	context->playback->uri=strdup(uri);

    if (!context->playback->isPlaying) {
	    if (!strncmp("file://", uri, 7)) {
		    char * extension = NULL;
		    context->playback->isFile = 1;
		    context->playback->isHttp = 0;

		    context->playback->fd = open(uri+7, O_RDONLY);
		    if(context->playback->fd == -1) {
			    printf("context->playback->fd == -1!\n");
			    return -1;
		    }

		    getExtension(uri+7, &extension);
		    if(!extension) return -1;
		
		    if(context->container->Command(context, CONTAINER_ADD, extension) < 0)
			    return -1;
		    if (context->container->selectedContainer != NULL) {
			    if(context->container->selectedContainer->Command(context, CONTAINER_INIT, uri+7) < 0)
				    return -1;
		    } else {
			    return -1;
		    }

		    free(extension);

		    //CHECK FOR SUBTITLES
            if (context->container && context->container->textSrtContainer)
                context->container->textSrtContainer->Command(context, CONTAINER_INIT, uri+7);
	    //if(context->playback->isSubtitle<=0)
            	if (context->container && context->container->textSsaContainer)
                	context->container->textSsaContainer->Command(context, CONTAINER_INIT, uri+7);

	    } else if (!strncmp("http://", uri, 7)) {
		    char * extension = NULL;
		    context->playback->isFile = 0;
		    context->playback->isHttp = 1;
		
		    context->playback->fd = openHttpConnection(context, &extension,0);
		    //printf("context->playback->fd = %d\n", context->playback->fd);
		    if(context->playback->fd == 0) {
			    printf("context->playback->fd == 0!\n");
			    return -1;
		    }

		    if(!extension) getExtension(uri+7, &extension);
		    if(!extension) return -1;
		
		    if(context->container->Command(context, CONTAINER_ADD, extension) < 0)
			    return -1;
		    if (context->container->selectedContainer != NULL) {
			    if(context->container->selectedContainer->Command(context, CONTAINER_INIT, uri+7) < 0)
				    return -1;
		    } else {
			    return -1;
		    }
			
		    free(extension);	
        } else if (!strncmp("mms://", uri, 6)) {		
            char * extension = NULL;
		    context->playback->isFile = 0;
		    context->playback->isHttp = 1;
		
		    context->playback->fd = openMmsConnection(uri, &extension);
		    //printf("context->playback->fd = %d\n", context->playback->fd);
		    if(context->playback->fd == 0) {
			    printf("context->playback->fd == 0!\n");
			    return -1;
		    }

		    if(!extension) getExtension(uri+6, &extension);
		    if(!extension) return -1;
		
		    if(context->container->Command(context, CONTAINER_ADD, extension) < 0)
			    return -1;
		    if (context->container->selectedContainer != NULL) {
			    if(context->container->selectedContainer->Command(context, CONTAINER_INIT, uri+6) < 0)
				    return -1;
		    } else {
			    return -1;
		    }
			
		    free(extension);	
	    } else {
		    printf("Unknown stream!\n");
		    return -1;
	    }
    } else 
        return -1;

	return 0;
}

static int PlaybackClose(Context_t  *context) {
	printf("%s::%s \n", FILENAME, __FUNCTION__);

        context->container->Command(context, CONTAINER_DEL, NULL);

//FIXME KILLED BY signal 7 or 11
        if (context->container && context->container->textSrtContainer)
            context->container->textSrtContainer->Command(context, CONTAINER_DEL, NULL);

        if (context->container && context->container->textSsaContainer)
            context->container->textSsaContainer->Command(context, CONTAINER_DEL, NULL);

        context->manager->audio->Command(context, MANAGER_DEL, NULL);
        context->manager->video->Command(context, MANAGER_DEL, NULL);
        context->manager->subtitle->Command(context, MANAGER_DEL, NULL);

        close(context->playback->fd);

        context->playback->isPaused     = 0;
		context->playback->isPlaying    = 0;
		context->playback->isForwarding = 0;
		context->playback->Speed        = 0;

	return 0;
}

static int PlaybackPlay(Context_t  *context) {
	int exec;
	int ret = 0;
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	if (!context->playback->isPlaying) {
		context->playback->AVSync = 1;
		context->output->Command(context, OUTPUT_AVSYNC, NULL);

		context->output->Command(context, OUTPUT_PLAY, NULL);

		context->playback->isPlaying    = 1;
		context->playback->isPaused     = 0;
		context->playback->isForwarding = 0;
		context->playback->Speed        = 1;

		exec = context->container->selectedContainer->Command(context, CONTAINER_PLAY, NULL);
		if (exec != 0) {
			printf("%s::%s CONTAINER_PLAY failed!\n", FILENAME, __FUNCTION__);
			ret = -1;
		}
	} else
		ret = -1;

	return ret;
}

static int PlaybackPause(Context_t  *context) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	if (context->playback->isPlaying && !context->playback->isPaused) {
		context->output->Command(context, OUTPUT_PAUSE, NULL);

		context->playback->isPaused     = 1;
		//context->playback->isPlaying  = 1;
		context->playback->isForwarding = 0;
		context->playback->Speed        = 1;
	} else
        return -1;

	return 0;
}

static int PlaybackContinue(Context_t  *context) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	if (context->playback->isPlaying && 
        (context->playback->isPaused || context->playback->isForwarding)) {

		context->output->Command(context, OUTPUT_CONTINUE, NULL);

		context->playback->isPaused     = 0;
		//context->playback->isPlaying  = 1;
		context->playback->isForwarding = 0;
		context->playback->Speed        = 1;
	} else
        return -1;

	return 0;
}

static int PlaybackStop(Context_t  *context) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	if (context->playback->isPlaying) {

		context->playback->isPaused     = 0;
		context->playback->isPlaying    = 0;
		context->playback->isForwarding = 0;
		context->playback->Speed        = 0;

		context->output->Command(context, OUTPUT_STOP, NULL);
		context->container->selectedContainer->Command(context, CONTAINER_STOP, NULL);

        //PlaybackClose(context);
	} else
        return -1;

	return 0;
}

static int PlaybackTerminate(Context_t  *context) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	if (context->playback->isPlaying) {
        //First Flush and than delete container, else e2 cant read length of file anymore
		context->output->Command(context, OUTPUT_FLUSH, NULL);
        context->container->selectedContainer->Command(context, CONTAINER_STOP, NULL);

        context->playback->isPaused     = 0;
		context->playback->isPlaying    = 0;
		context->playback->isForwarding = 0;
		context->playback->Speed        = 0;

        //PlaybackClose(context);
	} else
        return -1;
	return 0;
}

static int PlaybackFastForward(Context_t  *context,int* speed) {


    //Audio only forwarding not supported
	if (context->playback->isVideo && !context->playback->isHttp && (!context->playback->isPaused || context->playback->isPlaying)) {

		context->playback->isForwarding = 1;

		switch(*speed) {
		case 2: 
			context->playback->Speed = 1;
			break;
		case 4:
			context->playback->Speed = 2;
			break;
		case 8:
			context->playback->Speed = 3;
			break;
		case 48: //16x
			context->playback->Speed = 4;
			break;
		case 96: //32x
			context->playback->Speed = 5;
			break;
		case 192: //64x
			context->playback->Speed = 6;
			break;
		case 384: //128x
			context->playback->Speed = 7;
			break;
	}

	printf("%s::%s Speed: %d x {%d}\n", FILENAME, __FUNCTION__, *speed, context->playback->Speed);

		context->output->Command(context, OUTPUT_FASTFORWARD, NULL);
	} else
        return -1;
	return 0;
}

static int PlaybackSeek(Context_t  *context, float * pos) {
	printf("%s::%s pos: %f\n", FILENAME, __FUNCTION__, *pos);

	if (!context->playback->isHttp && context->playback->isPlaying && !context->playback->isForwarding) {
		context->playback->isSeeking = 1;
		context->output->Command(context, OUTPUT_CLEAR, NULL);
		PlaybackPause(context);
		context->output->Command(context, OUTPUT_CLEAR, NULL);
		context->container->selectedContainer->Command(context, CONTAINER_SEEK, pos);
		context->output->Command(context, OUTPUT_CLEAR, NULL);
		context->playback->isSeeking = 0;

		PlaybackContinue(context);
	} else
        return -1;
	
	return 0;
}

static int PlaybackPts(Context_t  *context, unsigned long long int* pts) {
	//printf("%s::%s\n", FILENAME, __FUNCTION__);

    *pts = 0;

	if (context->playback->isPlaying) {
		context->output->Command(context, OUTPUT_PTS, pts);
	} else
        return -1;
		
	
	return 0;
}

static int PlaybackLength(Context_t  *context, double* length) {
	//printf("%s::%s\n", FILENAME, __FUNCTION__);

    *length = 0;

	if (context->playback->isPlaying) {
		if (context->container && context->container->selectedContainer)
		    context->container->selectedContainer->Command(context, CONTAINER_LENGTH, length);
	} else
        return -1;
		
	
	return 0;
}

static int PlaybackSwitchAudio(Context_t  *context, int* track) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);

    int curtrackid = 0;
    int nextrackid = 0;

	if (context->playback->isPlaying) {
        if (context->manager && context->manager->audio) {
            context->manager->audio->Command(context, MANAGER_GET, &curtrackid);
            context->manager->audio->Command(context, MANAGER_SET, track);
            context->manager->audio->Command(context, MANAGER_GET, &nextrackid);
        }

        if(nextrackid != curtrackid) {

	    //PlaybackPause(context);

            if (context->output && context->output->audio)
	            context->output->audio->Command(context, OUTPUT_SWITCH, (void*)"audio");

	    if (context->container && context->container->selectedContainer)
	            context->container->selectedContainer->Command(context, CONTAINER_SWITCH_AUDIO, &nextrackid);

            //PlaybackContinue(context);
        }
	} else
        return -1;
		
	
	return 0;
}

static int PlaybackSwitchSubtitle(Context_t  *context, int* track) {
	printf("%s::%s Track: %d\n", FILENAME, __FUNCTION__, *track);

    int curtrackid = 0;
    int nextrackid = 0;

	if (context->playback->isPlaying) {
        if (context->manager && context->manager->subtitle) {
            context->manager->subtitle->Command(context, MANAGER_GET, &curtrackid);
            context->manager->subtitle->Command(context, MANAGER_SET, track);
            context->manager->subtitle->Command(context, MANAGER_GET, &nextrackid);
        } else return -1;

	    printf("%s::%s nextrackid: %d != curtrackid: %d\n", FILENAME, __FUNCTION__, nextrackid, curtrackid);

        if(nextrackid != curtrackid) {

            //PlaybackPause(context);
                
            if (context->container && context->container->selectedContainer)
                context->container->selectedContainer->Command(context, CONTAINER_SWITCH_SUBTITLE, &nextrackid);
            else return -1;
           
            if(nextrackid==100){
            	if (context->container && context->container->textSrtContainer)
                	context->container->textSrtContainer->Command(context, CONTAINER_SWITCH_SUBTITLE, &nextrackid);
            }
            else if(nextrackid==200){
            	if (context->container && context->container->textSsaContainer)
            	    context->container->textSsaContainer->Command(context, CONTAINER_SWITCH_SUBTITLE, &nextrackid);
            }
            if (context->output && context->output->subtitle)
	            context->output->subtitle->Command(context, OUTPUT_SWITCH, (void*)"subtitle");
            else return -1;
            //PlaybackContinue(context);
        }
	} else
        return -1;
		
	
	return 0;
}

static int PlaybackInfo(Context_t  *context, char** infoString) {
	printf("%s::%s\n", FILENAME, __FUNCTION__);

	if (context->playback->isPlaying) {
		if (context->container && context->container->selectedContainer)
		    context->container->selectedContainer->Command(context, CONTAINER_INFO, infoString);
	} else
        return -1;
		
	return 0;
}

static int Command(Context_t  *context, PlaybackCmd_t command, void * argument) {
	//printf("%s::%s\n", FILENAME, __FUNCTION__);

	switch(command) {
		case PLAYBACK_OPEN: {
			return PlaybackOpen(context, (char*)argument);
			break;
		}
		case PLAYBACK_CLOSE: {
			return PlaybackClose(context);
			break;
		}
		case PLAYBACK_PLAY: {
			return PlaybackPlay(context);
			break;
		}
		case PLAYBACK_STOP: {
			return PlaybackStop(context);
			break;
		}
		case PLAYBACK_PAUSE: {
			return PlaybackPause(context);
			break;
		}
		case PLAYBACK_CONTINUE: {
			return PlaybackContinue(context);
			break;
		}
		case PLAYBACK_TERM: {
			return PlaybackTerminate(context);
			break;
		}
		case PLAYBACK_FASTFORWARD: {
			return PlaybackFastForward(context,(int*)argument);
			break;
		}
		case PLAYBACK_SEEK: {
			return PlaybackSeek(context, (float*)argument);
			break;
		}
		case PLAYBACK_PTS: {
			return PlaybackPts(context, (unsigned long long int*)argument);
			break;
		}
		case PLAYBACK_LENGTH: {
			return PlaybackLength(context, (double*)argument);
			break;
		}
		case PLAYBACK_SWITCH_AUDIO: {
			return PlaybackSwitchAudio(context, (int*)argument);
			break;
		}
		case PLAYBACK_SWITCH_SUBTITLE: {
			return PlaybackSwitchSubtitle(context, (int*)argument);
			break;
		}
        case PLAYBACK_INFO: {
			return PlaybackInfo(context, (char**)argument);
			break;
		}
		default:
			printf("%s::%s PlaybackCmd not supported! %d\n", FILENAME, __FUNCTION__, command);
			break;
	}

	return -1;
}


PlaybackHandler_t PlaybackHandler = {
	"Playback",
	-1,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	&Command,
	"",
	0,
};
