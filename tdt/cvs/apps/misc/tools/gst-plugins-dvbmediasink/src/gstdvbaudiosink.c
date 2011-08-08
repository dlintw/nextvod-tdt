/*
 * GStreamer DVB Media Sink
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
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <linux/dvb/audio.h>
#include <linux/dvb/video.h>
#include <fcntl.h>
#include <poll.h>

#include <gst/gst.h>

#include "gstdvbaudiosink.h"
#include "gstdvbsink-marshal.h"

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

#define SEND_COMMAND(sink, command)			\
G_STMT_START {						\
	unsigned char c; c = command;			\
	write (WRITE_SOCKET(sink), &c, 1);		\
} G_STMT_END

#define READ_COMMAND(sink, command, res)		\
G_STMT_START {						\
	res = read(READ_SOCKET(sink), &command, 1);	\
} G_STMT_END

#ifndef AUDIO_GET_PTS
#define AUDIO_GET_PTS           _IOR('o', 19, gint64)
#endif

#define PROP_LOCATION 99

GST_DEBUG_CATEGORY_STATIC (dvbaudiosink_debug);
#define GST_CAT_DEFAULT dvbaudiosink_debug

enum
{
	SIGNAL_GET_DECODER_TIME,
	LAST_SIGNAL
};

static guint gst_dvbaudiosink_signals[LAST_SIGNAL] = { 0 };

static guint AdtsSamplingRates[] = { 96000, 88200, 64000, 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11025, 8000, 7350, 0 };

static GstStaticPadTemplate sink_factory_ati_xilleon =
GST_STATIC_PAD_TEMPLATE (
	"sink",
	GST_PAD_SINK,
	GST_PAD_ALWAYS,
	GST_STATIC_CAPS ("audio/mpeg, "
		"mpegversion = (int) 1, "
		"layer = (int) [ 1, 2 ], "
		"framed = (boolean) true; "
		"audio/x-ac3, "
		"framed = (boolean) true; "
		"audio/x-private1-ac3, "
		"framed = (boolean) true")
);

static GstStaticPadTemplate sink_factory_broadcom_dts =
GST_STATIC_PAD_TEMPLATE (
	"sink",
	GST_PAD_SINK,
	GST_PAD_ALWAYS,
	GST_STATIC_CAPS ("audio/mpeg, "
		"framed = (boolean) true; "
		"audio/x-ac3, "
		"framed = (boolean) true; "
		"audio/x-private1-ac3, "
		"framed = (boolean) true; "
		"audio/x-dts, "
		"framed = (boolean) true; "
		"audio/x-private1-dts, "
		"framed = (boolean) true; "
		"audio/x-private1-lpcm, "
		"framed = (boolean) true")
);

static GstStaticPadTemplate sink_factory_broadcom =
GST_STATIC_PAD_TEMPLATE (
	"sink",
	GST_PAD_SINK,
	GST_PAD_ALWAYS,
	GST_STATIC_CAPS ("audio/mpeg, "
		"framed = (boolean) true; "
		"audio/x-ac3, "
		"framed = (boolean) true; "
		"audio/x-private1-ac3, "
		"framed = (boolean) true")
);

#define DEBUG_INIT(bla) \
	GST_DEBUG_CATEGORY_INIT (dvbaudiosink_debug, "dvbaudiosink", 0, "dvbaudiosink element");

GST_BOILERPLATE_FULL (GstDVBAudioSink, gst_dvbaudiosink, GstBaseSink, GST_TYPE_BASE_SINK, DEBUG_INIT);

static void gst_dvbaudiosink_set_property (GObject * object, guint prop_id, const GValue * value, GParamSpec * pspec);
static void gst_dvbaudiosink_get_property (GObject * object, guint prop_id, GValue * value, GParamSpec * pspec);

static gboolean gst_dvbaudiosink_start (GstBaseSink * sink);
static gboolean gst_dvbaudiosink_stop (GstBaseSink * sink);
static gboolean gst_dvbaudiosink_event (GstBaseSink * sink, GstEvent * event);
static GstFlowReturn gst_dvbaudiosink_render (GstBaseSink * sink, GstBuffer * buffer);
static gboolean gst_dvbaudiosink_unlock (GstBaseSink * basesink);
static gboolean gst_dvbaudiosink_unlock_stop (GstBaseSink * basesink);
static gboolean gst_dvbaudiosink_set_caps (GstBaseSink * sink, GstCaps * caps);
static void gst_dvbaudiosink_dispose (GObject * object);
static GstStateChangeReturn gst_dvbaudiosink_change_state (GstElement * element, GstStateChange transition);
static gint64 gst_dvbaudiosink_get_decoder_time (GstDVBAudioSink *self);

typedef enum { DM7025, DM800, DM8000, DM500HD, DM800SE, DM7020HD } hardware_type_t;

static hardware_type_t hwtype;

static void
gst_dvbaudiosink_base_init (gpointer klass)
{
	static GstElementDetails element_details = {
		"A DVB audio sink",
		"Generic/DVBAudioSink",
		"Outputs a MPEG2 PES / ES into a DVB audio device for hardware playback",
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
			string[rd] = 0;
			if ( !strncasecmp(string, "DM7025", 6) ) {
				hwtype = DM7025;
				GST_INFO ("model is DM7025 set ati xilleon caps");
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_ati_xilleon));
			}
			else if ( !strncasecmp(string, "DM8000", 6) ) {
				hwtype = DM8000;
				GST_INFO ("model is DM8000 set broadcom dts caps");
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_broadcom_dts));
			}
			else if ( !strncasecmp(string, "DM800SE", 7) ) {
				hwtype = DM800SE;
				GST_INFO ("model is DM800SE set broadcom dts caps", string);
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_broadcom_dts));
			}
			else if ( !strncasecmp(string, "DM7020HD", 8) ) {
				hwtype = DM7020HD;
				GST_INFO ("model is DM7020HD set broadcom dts caps", string);
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_broadcom_dts));
			}
			else if ( !strncasecmp(string, "DM800", 5) ) {
				hwtype = DM800;
				GST_INFO ("model is DM800 set broadcom caps", string);
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_broadcom));
			}
			else if ( !strncasecmp(string, "DM500HD", 7) ) {
				hwtype = DM500HD;
				GST_INFO ("model is DM500HD set broadcom dts caps", string);
				gst_element_class_add_pad_template (element_class,
					gst_static_pad_template_get (&sink_factory_broadcom_dts));
			}
		}
		close(fd);
	}

	gst_element_class_set_details (element_class, &element_details);
}

static int
gst_dvbaudiosink_async_write(GstDVBAudioSink *self, unsigned char *data, unsigned int len);

/* initialize the plugin's class */
static void
gst_dvbaudiosink_class_init (GstDVBAudioSinkClass *klass)
{
	GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
	GstBaseSinkClass *gstbasesink_class = GST_BASE_SINK_CLASS (klass);
	GstElementClass *gelement_class = GST_ELEMENT_CLASS (klass);

	gobject_class->dispose = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_dispose);
	gobject_class->set_property = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_set_property);
	gobject_class->get_property = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_get_property);
	g_object_class_install_property (gobject_class, PROP_LOCATION,
		g_param_spec_string ("dump-filename", "Dump File Location",
			"Filename that Packetized Elementary Stream will be written to", NULL,
			G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

	gstbasesink_class->start = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_start);
	gstbasesink_class->stop = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_stop);
	gstbasesink_class->render = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_render);
	gstbasesink_class->event = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_event);
	gstbasesink_class->unlock = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_unlock);
	gstbasesink_class->unlock_stop = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_unlock_stop);
	gstbasesink_class->set_caps = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_set_caps);

	gelement_class->change_state = GST_DEBUG_FUNCPTR (gst_dvbaudiosink_change_state);

	gst_dvbaudiosink_signals[SIGNAL_GET_DECODER_TIME] =
		g_signal_new ("get-decoder-time",
		G_TYPE_FROM_CLASS (klass),
		G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
		G_STRUCT_OFFSET (GstDVBAudioSinkClass, get_decoder_time),
		NULL, NULL, gst_dvbsink_marshal_INT64__VOID, G_TYPE_INT64, 0);

	klass->get_decoder_time = gst_dvbaudiosink_get_decoder_time;
	klass->async_write = gst_dvbaudiosink_async_write;
}

/* initialize the new element
 * instantiate pads and add them to element
 * set functions
 * initialize structure
 */
static void
gst_dvbaudiosink_init (GstDVBAudioSink *klass, GstDVBAudioSinkClass * gclass)
{
	klass->bypass = -1;

	klass->timestamp = 0;
	klass->aac_adts_header_valid = FALSE;

	klass->no_write = 0;
	klass->queue = NULL;
	klass->fd = -1;
	klass->dump_fd = -1;
	klass->dump_filename = NULL;

	gst_base_sink_set_sync (GST_BASE_SINK(klass), FALSE);
	gst_base_sink_set_async_enabled (GST_BASE_SINK(klass), TRUE);
}

static void
gst_dvbaudiosink_dispose (GObject * object)
{
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (object);
	GstState state, pending;
	GST_DEBUG_OBJECT (self, "dispose");

// hack for gstreamer decodebin2 bug... it tries to dispose .. but doesnt set the state to NULL when it is READY
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

	if (self->dump_filename)
	{
			g_free (self->dump_filename);
			self->dump_filename = NULL;
	}

	G_OBJECT_CLASS (parent_class)->dispose (object);
}

static gboolean
gst_dvbaudiosink_set_location (GstDVBAudioSink * sink, const gchar * location)
{
	if (sink->dump_fd)
		goto was_open;

	g_free (sink->dump_filename);
	if (location != NULL) {
		/* we store the filename as we received it from the application. On Windows
		* this should be in UTF8 */
		sink->dump_filename = g_strdup (location);
	} else {
		sink->dump_filename = NULL;
	}

	return TRUE;

	/* ERRORS */
	was_open:
	{
		g_warning ("Changing the `dump-filename' property during operation is not supported.");
		return FALSE;
	}
}

static void
gst_dvbaudiosink_set_property (GObject * object, guint prop_id, const GValue * value, GParamSpec * pspec)
{
	GstDVBAudioSink *sink = GST_DVBAUDIOSINK (object);

	switch (prop_id) {
		case PROP_LOCATION:
		gst_dvbaudiosink_set_location (sink, g_value_get_string (value));
		break;
		default:
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
		break;
	}
}

static void
gst_dvbaudiosink_get_property (GObject * object, guint prop_id, GValue * value, GParamSpec * pspec)
{
	GstDVBAudioSink *sink = GST_DVBAUDIOSINK (object);

	switch (prop_id) {
		case PROP_LOCATION:
		g_value_set_string (value, sink->dump_filename);
		break;
		default:
		G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
		break;
	}
}

static gint64
gst_dvbaudiosink_get_decoder_time (GstDVBAudioSink *self)
{
	if (self->bypass != -1) {
		gint64 cur = 0;
		static gint64 last_pos = 0;

		ioctl(self->fd, AUDIO_GET_PTS, &cur);

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

static gboolean
gst_dvbaudiosink_unlock (GstBaseSink * basesink)
{
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (basesink);
	GST_OBJECT_LOCK(self);
	self->no_write |= 2;
	GST_OBJECT_UNLOCK(self);
	SEND_COMMAND (self, CONTROL_STOP);
	GST_DEBUG_OBJECT (basesink, "unlock");
	return TRUE;
}

static gboolean
gst_dvbaudiosink_unlock_stop (GstBaseSink * basesink)
{
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (basesink);
	GST_OBJECT_LOCK(self);
	self->no_write &= ~2;
	GST_OBJECT_UNLOCK(self);
	GST_DEBUG_OBJECT (basesink, "unlock_stop");
	return TRUE;
}

static gboolean
gst_dvbaudiosink_set_caps (GstBaseSink * basesink, GstCaps * caps)
{
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (basesink);
	GstStructure *structure = gst_caps_get_structure (caps, 0);
	const char *type = gst_structure_get_name (structure);
	int bypass = -1;

	self->skip = 0;

	if (!strcmp(type, "audio/mpeg")) {
		gint mpegversion;
		gst_structure_get_int (structure, "mpegversion", &mpegversion);
		switch (mpegversion) {
			case 1:
			{
				gint layer;
				gst_structure_get_int (structure, "layer", &layer);
				if ( layer == 3 )
					bypass = 0xA;
				else
					bypass = 1;
				GST_INFO_OBJECT (self, "MIMETYPE %s version %d layer %d",type,mpegversion,layer);
				break;
			}
			case 2:
			case 4:
			{
				const gchar *stream_type = gst_structure_get_string (structure, "stream-type");
				if (!stream_type)
					stream_type = gst_structure_get_string (structure, "stream-format");
				if (stream_type && !strcmp(stream_type, "adts"))
					GST_INFO_OBJECT (self, "MIMETYPE %s version %d (AAC-ADTS)", type, mpegversion);
				else {
					const GValue *codec_data = gst_structure_get_value (structure, "codec_data");
					GST_INFO_OBJECT (self, "MIMETYPE %s version %d (AAC-RAW)", type, mpegversion);
					if (codec_data) {
						guint8 *h = GST_BUFFER_DATA(gst_value_get_buffer (codec_data));
						guint8 obj_type = ((h[0] & 0xC) >> 2) + 1;
						guint8 rate_idx = ((h[0] & 0x3) << 1) | ((h[1] & 0x80) >> 7);
						guint8 channels = (h[1] & 0x78) >> 3;
						GST_INFO_OBJECT (self, "have codec data -> obj_type = %d, rate_idx = %d, channels = %d\n",
							obj_type, rate_idx, channels);
						/* Sync point over a full byte */
						self->aac_adts_header[0] = 0xFF;
						/* Sync point continued over first 4 bits + static 4 bits
						 * (ID, layer, protection)*/
						self->aac_adts_header[1] = 0xF1;
						if (mpegversion == 2)
							self->aac_adts_header[1] |= 8;
						/* Object type over first 2 bits */
						self->aac_adts_header[2] = obj_type << 6;
						/* rate index over next 4 bits */
						self->aac_adts_header[2] |= rate_idx << 2;
						/* channels over last 2 bits */
						self->aac_adts_header[2] |= (channels & 0x4) >> 2;
						/* channels continued over next 2 bits + 4 bits at zero */
						self->aac_adts_header[3] = (channels & 0x3) << 6;
						self->aac_adts_header_valid = TRUE;
					}
					else {
						gint rate, channels, rate_idx=0, obj_type=1; // hardcoded yet.. hopefully this works every time ;)
						GST_INFO_OBJECT (self, "no codec data");
						if (gst_structure_get_int (structure, "rate", &rate) && gst_structure_get_int (structure, "channels", &channels)) {
							do {
								if (AdtsSamplingRates[rate_idx] == rate)
									break;
								++rate_idx;
							} while (AdtsSamplingRates[rate_idx]);
							if (AdtsSamplingRates[rate_idx]) {
								GST_INFO_OBJECT (self, "mpegversion %d, channels %d, rate %d, rate_idx %d\n", mpegversion, channels, rate, rate_idx);
								/* Sync point over a full byte */
								self->aac_adts_header[0] = 0xFF;
								/* Sync point continued over first 4 bits + static 4 bits
								 * (ID, layer, protection)*/
								self->aac_adts_header[1] = 0xF1;
								if (mpegversion == 2)
									self->aac_adts_header[1] |= 8;
								/* Object type over first 2 bits */
								self->aac_adts_header[2] = obj_type << 6;
								/* rate index over next 4 bits */
								self->aac_adts_header[2] |= rate_idx << 2;
								/* channels over last 2 bits */
								self->aac_adts_header[2] |= (channels & 0x4) >> 2;
								/* channels continued over next 2 bits + 4 bits at zero */
								self->aac_adts_header[3] = (channels & 0x3) << 6;
								self->aac_adts_header_valid = TRUE;
							}
						}
					}
				}
				bypass = 0x0b; // always use AAC+ ADTS yet..
				break;
			}
			default:
				GST_ELEMENT_ERROR (self, STREAM, FORMAT, (NULL), ("unhandled mpeg version %i", mpegversion));
				break;
		}
	}
	else if (!strcmp(type, "audio/x-ac3")) {
		GST_INFO_OBJECT (self, "MIMETYPE %s",type);
		bypass = 0;
	}
	else if (!strcmp(type, "audio/x-private1-dts")) {
		GST_INFO_OBJECT (self, "MIMETYPE %s (DVD Audio - 2 byte skipping)",type);
		bypass = 2;
		self->skip = 2;
	}
	else if (!strcmp(type, "audio/x-private1-ac3")) {
		GST_INFO_OBJECT (self, "MIMETYPE %s (DVD Audio - 2 byte skipping)",type);
		bypass = 0;
		self->skip = 2;
	}
	else if (!strcmp(type, "audio/x-private1-lpcm")) {
		GST_INFO_OBJECT (self, "MIMETYPE %s (DVD Audio)",type);
		bypass = 6;
	}
	else if (!strcmp(type, "audio/x-dts")) {
		GST_INFO_OBJECT (self, "MIMETYPE %s",type);
		bypass = 2;
	}
	else {
		GST_ELEMENT_ERROR (self, STREAM, TYPE_NOT_FOUND, (NULL), ("unimplemented stream type %s", type));
		return FALSE;
	}

	GST_INFO_OBJECT(self, "setting dvb mode 0x%02x\n", bypass);

	if (ioctl(self->fd, AUDIO_SET_BYPASS_MODE, bypass) < 0) {
		if (bypass == 2) {
			GST_ELEMENT_ERROR (self, STREAM, TYPE_NOT_FOUND, (NULL), ("hardware decoder can't be set to bypass mode type %s", type));
			return FALSE;
		}
		GST_ELEMENT_WARNING (self, STREAM, DECODE, (NULL), ("hardware decoder can't be set to bypass mode %i.", bypass));
// 		return FALSE;
	}
	self->bypass = bypass;
	return TRUE;
}

static void
queue_push(queue_entry_t **queue_base, guint8 *data, size_t len)
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

static void
queue_pop(queue_entry_t **queue_base)
{
	queue_entry_t *base = *queue_base;
	*queue_base = base->next;
	free(base);
}

static int
queue_front(queue_entry_t **queue_base, guint8 **data, size_t *bytes)
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
gst_dvbaudiosink_event (GstBaseSink * sink, GstEvent * event)
{
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (sink);
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
		ioctl(self->fd, AUDIO_CLEAR_BUFFER);
		GST_OBJECT_LOCK(self);
		while(self->queue)
			queue_pop(&self->queue);
		self->timestamp = 0;
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

		int video_fd = open("/dev/dvb/adapter0/video0", O_RDWR);
		if (fmt == GST_FORMAT_TIME) {
			if ( rate > 1 )
				skip = (int) rate;
			else if ( rate < 1 )
				repeat = 1.0/rate;
			ret = ioctl(video_fd, VIDEO_SLOWMOTION, repeat);
			ret = ioctl(video_fd, VIDEO_FAST_FORWARD, skip);
//			gst_segment_set_newsegment_full (&dec->segment, update, rate, applied_rate, dformat, cur, stop, time);
		}
		close(video_fd);
		break;
	}

	default:
		break;
	}

	return ret;
}

#define ASYNC_WRITE(data, len) do { \
		switch(gst_dvbaudiosink_async_write(self, data, len)) { \
		case -1: goto poll_error; \
		case -3: goto write_error; \
		default: break; \
		} \
	} while(0)

static int
gst_dvbaudiosink_async_write(GstDVBAudioSink *self, unsigned char *data, unsigned int len)
{
	unsigned int written=0;
	struct pollfd pfd[2];

	pfd[0].fd = READ_SOCKET(self);
	pfd[0].events = POLLIN;
	pfd[1].fd = self->fd;
	pfd[1].events = POLLOUT;

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
		if (pfd[1].revents & POLLOUT) {
			size_t queue_entry_size;
			guint8 *queue_data;
			GST_OBJECT_LOCK(self);
			if (queue_front(&self->queue, &queue_data, &queue_entry_size)) {
				int wr = write(self->fd, queue_data, queue_entry_size);
				if ( self->dump_fd > 0 )
						write(self->dump_fd, queue_data, queue_entry_size);
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
			if ( self->dump_fd > 0 )
					write(self->dump_fd, data+written, len - written);
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
gst_dvbaudiosink_render (GstBaseSink * sink, GstBuffer * buffer)
{
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (sink);
	unsigned char pes_header[64];
	unsigned int size = GST_BUFFER_SIZE (buffer) - self->skip;
	unsigned char *data = GST_BUFFER_DATA (buffer) + self->skip;
	long long timestamp = GST_BUFFER_TIMESTAMP(buffer);
	long long duration = GST_BUFFER_DURATION(buffer);

	size_t pes_header_size;
//	int i=0;

	/* LPCM workaround.. we also need the first two byte of the lpcm header.. (substreamid and num of frames) 
	   i dont know why the mpegpsdemux strips out this two bytes... */
	if (self->bypass == 6 && (data[0] < 0xA0 || data[0] > 0xAF)) {
		if (data[-2] >= 0xA0 && data[-2] <= 0xAF) {
			data -= 2;
			size += 2;
		}
	}

	if (duration != -1 && timestamp != -1) {
		if (self->timestamp == 0)
			self->timestamp = timestamp;
		else
			timestamp = self->timestamp;
		self->timestamp += duration;
	}
	else
		self->timestamp = 0;

//	for (;i < (size > 0x1F ? 0x1F : size); ++i)
//		printf("%02x ", data[i]);
//	printf("%d bytes\n", size);
//	printf("timestamp: %016lld, buffer timestamp: %016lld, duration %lld, diff %lld\n", timestamp, GST_BUFFER_TIMESTAMP(buffer), duration,
//		(timestamp > GST_BUFFER_TIMESTAMP(buffer) ? timestamp - GST_BUFFER_TIMESTAMP(buffer) : GST_BUFFER_TIMESTAMP(buffer) - timestamp) / 1000000);

	if ( self->bypass == -1 ) {
		GST_ELEMENT_ERROR (self, STREAM, FORMAT, (NULL), ("hardware decoder not setup (no caps in pipeline?)"));
		return GST_FLOW_ERROR;
	}

	if (self->fd < 0)
		return GST_FLOW_OK;

	pes_header[0] = 0;
	pes_header[1] = 0;
	pes_header[2] = 1;
	pes_header[3] = 0xC0;

	if (self->bypass == 2) {  // dts
		int pos=0;
		while((pos+3) < size) {
			if (!strcmp((char*)(data+pos), "\x64\x58\x20\x25")) {  // is DTS-HD ?
				size = pos;
				break;
			}
			++pos;
		}
	}

	if (self->aac_adts_header_valid)
		size += 7;

		/* do we have a timestamp? */
	if (timestamp != GST_CLOCK_TIME_NONE) {
		unsigned long long pts = timestamp * 9LL / 100000 /* convert ns to 90kHz */;

		pes_header[6] = 0x80;

		pes_header[9]  = 0x21 | ((pts >> 29) & 0xE);
		pes_header[10] = pts >> 22;
		pes_header[11] = 0x01 | ((pts >> 14) & 0xFE);
		pes_header[12] = pts >> 7;
		pes_header[13] = 0x01 | ((pts << 1) & 0xFE);

		if (hwtype == DM7025) {  // DM7025 needs DTS in PES header
			int64_t dts = pts; // what to use as DTS-PTS offset?
			pes_header[4] = (size + 13) >> 8;
			pes_header[5] = (size + 13) & 0xFF;
			pes_header[7] = 0xC0;
			pes_header[8] = 10;
			pes_header[9] |= 0x10;

			pes_header[14] = 0x11 | ((dts >> 29) & 0xE);
			pes_header[15] = dts >> 22;
			pes_header[16] = 0x01 | ((dts >> 14) & 0xFE);
			pes_header[17] = dts >> 7;
			pes_header[18] = 0x01 | ((dts << 1) & 0xFE);
			pes_header_size = 19;
		}
		else {
			pes_header[4] = (size + 8) >> 8;
			pes_header[5] = (size + 8) & 0xFF;
			pes_header[7] = 0x80;
			pes_header[8] = 5;
			pes_header_size = 14;
		}
	}
	else {
		pes_header[4] = (size + 3) >> 8;
		pes_header[5] = (size + 3) & 0xFF;
		pes_header[6] = 0x80;
		pes_header[7] = 0x00;
		pes_header[8] = 0;
		pes_header_size = 9;
	}

	if (self->aac_adts_header_valid) {
		self->aac_adts_header[3] &= 0xC0;
		/* frame size over last 2 bits */
		self->aac_adts_header[3] |= (size & 0x1800) >> 11;
		/* frame size continued over full byte */
		self->aac_adts_header[4] = (size & 0x1FF8) >> 3;
		/* frame size continued first 3 bits */
		self->aac_adts_header[5] = (size & 7) << 5;
		/* buffer fullness (0x7FF for VBR) over 5 last bits */
		self->aac_adts_header[5] |= 0x1F;
		/* buffer fullness (0x7FF for VBR) continued over 6 first bits + 2 zeros for
		 * number of raw data blocks */
		self->aac_adts_header[6] = 0xFC;
		memcpy(pes_header + pes_header_size, self->aac_adts_header, 7);
		pes_header_size += 7;
		size -= 7;
	}

	ASYNC_WRITE(pes_header, pes_header_size);
	ASYNC_WRITE(data, size);

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
}

static gboolean
gst_dvbaudiosink_start (GstBaseSink * basesink)
{
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (basesink);
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
gst_dvbaudiosink_stop (GstBaseSink * basesink)
{
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (basesink);

	GST_DEBUG_OBJECT (self, "stop");

	if (self->fd >= 0) {
		int video_fd = open("/dev/dvb/adapter0/video0", O_RDWR);

		ioctl(self->fd, AUDIO_STOP);
		ioctl(self->fd, AUDIO_SELECT_SOURCE, AUDIO_SOURCE_DEMUX);

		if ( video_fd > 0 ) {
			ioctl(video_fd, VIDEO_SLOWMOTION, 0);
			ioctl(video_fd, VIDEO_FAST_FORWARD, 0);
			close (video_fd);
		}
		close(self->fd);
	}

	if (self->dump_fd > 0)
		close(self->dump_fd);

	while(self->queue)
		queue_pop(&self->queue);

	close (READ_SOCKET (self));
	close (WRITE_SOCKET (self));
	READ_SOCKET (self) = -1;
	WRITE_SOCKET (self) = -1;

	return TRUE;
}

static GstStateChangeReturn
gst_dvbaudiosink_change_state (GstElement * element, GstStateChange transition)
{
	GstStateChangeReturn ret = GST_STATE_CHANGE_SUCCESS;
	GstDVBAudioSink *self = GST_DVBAUDIOSINK (element);

	switch (transition) {
	case GST_STATE_CHANGE_NULL_TO_READY:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_NULL_TO_READY");
		break;
	case GST_STATE_CHANGE_READY_TO_PAUSED:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_READY_TO_PAUSED");
		GST_OBJECT_LOCK(self);
		self->no_write |= 4;
		GST_OBJECT_UNLOCK(self);

		if (self->dump_filename)
				self->dump_fd = open(self->dump_filename, O_RDWR|O_CREAT, 0555);

		self->fd = open("/dev/dvb/adapter0/audio0", O_RDWR|O_NONBLOCK);

		if (self->fd) {
			ioctl(self->fd, AUDIO_SELECT_SOURCE, AUDIO_SOURCE_MEMORY);
			ioctl(self->fd, AUDIO_PLAY);
			ioctl(self->fd, AUDIO_PAUSE);
		}
		break;
	case GST_STATE_CHANGE_PAUSED_TO_PLAYING:
		GST_DEBUG_OBJECT (self,"GST_STATE_CHANGE_PAUSED_TO_PLAYING");
		ioctl(self->fd, AUDIO_CONTINUE);
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
		ioctl(self->fd, AUDIO_PAUSE);
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
	return gst_element_register (plugin, "dvbaudiosink",
						 GST_RANK_PRIMARY,
						 GST_TYPE_DVBAUDIOSINK);
}

/* this is the structure that gstreamer looks for to register plugins
 *
 * exchange the strings 'plugin' and 'Template plugin' with you plugin name and
 * description
 */
GST_PLUGIN_DEFINE (
	GST_VERSION_MAJOR,
	GST_VERSION_MINOR,
	"dvb_audio_out",
	"DVB Audio Output",
	plugin_init,
	VERSION,
	"LGPL",
	"GStreamer",
	"http://gstreamer.net/"
)
