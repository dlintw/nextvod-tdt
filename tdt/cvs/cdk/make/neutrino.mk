# tuxbox/neutrino 

#
#NIGHLY
#

$(appsdir)/neutrino-nightly/config.status: bootstrap freetype libpng libid3tag openssl curl libmad libboost
	cd $(appsdir)/neutrino-nightly && \
		./autogen.sh && \
		./configure \
			--host=$(target) \
			--without-libsdl \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig
			

$(DEPDIR)/neutrino-nightly.do_prepare: Patches/neutrino.patch
	svn co http://www.coolstreamtech.de/coolstream_public_svn/THIRDPARTY/applications/neutrino/ --username coolstream --password coolstream $(appsdir)/neutrino-nightly
	touch $(appsdir)/neutrino-nightly/README
	cd $(appsdir)/neutrino-nightly && patch -p1 <../../cdk/$(word 1,$^)
	touch $@

$(DEPDIR)/neutrino-nightly.do_compile: $(appsdir)/neutrino-nightly/config.status
	cd $(appsdir)/neutrino-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-nightly: neutrino-nightly.do_prepare neutrino-nightly.do_compile
	$(MAKE) -C $(appsdir)/neutrino-nightly install DESTDIR=$(targetprefix)
	touch $@

neutrino-nightly-clean neutrino-nightly-distclean:
	rm -f $(DEPDIR)/neutrino-nightly
	rm -f $(DEPDIR)/neutrino-nightly.do_compile
	rm -f $(DEPDIR)/neutrino-nightly.do_prepare
	rm -rf $(appsdir)/neutrino-nightly
	
	
#
#NORMAL
#

$(appsdir)/neutrino/config.status: bootstrap freetype libpng libid3tag openssl curl libmad libboost libgif
	cd $(appsdir)/neutrino && \
		./autogen.sh && \
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
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig
			

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
	
#libogg is needed
