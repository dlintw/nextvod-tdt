/*
 * Ufs912.c
 * 
 * (c) 2009 dagobert@teamducktales
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or 
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <linux/input.h>
#include <termios.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <signal.h>
#include <time.h>

#include "global.h"
#include "map.h"
#include "remotes.h"
#include "Ufs912.h"

/* ***************** some constants **************** */

#define rcDeviceName "/dev/rc"
#define cUFS912CommandLen 8

typedef struct
{
	int          vLastCode;
        unsigned int lastTime;
	int          rate;
	int          isNewKey;
	int          toggleFeedback;
	
	int          maxRate;
	int          maxDelay;
} tUFS912Private;

/* ***************** our key assignment **************** */

static tButton cButtonUFS912[] = {
    {"MENU"           , "54", KEY_MENU},
    {"RED"            , "6D", KEY_RED},
    {"GREEN"          , "6E", KEY_GREEN},
    {"YELLOW"         , "6F", KEY_YELLOW},
    {"BLUE"           , "70", KEY_BLUE},
    {"EXIT"           , "55", KEY_HOME},
    {"TEXT"           , "3C", KEY_TEXT},
    {"EPG"            , "4C", KEY_EPG},
    {"REWIND"         , "21", KEY_REWIND},
    {"FASTFORWARD"    , "20", KEY_FASTFORWARD},
    {"PLAY"           , "38", KEY_PLAY},
    {"PAUSE"          , "39", KEY_PAUSE},
    {"RECORD"         , "37", KEY_RECORD},
    {"STOP"           , "31", KEY_STOP},
    {"STANDBY"        , "0C", KEY_POWER},
    {"MUTE"           , "0D", KEY_MUTE},
    {"CHANNELUP"      , "1E", KEY_PAGEUP},
    {"CHANNELDOWN"    , "1F", KEY_PAGEDOWN},
    {"VOLUMEUP"       , "10", KEY_VOLUMEUP},
    {"VOLUMEDOWN"     , "11", KEY_VOLUMEDOWN},
    {"INFO"           , "0F", KEY_HELP}, //THIS IS WRONG SHOULD BE KEY_INFO
    {"OK"             , "5C", KEY_OK},
    {"UP"             , "58", KEY_UP},
    {"RIGHT"          , "5B", KEY_RIGHT},
    {"DOWN"           , "59", KEY_DOWN},
    {"LEFT"           , "5A", KEY_LEFT},
    {"0BUTTON"        , "00", KEY_0},
    {"1BUTTON"        , "01", KEY_1},
    {"2BUTTON"        , "02", KEY_2},
    {"3BUTTON"        , "03", KEY_3},
    {"4BUTTON"        , "04", KEY_4},
    {"5BUTTON"        , "05", KEY_5},
    {"6BUTTON"        , "06", KEY_6},
    {"7BUTTON"        , "07", KEY_7},
    {"8BUTTON"        , "08", KEY_8},
    {"9BUTTON"        , "09", KEY_9},
    {""               , ""  , KEY_NULL},
};

/* ***************** our fp button assignment **************** */

static tButton cButtonUFS912Frontpanel[] = {
	{"FP_MEDIA"		, "80", KEY_MENU},
	{"FP_ON_OFF"		, "01", KEY_HOME},
	{"FP_MINUS"		, "04", KEY_DOWN},
	{"FP_PLUS"		, "02", KEY_UP},
	{"FP_TV_R"		, "08", KEY_OK},
	{""	                , ""  , KEY_NULL}
/* Powerkey is used as HOME EXIT Button? */
};

static int pInit(Context_t* context, int argc, char* argv[]) 
{
    int vFd;
    tUFS912Private* private = malloc(sizeof(tUFS912Private));

    ((RemoteControl_t*)context->r)->private = private;

    vFd = open(rcDeviceName, O_RDWR);

    memset(private, 0, sizeof(tUFS912Private));

    if (argc >= 2)
       private->toggleFeedback = atoi(argv[1]);
    else
       private->toggleFeedback = 0;
       
    if (argc >= 3)
       private->maxRate = atoi(argv[2]);
    else
       private->maxRate = 2;
       
    if (argc == 4)
       private->maxDelay = atoi(argv[3]);
    else
       private->maxDelay = 400;

    printf("toggleFeedback = %d, maxRate = %d, maxDelay %d\n", private->toggleFeedback, private->maxRate, private->maxDelay);
        			
    if (private->toggleFeedback)
    {
       struct micom_ioctl_data vfd_data;
       int ioctl_fd = open("/dev/vfd", O_RDONLY);
		   	
       vfd_data.u.led.led_nr = 6;
       vfd_data.u.led.on = 1;
       ioctl(ioctl_fd, VFDSETLED, &vfd_data);
       close(ioctl_fd);
    }

    return vFd;
}


static int pRead(Context_t* context) 
{
    unsigned char   vData[cUFS912CommandLen];
    eKeyType        vKeyType = RemoteControl;
    unsigned int    currentTime = 0;
    int             vCurrentCode = -1;
    struct          timespec tmp = {0, 0};
    tUFS912Private* private = (tUFS912Private*) ((RemoteControl_t*)context->r)->private;

    printf("%s >\n", __func__);

    while (1)
    {
       read (context->fd, vData, cUFS912CommandLen);

       printf("0x%02X 0x%02X\n", vData[0], vData[1]);

       if(vData[0] == 0xD2)
           vKeyType = RemoteControl;
       else 
       if(vData[0] == 0xD1)
           vKeyType = FrontPanel;
       else
           return -1;

       if(vKeyType == RemoteControl)
           vCurrentCode = getInternalCodeHex(cButtonUFS912, vData[1] & ~0x80);
       else
           vCurrentCode = getInternalCodeHex(cButtonUFS912Frontpanel, vData[1]);

       private->isNewKey = 0;

       /* get time */
       clock_gettime(CLOCK_REALTIME, &tmp);

       /* convert it to milliseconds */
       currentTime = tmp.tv_sec * 1000 + tmp.tv_nsec / 1000000;

       /* printf("c %x l %x\n", vCurrentCode, private->vLastCode); */

/* fixme: to be observed if this should be distinguished between
 * frontpanel button and remote control. what about people
 * who uses an alternate rc, which may be a little bit different
 * in behaviour. so we need maxRate and Delay for rc and fp
 * button ...
 */
       if (vCurrentCode != private->vLastCode)
	  private->isNewKey = 1;
       else
       {
	  if (private->lastTime == 0)
             private->lastTime = currentTime;

	  if (currentTime - private->lastTime > private->maxDelay)
             private->isNewKey = 1;

             /* printf("%d %d %d\n", currentTime, lastTime, currentTime - lastTime); */
       }  

       private->vLastCode = vCurrentCode; 
       private->lastTime = currentTime;

       if (private->isNewKey) 
	  private->rate = 0;
       else
	  private->rate++;

       if ((!private->isNewKey) && (private->rate < private->maxRate))
	  return -1;

       private->rate = 0;
       break;
    } /* for later use we make a dummy while loop here */
    
    printf("%s <\n", __func__);
    
    return vCurrentCode;
}

static int pNotification(Context_t* context, const int cOn) 
{
    int 	            ioctl_fd = -1;
    struct micom_ioctl_data vfd_data;
    tUFS912Private*         private = (tUFS912Private*) ((RemoteControl_t*)context->r)->private;

    if(cOn)
    {
       if (private->isNewKey)
       {
            ioctl_fd = open("/dev/vfd", O_RDONLY);
            vfd_data.u.led.led_nr = 2;
            vfd_data.u.led.on = !private->toggleFeedback;
            ioctl(ioctl_fd, VFDSETLED, &vfd_data);
            close(ioctl_fd);
       }
    }
    else
    {
       if (private->isNewKey)
       {
          usleep(100000);
          ioctl_fd = open("/dev/vfd", O_RDONLY);
          vfd_data.u.led.led_nr = 2;
          vfd_data.u.led.on = private->toggleFeedback;
          ioctl(ioctl_fd, VFDSETLED, &vfd_data);
          close(ioctl_fd);
       }
    }

    return 0;
}

static int pShutdown(Context_t* context) 
{
    tUFS912Private*         private = (tUFS912Private*) ((RemoteControl_t*)context->r)->private;

    close(context->fd);

    if (private->toggleFeedback)
    {
       struct micom_ioctl_data vfd_data;
       int ioctl_fd = open("/dev/vfd", O_RDONLY);
		   	
       vfd_data.u.led.led_nr = 6;
       vfd_data.u.led.on = 0;
       ioctl(ioctl_fd, VFDSETLED, &vfd_data);
       close(ioctl_fd);
    }

    free(private);
    
    return 0;
}

RemoteControl_t UFS912_RC = {
	"Kathrein UFS912 RemoteControl",
	Ufs912,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonUFS912,
	cButtonUFS912Frontpanel,
	NULL,
};
