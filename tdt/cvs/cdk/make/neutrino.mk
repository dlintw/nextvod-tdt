#
# Makefile to build NEUTRINO
#
$(targetprefix)/var/etc/.version:
	echo "imagename=Neutrino" > $@
	echo "homepage=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "creator=`id -un`" >> $@
	echo "docs=http://gitorious.org/open-duckbox-project-sh4/pages/Home" >> $@
	echo "forum=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "version=0200`date +%Y%m%d%H%M`" >> $@
	echo "git=`git describe`" >> $@

#
#
#
N_CPPFLAGS = -I$(driverdir)/bpamem

if BOXTYPE_SPARK
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom_spark
endif

if BOXTYPE_SPARK7162
N_CPPFLAGS += -I$(driverdir)/frontcontroller/aotom_spark
endif

N_CONFIG_OPTS = --enable-silent-rules --enable-freesatepg

if ENABLE_EXTERNALLCD
N_CONFIG_OPTS += --enable-graphlcd
endif

if ENABLE_MEDIAFWGSTREAMER
N_CONFIG_OPTS += --enable-gstreamer
else
N_CONFIG_OPTS += --enable-libeplayer3
endif

#
# LIBSTB-HAL
#
$(DEPDIR)/libstb-hal.do_prepare:
	rm -rf $(appsdir)/libstb-hal
	rm -rf $(appsdir)/libstb-hal.org
	[ -d "$(archivedir)/libstb-hal.git" ] && \
	(cd $(archivedir)/libstb-hal.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/libstb-hal.git" ] || \
	git clone git://gitorious.org/neutrino-hd/max10s-libstb-hal.git $(archivedir)/libstb-hal.git; \
	cp -ra $(archivedir)/libstb-hal.git $(appsdir)/libstb-hal;\
	cp -ra $(appsdir)/libstb-hal $(appsdir)/libstb-hal.org
	touch $@

$(appsdir)/libstb-hal/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/libstb-hal && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/libstb-hal.do_compile: $(appsdir)/libstb-hal/config.status
	cd $(appsdir)/libstb-hal && \
		$(MAKE)
	touch $@

$(DEPDIR)/libstb-hal: libstb-hal.do_prepare libstb-hal.do_compile
	$(MAKE) -C $(appsdir)/libstb-hal install DESTDIR=$(targetprefix)
	touch $@

libstb-hal-clean:
	rm -f $(DEPDIR)/libstb-hal
	cd $(appsdir)/libstb-hal && \
		$(MAKE) distclean

libstb-hal-distclean:
	rm -f $(DEPDIR)/libstb-hal
	rm -f $(DEPDIR)/libstb-hal.do_compile
	rm -f $(DEPDIR)/libstb-hal.do_prepare

#
# LIBSTB-HAL-EXP
#
$(DEPDIR)/libstb-hal-exp.do_prepare:
	rm -rf $(appsdir)/libstb-hal-exp
	rm -rf $(appsdir)/libstb-hal-exp.org
	[ -d "$(archivedir)/libstb-hal.git" ] && \
	(cd $(archivedir)/libstb-hal.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/libstb-hal.git" ] || \
	git clone git://gitorious.org/neutrino-hd/max10s-libstb-hal.git $(archivedir)/libstb-hal.git; \
	cp -ra $(archivedir)/libstb-hal.git $(appsdir)/libstb-hal-exp;\
	(cd $(appsdir)/libstb-hal-exp; git checkout experimental; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/libstb-hal-exp $(appsdir)/libstb-hal-exp.org
	touch $@

$(appsdir)/libstb-hal-exp/config.status: bootstrap
	cd $(appsdir)/libstb-hal-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/libstb-hal-exp.do_compile: $(appsdir)/libstb-hal-exp/config.status
	cd $(appsdir)/libstb-hal-exp && \
		$(MAKE)
	touch $@

$(DEPDIR)/libstb-hal-exp: libstb-hal-exp.do_prepare libstb-hal-exp.do_compile
	$(MAKE) -C $(appsdir)/libstb-hal-exp install DESTDIR=$(targetprefix)
	touch $@

libstb-hal-exp-clean:
	rm -f $(DEPDIR)/libstb-hal-exp
	cd $(appsdir)/libstb-hal-exp && \
		$(MAKE) distclean

libstb-hal-exp-distclean:
	rm -f $(DEPDIR)/libstb-hal-exp
	rm -f $(DEPDIR)/libstb-hal-exp.do_compile
	rm -f $(DEPDIR)/libstb-hal-exp.do_prepare

#
# libstb-hal-exp-next
#
$(DEPDIR)/libstb-hal-exp-next.do_prepare:
	rm -rf $(appsdir)/libstb-hal-exp-next
	rm -rf $(appsdir)/libstb-hal-exp-next.org
	[ -d "$(archivedir)/libstb-hal.git" ] && \
	(cd $(archivedir)/libstb-hal.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/libstb-hal.git" ] || \
	git clone git://gitorious.org/neutrino-hd/max10s-libstb-hal.git $(archivedir)/libstb-hal.git; \
	cp -ra $(archivedir)/libstb-hal.git $(appsdir)/libstb-hal-exp-next;\
	(cd $(appsdir)/libstb-hal-exp-next; git checkout experimental-next; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/libstb-hal-exp-next $(appsdir)/libstb-hal-exp-next.org
	touch $@

$(appsdir)/libstb-hal-exp-next/config.status: bootstrap
	cd $(appsdir)/libstb-hal-exp-next && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/libstb-hal-exp-next.do_compile: $(appsdir)/libstb-hal-exp-next/config.status
	cd $(appsdir)/libstb-hal-exp-next && \
		$(MAKE)
	touch $@

$(DEPDIR)/libstb-hal-exp-next: libstb-hal-exp-next.do_prepare libstb-hal-exp-next.do_compile
	$(MAKE) -C $(appsdir)/libstb-hal-exp-next install DESTDIR=$(targetprefix)
	touch $@

libstb-hal-exp-next-clean:
	rm -f $(DEPDIR)/libstb-hal-exp-next
	cd $(appsdir)/libstb-hal-exp-next && \
		$(MAKE) distclean

libstb-hal-exp-next-distclean:
	rm -f $(DEPDIR)/libstb-hal-exp-next
	rm -f $(DEPDIR)/libstb-hal-exp-next.do_compile
	rm -f $(DEPDIR)/libstb-hal-exp-next.do_prepare

#
# NEUTRINO MP
#
$(DEPDIR)/neutrino-mp.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec openssl ffmpeg_old libopenthreads libusb2 libalsa libstb-hal
	rm -rf $(appsdir)/neutrino-mp
	rm -rf $(appsdir)/neutrino-mp.org
	[ -d "$(archivedir)/neutrino-mp.git" ] && \
	(cd $(archivedir)/neutrino-mp.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-mp.git" ] || \
	git clone git://gitorious.org/neutrino-mp/max10s-neutrino-mp.git $(archivedir)/neutrino-mp.git; \
	cp -ra $(archivedir)/neutrino-mp.git $(appsdir)/neutrino-mp; \
	cp -ra $(appsdir)/neutrino-mp $(appsdir)/neutrino-mp.org
	touch $@

$(appsdir)/neutrino-mp/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-mp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-mp.do_compile: $(appsdir)/neutrino-mp/config.status
	cd $(appsdir)/neutrino-mp && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-mp: neutrino-mp.do_prepare neutrino-mp.do_compile
	$(MAKE) -C $(appsdir)/neutrino-mp install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-mp-clean:
	rm -f $(DEPDIR)/neutrino-mp
	cd $(appsdir)/neutrino-mp && \
		$(MAKE) distclean

neutrino-mp-distclean:
	rm -f $(DEPDIR)/neutrino-mp
	rm -f $(DEPDIR)/neutrino-mp.do_compile
	rm -f $(DEPDIR)/neutrino-mp.do_prepare

neutrino-mp-updateyaud: neutrino-mp-clean neutrino-mp
	mkdir -p $(prefix)/release_neutrino/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino/usr/local/bin/
	mkdir -p $(prefix)/release_neutrino/usr/local/sbin
	cp $(targetprefix)/usr/local/sbin/udpstreampes $(prefix)/release_neutrino/usr/local/sbin/

#
# NEUTRINO MP EXP
#
$(DEPDIR)/neutrino-mp-exp.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec openssl ffmpeg_old liblua libopenthreads libusb2 libalsa libstb-hal-exp
	rm -rf $(appsdir)/neutrino-mp-exp
	rm -rf $(appsdir)/neutrino-mp-exp.org
	[ -d "$(archivedir)/neutrino-mp.git" ] && \
	(cd $(archivedir)/neutrino-mp.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-mp.git" ] || \
	git clone git://gitorious.org/neutrino-mp/max10s-neutrino-mp.git $(archivedir)/neutrino-mp.git; \
	cp -ra $(archivedir)/neutrino-mp.git $(appsdir)/neutrino-mp-exp; \
	(cd $(appsdir)/neutrino-mp-exp; git checkout experimental; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/neutrino-mp-exp $(appsdir)/neutrino-mp-exp.org
	touch $@

$(appsdir)/neutrino-mp-exp/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-mp-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal-exp/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal-exp \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-mp-exp.do_compile: $(appsdir)/neutrino-mp-exp/config.status
	cd $(appsdir)/neutrino-mp-exp && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-mp-exp: neutrino-mp-exp.do_prepare neutrino-mp-exp.do_compile
	$(MAKE) -C $(appsdir)/neutrino-mp-exp install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-mp-exp-clean:
	rm -f $(DEPDIR)/neutrino-mp-exp
	cd $(appsdir)/neutrino-mp-exp && \
		$(MAKE) distclean

neutrino-mp-exp-distclean:
	rm -f $(DEPDIR)/neutrino-mp-exp
	rm -f $(DEPDIR)/neutrino-mp-exp.do_compile
	rm -f $(DEPDIR)/neutrino-mp-exp.do_prepare

neutrino-mp-exp-updateyaud: neutrino-mp-exp-clean neutrino-mp-exp
	mkdir -p $(prefix)/release_neutrino/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino/usr/local/bin/
	mkdir -p $(prefix)/release_neutrino/usr/local/sbin
	cp $(targetprefix)/usr/local/sbin/udpstreampes $(prefix)/release_neutrino/usr/local/sbin/

#
# neutrino-mp-exp-next
#
$(DEPDIR)/neutrino-mp-exp-next.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec openssl ffmpeg liblua libopenthreads libusb2 libalsa libstb-hal-exp-next
	rm -rf $(appsdir)/neutrino-mp-exp-next
	rm -rf $(appsdir)/neutrino-mp-exp-next.org
	[ -d "$(archivedir)/neutrino-mp.git" ] && \
	(cd $(archivedir)/neutrino-mp.git; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-mp.git" ] || \
	git clone git://gitorious.org/neutrino-mp/max10s-neutrino-mp.git $(archivedir)/neutrino-mp.git; \
	cp -ra $(archivedir)/neutrino-mp.git $(appsdir)/neutrino-mp-exp-next; \
	(cd $(appsdir)/neutrino-mp-exp-next; git checkout experimental-next; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/neutrino-mp-exp-next $(appsdir)/neutrino-mp-exp-next.org
	touch $@

$(appsdir)/neutrino-mp-exp-next/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-mp-exp-next && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal-exp-next/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal-exp-next \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-mp-exp-next.do_compile: $(appsdir)/neutrino-mp-exp-next/config.status
	cd $(appsdir)/neutrino-mp-exp-next && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-mp-exp-next: neutrino-mp-exp-next.do_prepare neutrino-mp-exp-next.do_compile
	$(MAKE) -C $(appsdir)/neutrino-mp-exp-next install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-mp-exp-next-clean:
	rm -f $(DEPDIR)/neutrino-mp-exp-next
	cd $(appsdir)/neutrino-mp-exp-next && \
		$(MAKE) distclean

neutrino-mp-exp-next-distclean:
	rm -f $(DEPDIR)/neutrino-mp-exp-next
	rm -f $(DEPDIR)/neutrino-mp-exp-next.do_compile
	rm -f $(DEPDIR)/neutrino-mp-exp-next.do_prepare

#
# neutrino-twin-next
#
$(DEPDIR)/neutrino-twin-next.do_prepare: | bootstrap $(EXTERNALLCD_DEP) libdvbsipp libfreetype libjpeg libpng libgif_current libid3tag libcurl libmad libvorbisidec openssl ffmpeg libopenthreads libalsa libstb-hal-exp-next
	rm -rf $(appsdir)/neutrino-twin-next
	rm -rf $(appsdir)/neutrino-twin-next.org
	rm -rf $(appsdir)/neutrino-twin-next.patched
	[ -d "$(archivedir)/cst-public-gui-neutrino.git" ] && \
	(cd $(archivedir)/cst-public-gui-neutrino.git; git pull ; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/cst-public-gui-neutrino.git" ] || \
	git clone git://c00lstreamtech.de/cst-public-gui-neutrino.git $(archivedir)/cst-public-gui-neutrino.git; \
	cp -ra $(archivedir)/cst-public-gui-neutrino.git $(appsdir)/neutrino-twin-next; \
	(cd $(appsdir)/neutrino-twin-next; git checkout --track -b next-cc origin/next-cc; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/neutrino-twin-next $(appsdir)/neutrino-twin-next.org
	cd $(appsdir)/neutrino-twin-next && patch -p1 < "$(buildprefix)/Patches/neutrino-twin-next.diff"
	touch $@

$(appsdir)/neutrino-twin-next/config.status:
	cd $(appsdir)/neutrino-twin-next && \
		$(BUILDENV) \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--enable-giflib \
			--enable-fb_blit \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-stb-hal-includes=$(appsdir)/libstb-hal-exp-next/include \
			--with-stb-hal-build=$(appsdir)/libstb-hal-exp-next \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS) -DFB_BLIT"

$(DEPDIR)/neutrino-twin-next.do_compile: $(appsdir)/neutrino-twin-next/config.status
	cd $(appsdir)/neutrino-twin-next && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-twin-next: neutrino-twin-next.do_prepare neutrino-twin-next.do_compile
	$(MAKE) -C $(appsdir)/neutrino-twin-next install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-twin-next-clean:
	rm -f $(DEPDIR)/neutrino-twin-next
	cd $(appsdir)/neutrino-twin-next && \
		$(MAKE) distclean

neutrino-twin-next-distclean:
	rm -f $(DEPDIR)/neutrino-twin-next
	rm -f $(DEPDIR)/neutrino-twin-next.do_compile
	rm -f $(DEPDIR)/neutrino-twin-next.do_prepare

#
# neutrino-hd2-exp branch
#
$(DEPDIR)/neutrino-hd2-exp.do_prepare: | bootstrap $(MEDIAFW_DEP) $(EXTERNALLCD_DEP) libfreetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec libboost libflac openssl ffmpeg libusb2 libalsa
	rm -rf $(appsdir)/nhd2-exp
	rm -rf $(appsdir)/nhd2-exp.org
	[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] && \
	(cd $(archivedir)/neutrino-hd2-exp.svn; svn up ; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-hd2-exp.svn" ] || \
	svn co http://neutrinohd2.googlecode.com/svn/branches/nhd2-exp $(archivedir)/neutrino-hd2-exp.svn; \
	cp -ra $(archivedir)/neutrino-hd2-exp.svn $(appsdir)/nhd2-exp; \
	cp -ra $(appsdir)/nhd2-exp $(appsdir)/nhd2-exp.org
	cd $(appsdir)/nhd2-exp && patch -p1 < "$(buildprefix)/Patches/neutrino-hd2-exp.diff"
	touch $@

$(appsdir)/nhd2-exp/config.status:
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/nhd2-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/plugins \
			--with-isocodesdir=/usr/share/iso-codes \
			--enable-standaloneplugins \
			--enable-radiotext \
			--enable-upnp \
			--enable-scart \
			--enable-ci \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-hd2-exp: neutrino-hd2-exp.do_prepare neutrino-hd2-exp.do_compile
	$(MAKE) -C $(appsdir)/nhd2-exp install DESTDIR=$(targetprefix) && \
	rm -f $(targetprefix)/var/etc/.version
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

$(DEPDIR)/neutrino-hd2-exp.do_compile: $(appsdir)/nhd2-exp/config.status
	cd $(appsdir)/nhd2-exp && \
		$(MAKE) all
	touch $@

neutrino-hd2-exp-clean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	cd $(appsdir)/nhd2-exp && \
		$(MAKE) clean

neutrino-hd2-exp-distclean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	rm -f $(DEPDIR)/neutrino-hd2-exp.do_compile
	rm -f $(DEPDIR)/neutrino-hd2-exp.do_prepare

#
#NORMAL
#
$(appsdir)/neutrino/config.status: bootstrap $(EXTERNALLCD_DEP) libfreetype libpng libid3tag openssl libcurl libmad libboost libgif ffmpeg_old
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--without-libsdl \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/local/share \
			--with-fontdir=/usr/local/share/fonts \
			--with-configdir=/usr/local/share/config \
			--with-gamesdir=/usr/local/share/games \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/neutrino.do_prepare:
	touch $@

$(DEPDIR)/neutrino.do_compile: $(appsdir)/neutrino/config.status
	cd $(appsdir)/neutrino && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino: neutrino.do_prepare neutrino.do_compile
	$(MAKE) -C $(appsdir)/neutrino install DESTDIR=$(targetprefix) DATADIR=$(targetprefix)/usr/local/share/
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

neutrino-clean neutrino-distclean:
	rm -f $(DEPDIR)/neutrino
	rm -f $(DEPDIR)/neutrino.do_compile
	rm -f $(DEPDIR)/neutrino.do_prepare
	cd $(appsdir)/neutrino && \
		$(MAKE) distclean
