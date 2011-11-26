INCLUDES = \
	-I../../../neutrino/src/libeventserver \
	-I../../../neutrino/lib/ \
	-I../../../neutrino/src/ \
	-I../libeplayer3/include

lib_LTLIBRARIES = libcoolstream.la
libcoolstream_la_SOURCES = audio_cs.cpp dmx_cs.cpp dvb-ci.cpp playback_cs.cpp pwrmngr.cpp record_cs.cpp video_cs.cpp cool.cpp \
dvbci_session.cpp dvbci_mmi.cpp dvbci_camgr.cpp dvbci_appmgr.cpp dvbci_datetimemgr.cpp dvbci_resmgr.cpp

AM_CPPFLAGS = -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE

libcoolstream_LDADD =  -leplayer3
