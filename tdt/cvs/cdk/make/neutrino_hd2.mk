#
# Makefile to build NEUTRINO
#

N_CPPFLAGS =-DNEW_LIBCURL

N_CONFIG_OPTS = --enable-silent-rules

#
# NEUTRINO HD2
#
$(DEPDIR)/neutrino-hd2.do_prepare:
	svn co http://neutrinohd2.googlecode.com/svn/trunk/neutrino-hd $(appsdir)/neutrino-hd2
	cp -ra $(appsdir)/neutrino-hd2 $(appsdir)/neutrino-hd2.org
	cd $(appsdir)/neutrino-hd2 && patch -p1 < "$(buildprefix)/Patches/neutrino.hd2.diff"
#	cd $(appsdir)/neutrino-hd2 && patch -p1 < "$(buildprefix)/Patches/neutrino.hd2.infoviewer.diff"
	touch $@

$(appsdir)/neutrino-hd2/config.status: bootstrap $(EXTERNALLCD_DEP) freetype jpeg libpng libgif libid3tag curl libmad libvorbisidec libboost libflac openssl sdparm
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-hd2 && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--enable-libeplayer3 \
			--with-boxtype=duckbox \
			--enable-pcmsoftdecoder \
			--with-tremor \
			--enable-libass \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/var/plugins \
			--with-fontdir=/usr/local/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"


$(DEPDIR)/neutrino-hd2.do_compile: $(appsdir)/neutrino-hd2/config.status
	cd $(appsdir)/neutrino-hd2 && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-hd2: neutrino-hd2.do_prepare neutrino-hd2.do_compile
	$(MAKE) -C $(appsdir)/neutrino-hd2 install DESTDIR=$(targetprefix) && \
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

neutrino-hd2-clean:
	rm -f $(DEPDIR)/neutrino-hd2
	cd $(appsdir)/neutrino-hd2 && \
		$(MAKE) distclean

neutrino-hd2-distclean:
	rm -f $(DEPDIR)/neutrino-hd2
	rm -f $(DEPDIR)/neutrino-hd2.do_compile
	rm -f $(DEPDIR)/neutrino-hd2.do_prepare
	rm -rf $(appsdir)/neutrino-hd2.org
	rm -rf $(appsdir)/neutrino-hd2


### neutrino-hd2-exp
$(DEPDIR)/neutrino-hd2-exp.do_prepare:
	svn co http://neutrinohd2.googlecode.com/svn/branches/nhd2-exp $(appsdir)/neutrino-hd2-exp
	cp -ra $(appsdir)/neutrino-hd2-exp $(appsdir)/neutrino-hd2-exp.org
	cd $(appsdir)/neutrino-hd2-exp && patch -p1 < "$(buildprefix)/Patches/neutrino.hd2-exp.diff"
	touch $@

$(appsdir)/neutrino-hd2-exp/config.status: bootstrap $(EXTERNALLCD_DEP) freetype jpeg libpng libgif libid3tag curl libmad libvorbisidec libboost libflac openssl sdparm
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-hd2-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--enable-libeplayer3 \
			--with-boxtype=$(MODNAME) \
			--enable-pcmsoftdecoder \
			--with-tremor \
			--enable-libass \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/var/plugins \
			--with-fontdir=/usr/local/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"


$(DEPDIR)/neutrino-hd2-exp.do_compile: $(appsdir)/neutrino-hd2-exp/config.status
	cd $(appsdir)/neutrino-hd2-exp && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-hd2-exp: neutrino-hd2-exp.do_prepare neutrino-hd2-exp.do_compile
	$(MAKE) -C $(appsdir)/neutrino-hd2-exp install DESTDIR=$(targetprefix) && \
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

neutrino-hd2-exp-clean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	cd $(appsdir)/neutrino-hd2-exp && \
		$(MAKE) distclean

neutrino-hd2-exp-distclean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	rm -f $(DEPDIR)/neutrino-hd2-exp.do_compile
	rm -f $(DEPDIR)/neutrino-hd2-exp.do_prepare
	rm -rf $(appsdir)/neutrino-hd2-exp.org
	rm -rf $(appsdir)/neutrino-hd2-exp
