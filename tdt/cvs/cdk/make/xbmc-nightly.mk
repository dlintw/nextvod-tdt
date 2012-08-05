# tuxbox/enigma2

$(DEPDIR)/xbmc-nightly.do_prepare:
	REVISION=""; \
	HEAD="master"; \
	DIFF="0"; \
	REPO="git://github.com/xbmc/xbmc.git"; \
	rm -rf $(appsdir)/xbmc-nightly; \
	rm -rf $(appsdir)/xbmc-nightly.org; \
	rm -rf $(appsdir)/xbmc-nightly.newest; \
	rm -rf $(appsdir)/xbmc-nightly.patched; \
	clear; \
	echo "Choose between the following revisions:"; \
	echo " 0) Newest (Can fail due to outdated patch)"; \
	echo "---- REVISIONS ----"; \
	echo "1) Sat, 14 Apr 2012 12:36 - 460e79416c5cb13010456794f36f89d49d25da75"; \
	echo "2) Sun, 10 Jun 2012 13:53 - 327710767d2257dad27e3885effba1d49d4557f0"; \
	echo "3) current inactive... comming soon, here is the next stable (case 3 == DIFF=3)"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="2"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && REVISION="460e79416c5cb13010456794f36f89d49d25da75"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && REVISION="327710767d2257dad27e3885effba1d49d4557f0"; \
	echo "Revision: " $$REVISION; \
	[ -d "$(appsdir)/xbmc-nightly" ] && \
	git pull $(appsdir)/xbmc-nightly $$HEAD;\
	[ -d "$(appsdir)/xbmc-nightly" ] || \
	git clone -b $$HEAD $$REPO $(appsdir)/xbmc-nightly; \
	cp -ra $(appsdir)/xbmc-nightly $(appsdir)/xbmc-nightly.newest; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/xbmc-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/xbmc-nightly $(appsdir)/xbmc-nightly.org; \
	cd $(appsdir)/xbmc-nightly && patch -p1 < "../../cdk/Patches/xbmc-nightly.$$DIFF.diff"; \
	cp -ra $(appsdir)/xbmc-nightly $(appsdir)/xbmc-nightly.patched
	touch $@


#			PYTHON_LDFLAGS='-L$(targetprefix)/usr/include/python2.6 -lpython2.6' \
#			PYTHON_VERSION='2.6' \
#endable webserver else httpapihandler will fail
$(appsdir)/xbmc-nightly/config.status: bootstrap libboost directfb libstgles libass libmpeg2 libmad jpeg libsamplerate libogg libvorbis libmodplug curl libflac bzip2 tiff lzo libz fontconfig libfribidi freetype sqlite libpng libpcre libcdio jasper yajl libmicrohttpd tinyxml python gstreamer gst_plugins_dvbmediasink expat
	cd $(appsdir)/xbmc-nightly && \
		$(BUILDENV) \
		./bootstrap && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PYTHON_SITE_PKG=$(targetprefix)/usr/lib/python2.6/site-packages \
			PYTHON_CPPFLAGS=-I$(targetprefix)/usr/include/python2.6 \
			PY_PATH=$(targetprefix)/usr \
			--disable-gl \
			--enable-glesv1 \
			--disable-gles \
			--disable-sdl \
			--enable-webserver \
			--disable-x11 \
			--disable-samba \
			--disable-mysql \
			--disable-joystick \
			--disable-rsxs \
			--disable-projectm \
			--disable-goom \
			--disable-nfs \
			--disable-afpclient \
			--disable-airplay \
			--disable-airtunes \
			--disable-dvdcss \
			--disable-hal \
			--disable-avahi \
			--disable-optical-drive \
			--disable-libbluray \
			--disable-texturepacker \
			--disable-udev \
			--disable-libusb \
			--disable-libcec \
			--enable-gstreamer \
			--disable-paplayer \
			--enable-gstplayer \
			--enable-dvdplayer \
			--disable-pulse \
			--disable-alsa

$(DEPDIR)/xbmc-nightly.do_compile: $(appsdir)/xbmc-nightly/config.status
	cd $(appsdir)/xbmc-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/xbmc-nightly: xbmc-nightly.do_prepare xbmc-nightly.do_compile
	$(MAKE) -C $(appsdir)/xbmc-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(targetprefix)/usr/lib/xbmc/xbmc.bin; \
		$(target)-strip $(targetprefix)/usr/lib/xbmc/system/*; \
		$(target)-strip $(targetprefix)/usr/lib/xbmc/system/players/dvdplayer/*; \
		$(target)-strip $(targetprefix)/usr/lib/xbmc/system/players/paplayer/*; \
	fi
	touch $@

xbmc-nightly-clean xbmc-nightly-distclean:
	rm -f $(DEPDIR)/xbmc-nightly
	rm -f $(DEPDIR)/xbmc-nightly.do_compile
	rm -f $(DEPDIR)/xbmc-nightly.do_prepare
	rm -rf $(appsdir)/xbmc-nightly
	rm -rf $(appsdir)/xbmc-nightly.newest
	rm -rf $(appsdir)/xbmc-nightly.org
	rm -rf $(appsdir)/xbmc-nightly.patched

