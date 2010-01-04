/*
 * frequencies.h: wirbelscan - A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */


#ifndef __WIRBELSCAN_FREQUENCIES_H_
#define __WIRBELSCAN_FREQUENCIES_H_

#define    FREQ_OFFSET_OFF               0
#define    FREQ_OFFSET_DOWN              1
#define    FREQ_OFFSET_UP                2
#define    FREQ_OFFSET_BOTH              3

typedef struct cFreqlist {
    const char       * channelname;
    int                channelfreq;
} _chanlist;

typedef struct cFreqlists {
    const char       * freqlist_name;
    struct cFreqlist * freqlist;
    int                freqlist_count;
} _chanlists;


typedef struct cCountry {
    int                freqlist_id;
    int                videonorm;
    int                is_Offset;
    int                freq_Offset;
} _country;


#define FREQ_COUNT(x) (sizeof(x)/sizeof(struct cFreqlist))

extern const struct cFreqlists   freqlists[];
extern const struct cCountry     CountryProperties[];
extern const struct cFreqlists   freqlistsDVBT[];
extern const struct cCountry     CountryPropertiesDVBT[];
extern const struct cFreqlists   freqlistsDVBC[];
extern const struct cCountry     CountryPropertiesDVBC[];
extern const char             *  CountryNames[];

#endif
