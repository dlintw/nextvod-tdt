AM_CPPFLAGS =  \
	@FREETYPE_CFLAGS@ \
	-I$(top_srcdir)/include

clock_LDADD = \
	@FREETYPE_LIBS@

ssaver_LDADD = \
	@FREETYPE_LIBS@

bin_PROGRAMS = clock

clock_SOURCES = \
	clock.c \
	text.c \
	gfx.c

ssaver_SOURCES = \
	ssaver.c \
	text.c \
	io.c \
	gfx.c

noinst_LTLIBRARIES = clock.la

clock_la_LDFLAGS = -rpath $(PLUGINDIR) -module -avoid-version

clock_la_SOURCES = \
	start.c

install-exec-local:
	install -d $(DESTDIR)$(PLUGINDIR)
	install -d $(DESTDIR)$(CONFIGDIR)
	$(LIBTOOL) --mode=install install clock.la $(DESTDIR)$(PLUGINDIR)
	install -m 0755 $(srcdir)/sclock $(DESTDIR)$(bindir)
	install -m 0644 $(srcdir)/clock.cfg $(DESTDIR)$(PLUGINDIR)
	install -m 0644 $(srcdir)/clock.conf $(DESTDIR)$(CONFIGDIR)
