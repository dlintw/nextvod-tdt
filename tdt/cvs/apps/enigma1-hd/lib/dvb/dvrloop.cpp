#include <lib/dvb/dvrloop.h>

#include <sys/types.h>
#include <sys/msg.h>
#include <sys/ipc.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/un.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <errno.h>
#include <signal.h>

#include <lib/system/init.h>
#include <lib/system/init_num.h>

eDVRLoop *eDVRLoop::instance;

eDVRLoop::eDVRLoop()
{
	instance=this;
}

eDVRLoop::~eDVRLoop()
{
	instance=0;
}

void eDVRLoop::playStream(int what)
{
        eDebug("eDVRLoop [%s]  what = %d",__FUNCTION__, what);   

        if (what>=1){
		dvrLoop(1);	
	} else
		dvrLoop(0);	
}

void eDVRLoop::dvrLoop(int i)
{
	char dvrBuffer[10];
        if (i)
    	        strcpy(dvrBuffer, "\x11\x01" );   	
	else
		strcpy(dvrBuffer, "\x11\x00" );   	
	
	struct sockaddr_un servaddr;
    	int dvrSocket;
	servaddr.sun_family = AF_UNIX;
    	strcpy(servaddr.sun_path, "/tmp/dvrloop.socket");
    	if ((dvrSocket = socket(AF_UNIX, SOCK_STREAM, 0)) < 0)
    	{
	        perror("[dvrConnect] socket");
        	return;
    	}
    	if (connect(dvrSocket, (struct sockaddr*) &servaddr, sizeof(servaddr)) < 0)
    	{
	        perror("[dvrConnect] connect");
        	close(dvrSocket);
        	return;
    	}
        write(dvrSocket, dvrBuffer, 2);
        close(dvrSocket);
}
eAutoInitP0<eDVRLoop> init_eDVRLoop(eAutoInitNumbers::service + 3, "eDVRLoop");
