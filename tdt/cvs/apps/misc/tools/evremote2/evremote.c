/*
 * evremote.c
 *
 * (c) 2009 donald@teamducktales
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
#include "remotes.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

int processSimple (Context_t * context, int argc, char* argv[]) {

    int         vCurrentCode      = -1;

    if (((RemoteControl_t*)context->r)->Init)
       context->fd = (((RemoteControl_t*)context->r)->Init)(context, argc, argv);
    else
    {
       fprintf(stderr, "driver does not support init function\n");
       exit(1);
    }

    if (context->fd < 0)
    {
       fprintf(stderr, "error in device initialization\n");
       exit(1);
    }

    while ( true ) {

        //wait for new command
        if (((RemoteControl_t*)context->r)->Read)
           vCurrentCode = ((RemoteControl_t*)context->r)->Read(context);
        if(vCurrentCode <= 0)
            continue;

        //activate visual notification
        if (((RemoteControl_t*)context->r)->Notification)
           ((RemoteControl_t*)context->r)->Notification(context, 1);

        //Check if tuxtxt is running
        if (checkTuxTxt(vCurrentCode) == false)
           sendInputEvent(vCurrentCode);

        //deactivate visual notification
        if (((RemoteControl_t*)context->r)->Notification)
           ((RemoteControl_t*)context->r)->Notification(context, 0);
    }

    if (((RemoteControl_t*)context->r)->Shutdown)
       ((RemoteControl_t*)context->r)->Shutdown(context);
    else
       close(context->fd);


    return 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


int getKathreinUfs910BoxType() {
    char vType;
    int vFdBox = open("/proc/boxtype", O_RDONLY);

    read (vFdBox, &vType, 1);

    close(vFdBox);

    return vType=='0'?0:vType=='1'||vType=='3'?1:-1;
}

int getModel()
{
    int         vFd             = -1;
    const int   cSize           = 128;
    char        vName[129]      = "Unknown";
    int         vLen            = -1;
    eBoxType    vBoxType        = Unknown;

    vFd = open("/proc/stb/info/model", O_RDONLY);
    vLen = read (vFd, vName, cSize);

    close(vFd);

    if(vLen > 0) {
        vName[vLen-1] = '\0';

        printf("Model: %s\n", vName);

        if(!strncasecmp(vName,"ufs910", 6)) {
            switch(getKathreinUfs910BoxType())
            {
                case 0:
                    vBoxType = Ufs910_1W;
                    break;
                case 1:
                    vBoxType = Ufs910_14W;
                    break;
                default:
                    vBoxType = Unknown;
                    break;
            }
        } else if(!strncasecmp(vName,"ufs922", 6))
            vBoxType = Ufs922;
        else if(!strncasecmp(vName,"tf7700hdpvr", 11))
            vBoxType = Tf7700;
        else if(!strncasecmp(vName,"hl101", 5))
            vBoxType = Hl101;
        else if(!strncasecmp(vName,"vip1-v2", 7))
            vBoxType = Vip2;
        else if(!strncasecmp(vName,"vip2-v1", 7))
            vBoxType = Vip2;
        else if(!strncasecmp(vName,"hdbox", 5))
            vBoxType = HdBox;
		else if(!strncasecmp(vName,"octagon1008", 11))
            vBoxType = HdBox;
        else if(!strncasecmp(vName,"hs5101", 6))
            vBoxType = Hs5101;
        else if(!strncasecmp(vName,"ufs912", 5))
            vBoxType = Ufs912;
        else if(!strncasecmp(vName,"spark", 5))
            vBoxType = Spark;
        else
            vBoxType = Unknown;
    }

    printf("vBoxType: %d\n", vBoxType);

    return vBoxType;
}

void ignoreSIGPIPE()
{
       struct sigaction vAction;

       vAction.sa_handler = SIG_IGN;

       sigemptyset(&vAction.sa_mask);
       vAction.sa_flags = 0;
       sigaction(SIGPIPE,  &vAction, (struct sigaction*)NULL);
}


int main (int argc, char* argv[])
{
    eBoxType vBoxType = Unknown;
    Context_t context;

    /* Dagobert: if tuxtxt closes the socket while
     * we are writing a sigpipe occures which kills
     * evremote. so lets ignore it ...
     */
    ignoreSIGPIPE();

    vBoxType = getModel();

    if(vBoxType != Unknown)
        if(!getEventDevice())
            return 5;

    selectRemote(&context, vBoxType);

    printf("Selected Remote: %s\n", ((RemoteControl_t*)context.r)->Name);

    if(((RemoteControl_t*)context.r)->RemoteControl != NULL) {
        printf("RemoteControl Map:\n");
        printKeyMap((tButton*)((RemoteControl_t*)context.r)->RemoteControl);
    }

    if(((RemoteControl_t*)context.r)->Frontpanel != NULL) {
        printf("Frontpanel Map:\n");
        printKeyMap((tButton*)((RemoteControl_t*)context.r)->Frontpanel);
    }

    const int cMaxButtonExtension = 128; // Up To 128 Extension Buttons
    tButton vButtonExtension[cMaxButtonExtension]; 
    int vButtonExtensionCounter = 0;

    if (argc >= 2) {
        if (argc == 3 && !strncmp(argv[1], "-r", 2)) {
            char   vKeyName[64];
            char   vKeyWord[64];
            int    vKeyCode;
            char * vRemoteFile  = argv[2];
            FILE * vRemoteFileD = NULL;

            vRemoteFileD = fopen(vRemoteFile, "r");
            if (vRemoteFileD != NULL) {
                while ( fscanf(vRemoteFileD,"%s %s %d", vKeyName, vKeyWord, &vKeyCode) == 3 ) {
                    strncpy(vButtonExtension[vButtonExtensionCounter].KeyName, vKeyName, 20);
                    strncpy(vButtonExtension[vButtonExtensionCounter].KeyWord, vKeyWord, 2);
                    vButtonExtension[vButtonExtensionCounter].KeyCode = vKeyCode;
                    vButtonExtensionCounter++;
                    if (vButtonExtensionCounter + 1 == cMaxButtonExtension)
                        break;
                }
                fclose(vRemoteFileD);

                strncpy(vButtonExtension[vButtonExtensionCounter].KeyName, "\0", 1);
                strncpy(vButtonExtension[vButtonExtensionCounter].KeyWord, "\0", 1);
                vButtonExtension[vButtonExtensionCounter].KeyCode = KEY_NULL;

                printf("RemoteControl Extension Map:\n");
                printKeyMap(vButtonExtension);
            }
        }
    }

    if (vButtonExtensionCounter > 0)
        ((RemoteControl_t*)context.r)->RemoteControl = vButtonExtension;
    // TODO
    //if(((RemoteControl_t*)context.r)->RemoteControl == NULL && vButtonExtensionCounter > 0)
        //((RemoteControl_t*)context.r)->RemoteControl = vButtonExtension;
    //else if (vButtonExtensionCounter > 0) {
        //int vRemoteControlSize    = sizeof(((RemoteControl_t*)context.r)->RemoteControl) / sizeof(tButton);
        //int vRemoteControlExtSize = vButtonExtensionCounter;
        //((RemoteControl_t*)context.r)->RemoteControl = malloc((vRemoteControlSize + vRemoteControlExtSize - 1)*sizeof(tButton));
    //}

    //printf("RemoteControl Map:\n");
    //printKeyMap((tButton*)((RemoteControl_t*)context.r)->RemoteControl);

    processSimple(&context, argc, argv);

    return 0;
}
