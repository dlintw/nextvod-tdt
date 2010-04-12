/*
 * fp_control.c
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
#include <time.h>

#include "global.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct
{
   char* arg;
   char* arg_long;
   char* arg_description;
} tArgs;

tArgs vArgs[] =
{
   { "-e", "--setTimer       ",
"Args: No arguments\nSet the most recent timer from e2 to the frontcontroller and standby" },
   { "-g", "--getTime        ",
"Args: No arguments\nReturn current set frontcontroller time" },
   { "-s", "--setTime        ",
"Args: time date [format???]\nSet the current frontcontroller time" },
   { "-m", "--setTimerManual ",
"Args: time date [format???]\nSet the current frontcontroller wake-up time" },
   { "-gt", "--getTimer       ",
"Args: No arguments\nGet the current frontcontroller wake-up time" },
   { "-d", "--shutdown       ",
"Args: time date [format???]\nShutdown receiver via fc at given time." },
   { "-r", "--reboot         ",
"Args: time date [format???]\nReboot receiver via fc at given time." },
   { "-p", "--sleep          ",
"Args: time date [format???]\nReboot receiver via fc at given time." },
   { "-t", "--settext        ",
"Args: text\nSet text to frontpanel." },
   { "-l", "--setLed         ",
"Args: led on\nSet a led on or off" },
   { "-i", "--setIcon        ",
"Args: icon on\nSet an icon on or off" },
   { "-b", "--setBrightness  ",
"Args: brightness\nSet display brightness" },
   { "-w", "--getWakeupReason",
"Args: No arguments\nGet the wake-up reason" },
   { "-L", "--setLight",
"Args: 0/1\nSet light" },
   { "-c", "--clear",
"Args: No argumens\nClear display, all icons and leds off" },
   { NULL, NULL, NULL }
};

void usage(Context_t * context, char* prg)
{
   /* let the model print out what it can handle in real */
   if ((((Model_t*)context->m)->Usage == NULL) || (((Model_t*)context->m)->Usage(context, prg) < 0))
   {
      int i;

      /* or printout a default usage */
      fprintf(stderr, "usage:\n\n");
      fprintf(stderr, "%s argument [optarg1] [optarg2]\n", prg);

      for (i = 0; ;i++)
      {
         if (vArgs[i].arg == NULL)
	    break;
	 fprintf(stderr, "%s   %s   %s\n\n", vArgs[i].arg, vArgs[i].arg_long, vArgs[i].arg_description);
      }
   }

   if (((Model_t*)context->m)->Exit)
       ((Model_t*)context->m)->Exit(context);
   exit(1);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

/* fixme: check if this function is correct and delivers gmt time */
void getTimeFromArg(char* timeStr, char* dateStr, time_t* theGMTTime)
{
   struct tm  theTime;

   printf("%s\n", __func__);

   sscanf(timeStr, "%d:%d:%d",
		&theTime.tm_hour, &theTime.tm_min, &theTime.tm_sec);

   sscanf(dateStr, "%d-%d-%d",
		&theTime.tm_mday, &theTime.tm_mon, &theTime.tm_year);

   theTime.tm_year -= 1900;
   theTime.tm_mon   = theTime.tm_mon - 1;

   theTime.tm_isdst = -1; /* say mktime that we dont know */
/* fixme: hmm this is not a gmt or, isn't it? */
   *theGMTTime = mktime(&theTime);

/*   new_time = localtime(&dummy);*/
   printf("%s <\n", __func__);

}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


void processCommand (Context_t * context, int argc, char* argv[])
{
    int   i;

    if (((Model_t*)context->m)->Init)
        context->fd = ((Model_t*)context->m)->Init(context);

    if (argc > 1)
    {
        i = 1;
	while (i < argc)
	{
            if ((strcmp(argv[i], "-e") == 0) || (strcmp(argv[i], "--setTimer") == 0))
            {
	        /* setup timer; wake-up time will be read from e2 */
                if (((Model_t*)context->m)->SetTimer)
                    ((Model_t*)context->m)->SetTimer(context);
	    } else
            if ((strcmp(argv[i], "-g") == 0) || (strcmp(argv[i], "--getTime") == 0))
            {
	        time_t theGMTTime;

	        /* get the frontcontroller time */
                if (((Model_t*)context->m)->GetTime)
                {
		    if (((Model_t*)context->m)->GetTime(context, &theGMTTime))
		    {
		       struct tm *gmt = gmtime(&theGMTTime);

		       fprintf(stderr, "Current Time: %02d:%02d:%02d %02d-%02d-%04d\n",
	                 gmt->tm_hour, gmt->tm_min, gmt->tm_sec, gmt->tm_mday, gmt->tm_mon+1, gmt->tm_year+1900);
		    }
		}

	    } else
            if ((strcmp(argv[i], "-s") == 0) || (strcmp(argv[i], "--setTime") == 0))
            {
	        time_t theGMTTime;

                getTimeFromArg(argv[i + 1], argv[i + 2], &theGMTTime);

	        /* set the frontcontroller time */
                if (((Model_t*)context->m)->SetTime)
                    ((Model_t*)context->m)->SetTime(context, &theGMTTime);

		i += 2;
	    } else
            if ((strcmp(argv[i], "-m") == 0) || (strcmp(argv[i], "--setTimerManual") == 0))
            {
	        time_t theGMTTime;

                getTimeFromArg(argv[i + 1], argv[i + 2], &theGMTTime);

	        /* set the frontcontroller timer from args */
                if (((Model_t*)context->m)->SetTimerManual)
                    ((Model_t*)context->m)->SetTimerManual(context, &theGMTTime);

		i += 2;
	    } else
            if ((strcmp(argv[i], "-gt") == 0) || (strcmp(argv[i], "--getTimer") == 0))
            {
	        time_t theGMTTime;

	        /* get the current timer value from frontcontroller */
                if (((Model_t*)context->m)->GetTimer)
                {
		    if (((Model_t*)context->m)->GetTimer(context, &theGMTTime) == 0)
		    {
		       struct tm *gmt = gmtime(&theGMTTime);

		       fprintf(stderr, "Current Timer: %02d:%02d:%02d %02d-%02d-%04d\n",
	                 gmt->tm_hour, gmt->tm_min, gmt->tm_sec, gmt->tm_mday, gmt->tm_mon+1, gmt->tm_year+1900);
		    }
		}
	    } else
            if ((strcmp(argv[i], "-d") == 0) || (strcmp(argv[i], "--shutdown") == 0))
            {
	        time_t theGMTTime;

                getTimeFromArg(argv[i + 1], argv[i + 2], &theGMTTime);

	        /* shutdown immediately or at a given time */
                if (((Model_t*)context->m)->Shutdown)
                    ((Model_t*)context->m)->Shutdown(context, &theGMTTime);

		i += 2;
	    } else
            if ((strcmp(argv[i], "-r") == 0) || (strcmp(argv[i], "--reboot") == 0))
            {
	        time_t theGMTTime;

                getTimeFromArg(argv[i + 1], argv[i + 2], &theGMTTime);

	        /* reboot immediately or at a given time */
                if (((Model_t*)context->m)->Reboot)
                    ((Model_t*)context->m)->Reboot(context, &theGMTTime);

		i += 2;
	    } else
            if ((strcmp(argv[i], "-p") == 0) || (strcmp(argv[i], "--sleep") == 0))
            {
	        time_t theGMTTime;

                getTimeFromArg(argv[i + 1], argv[i + 2], &theGMTTime);

	        /* sleep for a while, or wake-up on another reason (rc ...) */
                if (((Model_t*)context->m)->Sleep)
                    ((Model_t*)context->m)->Sleep(context, &theGMTTime);

		i += 2;
	    } else
            if ((strcmp(argv[i], "-t") == 0) || (strcmp(argv[i], "--settext") == 0))
            {
	        if (i + 1 <= argc)
	           /* set display text */
                   if (((Model_t*)context->m)->SetText)
                       ((Model_t*)context->m)->SetText(context, argv[i+1]);
		i += 1;

	    } else
            if ((strcmp(argv[i], "-l") == 0) || (strcmp(argv[i], "--setLed") == 0))
            {
	        if (i + 2 <= argc)
		{
		   int which, on;

		   which = atoi(argv[i + 1]);
		   on = atoi(argv[i + 2]);
		   i+=2;

	           /* set display led */
                   if (((Model_t*)context->m)->SetLed)
                       ((Model_t*)context->m)->SetLed(context, which, on);

	        }
		i += 2;
	    } else
            if ((strcmp(argv[i], "-i") == 0) || (strcmp(argv[i], "--setIcon") == 0))
            {
	        if (i + 2 <= argc)
		{
		   int which, on;

		   which = atoi(argv[i + 1]);
		   on = atoi(argv[i + 2]);

	           /* set display icon */
                   if (((Model_t*)context->m)->SetIcon)
                       ((Model_t*)context->m)->SetIcon(context, which, on);

	        }
		i += 2;
	    } else
            if ((strcmp(argv[i], "-b") == 0) || (strcmp(argv[i], "--setBrightness") == 0))
            {
	        if (i + 1 <= argc)
		{
		   int brightness;

		   brightness = atoi(argv[i + 1]);

	           /* set display icon */
                   if (((Model_t*)context->m)->SetBrightness)
                       ((Model_t*)context->m)->SetBrightness(context, brightness);

	        }
		i += 1;
	    } else
            if ((strcmp(argv[i], "-w") == 0) || (strcmp(argv[i], "--getWakeupReason") == 0))
            {
		   int reason;

                   if (((Model_t*)context->m)->GetWakeupReason)
                       if (((Model_t*)context->m)->GetWakeupReason(context, &reason) == 0)
		       {
                            printf("wakeup reason = %d\n", reason);
		       }
	    } else
            if ((strcmp(argv[i], "-L") == 0) || (strcmp(argv[i], "--setLight") == 0))
            {
	        if (i + 1 < argc)
		{
		   int on;

		   on = atoi(argv[i + 1]);

	           /* set display icon */
                   if (((Model_t*)context->m)->SetLight)
                       ((Model_t*)context->m)->SetLight(context, on);

	        }
		i += 1;
	    } else
            if ((strcmp(argv[i], "-c") == 0) || (strcmp(argv[i], "--clear") == 0))
            {
	           /* clear the display */
                   if (((Model_t*)context->m)->Clear)
                       ((Model_t*)context->m)->Clear(context);
	    } else
	    {
                usage(context, argv[0]);
	    }

	    i++;
        }
    } else
    {
       usage(context, argv[0]);
    }

    if (((Model_t*)context->m)->Exit)
	((Model_t*)context->m)->Exit(context);
    exit(1);
}

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
        else if(!strncasecmp(vName,"vip2", 4))
            vBoxType = Vip2;
        else if(!strncasecmp(vName,"hdbox", 5))
            vBoxType = HdBox;
	else if(!strncasecmp(vName,"octagon1008", 11))
            vBoxType = HdBox;
        else if(!strncasecmp(vName,"hs5101", 6))
            vBoxType = Hs5101;
        else
            vBoxType = Unknown;
    }

    printf("vBoxType: %d\n", vBoxType);

    return vBoxType;
}


int main (int argc, char* argv[])
{
    eBoxType vBoxType = Unknown;
    Context_t context;

    vBoxType = getModel();

    searchModel(&context, vBoxType);

    printf("Selected Model: %s\n", ((Model_t*)context.m)->Name);

    processCommand(&context, argc, argv);

    return 0;
}
