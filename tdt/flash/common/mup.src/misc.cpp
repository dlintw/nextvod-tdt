#include <time.h>
#include <string.h>

#include "misc.h"

char * strTime(time_t now)
{
	struct tm  *ts;
	char       buf[80];
	ts = localtime(&now);
	strftime(buf, sizeof(buf), "%a %Y-%m-%d %H:%M:%S %Z", ts);

	return strdup(buf);
}
