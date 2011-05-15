# sh4-duckbox/enigma1-hd

$(appsdir)/enigma1-hd/config.status: bare-os freetype-old libid3tag libmad libpng libgif libsigc libfribidi libvorbisidec \
			curl alsa-lib alsa-lib-dev alsa-utils alsaplayer alsaplayer-dev \
			$(targetprefix)/usr/lib/pkgconfig/tuxbox.pc $(targetprefix)/usr/lib/pkgconfig/tuxbox-xmltree.pc $(targetprefix)/usr/include/tuxbox/plugin.h \
			$(targetprefix)/usr/lib/pkgconfig/tuxbox-tuxtxt.pc \
			$(targetprefix)/include/mtd/mtd-user.h
	cd $(appsdir)/enigma1-hd && \
		$(CONFIGURE) \
			--host=$(target) \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			CPPFLAGS="-I$(driverdir)/player2/linux/include" \
			LDFLAGS="-L$(targetprefix)/usr/lib/freetype-old"

$(DEPDIR)/enigma1-hd.do_prepare:
	touch $@

$(DEPDIR)/enigma1-hd.do_compile: $(appsdir)/enigma1-hd/config.status
	rm -rf $(targetprefix)/usr/share/zoneinfo
	$(MAKE) -C $(appsdir)/enigma1-hd all install DESTDIR=$$(targetprefix)
	touch $@

$(DEPDIR)/enigma1-hd: enigma1-hd.do_prepare enigma1-hd.do_compile
	$(MAKE) -C $(appsdir)/enigma1-hd install DESTDIR=$$(targetprefix)
	touch $@

#enigma1-hd: lirc enigma1-hd.do_compile
#	$(MAKE) -C $(appsdir)/enigma1-hd install DESTDIR=$(targetprefix)

enigma1-hd-clean enigma1-hd-distclean:
	rm -f $(DEPDIR)/enigma1-hd*
	cd $(appsdir)/enigma1-hd && \
		$(MAKE) distclean
