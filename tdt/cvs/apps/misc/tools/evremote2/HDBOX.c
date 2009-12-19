/*
 * HDBOX.c
 * 
 * (c) 2009 teamducktales
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
#include "HDBOX.h"

/* ***************** some constants **************** */

#define rcDeviceName "/dev/rc"
#define cHDBOXDataLen    128 

typedef struct
{
	int          vLastCode;
        unsigned int lastTime;
	int          rate;
	int          isNewKey;
	int          lenOfCommand;

	int          maxRate;
	int          maxDelay;
} tHDBOXPrivate;

/* ***************** our key assignment **************** */

static tButton cButtonHDBOX[] = {
    {"MENU"           , "04", KEY_MENU},
    {"RED"            , "4B", KEY_RED},
    {"GREEN"          , "4A", KEY_GREEN},
    {"YELLOW"         , "49", KEY_YELLOW},
    {"BLUE"           , "48", KEY_BLUE},
    {"EXIT"           , "1C", KEY_HOME},
    {"TEXT"           , "0D", KEY_TEXT},
    {"EPG"            , "08", KEY_EPG},
    {"REWIND"         , "58", KEY_REWIND},
    {"FASTFORWARD"    , "5C", KEY_FASTFORWARD},
    {"PLAY"           , "55", KEY_PLAY},
    {"PAUSE"          , "07", KEY_PAUSE},
    {"RECORD"         , "56", KEY_RECORD},
    {"STOP"           , "54", KEY_STOP},
    {"STANDBY"        , "0A", KEY_POWER},
    {"MUTE"           , "0C", KEY_MUTE},
    {"CHANNELUP"      , "5E", KEY_PAGEUP},
    {"CHANNELDOWN"    , "5F", KEY_PAGEDOWN},
    {"VOLUMEUP"       , "4E", KEY_VOLUMEUP},
    {"VOLUMEDOWN"     , "4F", KEY_VOLUMEDOWN},
    {"INFO"           , "06", KEY_HELP}, //THIS IS WRONG SHOULD BE KEY_INFO
    {"OK"             , "1F", KEY_OK},
    {"UP"             , "00", KEY_UP},
    {"RIGHT"          , "02", KEY_RIGHT},
    {"DOWN"           , "01", KEY_DOWN},
    {"LEFT"           , "03", KEY_LEFT},
    {"0BUTTON"        , "10", KEY_0},
    {"1BUTTON"        , "11", KEY_1},
    {"2BUTTON"        , "12", KEY_2},
    {"3BUTTON"        , "13", KEY_3},
    {"4BUTTON"        , "14", KEY_4},
    {"5BUTTON"        , "15", KEY_5},
    {"6BUTTON"        , "16", KEY_6},
    {"7BUTTON"        , "17", KEY_7},
    {"8BUTTON"        , "18", KEY_8},
    {"9BUTTON"        , "19", KEY_9},
    {""               , ""  , KEY_NULL},
/* additional:
0x09 = recall
0x0b = TEXT Zoom
0x0e = vformat
0x0f = resolution
0x1a = tv/radio
0x1e = sleep
0x40 = Pfeil + Strich drunter (Archive/Aufnahmen)
0x41 = FAV
0x42 = hackentaste
0x43 = <<P ???
0x44 = P>> ???
0x4c = titel vor
0x50 = titel zurück
0x51 = Bild Zoom; PIP
0x52 = Subservice Swappen
0x53 = Liste möglicher Subservices anzeigen
*/
};

/* ***************** our fp button assignment **************** */

static tButton cButtonHDBOXFrontpanel[] = {
	{"VOLUMEUP"		, "04", KEY_VOLUMEUP},
	{"VOLUMEDOWN"		, "03", KEY_VOLUMEDOWN},
	{"CHANNELUP"		, "01", KEY_PAGEUP},
	{"CHANNELDOWN"	        , "02", KEY_PAGEDOWN},
	{""	                , ""  , KEY_NULL}
/* is there no power key on frontpanel? */
};

static int pInit(Context_t* context, int argc, char* argv[]) 
{
    int vFd;
    tHDBOXPrivate* private = malloc(sizeof(tHDBOXPrivate));

    ((RemoteControl_t*)context->r)->private = private;

    memset(private, 0, sizeof(tHDBOXPrivate));

    if (argc >= 2)
       private->maxRate = atoi(argv[1]);
    else
       private->maxRate = 3;
       
    if (argc == 3)
       private->maxDelay = atoi(argv[2]);
    else
       private->maxDelay = 150;

    printf("maxRate = %d, maxDelay %d\n", private->maxRate, private->maxDelay);

    vFd = open(rcDeviceName, O_RDWR);

    private->lenOfCommand = 0;

    return vFd;
}


static int pRead(Context_t* context) 
{
    unsigned char   vData[cHDBOXDataLen];
    eKeyType        vKeyType = RemoteControl;
    unsigned int    currentTime = 0;
    int             vCurrentCode = -1;
    struct          timespec tmp = {0, 0};
    tHDBOXPrivate* private = (tHDBOXPrivate*) ((RemoteControl_t*)context->r)->private;

    printf("%s >\n", __func__);

    while (1)
    {
    
       private->lenOfCommand += read (context->fd, vData, cHDBOXDataLen - private->lenOfCommand);

       printf("0x%02X 0x%02X\n", vData[0], vData[1]);

       //command complete?
       if (private->lenOfCommand < 1)
	       return -1;

       /* standby buttons (remote control + frontpanel 
	*/	
       if ((vData[0] == 0x80) && (private->lenOfCommand < 2))
	       return -1;

       /* frontpanel buttons */	
       if ((vData[0] == 0x51) && (private->lenOfCommand < 3))
	       return -1;

       /* remotecontrol buttons */	
       if ((vData[0] == 0x63) && (private->lenOfCommand < 5))
	       return -1;

       private->lenOfCommand = 0;

       if ((vData[0] != 0x51) && (vData[0] != 0x63) && (vData[0] != 0x80))
               return -1;

       if(vData[0] == 0x63)
           vKeyType = RemoteControl;
       else 
       if(vData[0] == 0x51)
           vKeyType = FrontPanel;
       else
           return -1;

       if(vKeyType == RemoteControl)
           vCurrentCode = getInternalCodeHex(cButtonHDBOX, vData[3] & ~0x80);
       else
           vCurrentCode = getInternalCodeHex(cButtonHDBOXFrontpanel, vData[1]);

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
    tHDBOXPrivate*          private = (tHDBOXPrivate*) ((RemoteControl_t*)context->r)->private;

/* FIXME */
    if(cOn)
    {
       if (private->isNewKey)
       {
       }
    }
    else
    {
       if (private->isNewKey)
       {
          usleep(10000);
       }
    }

    return 0;
}

static int pShutdown(Context_t* context) 
{
    tHDBOXPrivate*         private = (tHDBOXPrivate*) ((RemoteControl_t*)context->r)->private;

    close(context->fd);
    free(private);
    
    return 0;
}

RemoteControl_t HDBOX_RC = {
	"Fortis HDBOX RemoteControl",
	HdBox,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonHDBOX,
	cButtonHDBOXFrontpanel,
	NULL,
};
