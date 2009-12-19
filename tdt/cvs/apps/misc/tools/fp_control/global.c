/*
 * global.c
 * 
 * (c) 2009 dagobert/donald@teamducktales
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
#include <time.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ioctl.h>

#include "global.h"

#define E2TIMERSXML "/usr/local/share/enigma2/timers.xml"

#define CONFIG "/etc/vdstandby.cfg"
char * sDisplayStd = "%a %d %H:%M:%S";

unsigned long int read_e2_timers(time_t curTime)
{
	unsigned long int recordTime = 3000000000ul;
	char              recordString[11];
	char              line[1000];
	FILE              *fd = fopen (E2TIMERSXML, "r");

	if (fd)
	{
		while(fgets(line, 999, fd) != NULL)
		{
			line[999]='\0';
			if (!strncmp("<timer begin=\"",line,14) )
			{
				unsigned long int tmp = 0;
				strncpy(recordString, line+14, 10);
				recordString[11] = '\0';
				tmp = atol(recordString);
				recordTime = (tmp < recordTime && tmp > curTime ? tmp : recordTime);
			}
		}
	}

	if (recordTime == 3000000000ul)
        {
	   struct tm tsWake;
	   struct tm *ts;

           ts = localtime (&curTime);

	   tsWake.tm_hour = ts->tm_hour;
	   tsWake.tm_min  = ts->tm_min;
	   tsWake.tm_sec  = ts->tm_sec;
	   tsWake.tm_mday = ts->tm_mday;
	   tsWake.tm_mon  = ts->tm_mon;
	   tsWake.tm_year = ts->tm_year + 1;

	   recordTime = mktime(&tsWake);
	} 

	return recordTime;
}

/* ******************************************** */

double modJulianDate(struct tm *theTime)
{

  double date;
  int month;
  int day; 
  int year;

  year  = theTime->tm_year + 1900;
  month = theTime->tm_mon + 1;
  day   = theTime->tm_mday;

  date = day - 32076 + 
    1461 * (year + 4800 + (month - 14)/12)/4 +
    367 * (month - 2 - (month - 14)/12*12)/12 - 
    3 * ((year + 4900 + (month - 14)/12)/100)/4;

  date += (theTime->tm_hour + 12.0)/24.0;
  date += (theTime->tm_min)/1440.0;
  date += (theTime->tm_sec)/86400.0;

  date -= 2400000.5;

  return date;
}

/* ********************************************** */

int searchModel(Context_t  *context, eBoxType type) {
    int i;
    for (i = 0; AvailableModels[i] != 0ull; i++)

        if (AvailableModels[i]->Type == type) {
            context->m = AvailableModels[i];
            return 0;
        }

    return -1;
}

int checkConfig(int* display, int* display_custom, char** timeFormat, int* wakeup) {
	const int MAX = 100;
	char puffer[MAX];
	FILE *fd_config = fopen(CONFIG, "r");

	printf("%s\n", __func__);

	if (fd_config == NULL)
		return -1;

	*display = 0;
	*display_custom = 0;
	*timeFormat = NULL;
        *wakeup = 5*60;
	
	while (fgets(puffer, MAX, fd_config)) {
		if (!strncmp("DISPLAY=", puffer, 8)) {
			char * option = &puffer[8];
			if (!strncmp("TRUE", option, 2))
				*display = 1;

		} else if (!strncmp("DISPLAYCUSTOM=", puffer, 14)) {
			char * option = &puffer[14];
			*display_custom = 1;
			*timeFormat = strdup(option);
		}
		else if (!strncmp("WAKEUPDECREMENT=", puffer, 16)) {
			char * option = &puffer[14];
			*wakeup = atoi(option);
		}
	}
	
	if (*timeFormat == NULL)
	   *timeFormat = sDisplayStd;
	
	printf("configs: DISPLAY = %d, DISPLAYCUSTOM = %d, CUSTOM = %s, WAKEUPDECREMENT  %d\n", 
	            *display, *display_custom, *timeFormat, *wakeup);
	
	fclose(fd_config);
	
	return 0;
}
