/*
 * Spark.c
 *
 * (c) 2010 duckbox project
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

#include <termios.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <signal.h>
#include <time.h>

#include "global.h"
#include "map.h"
#include "remotes.h"
#include "Spark.h"


#define	SPARK_RC05_PREDATA		"11EE"
#define	SPARK_RC08_PREDATA		"44BB"
#define	SPARK_RC09_PREDATA		"9966"

static tLongKeyPressSupport cLongKeyPressSupport = {
  10, 120,
};

/* Edision argus-spark RCU */
static tButton cButtonsEdisionSpark[] = {
    {"STANDBY"        , "25", KEY_POWER},
    {"MUTE"           , "85", KEY_MUTE},
    {"V.FORMAT"       , "ad", KEY_V},
    {"TV/SAT"         , "c5", KEY_AUX},

    {"0BUTTON"        , "57", KEY_0},
    {"1BUTTON"        , "b5", KEY_1},
    {"2BUTTON"        , "95", KEY_2},
    {"3BUTTON"        , "bd", KEY_3},
    {"4BUTTON"        , "f5", KEY_4},
    {"5BUTTON"        , "d5", KEY_5},
    {"6BUTTON"        , "fd", KEY_6},
    {"7BUTTON"        , "35", KEY_7},
    {"8BUTTON"        , "15", KEY_8},
    {"9BUTTON"        , "3d", KEY_9},

    {"BACK"           , "7f", KEY_BACK},
    {"INFO"           , "a7", KEY_INFO}, //THIS IS WRONG SHOULD BE KEY_INFO
    {"AUDIO"          , "35", KEY_AUDIO},

    {"DOWN/P-"        , "0f", KEY_DOWN},
    {"UP/P+"          , "27", KEY_UP},
    {"RIGHT/V+"       , "af", KEY_RIGHT},
    {"LEFT/V-"        , "6d", KEY_LEFT},
    {"OK/LIST"        , "2f", KEY_OK},
    {"MENU"           , "65", KEY_MENU},
    {"GUIDE"          , "8f", KEY_EPG},
    {"EXIT"           , "4d", KEY_HOME},
    {"FAV"            , "87", KEY_FAVORITES},

    {"RED"            , "7d", KEY_RED},
    {"GREEN"          , "ff", KEY_GREEN},
    {"YELLOW"         , "3f", KEY_YELLOW},
    {"BLUE"           , "bf", KEY_BLUE},

    {"REWIND"         , "1f", KEY_REWIND},
    {"PAUSE"          , "37", KEY_PAUSE},
    {"PLAY"           , "b7", KEY_PLAY},
    {"FASTFORWARD"    , "97", KEY_FASTFORWARD},
    {"RECORD"         , "45", KEY_RECORD},
    {"STOP"           , "f7", KEY_STOP},
    {"SLOWMOTION"     , "5d", KEY_SLOW},
    {"ARCHIVE"        , "75", KEY_ARCHIVE},
    {"SAT"            , "1d", KEY_SAT},
    {"STEPBACK"       , "55", KEY_PREVIOUS},
    {"STEPFORWARD"    , "d7", KEY_NEXT},
    {"MARK"           , "8f", KEY_EPG},
    {"TV/RADIO"       , "77", KEY_TV2}, //WE USE TV2 AS TV/RADIO SWITCH BUTTON
    {"USB"            , "95", KEY_CLOSE},
    {"TIMER"          , "8d", KEY_TIME},
    {""               , ""  , KEY_NULL},
};

/* spark RC8 */
static tButton cButtonsSparRc08[] = {
    {"POWER"          , "4D", KEY_POWER},
    {"MUTE"           , "DD", KEY_MUTE},
    {"TIME"           , "ED", KEY_TIME},
    {"V.FORMAT"       , "AD", KEY_V},
    {"F1"             , "0F", KEY_F1},
    {"TV/SAT"         , "37", KEY_AUX},
    {"USB"            , "0D", KEY_CLOSE},
    {"FIND"           , "35", KEY_FIND},

    {"0BUTTON"        , "27", KEY_0},
    {"1BUTTON"        , "7D", KEY_1},
    {"2BUTTON"        , "3F", KEY_2},
    {"3BUTTON"        , "BD", KEY_3},
    {"4BUTTON"        , "5D", KEY_4},
    {"5BUTTON"        , "1F", KEY_5},
    {"6BUTTON"        , "9D", KEY_6},
    {"7BUTTON"        , "55", KEY_7},
    {"8BUTTON"        , "17", KEY_8},
    {"9BUTTON"        , "95", KEY_9},

	{"TV/RADIO" 	  , "65", KEY_TV2}, //WE USE TV2 AS TV/RADIO SWITCHB
    {"RECALL"         , "A5", KEY_BACK},

    {"MENU"           , "5F", KEY_MENU},
    {"INFO"           , "1D", KEY_INFO},

	{"UP"		      , "9F", KEY_UP},
	{"DOWN"		      , "AF", KEY_DOWN},
	{"LEFT" 	      , "3D", KEY_LEFT},
	{"RIGHT"		  , "7F", KEY_RIGHT},
	{"OK"		      , "BF", KEY_OK},
    {"EXIT"           , "2D", KEY_HOME},
    {"EPG"            , "25", KEY_EPG},

    {"VOL-"           , "8D", KEY_VOLUMEDOWN},
    {"VOL+"           , "B5", KEY_VOLUMEUP},
    {"REC"            , "EF", KEY_RECORD},
    {"PAGE-"          , "B7", KEY_CHANNELDOWN},
    {"PAGE+"          , "77", KEY_CHANNELUP},

	{"FOLDER"		  , "E5", KEY_ARCHIVE},

	{"STOP" 		  , "A7", KEY_STOP},
	{"PLAY" 		  , "75", KEY_PLAY},
	{"PAUSE"		  , "F5", KEY_PAUSE},
	{"FASTFORWARD"	  , "CD", KEY_FASTFORWARD},
	{"REWIND"		  , "D5", KEY_REWIND},
    {"PREV"           , "8F", KEY_PREVIOUS},
    {"NEXT"           , "57", KEY_NEXT},

    {"Tms"            , "4F", KEY_T},

    {"FAST"           , "97", KEY_F},
    {"SLOW"           , "15", KEY_SLOW},
    {"PLAY_MODE"      , "6F", KEY_P},
    {"WHITE"          , "67", KEY_W},

    {"RED"            , "05", KEY_RED},
    {"GREEN"          , "87", KEY_GREEN},
    {"YELLOW"         , "C5", KEY_YELLOW},
    {"BLUE"           , "47", KEY_BLUE},

	{"FAV"			  , "F7", KEY_FAVORITES},
    {"SAT"            , "2F", KEY_SAT},
    {"TTX"            , "DF", KEY_TITLE},
    {"AUDIO"          , "D7", KEY_SUBTITLE},
    {""               , ""  , KEY_NULL},
};
/* fixme: move this to a structure and
 * use the private structure of RemoteControl_t
 */
static struct sockaddr_un  vAddr;



static tButton *pSparkGetButton(char *pData)

{
	tButton	*pButtons = cButtonsEdisionSpark;
	if (!strncasecmp(pData, SPARK_RC05_PREDATA, sizeof(SPARK_RC05_PREDATA)))
	{
		pButtons = cButtonsEdisionSpark;
	}
	else if (!strncasecmp(pData, SPARK_RC08_PREDATA, sizeof(SPARK_RC08_PREDATA)))
	{
		pButtons = cButtonsSparRc08;
	}
	else if (!strncasecmp(pData, SPARK_RC09_PREDATA, sizeof(SPARK_RC09_PREDATA)))
	{
		pButtons = cButtonsEdisionSpark;
	}
	return pButtons;
}


static int pInit(Context_t* context, int argc, char* argv[]) {

    int vHandle;

    vAddr.sun_family = AF_UNIX;
    strcpy(vAddr.sun_path, "/dev/lircd");

    vHandle = socket(AF_UNIX,SOCK_STREAM, 0);

    if(vHandle == -1)  {
        perror("socket");
        return -1;
    }

    if(connect(vHandle,(struct sockaddr *)&vAddr,sizeof(vAddr)) == -1)
    {
        perror("connect");
        return -1;
    }

    return vHandle;
}

static int pShutdown(Context_t* context ) {

    close(context->fd);

    return 0;
}

static int pRead(Context_t* context ) {
    char                vBuffer[128];
    char                vData[10];
    const int           cSize         = 128;
    int                 vCurrentCode  = -1;
	int					rc;
	tButton 			*cButtons = cButtonsEdisionSpark;

	memset(vBuffer, 0, 128);
    //wait for new command
    rc = read (context->fd, vBuffer, cSize);
	if(rc <= 0)return -1;

    //parse and send key event
    vData[0] = vBuffer[17];
    vData[1] = vBuffer[18];
    vData[2] = '\0';


    vData[0] = vBuffer[8];
    vData[1] = vBuffer[9];
    vData[2] = vBuffer[10];
    vData[3] = vBuffer[11];
    vData[4] = '\0';
	cButtons = pSparkGetButton(vData);

    vData[0] = vBuffer[14];
    vData[1] = vBuffer[15];
    vData[2] = '\0';

    printf("[RCU] key: %s -> %s\n", vData, &vBuffer[0]);
    vCurrentCode = getInternalCode(cButtons, vData);

	if(vCurrentCode != 0) {
		static int nextflag = 0;
		if (('0' == vBuffer[17]) && ('0' == vBuffer[18]))
		{
		    nextflag++;
		}
		vCurrentCode += (nextflag << 16);
	}
    return vCurrentCode;
}

static int pNotification(Context_t* context, const int cOn) {

    struct aotom_ioctl_data vfd_data;
    int ioctl_fd = -1;

    if(cOn)
    {
       ioctl_fd = open("/dev/vfd", O_RDONLY);
       vfd_data.u.icon.icon_nr = 35;
       vfd_data.u.icon.on = 1;
       ioctl(ioctl_fd, VFDICONDISPLAYONOFF, &vfd_data);
       close(ioctl_fd);
    }
    else
    {
       usleep(100000);
       ioctl_fd = open("/dev/vfd", O_RDONLY);
       vfd_data.u.icon.icon_nr = 35;
       vfd_data.u.icon.on = 0;
       ioctl(ioctl_fd, VFDICONDISPLAYONOFF, &vfd_data);
       close(ioctl_fd);
    }

    return 0;
}

RemoteControl_t Spark_RC = {
	"Spark RemoteControl",
	Spark,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonsEdisionSpark,
	NULL,
	NULL,
  	1,
  	&cLongKeyPressSupport,
};

