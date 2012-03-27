#
# Makefile to build NEUTRINO
#

$(targetprefix)/var/etc/.version:
	echo "imagename=Neutrino-HD" > $@
	echo "homepage=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "creator=`id -un`" >> $@
	echo "docs=http://gitorious.org/open-duckbox-project-sh4/pages/Home" >> $@
	echo "forum=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "version=0100`date +%Y%m%d%H%M`" >> $@
	echo "git =`git describe`" >> $@

N_CPPFLAGS +=-DNEW_LIBCURL

N_CONFIG_OPTS = --enable-silent-rules

#
# NEUTRINO BETA
#
$(DEPDIR)/neutrino-beta.do_prepare:
	svn co http://109.75.98.228/coolstream_public_svn/THIRDPARTY/applications/neutrino-beta/ --username coolstream --password coolstream $(appsdir)/neutrino-beta
	rm -rf $(appsdir)/neutrino-beta/lib/libcoolstream/*.*
	cp -ra $(appsdir)/neutrino-beta $(appsdir)/neutrino-beta.org
	cd $(appsdir)/neutrino-beta && patch -p1 < "$(buildprefix)/Patches/neutrino.beta.diff"
	cd $(appsdir)/neutrino-beta && patch -p1 < "$(buildprefix)/Patches/neutrino.libcool.beta.diff"
	touch $@

$(appsdir)/neutrino-beta/config.status: bootstrap $(EXTERNALLCD_DEP) freetype jpeg libpng libgif libid3tag curl libmad libvorbisidec libboost openssl libopenthreads
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-beta && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/share/tuxbox \
			--with-fontdir=/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"


$(DEPDIR)/neutrino-beta.do_compile: $(appsdir)/neutrino-beta/config.status
	cd $(appsdir)/neutrino-beta && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-beta: neutrino-beta.do_prepare neutrino-beta.do_compile
	$(MAKE) -C $(appsdir)/neutrino-beta install DESTDIR=$(targetprefix) && \
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

neutrino-beta-clean:
	rm -f $(DEPDIR)/neutrino-beta
	cd $(appsdir)/neutrino-beta && \
		$(MAKE) distclean

neutrino-beta-distclean:
	rm -f $(DEPDIR)/neutrino-beta
	rm -f $(DEPDIR)/neutrino-beta.do_compile
	rm -f $(DEPDIR)/neutrino-beta.do_prepare
	rm -rf $(appsdir)/neutrino-nightly.org
	rm -rf $(appsdir)/neutrino-nightly

#
#NORMAL
#
$(appsdir)/neutrino/config.status: bootstrap freetype libpng libid3tag openssl curl libmad libboost libgif
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--without-libsdl \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			--with-fontdir=/usr/local/share/fonts \
			--with-configdir=/usr/local/share/config \
			--with-gamesdir=/usr/local/share/games \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/neutrino.do_prepare: Patches/neutrino.patch
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
