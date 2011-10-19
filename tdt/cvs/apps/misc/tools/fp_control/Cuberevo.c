/*
 * Cuberevo.c
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

/******************** includes ************************ */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>
#include <sys/ioctl.h>

#include "global.h"
#include "Cuberevo.h"

static int setText(Context_t* context, char* theText);

/******************** constants ************************ */

#define cVFD_DEVICE "/dev/vfd"
#define cRC_DEVICE "/dev/rc"

#define cMAXCharsCuberevo 14 /* 14seg ->rest is filtered by driver */

typedef struct
{
    int    display;
    int    display_custom;
    char*  timeFormat;
    
    time_t wakeupTime;
    int    wakeupDecrement;
} tCUBEREVOPrivate;

/* ******************* helper/misc functions ****************** */

static void setMode(int fd)
{
   struct micom_ioctl_data micom;
   
   micom.u.mode.compat = 1;
   
   if (ioctl(fd, VFDSETMODE, &micom) < 0)
   {
      perror("setMode: ");
   }
   
}

/* calculate the time value which we can pass to
 * the micom fp.
 */
static void setMicomTime(time_t theGMTTime, char* destString, int seconds)
{
   struct tm* now_tm;
   char tmpString[13];
   now_tm = gmtime (&theGMTTime);

   if (seconds)
   {
      sprintf(tmpString, "%02d%02d%02d%02d%02d%02d", 
         now_tm->tm_year-100, now_tm->tm_mon+1, now_tm->tm_mday, now_tm->tm_hour, now_tm->tm_min, now_tm->tm_sec);
      strncpy(destString, tmpString, 12);
   }
   else
   {
      sprintf(tmpString, "%02d%02d%02d%02d%02d", 
         now_tm->tm_year-100, now_tm->tm_mon+1, now_tm->tm_mday, now_tm->tm_hour, now_tm->tm_min);
      strncpy(destString, tmpString, 10);
   }
}

static time_t getMicomTime(char* micomTimeString)
{
    char            convertTime[128];
	unsigned int 	year, month, day;
	unsigned int 	hour, min, sec;
	struct tm       the_tm;

    sprintf(convertTime, "%02x %02x %02x %02x %02x %02x\n", 
                                  micomTimeString[0], micomTimeString[1],
                                  micomTimeString[2], micomTimeString[3],
                                  micomTimeString[4], micomTimeString[5]);

    sscanf(convertTime, "%d %d %d %d %d %d", &sec, &min, &hour, &day, &month, &year);

    the_tm.tm_year = year + 100;
    the_tm.tm_mon  = month -1;
    the_tm.tm_mday = day;
    the_tm.tm_hour = hour;
    the_tm.tm_min  = min;
    the_tm.tm_sec  = sec;
    the_tm.tm_isdst= -1;

    return mktime(&the_tm);
}

/* ******************* driver functions ****************** */

static int init(Context_t* context)
{
    tCUBEREVOPrivate* private = malloc(sizeof(tCUBEREVOPrivate));
    int vFd;

    printf("%s\n", __func__);
    
    vFd = open(cVFD_DEVICE, O_RDWR);
      
    if (vFd < 0)
    {
       fprintf(stderr, "cannot open %s\n", cVFD_DEVICE);
       perror("");
    }
    
    ((Model_t*)context->m)->private = private;
    memset(private, 0, sizeof(tCUBEREVOPrivate));

    checkConfig(&private->display, &private->display_custom, &private->timeFormat, &private->wakeupDecrement);

    return vFd;   
}

static int usage(Context_t* context, char* prg_name)
{
   fprintf(stderr, "%s: not implemented\n", __func__);
   return -1;
}

static int setTime(Context_t* context, time_t *theGMTTime)
{
   struct micom_ioctl_data vData;
   printf("%s ->\n", __func__);

   setMicomTime(*theGMTTime, vData.u.time.time, 1);

   fprintf(stderr, "Setting current Fp Time to: %s (mtime)\n", vData.u.time.time);

#if 1
   if (ioctl(context->fd, VFDSETTIME, &vData) < 0)
   {
      perror("settime: ");
      printf("%s <- -1\n", __func__);
      return -1;
   }
#endif

   printf("%s <- 0\n", __func__);
   return 0;
}

static int getTime(Context_t* context, time_t* theGMTTime)
{
   struct micom_ioctl_data vData;
   printf("%s ->\n", __func__);

   fprintf(stderr, "Getting current Fp Time...\n");

#if 1
   /* front controller time */
   if (ioctl(context->fd, VFDGETTIME, &vData) < 0)
   {
      perror("gettime: ");
      printf("%s <- -1\n", __func__);
      return -1;
   }
#else
   strncpy(vData.u.get_time.time, "111017182540", 12);
#endif

   fprintf(stderr, "Got current Fp Time %s (mtime)\n", vData.u.get_time.time);

   /* current front controller time */
   *theGMTTime = (time_t) getMicomTime(vData.u.get_time.time);

   printf("%s <- 0\n", __func__);
   return 0;
}
	
static int getWakeupTime(Context_t* context, time_t* theGMTTime)
{
   struct micom_ioctl_data vData;

   fprintf(stderr, "waiting on current wakeup-time from fp ...\n");

   /* front controller time */
   if (ioctl(context->fd, VFDGETWAKEUPTIME, &vData) < 0)
   {
      perror("gettime: ");
      return -1;
   }

   /* current front controller time */
   *theGMTTime = (time_t) getMicomTime(vData.u.wakeup_time.time);

   return 0;
}

static int setTimer(Context_t* context)
{
   struct micom_ioctl_data vData;
   time_t                  curTime    = 0;
   time_t                  curTimeFp  = 0;
   time_t                  wakeupTime = 0;
   struct tm               *ts;
   struct tm               *tsFp;
   struct tm               *tsWakeupTime;
   tCUBEREVOPrivate* private = (tCUBEREVOPrivate*) 
        ((Model_t*)context->m)->private;

   printf("%s ->\n", __func__);

   // Get current Frontpanel time
   getTime(context, &curTimeFp);
   tsFp = gmtime (&curTimeFp);
   fprintf(stderr, "Current Fp Time:     %02d:%02d:%02d %02d-%02d-%04d (UTC)\n",
      tsFp->tm_hour, tsFp->tm_min, tsFp->tm_sec, 
      tsFp->tm_mday, tsFp->tm_mon + 1, tsFp->tm_year + 1900);

   // Get current Linux time
   time(&curTime);
   ts = gmtime (&curTime);
   fprintf(stderr, "Current Linux Time:  %02d:%02d:%02d %02d-%02d-%04d (UTC)\n",
      ts->tm_hour, ts->tm_min, ts->tm_sec, 
      ts->tm_mday, ts->tm_mon + 1, ts->tm_year + 1900);

   // Set current Linux time as new current Frontpanel time
   setTime(context, &curTime);

   wakeupTime = read_e2_timers(curTime);

   /* failed to read e2 timers so lets take a look if
    * we are running on neutrino
    */
   if (wakeupTime == LONG_MAX)
      wakeupTime = read_neutrino_timers(curTime);

   if ((wakeupTime == 0) || (wakeupTime == LONG_MAX))
   {
       /* clear timer */
       vData.u.standby.time[0] = '\0';
   }
   else
   {
      // Print wakeup time
      tsWakeupTime = gmtime (&wakeupTime);
      fprintf(stderr, "Planned Wakeup Time: %02d:%02d:%02d %02d-%02d-%04d (UTC)\n", 
         tsWakeupTime->tm_hour, tsWakeupTime->tm_min, tsWakeupTime->tm_sec, 
         tsWakeupTime->tm_mday, tsWakeupTime->tm_mon + 1, tsWakeupTime->tm_year + 1900);

      setMicomTime(wakeupTime, vData.u.standby.time, 0);
      fprintf(stderr, "Setting Planned Fp Wakeup Time to = %s (mtime)\n", 
         vData.u.standby.time );
   }

   fprintf(stderr, "Entering DeepStandby. ... good bye ...\n");
   fflush(stdout);
   fflush(stderr);
   sleep(2);
   if (ioctl(context->fd, VFDSTANDBY, &vData) < 0)
   {
      perror("standby: ");
      printf("%s <- -1\n", __func__);
      return -1;
   }

   printf("%s <- 0\n", __func__);
   return 0;
}

static int setTimerManual(Context_t* context, time_t* theGMTTime)
{
   struct micom_ioctl_data vData;
   time_t                  curTime;
   time_t                  wakeupTime;
   struct tm               *ts;

   time(&curTime);
   ts = localtime (&curTime);

   fprintf(stderr, "Current Time: %02d:%02d:%02d %02d-%02d-%04d\n",
	   ts->tm_hour, ts->tm_min, ts->tm_sec, ts->tm_mday, ts->tm_mon+1, ts->tm_year+1900);

   wakeupTime = *theGMTTime;
   
   if ((wakeupTime == 0) || (curTime > wakeupTime))
   {
       /* nothing to do for e2 */   
       fprintf(stderr, "wrong timer parsed clearing fp wakeup time ... good bye ...\n");

       vData.u.standby.time[0] = '\0';

       if (ioctl(context->fd, VFDSTANDBY, &vData) < 0)
       {
	      perror("standby: ");
          return -1;
       }
             
   } else
   {
      unsigned long diff;

      fprintf(stderr, "waiting on current time from fp ...\n");
		
      /* front controller time */
      if (ioctl(context->fd, VFDGETTIME, &vData) < 0)
      {
         perror("gettime: ");
         return -1;
      }
		
      /* difference from now to wake up */
      diff = (unsigned long int) wakeupTime - curTime;

      /* current front controller time */
      curTime = (time_t) getMicomTime(vData.u.get_time.time);

      wakeupTime = curTime + diff;

      setMicomTime(wakeupTime, vData.u.standby.time, 0);

      if (ioctl(context->fd, VFDSTANDBY, &vData) < 0)
      {
         perror("standby: ");
         return -1;
      }
   }
   return 0;
}

static int getTimer(Context_t* context, time_t* theGMTTime)
{
   fprintf(stderr, "%s: not implemented\n", __func__);
   return -1;
}

static int shutdown(Context_t* context, time_t* shutdownTimeGMT)
{
   time_t     curTime;
   
   /* shutdown immediate */
   if (*shutdownTimeGMT == -1)
      return (setTimer(context));
   
   while (1)
   {
      time(&curTime);

      /*printf("curTime = %d, shutdown %d\n", curTime, *shutdownTimeGMT);*/
 
      if (curTime >= *shutdownTimeGMT)
      {
          /* set most recent e2 timer and bye bye */
          return (setTimer(context));
      }

      usleep(100000);
   }
   
   return -1;
}

static int reboot(Context_t* context, time_t* rebootTimeGMT)
{
   time_t                  curTime;
   struct micom_ioctl_data vData;
   
   while (1)
   {
      time(&curTime);

      if (curTime >= *rebootTimeGMT)
      {
         if (ioctl(context->fd, VFDREBOOT, &vData) < 0)
         {
            perror("reboot: ");
            return -1;
         }
      }

      usleep(100000);
   }
   return 0;
}

static int Sleep(Context_t* context, time_t* wakeUpGMT)
{
   time_t     curTime;
   int        sleep = 1;   
   int        vFd;
   fd_set     rfds;
   struct     timeval tv;
   int        retval;
   struct tm  *ts;
   char       output[cMAXCharsCuberevo + 1];
   tCUBEREVOPrivate* private = (tCUBEREVOPrivate*) 
        ((Model_t*)context->m)->private;

   printf("%s\n", __func__);

   vFd = open(cRC_DEVICE, O_RDWR);
      
   if (vFd < 0)
   {
      fprintf(stderr, "cannot open %s\n", cRC_DEVICE);
      perror("");
      return -1;
   }
      
   printf("%s 1\n", __func__);

   while (sleep)
   {
      time(&curTime);
      ts = localtime (&curTime);

      if (curTime >= *wakeUpGMT)
      {
         sleep = 0;
      } else
      {
	 FD_ZERO(&rfds);
	 FD_SET(vFd, &rfds);

	 tv.tv_sec = 0;
	 tv.tv_usec = 100000;

	 retval = select(vFd + 1, &rfds, NULL, NULL, &tv);

	 if (retval > 0)
	 {
            sleep = 0;
	 } 
      }

      if (private->display)
      {
         strftime(output, cMAXCharsCuberevo + 1, private->timeFormat, ts);
         setText(context, output);
      } 
   }
   return 0;
}
	
static int setText(Context_t* context, char* theText)
{
   char vHelp[128];
   
   strncpy(vHelp, theText, cMAXCharsCuberevo);
   vHelp[cMAXCharsCuberevo] = '\0';
 
   /* printf("%s, %d\n", vHelp, strlen(vHelp));*/
 
   write(context->fd, vHelp, strlen(vHelp));

   return 0;   
}
	
static int setLed(Context_t* context, int which, int on)
{
   struct micom_ioctl_data vData;

   vData.u.led.led_nr = which;
   vData.u.led.on = on;
   
   setMode(context->fd);

   if (ioctl(context->fd, VFDSETLED, &vData) < 0)
   {
      perror("setled: ");
      return -1;
   }
   return 0;   
}
	
static int setRFModulator(Context_t* context, int on)
{
   struct micom_ioctl_data vData;

   vData.u.rf.on = on;
   
   setMode(context->fd);

   if (ioctl(context->fd, VFDSETRF, &vData) < 0)
   {
      perror("setRFModulator: ");
      return -1;
   }
   return 0;   
}

static int setDisplayTime(Context_t* context, int on)
{
   struct micom_ioctl_data vData;

   vData.u.display_time.on = on;
   
   setMode(context->fd);

   if (ioctl(context->fd, VFDSETDISPLAYTIME, &vData) < 0)
   {
      perror("setDisplayTime: ");
      return -1;
   }
   return 0;   
}

static int setFan(Context_t* context, int on)
{
   struct micom_ioctl_data vData;

   vData.u.fan.on = on;
   
   setMode(context->fd);

   if (ioctl(context->fd, VFDSETFAN, &vData) < 0)
   {
      perror("setFan: ");
      return -1;
   }
   return 0;   
}

static int setTimeMode(Context_t* context, int twentyFour)
{
   struct micom_ioctl_data vData;

   vData.u.time_mode.twentyFour = twentyFour;
   
   setMode(context->fd);

   if (ioctl(context->fd, VFDSETTIMEMODE, &vData) < 0)
   {
      perror("setTimeMode: ");
      return -1;
   }
   return 0;   
}

static int setBrightness(Context_t* context, int brightness)
{
   struct micom_ioctl_data vData;

   if (brightness < 0 || brightness > 7)
      return -1;

   vData.u.brightness.level = brightness;
   
   setMode(context->fd);
   
   printf("%d\n", context->fd);
   if (ioctl(context->fd, VFDBRIGHTNESS, &vData) < 0)
   {
      perror("setbrightness: ");
      return -1;
   }
   return 0;   
}

static int setLight(Context_t* context, int on)
{
    if (on)
       setBrightness(context, 7);
    else
       setBrightness(context, 0);

    return 0;
}

/* attention: this is not the wakeup reason as for other
 * boxes (poweron, timer and son on) this is:
 * 0x00 ->timer off
 * 0x02 ->timer on
 */
static int getWakeupReason(Context_t* context, int* reason)
{
   struct micom_ioctl_data vData;

   fprintf(stderr, "waiting on wakeupmode from fp ...\n");

   /* front controller time */
   if (ioctl(context->fd, VFDGETWAKEUPMODE, &vData) < 0)
   {
      perror("getWakeupReason: ");
      return -1;
   }

    
   *reason = vData.u.status.status & 0xff;
      
   printf("reason = 0x%x\n", *reason);

   return 0;
}

static int getVersion(Context_t* context, int* version)
{
   struct micom_ioctl_data micom;

   fprintf(stderr, "waiting on version from fp ...\n");

   /* front controller time */
   if (ioctl(context->fd, VFDGETVERSION, &micom) < 0)
   {
      perror("getVersion: ");
      return -1;
   }

   printf("micom version = %d\n", micom.u.version.version);

   return 0;
}

static int Exit(Context_t* context)
{
   tCUBEREVOPrivate* private = (tCUBEREVOPrivate*) 
        ((Model_t*)context->m)->private;

    if (context->fd > 0)
       close(context->fd);

    free(private);

    exit(1);
}

static int Clear(Context_t* context)
{
   struct vfd_ioctl_data data;
   
   data.start = 0;

   if (ioctl(context->fd, VFDDISPLAYWRITEONOFF, &data) < 0)
   {
      perror("Clear: ");
      return -1;
   }
   return 0;
}

static int setLedBrightness(Context_t* context, int brightness)
{
   struct micom_ioctl_data vData;

   if (brightness < 0 || brightness > 0xff)
      return -1;

   vData.u.brightness.level = brightness;
   
   setMode(context->fd);
   
   printf("%d\n", context->fd);
   if (ioctl(context->fd, VFDLEDBRIGHTNESS, &vData) < 0)
   {
      perror("setledbrightness: ");
      return -1;
   }
   return 0;   
}

static int setIcon (Context_t* context, int which, int on)
{
   struct micom_ioctl_data vData;

   vData.u.icon.icon_nr = which;
   vData.u.icon.on = on;
   
   setMode(context->fd);

   if (ioctl(context->fd, VFDICONDISPLAYONOFF, &vData) < 0)
   {
      perror("seticon: ");
      return -1;
   }
   return 0;   
}


Model_t Cuberevo_model = {
	.Name             = "Kathrein CUBEREVO frontpanel control utility",
	.Type             = Cuberevo,
	.Init             = init,
	.Clear            = Clear,
	.Usage            = NULL,
	.SetTime          = setTime,
	.GetTime          = getTime,
	.SetTimer         = setTimer,
	.SetTimerManual   = setTimerManual,
	.GetTimer         = getTimer,
	.Shutdown         = shutdown,
	.Reboot           = reboot,
	.Sleep            = Sleep,
	.SetText          = setText,
	.SetLed           = setLed,
	.SetIcon          = setIcon,
	.SetBrightness    = setBrightness,
	.SetPwrLed        = NULL,
	.GetWakeupReason  = getWakeupReason,
	.SetLight         = setLight,
	.Exit             = Exit,
	.SetLedBrightness = setLedBrightness,
	.GetVersion       = getVersion,
	.SetRF            = setRFModulator,
	.SetFan           = setFan,
    .GetWakeupTime    = getWakeupTime,
    .SetDisplayTime   = setDisplayTime,
    .SetTimeMode      = setTimeMode,
	.private          = NULL
};
