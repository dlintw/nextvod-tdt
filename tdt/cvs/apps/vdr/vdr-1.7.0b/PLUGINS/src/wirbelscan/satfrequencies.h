/*
 * satfrequencies.h: wirbelscan - A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */


#ifndef __WIRBELSCAN_SATFREQUENCIES_H_
#define __WIRBELSCAN_SATFREQUENCIES_H_



typedef struct cSatFreqlist {
    int                channelfreq;
    int                channelpolarisation;
    int                channelsymbolrate;
    int                channelcoderateh;
} _satchanlist;


typedef struct cSatFreqlists {
    const char          * freqlist_name;
    struct cSatFreqlist * freqlist;
    int                 freqlist_count;
} _satchanlists;

typedef struct cSat {
    int                freqlist_id;
    const char         * source_id;
    const char         * SatName;
} _sat;

#define SATFREQ_COUNT(x) (sizeof(x)/sizeof(struct cSatFreqlist))

extern const struct cSat            SatProperties[];
extern const struct cSatFreqlists   freqlistsSat[];
extern const char                   * SatNames[];
extern const char                   * Polarisations[];

#endif
