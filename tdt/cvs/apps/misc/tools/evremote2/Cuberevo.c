/*
 * Cuberevo.c
 * 
 * (c) 2011 konfetti
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
#include "Cuberevo.h"

/* ***************** some constants **************** */

#define rcDeviceName "/dev/rc"
#define cCuberevoCommandLen 2

/* ***************** our key assignment **************** */

static tLongKeyPressSupport cLongKeyPressSupport = {
  10, 140,
};

static tButton cButtonCuberevo[] = {
    {"MEDIA"          , "09", KEY_MEDIA},   //fixme
    {"ARCHIVE"        , "0D", KEY_ARCHIVE}, //fixme
    {"MENU"           , "26", KEY_MENU},
    {"RED"            , "2A", KEY_RED},
    {"GREEN"          , "2D", KEY_GREEN},
    {"YELLOW"         , "2E", KEY_YELLOW},
    {"BLUE"           , "2B", KEY_BLUE},
    {"EXIT"           , "27", KEY_HOME},
    {"TEXT"           , "31", KEY_TEXT},
    {"EPG"            , "06", KEY_EPG},
    {"REWIND"         , "1E", KEY_REWIND},
    {"FASTFORWARD"    , "21", KEY_FASTFORWARD},
    {"PLAY"           , "20", KEY_PLAY},
    {"PAUSE"          , "25", KEY_PAUSE},
    {"RECORD"         , "07", KEY_RECORD},
    {"STOP"           , "22", KEY_STOP},
    {"STANDBY"        , "0A", KEY_POWER},
    {"MUTE"           , "0C", KEY_MUTE},
#if 0
    {"CHANNELUP"      , "1A", KEY_PAGEUP},    //fixme
    {"CHANNELDOWN"    , "1B", KEY_PAGEDOWN},  //fixme
#endif
    {"VOLUMEUP"       , "34", KEY_VOLUMEUP},
    {"VOLUMEDOWN"     , "35", KEY_VOLUMEDOWN},
    {"HELP"           , "81", KEY_HELP},      //fixme
    {"INFO"           , "03", KEY_INFO},
    {"OK"             , "1F", KEY_OK},
    {"UP"             , "1A", KEY_UP},
    {"RIGHT"          , "1C", KEY_RIGHT},
    {"DOWN"           , "1B", KEY_DOWN},
    {"LEFT"           , "1D", KEY_LEFT},
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
    {"SLOW"           , "23", KEY_SLOW},
    {"AGAIN"          , "24", KEY_AGAIN},
    {"BOOKMARKS"      , "29", KEY_BOOKMARKS},
    {"WWW"            , "36", KEY_WWW},
    {"AUDIO"          , "2F", KEY_AUDIO},
    {"SUBTITLE"       , "30", KEY_SUBTITLE},
    {"PREVIOUS"       , "05", KEY_PREVIOUS},
    {"RADIO"          , "04", KEY_RADIO},
    {"FAVORITES"      , "08", KEY_FAVORITES},
    {""               , ""  , KEY_NULL},
};

/* ***************** our fp button assignment **************** */

static tButton cButtonCuberevoFrontpanel[] = {
	{"FP_POWER"		, "00", KEY_POWER},
	{"FP_MENU"		, "01", KEY_MENU},
	{"FP_MENU"		, "02", KEY_EXIT},
	{"FP_F9"		, "03", KEY_F9},
	{"FP_OK"		, "04", KEY_OK},
	{"FP_LEFT"		, "05", KEY_LEFT},
	{"FP_RIGHT"		, "06", KEY_RIGHT},
	{"FP_UP"		, "07", KEY_UP},
	{"FP_DOWN"		, "08", KEY_DOWN},
	{""	            , ""  , KEY_NULL}
};

static int pInit(Context_t* context, int argc, char* argv[]) 
{
    int vFd;
    vFd = open(rcDeviceName, O_RDWR);

    if (argc >= 2)
    {
       cLongKeyPressSupport.period = atoi(argv[1]);
    }
    
    if (argc >= 3)
    {
       cLongKeyPressSupport.delay = atoi(argv[2]);
    }

    printf("period %d, delay %d\n", cLongKeyPressSupport.period, cLongKeyPressSupport.delay);

    return vFd;
}


static int pRead(Context_t* context) 
{
    unsigned char   vData[cCuberevoCommandLen];
    eKeyType        vKeyType = RemoteControl;
    static   int    vNextKey = 0;
    static   int    lastCode = 0;
    int             vCurrentCode = -1;
    static   char   vOldButton = 0;

    //printf("%s >\n", __func__);

    while (1)
    {
       read (context->fd, vData, cCuberevoCommandLen);

       if(vData[0] == 0xe0)
           vKeyType = RemoteControl;
       else 
       if(vData[0] == 0xE1) //fixme 0xe2
           vKeyType = FrontPanel;
       else
           continue;

       printf("data[0] 0x%2x, data[1] 0x%2x\n", vData[0], vData[1]);
       
       if(vKeyType == RemoteControl) 
       {
           if (vData[1] != 0xff)
               vCurrentCode = 
                    getInternalCodeHex((tButton*)((RemoteControl_t*)context->r)->RemoteControl, vData[1]);
           else
           {
               lastCode = vCurrentCode = 0;
           }
              
           if (vCurrentCode != 0) 
           {
               vNextKey = ((vCurrentCode != lastCode) ? vNextKey + 1 : vNextKey) % 0x100;
               lastCode = vCurrentCode;

//               printf("nextFlag %d\n", vNextKey);

               vCurrentCode += (vNextKey << 16);
               
               break;
           }
       }
       else 
       {
//FIXME
           vCurrentCode = getInternalCodeHex((tButton*)((RemoteControl_t*)context->r)->Frontpanel, vData[1]);

           if(vCurrentCode != 0) 
           {
             vNextKey = (vOldButton != vData[1] ? vNextKey + 1 : vNextKey) % 0x100;

             /* printf("nextFlag %d\n", vNextKey);*/

             vCurrentCode += (vNextKey << 16);
             break;
           }
       }
    }
//    printf("%s < %08X\n", __func__, vCurrentCode);
    
    return vCurrentCode;
}

static int pNotification(Context_t* context, const int cOn) 
{

  return 0;
}

static int pShutdown(Context_t* context) 
{

  close(context->fd);

  return 0;
}

RemoteControl_t Cuberevo_RC = {
  "Kathrein Cuberevo RemoteControl",
  Cuberevo,
  &pInit,
  &pShutdown,
  &pRead,
  &pNotification,
  cButtonCuberevo,
  cButtonCuberevoFrontpanel,
  NULL,
  1,
  &cLongKeyPressSupport,
};

