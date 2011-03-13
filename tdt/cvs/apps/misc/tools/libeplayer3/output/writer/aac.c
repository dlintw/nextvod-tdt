/*
 * linuxdvb output/writer handling.
 *
 * konfetti 2010 based on linuxdvb.c code from libeplayer2
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

/* ***************************** */
/* Includes                      */
/* ***************************** */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <linux/dvb/video.h>
#include <linux/dvb/audio.h>
#include <memory.h>
#include <asm/types.h>
#include <pthread.h>
#include <errno.h>

#include "common.h"
#include "output.h"
#include "debug.h"
#include "stm_ioctls.h"
#include "misc.h"
#include "pes.h"
#include "writer.h"

/* ***************************** */
/* Makros/Constants              */
/* ***************************** */

#define AAC_HEADER_LENGTH       7

#define AAC_DEBUG

#ifdef AAC_DEBUG

static short debug_level = 0;

#define aac_printf(level, fmt, x...) do { \
if (debug_level >= level) printf("[%s:%s] " fmt, __FILE__, __FUNCTION__, ## x); } while (0)
#else
#define aac_printf(level, fmt, x...)
#endif

#ifndef AAC_SILENT
#define aac_err(fmt, x...) do { printf("[%s:%s] " fmt, __FILE__, __FUNCTION__, ## x); } while (0)
#else
#define aac_err(fmt, x...)
#endif

/* ***************************** */
/* Types                         */
/* ***************************** */

/* ***************************** */
/* Varaibles                     */
/* ***************************** */

static unsigned char DefaultAACHeader[]    =  {
    0xff,
    0xf1,
    /*0x00, 0x00*/0x50,  //((Profile & 0x03) << 6)  | (SampleIndex << 2) | ((Channels >> 2) & 0x01);s
    0x80,                //(Channels & 0x03) << 6;
    0x00,
    0x1f,
    0xfc
};

/* ***************************** */
/* Prototypes                    */
/* ***************************** */

/* ***************************** */
/* MISC Functions                */
/* ***************************** */
static int reset()
{
    return 0;
}

static int writeData(void* _call)
{
    WriterAVCallData_t* call = (WriterAVCallData_t*) _call;

    unsigned char PesHeader[PES_MAX_HEADER_SIZE];
    unsigned char ExtraData[AAC_HEADER_LENGTH];
    unsigned int  PacketLength;

    aac_printf(10, "\n");

    if (call == NULL)
    {
        aac_err("call data is NULL...\n");
        return 0;
    }

    aac_printf(10, "AudioPts %lld\n", call->Pts);

    PacketLength    = call->len + AAC_HEADER_LENGTH;

    if ((call->data == NULL) || (call->len <= 0))
    {
        aac_err("parsing NULL Data. ignoring...\n");
        return 0;
    }

    if (call->fd < 0)
    {
        aac_err("file pointer < 0. ignoring ...\n");
        return 0;
    }

    if (call->private_data == NULL)
    {
        aac_printf(10, "private_data = NULL\n");

        call->private_data = DefaultAACHeader;
        call->private_size = AAC_HEADER_LENGTH;
    }

    memmove (ExtraData, call->private_data, AAC_HEADER_LENGTH);
    ExtraData[3]       |= (PacketLength >> 12) & 0x3;
    ExtraData[4]        = (PacketLength >> 3) & 0xff;
    ExtraData[5]       |= (PacketLength << 5) & 0xe0;

    unsigned int  HeaderLength = InsertPesHeader (PesHeader, PacketLength, AAC_AUDIO_PES_START_CODE, call->Pts, 0);

    unsigned char* PacketStart = malloc(HeaderLength + sizeof(ExtraData) + call->len);
    memmove (PacketStart, PesHeader, HeaderLength);
    memmove (PacketStart + HeaderLength, ExtraData, sizeof(ExtraData));
    memmove (PacketStart + HeaderLength + sizeof(ExtraData), call->data, call->len);

    aac_printf(100, "H %d d %d ExtraData %d\n", HeaderLength, call->len, sizeof(ExtraData));

    int len = write(call->fd, PacketStart, HeaderLength + call->len + sizeof(ExtraData));

    free(PacketStart);

    return len;
}

/* ***************************** */
/* Writer  Definition            */
/* ***************************** */

static WriterCaps_t caps = {
    "aac",
    eAudio,
    "A_AAC",
    AUDIO_ENCODING_AAC
};

struct Writer_s WriterAudioAAC = {
    &reset,
    &writeData,
    NULL,
    &caps
};
