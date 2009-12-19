/*
*
*	vfdctl.c
*	by nebman, 02.11.2007
*
*	vfdctl is a little utility to control the display of the UFS910 receiver
*
*	thx to captaintrip for his code
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <signal.h>

#define	VFD_Display_Chars 	0xc0425a00
#define VFDICONDISPLAYONOFF	0xc0425a0a
#define VFDWRITECGRAM		0x40425a01
#define SLEEPTIME 200000
#define true 1
#define false 0
/*
*	Umlauts:
*		128 ä, 129 ö, 130 ü
*		131 Ä, 132 Ö, 133 Ü
*		134 ß
*
*	Special chars:
*		17 = | bis 21 = |||||
*		22 = 6 horizontal bars filled from bottom of a total of 7
*		.. 27 = 1 horizontal bars filled from bottom of a total of 7
*/

void setMessageToDisplay ( char* );
void show_help();
void close_device_vfd();
void scrollText(char* text);
void iconOnOff(char* sym, unsigned char onoff);
void centeredText(char* text);
int writeCG (unsigned char adress, unsigned char pixeldata[5]);
void demoMode(void);
void sigfunc(int sig);

int file_vfd;
char verbose=false;

int main ( int argc, char **argv )
{
	// check command line argument count
	if (argc == 1) {
		show_help();
		return EXIT_FAILURE;
	}

	// function to catch SIGINT
	signal(SIGINT, sigfunc);

	// open display file
	if ( (file_vfd = open ( "/dev/vfd", O_RDWR )) == -1 )
	{
		printf ( "vfdctl: could not open vfd-device!\n" );
		return EXIT_FAILURE;
	}
	
	int i; unsigned char centerText=false;
	char* output=0;

	for (i=1; i<argc; i++) {
		char* cmd = argv[i];

		if (strcmp(cmd,"-c")==0) {	
			centerText = true;
			if (verbose) printf("option centered text active\n");
		} else if (strcmp(cmd,"-v")==0) {	
			verbose = true;
		} else if (cmd[0] == '+') {
			iconOnOff(cmd+1,true);
		} else if (cmd[0] == '-') {
			iconOnOff(cmd+1,false);
		} else if (strcmp(cmd,"demomode")==0) {
			printf("vfdctl: starting demomode\n");
			demoMode();
		} else {
			output=cmd;
		}
		
	}

	if (output) {
		if (strlen(output)>16)
			scrollText(output); // scroll text if >16
		else {
			if (centerText==true) {
				centeredText(output);
			} else {
				setMessageToDisplay(output);
			}
		}
	}
	close_device_vfd();

	return EXIT_SUCCESS;
}

// CODE captaintrip
void setMessageToDisplay ( char* str )
{
	int i;

	struct ioctl_data
	{
		unsigned char start;
		unsigned char data[64];
		unsigned char length;
	}
	writedisp_data;

	memset ( writedisp_data.data, ' ', 16 );

	i = strlen ( str );
	if ( i > 16 ) i = 16;
	memcpy ( writedisp_data.data, str, i );	

	writedisp_data.start = 0;
	writedisp_data.length = 16;

	ioctl ( file_vfd, VFD_Display_Chars, &writedisp_data );
}

void close_device_vfd()
{
	if ( file_vfd != -1 )
		close ( file_vfd );
}

void show_help() {
printf("vfdctl v0.4 - usage:\n\
\tvfdctl [[-c] text] [+sym] [-sym] ...\n\
\t-c\tcentered output\n\
\tto set symbols use e.g. +usb or -usb\n\
\tavailable symbols are usb,hd,hdd,lock,bt,mp3,music,dd,mail,mute,play,pause,ff,fr,rec,clock\n\
\ttype \"vfdctl demomode\" to start demo loop\n");
}

void centeredText(char* text) {
	if (verbose) printf("centering text\n");

	int ws = 0; // needed whitespace for centering
	if (strlen(text)<16)
		ws=(16-strlen(text))/2;
	else
		ws=0;
	
	char *textout = malloc(16);
	memset(textout, ' ', 16);
	memcpy(textout+ws, text, 16-ws);
	setMessageToDisplay(textout);
	free(textout);
}

void scrollText(char* text) {
	int i, len = strlen(text);
	char* out = malloc(16);

	for (i=0; i<=(len-16); i++) { // scroll text till end
		memset(out, ' ', 16);
		memcpy(out, text+i, 16);
		setMessageToDisplay(out);
		usleep(SLEEPTIME);
	}
	for (i=1; i<16; i++) { // scroll text with whitespaces from right
		memset(out, ' ', 16);
		memcpy(out, text+len+i-16, 16-i);
		setMessageToDisplay(out);
		usleep(SLEEPTIME);
	}

	memcpy(out, text, 16); // display first 16 chars after scrolling
	setMessageToDisplay(out);
	free (out);
}

void iconOnOff (char* sym, unsigned char onoff) {
	char icon;

	if (strcmp(sym,"usb")==0) {
		icon = 0x10;
	} else if (strcmp(sym,"hd")==0) {
		icon = 0x11;
	} else if (strcmp(sym,"hdd")==0) {
		icon = 0x12;
	} else if (strcmp(sym,"lock")==0) {
		icon = 0x13;
	} else if (strcmp(sym,"bt")==0) {
		icon = 0x14;
	} else if (strcmp(sym,"mp3")==0) {
		icon = 0x15;
	} else if (strcmp(sym,"music")==0) {
		icon = 0x16;
	} else if (strcmp(sym,"dd")==0) {
		icon = 0x17;
	} else if (strcmp(sym,"mail")==0) {
		icon = 0x18;
	} else if (strcmp(sym,"mute")==0) {
		icon = 0x19;
	} else if (strcmp(sym,"play")==0) {
		icon = 0x1a;
	} else if (strcmp(sym,"pause")==0) {
		icon = 0x1b;
	} else if (strcmp(sym,"ff")==0) {
		icon = 0x1c;
	} else if (strcmp(sym,"fr")==0) {
		icon = 0x1d;
	} else if (strcmp(sym,"rec")==0) {
		icon = 0x1e;
	} else if (strcmp(sym,"clock")==0) {
		icon = 0x1f;
	} else {
		printf("Unknown symbol %s\n",sym);
		return -1;
	}

	struct {
		unsigned char start;
		unsigned char data[64];
		unsigned char length;
	} data;
        data.start = 0x00;
        data.data[0] = icon;
        data.data[4] = onoff;
        data.length = 5;
        ioctl(file_vfd, VFDICONDISPLAYONOFF, &data);
	if (verbose) printf("set icon %s(%x) %d \n",sym,icon,onoff);
}

int writeCG (unsigned char adress, unsigned char pixeldata[5]) {
	struct {
		unsigned char start;
		unsigned char data[64];
		unsigned char length;
	} data;
	int i;

	data.start = adress & 0x07;
	data.data[0] = pixeldata[0];
	data.data[1] = pixeldata[1];
	data.data[2] = pixeldata[2];
	data.data[3] = pixeldata[3];
	data.data[4] = pixeldata[4];
	data.length = 5;
	return ioctl(file_vfd, VFDWRITECGRAM, &data);
}

void demoMode (void) {
	char man1[5] = {0x02, 0x64, 0x1D, 0x64, 0x02};
	char man2[5] = {0x04, 0x64, 0x1D, 0x64, 0x04};
	char u[5] = {0x00, 0x1C, 0x20, 0x20, 0x3E};
	char f[5] = {0x00, 0x3E, 0x0A, 0x0A, 0x00};
	char s[5] = {0x20, 0x20, 0x2C, 0x12, 0x02};
	char neun[5] = {0x20, 0x20, 0x2E, 0x2A, 0x3E};
	char eins[5] = {0x00, 0x00, 0x3E, 0x00, 0x00};
	char nul[5] = {0x1C, 0x22, 0x22, 0x1C, 0x00};

	char* writechars[7] = {&man1, &u, &f, &s, &neun, &eins, &nul};
	char* writechars_ani[7] = {&man2, &u, &f, &s, &neun, &eins, &nul};
	
	int i;
	for (i=0; i<7; i++) {
		writeCG(i, *(writechars+i));
	}

	char test[9]={0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x00};
	setMessageToDisplay(&test);
	
	
	//animation
	while (1) {
		usleep(750000);
		writeCG(0, *(writechars_ani+0));
		setMessageToDisplay(&test);
		
		usleep(750000);
		writeCG(0, *(writechars+0));
		setMessageToDisplay(&test);
	}
}

void sigfunc(int sig) {
   int c;
   if(sig != SIGINT)
      return;
   else {
      exit(-1);
   }
}
