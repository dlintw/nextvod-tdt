# tuxbox/xbmc-nightly

$(DEPDIR)/xbmc-nightly.do_prepare:
	REVISION=""; \
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
	echo "3) Fr,  31 Aug 2012 22:34 - Frodo_alpha5 - 12840c28d8fbfd71c26be798ff6b13828b05b168"; \
	echo "4) Fr,  31 Oct 2012 22:34 - Frodo_alpha7 - e292b1147bd89a7e53742e3e5039b9a906a3b1d0"; \
	echo "5) current inactive... comming soon, here is the next stable (case 5 == DIFF=5)"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="4"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && REVISION="460e79416c5cb13010456794f36f89d49d25da75"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && REVISION="327710767d2257dad27e3885effba1d49d4557f0"; \
	[ "$$REPLY" == "3" ] && DIFF="3" && REVISION="12840c28d8fbfd71c26be798ff6b13828b05b168"; \
	[ "$$REPLY" == "4" ] && DIFF="4" && REVISION="e292b1147bd89a7e53742e3e5039b9a906a3b1d0"; \
	echo "Revision: " $$REVISION; \
	[ -d "$(archivedir)/xbmc.git" ] && \
	(cd $(archivedir)/xbmc.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/xbmc.git" ] || \
	git clone $$REPO $(archivedir)/xbmc.git; \
	cp -ra $(archivedir)/xbmc.git $(appsdir)/xbmc-nightly.newest; \
	rm -rf $(appsdir)/xbmc-nightly.newest/.git; \
	cp -ra $(archivedir)/xbmc.git $(appsdir)/xbmc-nightly; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/xbmc-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	rm -rf $(appsdir)/xbmc-nightly/.git; \
	cp -ra $(appsdir)/xbmc-nightly $(appsdir)/xbmc-nightly.org; \
	cd $(appsdir)/xbmc-nightly && patch -p1 < "../../cdk/Patches/xbmc-nightly.$$DIFF.diff"; \
	cp -ra $(appsdir)/xbmc-nightly $(appsdir)/xbmc-nightly.patched
	touch $@

#			PYTHON_LDFLAGS='-L$(targetprefix)/usr/include/python2.6 -lpython2.6' \
#			PYTHON_VERSION='2.6' \
#endable webserver else httpapihandler will fail
$(appsdir)/xbmc-nightly/config.status: bootstrap libboost directfb libstgles libass libmpeg2 libmad jpeg libsamplerate libogg libvorbis libmodplug curl libflac bzip2 tiff lzo libz fontconfig libfribidi freetype sqlite libpng libpcre libcdio jasper yajl libmicrohttpd tinyxml python gstreamer gst_plugins_dvbmediasink expat libnfs taglib
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
			SWIG_EXE=none \
			JRE_EXE=none \
			--disable-gl \
			--enable-glesv1 \
			--disable-gles \
			--disable-sdl \
			--enable-webserver \
			--enable-nfs \
			--disable-x11 \
			--disable-samba \
			--disable-mysql \
			--disable-joystick \
			--disable-rsxs \
			--disable-projectm \
			--disable-goom \
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
			--disable-alsa \
			--disable-ssh

$(DEPDIR)/xbmc-nightly.do_compile: $(appsdir)/xbmc-nightly/config.status
	cd $(appsdir)/xbmc-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/xbmc-nightly: xbmc-nightly.do_prepare xbmc-nightly.do_compile
	$(MAKE) -C $(appsdir)/xbmc-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(targetprefix)/usr/lib/xbmc/xbmc.bin; \
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

