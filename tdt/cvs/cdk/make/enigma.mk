# tuxbox/enigma 

#$(appsdir)/tuxbox/enigma/config.status: bootstrap freetype libfribidi libmad libid3tag libpng libsigc jpeg libungif $(targetprefix)/lib/pkgconfig/tuxbox.pc $(targetprefix)/lib/pkgconfig/tuxbox-xmltree.pc $(targetprefix)/include/tuxbox/plugin.h
$(appsdir)/tuxbox/enigma/config.status: bare-os freetype lirc libfribidi libmad libid3tag \
		libpng libsigc jpeg libungif \
		$(targetprefix)/lib/pkgconfig/tuxbox.pc $(targetprefix)/lib/pkgconfig/tuxbox-xmltree.pc $(targetprefix)/include/tuxbox/plugin.h \
		$(targetprefix)/include/mtd/mtd-user.h
	cd $(appsdir)/tuxbox/enigma && $(CONFIGURE)
#	cp -pa $(appsdir)/tuxbox/enigma/po/locale.alias.image $@/share/locale/locale.alias
#	mkdir $@/lib
#	tar -C $@/lib -xjvf $(appsdir)/tuxbox/enigma/po/locale.image.tar.bz2
#	cp -rd $(targetprefix)/share/zoneinfo $@/share
#	cp -rd $(targetprefix)/share/locale/de/LC_MESSAGES/libc.mo $@/share/locale/de/LC_MESSAGES
#	cp -rd $(targetprefix)/share/locale/fr/LC_MESSAGES/libc.mo $@/share/locale/fr/LC_MESSAGES
#	rm -rf $@/share/locale/[a-c]* $@/share/locale/da $@/share/locale/e* $@/share/locale/fi $@/share/locale/[g-t]* $@/share/locale/[m-z]*
#	cp $(appsdir)/tuxbox/enigma/po/locale.alias.image $@/share/locale/locale.alias
	$(MAKE) -C $(appsdir)/tuxbox/plugins/tuxtxt all install
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/dbswitch all install
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/demo all install
	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/dreamdata all install
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/dreamflash all install
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/dslconnect all install
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/dsldisconnect all instal
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/getset all install
	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/movieplayer all install
	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/ngrabstart all install
	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/ngrabstop all install
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/rss all install
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/script all install
#	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma/weather all install

#enigma: $(appsdir)/tuxbox/enigma/config.status | tuxbox_tools
enigma.do_compile: $(appsdir)/tuxbox/enigma/config.status
	$(MAKE) -C $(appsdir)/tuxbox/enigma all

enigma: lirc fbset lm_sensors enigma.do_compile
	$(MAKE) -C $(appsdir)/tuxbox/enigma install

#Workaround:
$(targetprefix)/include/mtd/mtd-user.h: $(hostappsdir)/mkfs.jffs2/include/mtd/mtd-user.h
	$(INSTALL) -d $(@D)
	cp -rd $(hostappsdir)/mkfs.jffs2/include/mtd/* $(@D)
