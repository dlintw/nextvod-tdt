/*
*
*	vfdctl.c
*	by nebman
*	version v0.7.1
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
#define VFDICONGETSTATE		0xc0425a0b
#define VFDWRITECGRAM		0x40425a01
#define SLEEPTIME			200000
#define IN_CHAR				27
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
void setMessageToDisplayEx ( char*, int len );
void show_help();
void close_device_vfd();
void scrollText(char* text);
int iconOnOff(char* sym, unsigned char onoff);
void centeredText(char* text);
int writeCG (unsigned char adress, unsigned char pixeldata[5]);
void demoMode(void);
void sigfunc(int sig);
void inputRemote(char* text);
void refreshDisp();
void printState(int index);
int getIconIndex(char *icon);
void printBitmap(char* filename, int animationSpeed);
void playVfdx(char* filename);

const char *icons[16] = {"usb","hd","hdd","lock","bt","mp3","music","dd","mail","mute","play","pause","ff","fr","rec","clock"};
const char *states[3] = {"off", "on", "not inited"};

int file_vfd;
char verbose=false;

#define MAX_INPUT 200
char outbuffer[16];
char input[MAX_INPUT];
int position=0;
char offset=0;

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
	
	int i;
	unsigned char centerText=false;
	char* output=0;
	int animationSpeed = 500000;	// default animation to 1/2 second

	for (i=1; i<argc; i++) {
		char* cmd = argv[i];

		if (strcmp(cmd,"-c")==0) {	
			centerText = true;
			if (verbose) printf("option centered text active\n");
		} else if (strcmp(cmd,"-v")==0) {	
			verbose = true;
		} else if (strcmp(cmd,"-s")==0) {	
			if (argc > 2) {
				i++;
				animationSpeed = atoi(argv[i]) * 1000;
				continue;
			} else {
				fprintf(stderr,"vfdctl: please specify animationspeed in milliseconds as 2nd argument\n");
				break;
			}
		} else if (strcmp(cmd,"-b")==0) {	
			if (argc > 2) {
				printBitmap(argv[i + 1], animationSpeed);
			} else {
				fprintf(stderr,"vfdctl: please specify bitmap file as 2nd argument\n");
			}
			break;
		} else if (strcmp(cmd,"-x")==0) {	
			if (argc > 2) {
				playVfdx(argv[i + 1]);
			} else {
				fprintf(stderr,"vfdctl: please specify .vfdx file as 2nd argument\n");
			}
			break;
		} else if (cmd[0] == '+') {
			iconOnOff(cmd+1,true);
		} else if (cmd[0] == '-') {
			iconOnOff(cmd+1,false);
		} else if (strcmp(cmd,"demomode")==0) {
			printf("vfdctl: starting demomode\n");
			demoMode();
			break;
		} else if (strcmp(cmd,"input")==0) {
			fprintf(stderr,"vfdctl: starting remote control input mode\n");
			if (argc==3) {
				inputRemote(argv[2]);
			} else {
				inputRemote("");
			}
			break;
		} else if (strcmp(cmd,"iconstate")==0) {
			if (argc==3) {
				printState(getIconIndex(argv[2]));
			} else {
				printState(-1);
			}
			break;
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
	if (verbose) printf("closing vfd device\n");
	close_device_vfd();

	return EXIT_SUCCESS;
}

int getIconIndex(char* icon) {
	int i;

	for (i=0; i<16; i++) {
		if (strcmp(icon, icons[i])==0) {
			return i;
		}
	}
	
	printf("Icon %s does not exist!\n", icon);
	exit(-1);
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
printf("vfdctl v0.7.1 - usage:\n\
\tvfdctl [[-c] text] [-s speed] [-b file] [+sym] [-sym] ...\n\
\t-c\tcentered output\n\
\t-s\tset animation speed in milliseconds for -b output\n\
\t-b\toutput content of bitmap file\n\
\t-x\tplay vfdx file (animated)\n\
\tto set symbols use e.g. +usb or -usb\n\
\tavailable symbols are usb,hd,hdd,lock,bt,mp3,music,dd,mail,mute,play,pause,ff,fr,rec,clock\n\
\tspecial modes are: \n\
\tvfdctl demomode to start demo loop\n\
\tvfdctl input [text] for remote control input mode\n\
\tvfdctl iconstate [iconname] to get the current icon state\n");
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

int iconOnOff (char* sym, unsigned char onoff) {
	
	char icon=getIconIndex(sym);

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

	char* writechars[7] = {man1, u, f, s, neun, eins, nul };
	char* writechars_ani[7] = {man2, u, f, s, neun, eins, nul };
	
	int i;
	for (i=0; i<7; i++) {
		writeCG(i, *(writechars+i));
	}

	char test[9]={0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x00};
	setMessageToDisplay(test);
	
	
	//animation
	while (1) {
		usleep(750000);
		writeCG(0, *(writechars_ani+0));
		setMessageToDisplay(test);
		
		usleep(750000);
		writeCG(0, *(writechars+0));
		setMessageToDisplay(test);
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

void appendToOutput(char c) {
	//fprintf(stderr,"< appendToOutput\n");
	if (c==0) return;

	input[position] = c;
	if (position == MAX_INPUT) 
		return;
	position++;

	refreshDisp();
	//fprintf(stderr,"appendToOutput >\n");
}

void refreshDisp() {
	memset(&outbuffer[offset], ' ', 16-offset);
	if (position>15-offset) {
		memcpy(&outbuffer[offset], &input[position-15+offset], 15-offset);
		outbuffer[15]=IN_CHAR;
	} else {
		memcpy(&outbuffer[offset], &input, position);
		outbuffer[position+offset]=IN_CHAR;
	}
	setMessageToDisplay(outbuffer);
}

char decodeToChar(char in, char in2) {
	//fprintf(stderr,"< decodeToChar\n");
	
	if (in == 48 && in2 >= 48 && in2 <= 57) {
		return '0' + in2 - 48;
	} else if (in = 48 && in2 == 68) {
		return '.';
	}
	return 0;
}

void inputRemote(char* text) {
	//fprintf(stderr, "< inputRemote(%s)\n", text);

	char* out = malloc(16);
	memset(out, 0x10, 16);
	memset(input, 0, MAX_INPUT);
	memset(outbuffer, ' ', 16);
	
	if (text!=(void*)0) {
		offset=strlen(text);
		if (offset>10) offset=10;
		memcpy(outbuffer, text, offset);
	}

	outbuffer[offset] = IN_CHAR;
	
	FILE* fd;
	if (fd = fopen("/dev/ttyAS1", "r")) {
		fprintf(stderr,"opened remote control\n");
	}
	
	setMessageToDisplay(outbuffer);
	int in,in2,in3;
	char dec_in;

	while((in=fgetc(fd))>0) {
		in2=fgetc(fd);
		in3=fgetc(fd);

		if (in3==10) {
			//fprintf(stderr,"we have input: %d %d\n", in, in2);
			if (in==53 && in2==53) {
				break;
			} else if (in==53 && in2==67) {
				char* out = (char*)malloc(position+1);
				memcpy(out, &input, position);
				*(out+position)= 0x00;
				printf("%s",out);
				break;
			} else if (in==53 && in2==65) {
				//fprintf(stderr,"del\n");
				position--;
				if (position<0) position=0;
				refreshDisp();
			}
			dec_in = decodeToChar(in, in2);
			appendToOutput(dec_in);
		}
	}
	
	memset(&outbuffer, ' ', 16);
	setMessageToDisplay(outbuffer);
	fprintf(stderr, "bye\n");
	fclose(fd);
}

void printState(int index) {
	struct {
		unsigned char start;
		unsigned char data[64];
		unsigned char length;
	} data;

	memset(&data.data[0], 0, 64);
	ioctl(file_vfd, VFDICONGETSTATE, &data);

	data.data[16]=0x00;
	if (data.data[17]!=0x1F) {
		printf("Failed to get icon state! Kernel not patched?\n");
		return;
	}

	if (index == -1) {
		int i;
		for (i=0; i<16; i++) {
			printf("%s: %s\n", icons[i], states[data.data[i]]);
		}
	} else {
		printf("%s: %s\n", icons[index], states[data.data[index]]);
	}
}

void setMessageToDisplayEx ( char* str, int len )
{
	struct ioctl_data
	{
		unsigned char start;
		unsigned char data[64];
		unsigned char length;
	}
	writedisp_data;

	memset ( writedisp_data.data, ' ', 16 );

	if ( len > 16 ) len = 16;
	memcpy ( writedisp_data.data, str, len );

	writedisp_data.start = 0;
	writedisp_data.length = 16;

	ioctl ( file_vfd, VFD_Display_Chars, &writedisp_data );
}

void printBitmap(char* filename, int animationTime) {
	FILE* fd;
	int i, x;
	unsigned char* buf;
	unsigned char* tx;

	buf = malloc(35);
	tx = malloc(17);

	if (fd = fopen(filename, "r")) {
		fread(buf, 35, 1, fd);		// read character bitmaps
		x = 0;
		for (i = 0; i < 35; i += 5) {
			writeCG(x++, &buf[i]);
		}

		while (fread(tx, 17, 1, fd) > 0) {	// read string to display
			setMessageToDisplayEx(tx, 16);
			usleep(animationTime);
		}

		fclose(fd);

	} else {
		fprintf(stderr,"cannot open file\n");
	}

	free(tx);
	free(buf);
}

void playVfdx(char* filename) {
	FILE* fd;
	int i, x;
	unsigned char* buf;
    char endless = 0;
	char currentCharSet = 255;

#pragma pack(1)
	struct {
		char charSet;
		unsigned char text[16];
		unsigned short sleepTime;
	} line;
#pragma pack()

	buf = malloc(10 * 35);

	if (fd = fopen(filename, "r")) {
		fread(&endless, 1, 1, fd);		// read character bitmaps
		fread(buf, 10 * 35, 1, fd);		// read character bitmaps

		for (;;) {
			fseek(fd, 351L, SEEK_SET);

			while (fread(&line, sizeof(line), 1, fd) > 0) {		// read string to display
				if (line.charSet != currentCharSet) {
					currentCharSet = line.charSet;
					x = 0;
					int start = line.charSet * 35;
					for (i = start; i < start + 35; i += 5) {
						writeCG(x++, &buf[i]);
					}
				}
				setMessageToDisplayEx(line.text, 16);
				usleep(line.sleepTime * 1000);
			}

			if (endless == 0) {
				break;
			}
		}

		fclose(fd);

	} else {
		fprintf(stderr,"cannot open file\n");
	}

	free(buf);
}

