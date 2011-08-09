/* GStreamer DVB Media Sink
 * Copyright 2006 Felix Domke <tmbinc@elitedvb.net>
 * based on code by:
 * Copyright 2005 Thomas Vander Stichele <thomas@apestaart.org>
 * Copyright 2005 Ronald S. Bultje <rbultje@ronald.bitfreak.net>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * Alternatively, the contents of this file may be used under the
 * GNU Lesser General Public License Version 2.1 (the "LGPL"), in
 * which case the following provisions apply instead of the ones
 * mentioned above:
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

/**
 * SECTION:element-plugin
 *
 * <refsect2>
 * <title>Example launch line</title>
 * <para>
 * <programlisting>
 * gst-launch -v -m audiotestsrc ! plugin ! fakesink silent=TRUE
 * </programlisting>
 * </para>
 * </refsect2>
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
#include <unistd.h>
#include <stdint.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <linux/dvb/video.h>
#include <fcntl.h>
#include <poll.h>
#include <string.h>

#ifdef __sh__
#include <linux/dvb/stm_ioctls.h>
#endif

#include <gst/gst.h>

#include "gstdvbvideosink.h"
#include "gstdvbsink-marshal.h"

#ifndef VIDEO_GET_PTS
#define VIDEO_GET_PTS              _IOR('o', 57, gint64)
#endif

#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
struct bitstream
{
	guint8 *data;
	guint8 last;
	int avail;
};

void bitstream_init(struct bitstream *bit, const void *buffer, gboolean wr)
{
	bit->data = (guint8*) buffer;
	if (wr) {
		bit->avail = 0;
		bit->last = 0;
	}
	else {
		bit->avail = 8;
		bit->last = *bit->data++;
	}
}

unsigned long bitstream_get(struct bitstream *bit, int bits)
{
	unsigned long res=0;
	while (bits)
	{
		unsigned int d=bits;
		if (!bit->avail) {
			bit->last = *bit->data++;
			bit->avail = 8;
		}
		if (d > bit->avail)
			d=bit->avail;
		res<<=d;
		res|=(bit->last>>(bit->avail-d))&~(-1<<d);
		bit->avail-=d;
		bits-=d;
	}
	return res;
}

void bitstream_put(struct bitstream *bit, unsigned long val, int bits)
{
	while (bits)
	{
		bit->last |= ((val & (1 << (bits-1))) ? 1 : 0) << (7 - bit->avail);
		if (++bit->avail == 8) {
			*bit->data = bit->last;
			++bit->data;
			bit->last = 0;
			bit->avail = 0;
		}
		--bits;
	}
}
#endif

/* We add a control socket as in fdsrc to make it shutdown quickly when it's blocking on the fd.
 * Poll is used to determine when the fd is ready for use. When the element state is changed,
 * it happens from another thread while fdsink is poll'ing on the fd. The state-change thread 
 * sends a control message, so fdsink wakes up and changes state immediately otherwise
 * it would stay blocked until it receives some data. */

/* the poll call is also performed on the control sockets, that way
 * we can send special commands to unblock the poll call */
#define CONTROL_STOP		'S'			/* stop the poll call */
#define CONTROL_SOCKETS(sink)	sink->control_sock
#define WRITE_SOCKET(sink)	sink->control_sock[1]
#define READ_SOCKET(sink)	sink->control_sock[0]

#define SEND_COMMAND(sink, command)    \
G_STMT_START {                         \
	unsigned char c; c = command;      \
	write (WRITE_SOCKET(sink), &c, 1); \
} G_STMT_END

#define READ_COMMAND(sink, command, res)        \
G_STMT_START {                                  \
	res = read(READ_SOCKET(sink), &command, 1); \
} G_STMT_END

GST_DEBUG_CATEGORY_STATIC (dvbvideosink_debug);
#define GST_CAT_DEFAULT dvbvideosink_debug

#define COMMON_VIDEO_CAPS         \
  "width = (int) [ 16, 4096 ], "  \
  "height = (int) [ 16, 4096 ], " \
  "framerate = (fraction) [ 0, MAX ]"

#define MPEG4V2_LIMITED_CAPS     \
  "width = (int) [ 16, 800 ], "  \
  "height = (int) [ 16, 600 ], " \
  "framerate = (fraction) [ 0, MAX ]"

enum
{
	SIGNAL_GET_DECODER_TIME,
	LAST_SIGNAL
};

static guint gst_dvb_videosink_signals[LAST_SIGNAL] = { 0 };

static GstStaticPadTemplate sink_factory_bcm7400 =
GST_STATIC_PAD_TEMPLATE (
	"sink",
	GST_PAD_SINK,
	GST_PAD_ALWAYS,
	GST_STATIC_CAPS (
		"video/mpeg, "
		"mpegversion = (int) { 1, 2, 4 }, "
		"systemstream = (boolean) false, "
	COMMON_VIDEO_CAPS "; "
		"video/x-h264, "
	COMMON_VIDEO_CAPS "; "
		"video/x-h263, "
	COMMON_VIDEO_CAPS "; "
		"video/x-msmpeg, "
	MPEG4V2_LIMITED_CAPS ", mspegversion = (int) 43; "
		"video/x-divx, "
	MPEG4V2_LIMITED_CAPS ", divxversion = (int) [ 3, 5 ]; "
		"video/x-xvid, "
	MPEG4V2_LIMITED_CAPS "; "
		"video/x-3ivx, "
	MPEG4V2_LIMITED_CAPS "; ")
);

static GstStaticPadTemplate sink_factory_bcm7405 =
GST_STATIC_PAD_TEMPLATE (
	"sink",
	GST_PAD_SINK,
	GST_PAD_ALWAYS,
	GST_STATIC_CAPS (
		"video/mpeg, "
		"mpegversion = (int) { 1, 2, 4 }, "
		"systemstream = (boolean) false, "
	COMMON_VIDEO_CAPS "; "
		"video/x-msmpeg, "
	COMMON_VIDEO_CAPS ", mspegversion = (int) 43; "
		"video/x-h264, "
	COMMON_VIDEO_CAPS "; "
		"video/x-h263, "
	COMMON_VIDEO_CAPS "; "
		"video/x-divx, "
	COMMON_VIDEO_CAPS ", divxversion = (int) [ 3, 5 ]; "
		"video/x-xvid, "
	COMMON_VIDEO_CAPS "; "
		"video/x-3ivx, "
	COMMON_VIDEO_CAPS "; ")
);


static GstStaticPadTemplate sink_factory_bcm7401 =
GST_STATIC_PAD_TEMPLATE (
	"sink",
	GST_PAD_SINK,
	GST_PAD_ALWAYS,
	GST_STATIC_CAPS (
		"video/mpeg, "
		"mpegversion = (int) { 1, 2, 4 }, "
		"systemstream = (boolean) false, "
	COMMON_VIDEO_CAPS "; "
		"video/x-h264, "
	COMMON_VIDEO_CAPS "; "
		"video/x-h263, "
	COMMON_VIDEO_CAPS "; ")
);

static GstStaticPadTemplate sink_factory_ati_xilleon =
GST_STATIC_PAD_TEMPLATE (
	"sink",
	GST_PAD_SINK,
	GST_PAD_ALWAYS,
	GST_STATIC_CAPS (
		"video/mpeg, "
		"mpegversion = (int) { 1, 2 }, "
		"systemstream = (boolean) false, "
	COMMON_VIDEO_CAPS "; ")
);

#define SINK_FACTORY_STM_BASE \
GST_STATIC_PAD_TEMPLATE ( \
	"sink", \
	GST_PAD_SINK, \
	GST_PAD_ALWAYS, \
	GST_STATIC_CAPS ( \
		"video/mpeg, " \
		"mpegversion = (int) { 1, 2, 4 }, " \
		"systemstream = (boolean) false, " \
	COMMON_VIDEO_CAPS "; " \
		"video/x-h264, " \
	COMMON_VIDEO_CAPS "; " \
		"video/x-h263, " \
	COMMON_VIDEO_CAPS "; " \
		"video/x-msmpeg, " \
	MPEG4V2_LIMITED_CAPS ", mspegversion = (int) 43; " \
		"video/x-divx, " \
	MPEG4V2_LIMITED_CAPS ", divxversion = (int) [ 3, 5 ]; " \
		"video/x-xvid, " \
	MPEG4V2_LIMITED_CAPS "; " \
		"video/x-3ivx, " \
	MPEG4V2_LIMITED_CAPS "; ") \
)

#define SINK_FACTORY_STM_BASE_EXTENDED \
GST_STATIC_PAD_TEMPLATE ( \
	"sink", \
	GST_PAD_SINK, \
	GST_PAD_ALWAYS, \
	GST_STATIC_CAPS ( \
		"video/mpeg, " \
		"mpegversion = (int) { 1, 2, 4 }, " \
		"systemstream = (boolean) false, " \
	COMMON_VIDEO_CAPS "; " \
		"video/x-h264, " \
	COMMON_VIDEO_CAPS "; " \
		"video/x-h263, " \
	COMMON_VIDEO_CAPS "; " \
		"video/x-msmpeg, " \
	MPEG4V2_LIMITED_CAPS ", mspegversion = (int) 43; " \
		"video/x-divx, " \
	MPEG4V2_LIMITED_CAPS ", divxversion = (int) [ 3, 5 ]; " \
		"video/x-xvid, " \
	MPEG4V2_LIMITED_CAPS "; " \
		"video/x-3ivx, " \
	MPEG4V2_LIMITED_CAPS "; " \
		"video/x-wmv, " \
	COMMON_VIDEO_CAPS "; ") \
)

//TODO: All but 7100 and 7101 have wmv and vc1 capability. Need to add it
// FIRST GENERATION
static GstStaticPadTemplate sink_factory_stm_stx7100 = SINK_FACTORY_STM_BASE;
static GstStaticPadTemplate sink_factory_stm_stx7101 = SINK_FACTORY_STM_BASE;
static GstStaticPadTemplate sink_factory_stm_stx7109 = SINK_FACTORY_STM_BASE_EXTENDED;

// SECOND GENERATION
static GstStaticPadTemplate sink_factory_stm_stx7105 = SINK_FACTORY_STM_BASE_EXTENDED;
static GstStaticPadTemplate sink_factory_stm_stx7111 = SINK_FACTORY_STM_BASE_EXTENDED;

// THIRD GENERATION
static GstStaticPadTemplate sink_factory_stm_stx7106 = SINK_FACTORY_STM_BASE_EXTENDED;
static GstStaticPadTemplate sink_factory_stm_stx7108 = SINK_FACTORY_STM_BASE_EXTENDED;

#define DEBUG_INIT(bla) \
	GST_DEBUG_CATEGORY_INIT (dvbvideosink_debug, "dvbvideosink", 0, "dvbvideosink element");

GST_BOILERPLATE_FULL (GstDVBVideoSink, gst_dvbvideosink, GstBaseSink,
	GST_TYPE_BASE_SINK, DEBUG_INIT);

static gboolean             gst_dvbvideosink_start (GstBaseSink * sink);
static gboolean             gst_dvbvideosink_stop (GstBaseSink * sink);
static gboolean             gst_dvbvideosink_event (GstBaseSink * sink, GstEvent * event);
static GstFlowReturn        gst_dvbvideosink_render (GstBaseSink * sink, GstBuffer * buffer);
static gboolean             gst_dvbvideosink_set_caps (GstBaseSink * sink, GstCaps * caps);
static gboolean             gst_dvbvideosink_unlock (GstBaseSink * basesink);
static gboolean             gst_dvbvideosink_unlock_stop (GstBaseSink * basesink);
static void                 gst_dvbvideosink_dispose (GObject * object);
static GstStateChangeReturn gst_dvbvideosink_change_state (GstElement * element, GstStateChange transition);
static gint64               gst_dvbvideosink_get_decoder_time (GstDVBVideoSink *self);

#define PES_MAX_HEADER_SIZE 64

typedef enum {  HW_UNKNOWN, 
				DM7025, DM800, DM8000, DM500HD, DM800SE, DM7020HD, 
				STX7100, STX7101, STX7109, STX7105, STX7111, STX7106, STX7108 
} hardware_type_t;

typedef enum { PF_UNKNOWN, DM, HAVANA } platform_type_t;

static hardware_type_t hwtype = HW_UNKNOWN;
static platform_type_t pftype = PF_UNKNOWN;

//Please correct if wrong
#define STREAMTYPE_UNKNOWN  0xFF
#define STREAMTYPE_MPEG2    0x00
#define STREAMTYPE_H264     0x01
#define STREAMTYPE_H263     0x02
#define STREAMTYPE_MPEG4_P2 0x04
#define STREAMTYPE_MPEG1    0x06
#define STREAMTYPE_XVID     0x0A
#define STREAMTYPE_DIVX311  0x0C
#define STREAMTYPE_DIVX4    0x0E
#define STREAMTYPE_DIVX5    0x0F
#define STREAMTYPE_FLV1     0x10
#define STREAMTYPE_WMV      0x11
#define STREAMTYPE_VC1      0x12

#define VIDEO_ENCODING_UNKNOWN  0xFF

unsigned int streamtype_to_encoding (unsigned int streamtype)
{
#ifdef VIDEO_SET_ENCODING
	switch(streamtype)
	{
	case STREAMTYPE_MPEG2:
		return VIDEO_ENCODING_AUTO;
	case STREAMTYPE_H264:
		return VIDEO_ENCODING_H264;
	case STREAMTYPE_H263:
		return VIDEO_ENCODING_H263;
	case STREAMTYPE_MPEG4_P2:
		return VIDEO_ENCODING_MPEG4P2;
	case STREAMTYPE_MPEG1:
		return VIDEO_ENCODING_AUTO;
	case STREAMTYPE_XVID:
		return VIDEO_ENCODING_MPEG4P2;
	case STREAMTYPE_DIVX311:
		return VIDEO_ENCODING_MPEG4P2;
	case STREAMTYPE_DIVX4:
		return VIDEO_ENCODING_MPEG4P2;
	case STREAMTYPE_DIVX5:
		return VIDEO_ENCODING_MPEG4P2;
	case STREAMTYPE_FLV1:
		return VIDEO_ENCODING_FLV1;
	case STREAMTYPE_WMV:
		return VIDEO_ENCODING_WMV;
	case STREAMTYPE_VC1:
		return VIDEO_ENCODING_VC1;

	default:
		return VIDEO_ENCODING_UNKNOWN;
	}
#endif
	return VIDEO_ENCODING_UNKNOWN;
}

static void
gst_dvbvideosink_base_init (gpointer klass)
{
	static GstElementDetails element_details = {
		"A DVB video sink",
		"Generic/DVBVideoSink",
		"Output video PES / ES into a DVB video device for hardware playback",
		"Felix Domke <tmbinc@elitedvb.net>"
	};
	GstElementClass *element_class = GST_ELEMENT_CLASS (klass);

	int fd = open("/proc/stb/info/model", O_RDONLY);
	if ( fd > 0 )
	{
		gchar string[9] = { 0, };
		ssize_t rd = read(fd, string, 8);
		if ( rd >= 5 )
		{
			if ( !strncasecmp(string, "DM7025", 6) ) {
				hwtype = DM7025;
				pftype = DM;
				GST_INFO ("model is DM7025... set ati xilleon caps");
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_ati_xilleon));
			} else if ( !strncasecmp(string, "DM500HD", 7) ) {
				hwtype = DM500HD;
				pftype = DM;
				GST_INFO ("model is DM500HD... set bcm7405 caps");
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_bcm7405));
			} else if ( !strncasecmp(string, "DM800SE", 7) ) {
				hwtype = DM800SE;
				pftype = DM;
				GST_INFO ("model is DM800SE... set bcm7405 caps");
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_bcm7405));
			} else if ( !strncasecmp(string, "DM7020HD", 8) ) {
				hwtype = DM7020HD;
				pftype = DM;
				GST_INFO ("model is DM7020HD... set bcm7405 caps");
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_bcm7405));
			} else if ( !strncasecmp(string, "DM8000", 6) ) {
				hwtype = DM8000;
				pftype = DM;
				GST_INFO ("model is DM8000... set bcm7400 caps");
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_bcm7400));
			} else if ( !strncasecmp(string, "DM800", 5) ) {
				hwtype = DM800;
				pftype = DM;
				GST_INFO ("model is DM800 set bcm7401 caps");
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_bcm7401));
			}
		}
		close(fd);
	}

	if (hwtype == HW_UNKNOWN) {
		// Unfortunately we dont have sysinfo available so doing it the hard way
		char line[256];
		char *processor;
		FILE *file = fopen("/proc/cpuinfo", "r");
		while (fgets(line, sizeof(line) - 1, file) != NULL)
		{
			if (!strncmp(line, "cpu type", 8))
			{
				strtok (line,":");
				processor = strtok (NULL,":");
				while(processor[0] == ' ') processor++;
				break;
			}
		}
		fclose(file);
		
		printf("Processor: %s\n", processor);

		// FIRST GENERATION
		if( !strncasecmp(processor, "STX7100", 7) || 
			!strncasecmp(processor, "STB7100", 7) || 
			!strncasecmp(processor, "STI7100", 7)) {
			pftype = HAVANA;
			hwtype = STX7100;
			GST_INFO ("setting STX7100 caps");
			gst_element_class_add_pad_template (element_class,
				gst_static_pad_template_get (&sink_factory_stm_stx7100));
		}
		else if(!strncasecmp(processor, "STX7101", 7)) {
			pftype = HAVANA;
			hwtype = STX7101;
			GST_INFO ("setting STX7101 caps");
			gst_element_class_add_pad_template (element_class,
				gst_static_pad_template_get (&sink_factory_stm_stx7101));
		}
		else if(!strncasecmp(processor, "STX7109", 7)) {
			pftype = HAVANA;
			hwtype = STX7109;
			GST_INFO ("setting STX7109 caps");
			gst_element_class_add_pad_template (element_class,
				gst_static_pad_template_get (&sink_factory_stm_stx7109));
		}
		// SECOND GENERATIONad_template_get (&sink_factory_stm_stx7111));
		else if(!strncasecmp(processor, "STX7105", 7)) {
			pftype = HAVANA;
			hwtype = STX7105;
			GST_INFO ("setting STX7105 caps");
			gst_element_class_add_pad_template (element_class,
				gst_static_pad_template_get (&sink_factory_stm_stx7105));
		}
		else if(!strncasecmp(processor, "STX7111", 7)) {
			pftype = HAVANA;
			hwtype = STX7111;
			GST_INFO ("setting STX7111 caps");
			gst_element_class_add_pad_template (element_class,
				gst_static_pad_template_get (&sink_factory_stm_stx7111));
		}
		// THIRD GENERATION
		else if(!strncasecmp(processor, "STX7106", 7)) {
			pftype = HAVANA;
			hwtype = STX7106;
			GST_INFO ("setting STX7106 caps");
			gst_element_class_add_pad_template (element_class,
				gst_static_pad_template_get (&sink_factory_stm_stx7106));
		}
		else if(!strncasecmp(processor, "STX7108", 7)) {
			pftype = HAVANA;
			hwtype = STX7108;
			GST_INFO ("setting STX7108 caps");
			gst_element_class_add_pad_template (element_class,
				gst_static_pad_template_get (&sink_factory_stm_stx7108));
		}
	}

	gst_element_class_set_details (element_class, &element_details);
}

/* initialize the plugin's class */
static void
gst_dvbvideosink_class_init (GstDVBVideoSinkClass *klass)
{
	GObjectClass     *gobject_class = G_OBJECT_CLASS (klass);
	GstBaseSinkClass *gstbasesink_class = GST_BASE_SINK_CLASS (klass);
	GstElementClass  *element_class = GST_ELEMENT_CLASS (klass);

	gobject_class->dispose         = GST_DEBUG_FUNCPTR (gst_dvbvideosink_dispose);

	gstbasesink_class->start       = GST_DEBUG_FUNCPTR (gst_dvbvideosink_start);
	gstbasesink_class->stop        = GST_DEBUG_FUNCPTR (gst_dvbvideosink_stop);
	gstbasesink_class->render      = GST_DEBUG_FUNCPTR (gst_dvbvideosink_render);
	gstbasesink_class->event       = GST_DEBUG_FUNCPTR (gst_dvbvideosink_event);
	gstbasesink_class->unlock      = GST_DEBUG_FUNCPTR (gst_dvbvideosink_unlock);
	gstbasesink_class->unlock_stop = GST_DEBUG_FUNCPTR (gst_dvbvideosink_unlock_stop);
	gstbasesink_class->set_caps    = GST_DEBUG_FUNCPTR (gst_dvbvideosink_set_caps);

	element_class->change_state    = GST_DEBUG_FUNCPTR (gst_dvbvideosink_change_state);

	gst_dvb_videosink_signals[SIGNAL_GET_DECODER_TIME] =
		g_signal_new ("get-decoder-time",
		G_TYPE_FROM_CLASS (klass),
		G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
		G_STRUCT_OFFSET (GstDVBVideoSinkClass, get_decoder_time),
		NULL, NULL, gst_dvbsink_marshal_INT64__VOID, G_TYPE_INT64, 0);

	klass->get_decoder_time = gst_dvbvideosink_get_decoder_time;
}

#define H264_BUFFER_SIZE (64*1024+2048)

/* initialize the new element
 * instantiate pads and add them to element
 * set functions
 * initialize structure
 */
static void
gst_dvbvideosink_init (GstDVBVideoSink *klass, GstDVBVideoSinkClass * gclass)
{
	FILE *f = fopen("/proc/stb/vmpeg/0/fallback_framerate", "r");
#ifdef VIDEO_SET_ENCODING
	klass->use_set_encoding      = TRUE;
#else
	klass->use_set_encoding      = FALSE;
#endif	
	klass->dec_running           = FALSE;
	klass->must_send_header      = 1;
	klass->h264_buffer           = NULL;
	klass->h264_nal_len_size     = 0;
	klass->codec_data            = NULL;
#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
	klass->must_pack_bitstream   = 0;
	klass->num_non_keyframes     = 0;
	klass->prev_frame            = NULL;
#endif
	klass->no_write              = 0;
	klass->queue                 = NULL;
	klass->fd                    = -1;

	if (f) {
		fgets(klass->saved_fallback_framerate, 16, f);
		fclose(f);
	}

	gst_base_sink_set_sync(GST_BASE_SINK (klass), FALSE);
	gst_base_sink_set_async_enabled(GST_BASE_SINK (klass), TRUE);
}

static void gst_dvbvideosink_dispose (GObject * object)
{
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (object);
	GstState state, pending;
	GST_DEBUG_OBJECT(self, "dispose");

	// hack start : for decodebin2 bug.. decodebin2 tries to dispose ..
	//              but doesnt set state to NULL when it is READY
	switch(gst_element_get_state(GST_ELEMENT(object), &state, &pending, GST_CLOCK_TIME_NONE))
	{
	case GST_STATE_CHANGE_SUCCESS:
		GST_DEBUG_OBJECT(self, "success");
		if (state != GST_STATE_NULL) {
			GST_DEBUG_OBJECT(self, "state %d in dispose.. set it to NULL (decodebin2 bug?)", state);
			if (gst_element_set_state(GST_ELEMENT(object), GST_STATE_NULL) == GST_STATE_CHANGE_ASYNC) {
				GST_DEBUG_OBJECT(self, "set state returned async... wait!");
				gst_element_get_state(GST_ELEMENT(object), &state, &pending, GST_CLOCK_TIME_NONE);
			}
		}
		break;
	case GST_STATE_CHANGE_ASYNC:
		GST_DEBUG_OBJECT(self, "async");
		break;
	case GST_STATE_CHANGE_FAILURE:
		GST_DEBUG_OBJECT(self, "failure");
		break;
	case GST_STATE_CHANGE_NO_PREROLL:
		GST_DEBUG_OBJECT(self, "no preroll");
		break;
	default:
		break;
	}
	// hack end

	GST_DEBUG_OBJECT(self, "state in dispose %d, pending %d", state, pending);

	G_OBJECT_CLASS (parent_class)->dispose (object);
}

static gint64 gst_dvbvideosink_get_decoder_time (GstDVBVideoSink *self)
{
	if (self->dec_running) {
		gint64 cur = 0;
		static gint64 last_pos = 0;

		ioctl(self->fd, VIDEO_GET_PTS, &cur);

		/* workaround until driver fixed */
		if (cur)
			last_pos = cur;
		else
			cur = last_pos;

		cur *= 11111;

		return cur;
	}
	return GST_CLOCK_TIME_NONE;
}

static gboolean gst_dvbvideosink_unlock (GstBaseSink * basesink)
{
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (basesink);
	GST_OBJECT_LOCK(self);
	self->no_write |= 2;
	GST_OBJECT_UNLOCK(self);
	SEND_COMMAND (self, CONTROL_STOP);
	GST_DEBUG_OBJECT (basesink, "unlock");
	return TRUE;
}

static gboolean gst_dvbvideosink_unlock_stop (GstBaseSink * basesink)
{
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (basesink);
	GST_OBJECT_LOCK(self);
	self->no_write &= ~2;
	GST_OBJECT_UNLOCK(self);
	GST_DEBUG_OBJECT (basesink, "unlock_stop");
	return TRUE;
}

void queue_push(queue_entry_t **queue_base, guint8 *data, size_t len)
{
	queue_entry_t *entry = malloc(sizeof(queue_entry_t)+len);
	queue_entry_t *last = *queue_base;
	guint8 *d = (guint8*)(entry+1);
	memcpy(d, data, len);
	entry->bytes = len;
	entry->offset = 0;
	if (!last)
		*queue_base = entry;
	else {
		while(last->next)
			last = last->next;
		last->next = entry;
	}
	entry->next = NULL;
}

void queue_pop(queue_entry_t **queue_base)
{
	queue_entry_t *base = *queue_base;
	*queue_base = base->next;
	free(base);
}

int queue_front(queue_entry_t **queue_base, guint8 **data, size_t *bytes)
{
	if (!*queue_base) {
		*bytes = 0;
		*data = 0;
	}
	else {
		queue_entry_t *entry = *queue_base;
		*bytes = entry->bytes - entry->offset;
		*data = ((guint8*)(entry+1))+entry->offset;
	}
	return *bytes;
}

static gboolean
gst_dvbvideosink_event (GstBaseSink * sink, GstEvent * event)
{
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (sink);
	GST_DEBUG_OBJECT (self, "EVENT %s", gst_event_type_get_name(GST_EVENT_TYPE (event)));
	int ret=TRUE;

	switch (GST_EVENT_TYPE (event)) {
	case GST_EVENT_FLUSH_START:
		GST_OBJECT_LOCK(self);
		self->no_write |= 1;
		GST_OBJECT_UNLOCK(self);
		SEND_COMMAND (self, CONTROL_STOP);
		break;
	case GST_EVENT_FLUSH_STOP:
		ioctl(self->fd, VIDEO_CLEAR_BUFFER);
		GST_OBJECT_LOCK(self);
		self->must_send_header = 1;
		if (hwtype == DM7025)
			++self->must_send_header;  // we must send the sequence header twice on dm7025... 
		while (self->queue)
			queue_pop(&self->queue);
		self->no_write &= ~1;
		GST_OBJECT_UNLOCK(self);
		break;
	case GST_EVENT_EOS:
	{
		struct pollfd pfd[2];
		int retval;

		pfd[0].fd = READ_SOCKET(self);
		pfd[0].events = POLLIN;
		pfd[1].fd = self->fd;
		pfd[1].events = POLLIN;

		GST_PAD_PREROLL_UNLOCK (sink->sinkpad);
		while (1) {
			retval = poll(pfd, 2, 250);
			if (retval < 0) {
				perror("poll in EVENT_EOS");
				ret=FALSE;
				break;
			}

			if (pfd[0].revents & POLLIN) {
				GST_DEBUG_OBJECT (self, "wait EOS aborted!!\n");
				ret=FALSE;
				break;
			}

			if (pfd[1].revents & POLLIN) {
				GST_DEBUG_OBJECT (self, "got buffer empty from driver!\n");
				break;
			}

			if (sink->flushing) {
				GST_DEBUG_OBJECT (self, "wait EOS flushing!!\n");
				ret=FALSE;
				break;
			}
		}
		GST_PAD_PREROLL_LOCK (sink->sinkpad);

		break;
	}
	case GST_EVENT_NEWSEGMENT:{
		GstFormat fmt;
		gboolean update;
		gdouble rate, applied_rate;
		gint64 cur, stop, time;
		int skip = 0, repeat = 0, ret;
		gst_event_parse_new_segment_full (event, &update, &rate, &applied_rate,	&fmt, &cur, &stop, &time);
		GST_DEBUG_OBJECT (self, "GST_EVENT_NEWSEGMENT rate=%f applied_rate=%f\n", rate, applied_rate);
		
		if (fmt == GST_FORMAT_TIME)
		{	
			if ( rate > 1 )
				skip = (int) rate;
			else if ( rate < 1 )
				repeat = 1.0/rate;

			ret = ioctl(self->fd, VIDEO_SLOWMOTION, repeat);
			ret = ioctl(self->fd, VIDEO_FAST_FORWARD, skip);
// 			gst_segment_set_newsegment_full (&dec->segment, update, rate, applied_rate, dformat, cur, stop, time);
		}
		break;
	}

	default:
		break;
	}

	return ret;
}

#define ASYNC_WRITE(data, len) do { \
		switch(AsyncWrite(sink, self, data, len)) { \
		case -1: goto poll_error; \
		case -3: goto write_error; \
		default: break; \
		} \
	} while(0)

static int AsyncWrite(GstBaseSink * sink, GstDVBVideoSink *self, unsigned char *data, unsigned int len)
{
	unsigned int written=0;
	struct pollfd pfd[2];

	pfd[0].fd = READ_SOCKET(self);
	pfd[0].events = POLLIN;
	pfd[1].fd = self->fd;
	pfd[1].events = POLLOUT | POLLPRI;

	do {
loop_start:
		if (self->no_write & 1) {
			GST_DEBUG_OBJECT (self, "skip %d bytes", len - written);
			break;
		}
		else if (self->no_write & 6) {
			// directly push to queue
			GST_OBJECT_LOCK(self);
			queue_push(&self->queue, data + written, len - written);
			GST_OBJECT_UNLOCK(self);
			GST_DEBUG_OBJECT (self, "pushed %d bytes to queue", len - written);
			break;
		}
		else
			GST_LOG_OBJECT (self, "going into poll, have %d bytes to write", len - written);
		if (poll(pfd, 2, -1) == -1) {
			if (errno == EINTR)
				continue;
			return -1;
		}
		if (pfd[0].revents & POLLIN) {
			/* read all stop commands */
			while (TRUE) {
				gchar command;
				int res;
				READ_COMMAND (self, command, res);
				if (res < 0) {
					GST_DEBUG_OBJECT (self, "no more commands");
					/* no more commands */
					goto loop_start;
				}
			}
		}
		if (pfd[1].revents & POLLPRI) {
			GstStructure *s;
			GstMessage *msg;
			struct video_event evt;
			if (ioctl(self->fd, VIDEO_GET_EVENT, &evt) < 0)
				g_warning ("failed to ioctl VIDEO_GET_EVENT!");
			else {
				GST_INFO_OBJECT (self, "VIDEO_EVENT %d", evt.type);
				if (evt.type == VIDEO_EVENT_SIZE_CHANGED) {
					s = gst_structure_new ("eventSizeChanged",
						"aspect_ratio", G_TYPE_INT, evt.u.size.aspect_ratio == 0 ? 2 : 3,
						"width", G_TYPE_INT, evt.u.size.w,
						"height", G_TYPE_INT, evt.u.size.h, NULL);
					msg = gst_message_new_element (GST_OBJECT (sink), s);
					gst_element_post_message (GST_ELEMENT (sink), msg);
				} else if (evt.type == VIDEO_EVENT_FRAME_RATE_CHANGED) {
					s = gst_structure_new ("eventFrameRateChanged",
						"frame_rate", G_TYPE_INT, evt.u.frame_rate, NULL);
					msg = gst_message_new_element (GST_OBJECT (sink), s);
					gst_element_post_message (GST_ELEMENT (sink), msg);
				} else if (evt.type == 16 /*VIDEO_EVENT_PROGRESSIVE_CHANGED*/) {
					s = gst_structure_new ("eventProgressiveChanged",
						"progressive", G_TYPE_INT, evt.u.frame_rate, NULL);
					msg = gst_message_new_element (GST_OBJECT (sink), s);
					gst_element_post_message (GST_ELEMENT (sink), msg);
				} else
					g_warning ("unhandled DVBAPI Video Event %d", evt.type);
			}
		}
		if (pfd[1].revents & POLLOUT) {
			size_t queue_entry_size;
			guint8 *queue_data;
			GST_OBJECT_LOCK(self);
			if (queue_front(&self->queue, &queue_data, &queue_entry_size)) {
				int wr = write(self->fd, queue_data, queue_entry_size);
				if (wr < 0) {
					switch (errno) {
						case EINTR:
						case EAGAIN:
							break;
						default:
							GST_OBJECT_UNLOCK(self);
							return -3;
					}
				}
				else if (wr == queue_entry_size) {
					queue_pop(&self->queue);
					GST_DEBUG_OBJECT (self, "written %d queue bytes... pop entry", wr);
				}
				else {
					self->queue->offset += wr;
					GST_DEBUG_OBJECT (self, "written %d queue bytes... update offset", wr);
				}
				GST_OBJECT_UNLOCK(self);
				continue;
			}
			GST_OBJECT_UNLOCK(self);
			int wr = write(self->fd, data+written, len - written);
			if (wr < 0) {
				switch (errno) {
					case EINTR:
					case EAGAIN:
						continue;
					default:
						return -3;
				}
			}
			written += wr;
		}
	} while (written != len);

	return 0;
}

static GstFlowReturn
gst_dvbvideosink_render (GstBaseSink * sink, GstBuffer * buffer)
{
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (sink);
	unsigned char *data = GST_BUFFER_DATA(buffer);
	unsigned int data_len = GST_BUFFER_SIZE (buffer);
	guint8 pes_header[2048];
	unsigned int pes_header_len=0;
	unsigned int payload_len=0;
//	int i=0;

#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
	gboolean commit_prev_frame_data = FALSE,
			cache_prev_frame = FALSE;
#endif

//	for (;i < (data_len > 0xF ? 0xF : data_len); ++i)
//		printf("%02x ", data[i]);
//	printf("%d bytes\n", data_len);
//	printf("timestamp: %08llx\n", (long long)GST_BUFFER_TIMESTAMP(buffer));

	if (self->fd < 0)
		return GST_FLOW_OK;

#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
	if (self->must_pack_bitstream == 1) {
		cache_prev_frame = TRUE;
		unsigned int pos = 0;
		while(pos < data_len) {
			if (data[pos++])
				continue;
			if (data[pos++])
				continue;
			while (!data[pos])
				++pos;
			if (data[pos++] != 1)
				continue;
			if ((data[pos++] & 0xF0) == 0x20) { // we need time_inc_res
				gboolean low_delay=FALSE;
				unsigned int ver_id = 1, shape=0, time_inc_res=0, tmp=0;
				struct bitstream bit;
				bitstream_init(&bit, data+pos, 0);
				bitstream_get(&bit, 9);
				if (bitstream_get(&bit, 1)) {
					ver_id = bitstream_get(&bit, 4); // ver_id
					bitstream_get(&bit, 3);
				}
				if ((tmp=bitstream_get(&bit, 4)) == 15) { // Custom Aspect Ration
					bitstream_get(&bit, 8); // skip AR width
					bitstream_get(&bit, 8); // skip AR height
				}
				if (bitstream_get(&bit, 1)) {
					bitstream_get(&bit, 2);
					low_delay = bitstream_get(&bit, 1) ? TRUE : FALSE;
					if (bitstream_get(&bit, 1)) {
						bitstream_get(&bit, 32);
						bitstream_get(&bit, 32);
						bitstream_get(&bit, 15);
					}
				}
				shape = bitstream_get(&bit, 2);
				if (ver_id != 1 && shape == 3 /* Grayscale */)
					bitstream_get(&bit, 4);
				bitstream_get(&bit, 1);
				time_inc_res = bitstream_get(&bit, 16);
				self->time_inc_bits = 0;
				while (time_inc_res) { // count bits
					++self->time_inc_bits;
					time_inc_res >>= 1;
				}
//				printf("%d time_inc_bits\n", self->time_inc_bits);
			}
		}
	}

	if (self->must_pack_bitstream == 1) {
		int tmp1, tmp2;
		unsigned char c1, c2;
		unsigned int pos = 0;
		while(pos < data_len) {
			if (data[pos++])
				continue;
			if (data[pos++])
				continue;
			while (!data[pos])
				++pos;
			if (data[pos++] != 1)
				continue;
			if (data[pos++] != 0xB2)
				continue;
			if (data_len - pos < 13)
				break;
			if (sscanf((char*)data+pos, "DivX%d%c%d%cp", &tmp1, &c1, &tmp2, &c2) == 4 && (c1 == 'b' || c1 == 'B') && (c2 == 'p' || c2 == 'P')) {
				GST_INFO_OBJECT (self, "%s seen... already packed!", (char*)data+pos);
				self->must_pack_bitstream = 0;
			}
//			if (self->must_pack_bitstream)
//				printf("pack needed\n");
//			else
//				printf("no pack needed\n");
		}
	}
#endif

	pes_header[0] = 0;
	pes_header[1] = 0;
	pes_header[2] = 1;
	pes_header[3] = 0xE0;

		/* do we have a timestamp? */
	if (GST_BUFFER_TIMESTAMP(buffer) != GST_CLOCK_TIME_NONE) {
		unsigned long long pts = GST_BUFFER_TIMESTAMP(buffer) * 9LL / 100000 /* convert ns to 90kHz */;

		pes_header[6] = 0x80;
		pes_header[7] = 0x80;
		
		pes_header[8] = 5;
		
		pes_header[9] =  0x21 | ((pts >> 29) & 0xE);
		pes_header[10] = pts >> 22;
		pes_header[11] = 0x01 | ((pts >> 14) & 0xFE);
		pes_header[12] = pts >> 7;
		pes_header[13] = 0x01 | ((pts << 1) & 0xFE);

		pes_header_len = 14;

		if (self->codec_data) {
			switch (self->streamtype) { // we must always resend the codec data before every seq header on dm8k
			case STREAMTYPE_MPEG4_P2:
			case STREAMTYPE_DIVX4:
				if (data[0] == 0xb3 || !memcmp(data, "\x00\x00\x01\xb3", 4))
					self->must_send_header = 1;
			default:
				break;
			}
			if (self->must_send_header) {
				if (self->streamtype != STREAMTYPE_MPEG1 && 
						self->streamtype != STREAMTYPE_MPEG2 && 
						(self->streamtype != STREAMTYPE_DIVX4 || data[3] == 0x00)) {
					unsigned char *codec_data = GST_BUFFER_DATA (self->codec_data);
					unsigned int codec_data_len = GST_BUFFER_SIZE (self->codec_data);
					if (self->streamtype == STREAMTYPE_DIVX311)
						ASYNC_WRITE(codec_data, codec_data_len);
					else {
						memcpy(pes_header+pes_header_len, codec_data, codec_data_len);
						pes_header_len += codec_data_len;
					}
					self->must_send_header = 0;
				}
			}
			if (self->streamtype == STREAMTYPE_H264) {  // MKV stuff
				unsigned int pos = 0;
				if (self->h264_nal_len_size == 4) {
					while(TRUE) {
						unsigned int pack_len = (data[pos] << 24) | (data[pos+1] << 16) | (data[pos+2] << 8) | data[pos+3];
//						printf("patch %02x %02x %02x %02x\n",
//							data[pos],
//							data[pos + 1],
//							data[pos + 2],
//							data[pos + 3]);
						memcpy(data+pos, "\x00\x00\x00\x01", 4);
//						printf("pos %d, (%d) >= %d\n", pos, pos+pack_len, data_len);
						pos += 4;
						if ((pos + pack_len) >= data_len)
							break;
						pos += pack_len;
					}
				}
				else if (self->h264_nal_len_size == 3) {
					while(TRUE) {
						unsigned int pack_len = (data[pos] << 16) | (data[pos+1] << 8) | data[pos+2];
//						printf("patch %02x %02x %02x\n",
//							data[pos],
//							data[pos + 1],
//							data[pos + 2]);
						memcpy(data+pos, "\x00\x00\x01", 3);
//						printf("pos %d, (%d) >= %d\n", pos, pos+pack_len, data_len);
						pos += 3;
						if ((pos + pack_len) >= data_len)
							break;
						pos += pack_len;
					}
				}
				else {
					unsigned char *dest = GST_BUFFER_DATA (self->h264_buffer);
					unsigned int dest_pos = 0;
					while(TRUE) {
						unsigned int pack_len = self->h264_nal_len_size == 2 ? (data[pos] << 8) | data[pos+1] : data[pos];
						if (dest_pos + pack_len <= H264_BUFFER_SIZE) {
							memcpy(dest+dest_pos, "\x00\x00\x01", 3);
							dest_pos += 3;
							pos += self->h264_nal_len_size;
							memcpy(dest+dest_pos, data+pos, pack_len);
							dest_pos += pack_len;
							if ((pos + pack_len) >= data_len)
								break;
							pos += pack_len;
						}
						else {
							g_error("BUG!!!!!!!! H264 buffer to small skip video data!!.. please report!\n");
							break;
						}
					}
					data = dest;
					data_len = dest_pos;
				}
			}
			else if (self->streamtype == STREAMTYPE_MPEG4_P2) {
				if (data[0] || data[1] || data[2] != 1) {
					memcpy(pes_header+pes_header_len, "\x00\x00\x01", 3);
					pes_header_len += 3;
				}
			}
			else if (self->streamtype == STREAMTYPE_DIVX311) {
				if (data[0] || data[1] || data[2] != 1 || data[3] != 0xb6) {
					memcpy(pes_header+pes_header_len, "\x00\x00\x01\xb6", 4);
					pes_header_len += 4;
				}
			}
		}
	}
	else {
//		printf("no timestamp!\n");
		pes_header[6] = 0x80;
		pes_header[7] = 0x00;
		pes_header[8] = 0;
		pes_header_len = 9;
	}

#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
	if (self->must_pack_bitstream == 1) {
		unsigned int pos = 0;
		gboolean i_frame = FALSE;
//		gboolean s_frame = FALSE;
		while(pos < data_len) {
			if (data[pos++])
				continue;
			if (data[pos++])
				continue;
			while (!data[pos])
				++pos;
			if (data[pos++] != 1)
				continue;
			if (data[pos++] != 0xB6)
				continue;
			switch ((data[pos] & 0xC0) >> 6) {
				case 0: // I-Frame
//					printf("I ");
					cache_prev_frame = FALSE;
					i_frame = TRUE;
				case 1: // P-Frame
//					if (!i_frame)
//						printf("P ");
					if (self->prev_frame != buffer) {
						struct bitstream bit;
						gboolean store_frame=FALSE;
						if (self->prev_frame) {
							if (!self->num_non_keyframes) {
//								printf("no non keyframes...immediate commit prev frame\n");
								GstFlowReturn ret = gst_dvbvideosink_render(sink, self->prev_frame);
								gst_buffer_unref(self->prev_frame);
								self->prev_frame = NULL;
								if (ret != GST_FLOW_OK)
									return ret;
								store_frame = TRUE;
							}
							else {
//								int i=-4;
								pes_header[pes_header_len++] = 0;
								pes_header[pes_header_len++] = 0;
								pes_header[pes_header_len++] = 1;
								pes_header[pes_header_len++] = 0xB6;
								bitstream_init(&bit, pes_header+pes_header_len, 1);
								bitstream_put(&bit, 1, 2);
								bitstream_put(&bit, 0, 1);
								bitstream_put(&bit, 1, 1);
								bitstream_put(&bit, self->time_inc, self->time_inc_bits);
								bitstream_put(&bit, 1, 1);
								bitstream_put(&bit, 0, 1);
								bitstream_put(&bit, 0x7F >> bit.avail, 8 - bit.avail);
//								printf(" insert pack frame %d non keyframes, time_inc %d, time_inc_bits %d -",
//									self->num_non_keyframes, self->time_inc, self->time_inc_bits);
//								for (; i < (bit.data - (pes_header+pes_header_len)); ++i)
//									printf(" %02x", pes_header[pes_header_len+i]);
//								printf("\nset data_len to 0!\n");
								data_len = 0;
								pes_header_len += bit.data - (pes_header+pes_header_len);
								cache_prev_frame = TRUE;
							}
						}
						else if (!i_frame)
							store_frame = TRUE;

						self->num_non_keyframes=0;

						// extract time_inc
						bitstream_init(&bit, data+pos, 0);
						bitstream_get(&bit, 2); // skip coding_type
						while(bitstream_get(&bit, 1));
						bitstream_get(&bit, 1);
						self->time_inc = bitstream_get(&bit, self->time_inc_bits);
//						printf("\ntime_inc is %d\n", self->time_inc);

						if (store_frame) {
//							printf("store frame\n");
							self->prev_frame = buffer;
							gst_buffer_ref (buffer);
							return GST_FLOW_OK;
						}
					}
					else {
						cache_prev_frame = FALSE;
//						printf(" I/P Frame without non key frame(s)!!\n");
					}
					break;
				case 3: // S-Frame
//					printf("S ");
//					s_frame = TRUE;
				case 2: // B-Frame
//					if (!s_frame)
//						printf("B ");
					if (++self->num_non_keyframes == 1 && self->prev_frame) {
//						printf("send grouped with prev P!\n");
						commit_prev_frame_data = TRUE;
					}
					break;
				case 4: // N-Frame
				default:
					g_warning("unhandled divx5/xvid frame type %d\n", (data[pos] & 0xC0) >> 6);
					break;
			}
		}
//		printf("\n");
	}
#endif

	payload_len = data_len + pes_header_len - 6;

#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
	if (self->prev_frame && self->prev_frame != buffer) {
		unsigned long long pts = GST_BUFFER_TIMESTAMP(self->prev_frame) * 9LL / 100000 /* convert ns to 90kHz */;
//		printf("use prev timestamp: %08llx\n", (long long)GST_BUFFER_TIMESTAMP(self->prev_frame));

		pes_header[9] =  0x21 | ((pts >> 29) & 0xE);
		pes_header[10] = pts >> 22;
		pes_header[11] = 0x01 | ((pts >> 14) & 0xFE);
		pes_header[12] = pts >> 7;
		pes_header[13] = 0x01 | ((pts << 1) & 0xFE);
	}

	if (commit_prev_frame_data)
		payload_len += GST_BUFFER_SIZE (self->prev_frame);
#endif

	if (self->streamtype == STREAMTYPE_MPEG2 || self->streamtype == STREAMTYPE_MPEG1) {
		if (!self->codec_data && data_len > 3 && !data[0] && !data[1] && data[2] == 1 && data[3] == 0xb3) { // sequence header?
			gboolean ok = TRUE;
			unsigned int pos = 4;
			unsigned int sheader_data_len=0;
			while(pos < data_len && ok) {
				if ( pos >= data_len )
					break;
				pos+=7;
				if ( pos >=data_len )
					break;
				sheader_data_len=12;
				if ( data[pos] & 2 ) { // intra matrix avail?
					pos+=64;
					if ( pos >=data_len )
						break;
					sheader_data_len+=64;
				}
				if ( data[pos] & 1 ) { // non intra matrix avail?
					pos+=64;
					if ( pos >=data_len )
						break;
					sheader_data_len+=64;
				}
				pos+=1;
				if ( pos+3 >=data_len )
					break;
				// extended start code
				if ( !data[pos] && !data[pos+1] && data[pos+2] == 1 && data[pos+3] == 0xB5 ) {
					pos+=3;
					sheader_data_len+=3;
					do {
						pos+=1;
						++sheader_data_len;
						if (pos+2 > data_len)
							goto leave;
					}
					while( data[pos] || data[pos+1] || data[pos+2] != 1 );
				}
				if ( pos+3 >=data_len )
					break;
				// private data
				if ( !data[pos] && !data[pos+1] && data[pos+2] && data[pos+3] == 0xB2 ) {
					pos+=3;
					sheader_data_len+=3;
					do {
						pos+=1;
						++sheader_data_len;
						if (pos+2 > data_len)
							goto leave;
					}
					while( data[pos] || data[pos+1] || data[pos+2] != 1 );
				}
				self->codec_data = gst_buffer_new_and_alloc(sheader_data_len);
				memcpy(GST_BUFFER_DATA(self->codec_data), data+pos-sheader_data_len, sheader_data_len);
				self->must_send_header = 0;
leave:
				ok = FALSE;
			}
		}
		else if (self->codec_data && self->must_send_header) {
			unsigned char *codec_data = GST_BUFFER_DATA (self->codec_data);
			unsigned int codec_data_len = GST_BUFFER_SIZE (self->codec_data);
			int pos = 0;
			while(pos < data_len) {
				if ( data[pos++] )
					continue;
				if ( data[pos++] )
					continue;
				while ( !data[pos] )
					pos++;
				if ( data[pos++] != 1 )
					continue;
				if ( data[pos++] != 0xb8 ) // group start code
					continue;
				pos-=4; // before group start
				payload_len += codec_data_len;
				if (payload_len <= 0xFFFF) {
					pes_header[4] = payload_len >> 8;
					pes_header[5] = payload_len & 0xFF;
				}
				else {
					pes_header[4] = 0;
					pes_header[5] = 0;
				}
				ASYNC_WRITE(pes_header, pes_header_len);
				ASYNC_WRITE(data, pos);
				ASYNC_WRITE(codec_data, codec_data_len);
				ASYNC_WRITE(data+pos, data_len - pos);
				--self->must_send_header;
				return GST_FLOW_OK;
			}
		}
	}

	if (payload_len <= 0xFFFF) {
		pes_header[4] = payload_len >> 8;
		pes_header[5] = payload_len & 0xFF;
	}
	else {
		pes_header[4] = 0;
		pes_header[5] = 0;
	}

	ASYNC_WRITE(pes_header, pes_header_len);

#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
	if (commit_prev_frame_data) {
//		printf("commit prev frame data\n");
		ASYNC_WRITE(GST_BUFFER_DATA (self->prev_frame), GST_BUFFER_SIZE (self->prev_frame));
	}

	if (self->prev_frame && self->prev_frame != buffer) {
//		printf("unref prev_frame buffer\n");
		gst_buffer_unref(self->prev_frame);
		self->prev_frame = NULL;
	}

	if (cache_prev_frame) {
//		printf("cache prev frame\n");
		gst_buffer_ref(buffer);
		self->prev_frame = buffer;
	}
#endif
	ASYNC_WRITE(data, data_len);

	return GST_FLOW_OK;
poll_error:
	{
		GST_ELEMENT_ERROR (self, RESOURCE, READ, (NULL),
				("poll on file descriptor: %s.", g_strerror (errno)));
		GST_WARNING_OBJECT (self, "Error during poll");
		return GST_FLOW_ERROR;
	}
write_error:
	{
		GST_ELEMENT_ERROR (self, RESOURCE, READ, (NULL),
				("write on file descriptor: %s.", g_strerror (errno)));
		GST_WARNING_OBJECT (self, "Error during write");
		return GST_FLOW_ERROR;
	}
	self->must_send_header = 1;
	if (hwtype == DM7025)
		++self->must_send_header;  // we must send the sequence header twice on dm7025...
}

static gboolean 
gst_dvbvideosink_set_caps (GstBaseSink * basesink, GstCaps * caps)
{
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (basesink);
	GstStructure    *structure = gst_caps_get_structure (caps, 0);
	const char      *mimetype = gst_structure_get_name (structure);
	int              streamtype = STREAMTYPE_UNKNOWN;

	if (!strcmp (mimetype, "video/mpeg")) {
		gint mpegversion;
		gst_structure_get_int (structure, "mpegversion", &mpegversion);
		switch (mpegversion) {
			case 1:
				streamtype = STREAMTYPE_MPEG1;
				GST_INFO_OBJECT (self, "MIMETYPE video/mpeg1 -> VIDEO_SET_STREAMTYPE, 6");
			break;
			case 2:
				streamtype = STREAMTYPE_MPEG2;
				GST_INFO_OBJECT (self, "MIMETYPE video/mpeg2 -> VIDEO_SET_STREAMTYPE, 0");
			break;
			case 4:
			{
				const GValue *codec_data = gst_structure_get_value (structure, "codec_data");
				if (codec_data) {
					GST_INFO_OBJECT (self, "MPEG4 have codec data");
					self->codec_data = gst_value_get_buffer (codec_data);
					gst_buffer_ref (self->codec_data);
				}
				streamtype = STREAMTYPE_MPEG4_P2;
				GST_INFO_OBJECT (self, "MIMETYPE video/mpeg4 -> VIDEO_SET_STREAMTYPE, 4");
			}
			break;
			default:
				GST_ELEMENT_ERROR (self, STREAM, FORMAT, (NULL), ("unhandled mpeg version %i", mpegversion));
			break;
		}
	} else if (!strcmp (mimetype, "video/x-3ivx")) {
		const GValue *codec_data = gst_structure_get_value (structure, "codec_data");
		if (codec_data) {
			GST_INFO_OBJECT (self, "have 3ivx codec... handle as CT_MPEG4_PART2");
			self->codec_data = gst_value_get_buffer (codec_data);
			gst_buffer_ref (self->codec_data);
		}
		streamtype = STREAMTYPE_MPEG4_P2;
		GST_INFO_OBJECT (self, "MIMETYPE video/x-3ivx -> VIDEO_SET_STREAMTYPE, 4");
	} else if (!strcmp (mimetype, "video/x-h264")) {
		const GValue *cd_data = gst_structure_get_value (structure, "codec_data");
		streamtype = STREAMTYPE_H264;
		if (cd_data) {
			unsigned char tmp[2048];
			unsigned int tmp_len = 0;
			GstBuffer *codec_data = gst_value_get_buffer (cd_data);
			unsigned char *data = GST_BUFFER_DATA (codec_data);
			unsigned int cd_len = GST_BUFFER_SIZE (codec_data);
			unsigned int cd_pos = 0;
			GST_INFO_OBJECT (self, "H264 have codec data..!");
			if (cd_len > 7 && data[0] == 1) {
				unsigned short len = (data[6] << 8) | data[7];
//				printf("2 %d bytes\n", len);
				if (cd_len >= (len + 8)) {
					unsigned int i=0;
					uint8_t profile_num[] = { 66, 77, 88, 100 };
					uint8_t profile_cmp[2] = { 0x67, 0x00 };
					const char *profile_str[] = { "baseline", "main", "extended", "high" };
//					printf("3\n");
					memcpy(tmp, "\x00\x00\x00\x01", 4);
					tmp_len += 4;
//					printf("header part1 ");
//					for (i = 0; i < len; ++i)
//						printf("%02x ", data[8+i]);
//					printf("\n");
					memcpy(tmp+tmp_len, data+8, len);
					for (i = 0; i < 4; ++i) {
						profile_cmp[1] = profile_num[i];
						if (!memcmp(tmp+tmp_len, profile_cmp, 2)) {
							uint8_t level_org = tmp[tmp_len+3];
							if (level_org > 0x29) {
								GST_INFO_OBJECT (self, "H264 %s profile@%d.%d patched down to 4.1!", profile_str[i], level_org / 10 , level_org % 10);
								tmp[tmp_len+3] = 0x29; // level 4.1
							}
							else
								GST_INFO_OBJECT (self, "H264 %s profile@%d.%d", profile_str[i], level_org / 10 , level_org % 10);
							break;
						}
					}
					tmp_len += len;
					cd_pos = 8 + len;
					if (cd_len > (cd_pos + 2)) {
						len = (data[cd_pos+1] << 8) | data[cd_pos+2];
//						printf("4 %d bytes\n", len);
						cd_pos += 3;
						if (cd_len >= (cd_pos+len)) {
//							printf("codec data ok!\n");
							memcpy(tmp+tmp_len, "\x00\x00\x00\x01", 4);
							tmp_len += 4;
//							printf("header part2 %02x %02x %02x %02x ... %d bytes\n", data[cd_pos], data[cd_pos+1], data[cd_pos+2], data[cd_pos+3], len);
							memcpy(tmp+tmp_len, data+cd_pos, len);
							tmp_len += len;
							self->codec_data = gst_buffer_new_and_alloc(tmp_len);
							memcpy(GST_BUFFER_DATA(self->codec_data), tmp, tmp_len);
							self->h264_nal_len_size = (data[4] & 0x03) + 1;
							if (self->h264_nal_len_size < 3)
								self->h264_buffer = gst_buffer_new_and_alloc(H264_BUFFER_SIZE);
						}
						else
							GST_WARNING_OBJECT (self, "codec_data to short(4)");
					}
					else
						GST_WARNING_OBJECT (self, "codec_data to short(3)");
				}
				else
					GST_WARNING_OBJECT (self, "codec_data to short(2)");
			}
			else if (cd_len <= 7)
				GST_WARNING_OBJECT (self, "codec_data to short(1)");
			else
				GST_WARNING_OBJECT (self, "wrong avcC version %d!", data[0]);
		}
		else
			self->h264_nal_len_size = 0;
		GST_INFO_OBJECT (self, "MIMETYPE video/x-h264 VIDEO_SET_STREAMTYPE, 1");
	} else if (!strcmp (mimetype, "video/x-h263")) {
		streamtype = STREAMTYPE_H263;
		GST_INFO_OBJECT (self, "MIMETYPE video/x-h263 VIDEO_SET_STREAMTYPE, 2");
	} else if (!strcmp (mimetype, "video/x-xvid")) {
		streamtype = STREAMTYPE_XVID;
#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
		self->must_pack_bitstream = 1;
#endif
		GST_INFO_OBJECT (self, "MIMETYPE video/x-xvid -> VIDEO_SET_STREAMTYPE, 10");
	} else if (!strcmp (mimetype, "video/x-divx") || !strcmp (mimetype, "video/x-msmpeg")) {
		gint divxversion = -1;
		if (!gst_structure_get_int (structure, "divxversion", &divxversion) && !gst_structure_get_int (structure, "msmpegversion", &divxversion))
			;
		switch (divxversion) {
			case 3:
			case 43:
			{
				#define B_GET_BITS(w,e,b)  (((w)>>(b))&(((unsigned)(-1))>>((sizeof(unsigned))*8-(e+1-b))))
				#define B_SET_BITS(name,v,e,b)  (((unsigned)(v))<<(b))
				static const guint8 brcm_divx311_sequence_header[] = {
					0x00, 0x00, 0x01, 0xE0, 0x00, 0x34, 0x80, 0x80, // PES HEADER
					0x05, 0x2F, 0xFF, 0xFF, 0xFF, 0xFF, 
					0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20, /* 0 .. 7 */
					0x08, 0xC8, 0x0D, 0x40, 0x00, 0x53, 0x88, 0x40, /* 8 .. 15 */
					0x0C, 0x40, 0x01, 0x90, 0x00, 0x97, 0x53, 0x0A, /* 16 .. 24 */
					0x00, 0x00, 0x00, 0x00,
					0x30, 0x7F, 0x00, 0x00, 0x01, 0xB2, 0x44, 0x69, /* 0 .. 7 */
					0x76, 0x58, 0x33, 0x31, 0x31, 0x41, 0x4E, 0x44  /* 8 .. 15 */
				};
				self->codec_data = gst_buffer_new_and_alloc(63);
				guint8 *data = GST_BUFFER_DATA(self->codec_data);
				gint height, width;
				gst_structure_get_int (structure, "height", &height);
				gst_structure_get_int (structure, "width", &width);
				memcpy(data, brcm_divx311_sequence_header, 63);
				data += 38;
				data[0] = B_GET_BITS(width,11,4);
				data[1] = B_SET_BITS("width [3..0]", B_GET_BITS(width,3,0), 7, 4) |
					B_SET_BITS("'10'", 0x02, 3, 2) |
					B_SET_BITS("height [11..10]", B_GET_BITS(height,11,10), 1, 0);
				data[2] = B_GET_BITS(height,9,2);
				data[3]= B_SET_BITS("height [1.0]", B_GET_BITS(height,1,0), 7, 6) |
					B_SET_BITS("'100000'", 0x20, 5, 0);
				streamtype = STREAMTYPE_DIVX311;
				GST_INFO_OBJECT (self, "MIMETYPE video/x-divx vers. 3 -> VIDEO_SET_STREAMTYPE, 13");
			}
			break;
			case 4:
				streamtype = STREAMTYPE_DIVX4;
				self->codec_data = gst_buffer_new_and_alloc(12);
				guint8 *data = GST_BUFFER_DATA(self->codec_data);
				memcpy(data, "\x00\x00\x01\xb2\x44\x69\x76\x58\x34\x41\x4e\x44", 12);
				GST_INFO_OBJECT (self, "MIMETYPE video/x-divx vers. 4 -> VIDEO_SET_STREAMTYPE, 14");
			break;
			case 6:
			case 5:
				streamtype = STREAMTYPE_DIVX5;
#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
				self->must_pack_bitstream = 1;
#endif
				GST_INFO_OBJECT (self, "MIMETYPE video/x-divx vers. 5 -> VIDEO_SET_STREAMTYPE, 15");
			break;
			default:
				GST_ELEMENT_ERROR (self, STREAM, FORMAT, (NULL), ("unhandled divx version %i", divxversion));
			break;
		}
	}
	if (streamtype != -STREAMTYPE_UNKNOWN) {
		gint numerator, denominator;
		if (gst_structure_get_fraction (structure, "framerate", &numerator, &denominator)) {
			FILE *f = fopen("/proc/stb/vmpeg/0/fallback_framerate", "w");
			if (f) {
				int valid_framerates[] = { 23976, 24000, 25000, 29970, 30000, 50000, 59940, 60000 };
				int framerate = (int)(((double)numerator * 1000) / denominator);
				int diff = 60000;
				int best = 0;
				int i = 0;
				for (; i < 7; ++i) {
					int ndiff = abs(framerate - valid_framerates[i]);
					if (ndiff < diff) {
						diff = ndiff;
						best = i;
					}
				}
				fprintf(f, "%d", valid_framerates[best]);
				fclose(f);
			}
		}
		if (self->dec_running) {
			ioctl(self->fd, VIDEO_STOP, 0);
			self->dec_running = FALSE;
		}
		if (self->use_set_encoding)
		{
#ifdef VIDEO_SET_ENCODING
			unsigned int encoding = streamtype_to_encoding(streamtype);
			if (ioctl(self->fd, VIDEO_SET_ENCODING, encoding) < 0) {
				GST_ELEMENT_WARNING (self, STREAM, DECODE, (NULL), ("hardware decoder can't be set to encoding %i.", encoding));
			}
#endif
		}
		else
		{
			if (ioctl(self->fd, VIDEO_SET_STREAMTYPE, streamtype) < 0 )
				if ( streamtype != 0 && streamtype != 6 )
					GST_ELEMENT_ERROR (self, STREAM, CODEC_NOT_FOUND, (NULL), ("hardware decoder can't handle streamtype %i", streamtype));
		}
		self->streamtype = streamtype;

		ioctl(self->fd, VIDEO_PLAY);
		self->dec_running = TRUE;
	} else
		GST_ELEMENT_ERROR (self, STREAM, TYPE_NOT_FOUND, (NULL), ("unimplemented stream type %s", mimetype));

	return TRUE;
}

static int readMpegProc(char *str, int decoder)
{
	int val = -1;
	char tmp[64];
	sprintf(tmp, "/proc/stb/vmpeg/%d/%s", decoder, str);
	FILE *f = fopen(tmp, "r");
	if (f)
	{
		fscanf(f, "%x", &val);
		fclose(f);
	}
	return val;
}

static int readApiSize(int fd, int *xres, int *yres, int *aspect)
{
	video_size_t size;
	if (!ioctl(fd, VIDEO_GET_SIZE, &size))
	{
		*xres = size.w;
		*yres = size.h;
		*aspect = size.aspect_ratio == 0 ? 2 : 3;  // convert dvb api to etsi
		return 0;
	}
	return -1;
}

static int readApiFrameRate(int fd, int *framerate)
{
	unsigned int frate;
	if (!ioctl(fd, VIDEO_GET_FRAME_RATE, &frate))
	{
		*framerate = frate;
		return 0;
	}
	return -1;
}

static gboolean
gst_dvbvideosink_start (GstBaseSink * basesink)
{
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (basesink);
	gint control_sock[2];

	GST_DEBUG_OBJECT (self, "start");


	if (socketpair(PF_UNIX, SOCK_STREAM, 0, control_sock) < 0) {
		perror("socketpair");
		goto socket_pair;
	}

	READ_SOCKET (self) = control_sock[0];
	WRITE_SOCKET (self) = control_sock[1];

	fcntl (READ_SOCKET (self), F_SETFL, O_NONBLOCK);
	fcntl (WRITE_SOCKET (self), F_SETFL, O_NONBLOCK);

	return TRUE;
	/* ERRORS */
socket_pair:
	{
		GST_ELEMENT_ERROR (self, RESOURCE, OPEN_READ_WRITE, (NULL),
				GST_ERROR_SYSTEM);
		return FALSE;
	}
}

static gboolean
gst_dvbvideosink_stop (GstBaseSink * basesink)
{
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (basesink);
	FILE *f = fopen("/proc/stb/vmpeg/0/fallback_framerate", "w");
	GST_DEBUG_OBJECT (self, "stop");
	if (self->fd >= 0)
	{
		if (self->dec_running) {
			ioctl(self->fd, VIDEO_STOP);
			self->dec_running = FALSE;
		}
		ioctl(self->fd, VIDEO_SLOWMOTION, 0);
		ioctl(self->fd, VIDEO_FAST_FORWARD, 0);
		ioctl(self->fd, VIDEO_SELECT_SOURCE, VIDEO_SOURCE_DEMUX);
		close(self->fd);
	}

	if (self->codec_data)
		gst_buffer_unref(self->codec_data);

	if (self->h264_buffer)
		gst_buffer_unref(self->h264_buffer);

#ifdef PACK_UNPACKED_XVID_DIVX5_BITSTREAM
	if (self->prev_frame)
		gst_buffer_unref(self->prev_frame);
#endif

	while(self->queue)
		queue_pop(&self->queue);

	if (f) {
		fputs(self->saved_fallback_framerate, f);
		fclose(f);
	}

	close (READ_SOCKET  (self));
	close (WRITE_SOCKET (self));
	READ_SOCKET (self)  = -1;
	WRITE_SOCKET (self) = -1;

	return TRUE;
}

static GstStateChangeReturn
gst_dvbvideosink_change_state (GstElement * element, GstStateChange transition)
{
	GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;
	GstDVBVideoSink *self = GST_DVBVIDEOSINK (element);

	switch (transition) {
	case GST_STATE_CHANGE_NULL_TO_READY:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_NULL_TO_READY");
		break;
	case GST_STATE_CHANGE_READY_TO_PAUSED:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_READY_TO_PAUSED");

		self->fd = open("/dev/dvb/adapter0/video0", O_RDWR|O_NONBLOCK);
//		self->fd = open("/dump.pes", O_RDWR|O_CREAT|O_TRUNC, 0555);

		GST_OBJECT_LOCK(self);
		self->no_write |= 4;
		GST_OBJECT_UNLOCK(self);

		if (self->fd >= 0) {
			GstStructure *s = 0;
			GstMessage *msg = 0;
			int aspect = -1, width = -1, height = -1, framerate = -1,
				progressive = readMpegProc("progressive", 0);

			if (readApiSize(self->fd, &width, &height, &aspect) == -1) {
				aspect = readMpegProc("aspect", 0);
				width = readMpegProc("xres", 0);
				height = readMpegProc("yres", 0);
			} else
				aspect = aspect == 0 ? 2 : 3; // dvb api to etsi
			if (readApiFrameRate(self->fd, &framerate) == -1)
				framerate = readMpegProc("framerate", 0);

			s = gst_structure_new ("eventSizeAvail",
				"aspect_ratio", G_TYPE_INT, aspect == 0 ? 2 : 3,
				"width", G_TYPE_INT, width,
				"height", G_TYPE_INT, height, NULL);
			msg = gst_message_new_element (GST_OBJECT (element), s);
			gst_element_post_message (GST_ELEMENT (element), msg);
			s = gst_structure_new ("eventFrameRateAvail",
				"frame_rate", G_TYPE_INT, framerate, NULL);
			msg = gst_message_new_element (GST_OBJECT (element), s);
			gst_element_post_message (GST_ELEMENT (element), msg);
			s = gst_structure_new ("eventProgressiveAvail",
				"progressive", G_TYPE_INT, progressive, NULL);
			msg = gst_message_new_element (GST_OBJECT (element), s);
			gst_element_post_message (GST_ELEMENT (element), msg);
			ioctl(self->fd, VIDEO_SELECT_SOURCE, VIDEO_SOURCE_MEMORY);
			ioctl(self->fd, VIDEO_FREEZE);
		}
		break;
	case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_PAUSED_TO_PLAYING");
		ioctl(self->fd, VIDEO_CONTINUE);
		GST_OBJECT_LOCK(self);
		self->no_write &= ~4;
		GST_OBJECT_UNLOCK(self);
		break;
	default:
		break;
	}

	ret = GST_ELEMENT_CLASS (parent_class)->change_state (element, transition);

	switch (transition) {
	case GST_STATE_CHANGE_PLAYING_TO_PAUSED:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_PLAYING_TO_PAUSED");
		GST_OBJECT_LOCK(self);
		self->no_write |= 4;
		GST_OBJECT_UNLOCK(self);
		ioctl(self->fd, VIDEO_FREEZE);
		SEND_COMMAND (self, CONTROL_STOP);
		break;
	case GST_STATE_CHANGE_PAUSED_TO_READY:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_PAUSED_TO_READY");
		break;
	case GST_STATE_CHANGE_READY_TO_NULL:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_READY_TO_NULL");
		break;
	default:
		break;
	}

	return ret;
}

/* entry point to initialize the plug-in
 * initialize the plug-in itself
 * register the element factories and pad templates
 * register the features
 *
 * exchange the string 'plugin' with your elemnt name
 */
static gboolean
plugin_init (GstPlugin *plugin)
{
	return gst_element_register (plugin, "dvbvideosink",
						 GST_RANK_PRIMARY,
						 GST_TYPE_DVBVIDEOSINK);
}

/* this is the structure that gstreamer looks for to register plugins
 *
 * exchange the strings 'plugin' and 'Template plugin' with you plugin name and
 * description
 */
GST_PLUGIN_DEFINE (
	GST_VERSION_MAJOR,
	GST_VERSION_MINOR,
	"dvb_video_out",
	"DVB Video Output",
	plugin_init,
	VERSION,
	"LGPL",
	"GStreamer",
	"http://gstreamer.net/"
)
