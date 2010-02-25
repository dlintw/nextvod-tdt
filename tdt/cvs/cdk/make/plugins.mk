# tuxbox/plugins

$(appsdir)/tuxbox/plugins/config.status: bootstrap freetype-old curl libz libsigc $(targetprefix)/usr/lib/pkgconfig/tuxbox.pc $(targetprefix)/usr/lib/pkgconfig/tuxbox-xmltree.pc $(targetprefix)/usr/lib/pkgconfig/tuxbox-tuxtxt.pc
	cd $(appsdir)/tuxbox/plugins && $(CONFIGURE) \
		LDFLAGS="-L$(targetprefix)/usr/lib/freetype-old"

$(targetprefix)/usr/include/tuxbox/plugin.h \
$(targetprefix)/usr/lib/pkgconfig/tuxbox-plugins.pc: $(appsdir)/tuxbox/plugins/config.status
	$(MAKE) -C $(appsdir)/tuxbox/plugins/include all install
	cp $(appsdir)/tuxbox/plugins/tuxbox-plugins.pc $(targetprefix)/usr/lib/pkgconfig/tuxbox-plugins.pc

enigma-plugins: $(appsdir)/tuxbox/plugins/config.status $(targetprefix)/usr/include/tuxbox/plugin.h
	$(MAKE) -C $(appsdir)/tuxbox/plugins/enigma all install

tuxtxt: $(appsdir)/tuxbox/plugins/config.status $(targetprefix)/usr/include/tuxbox/plugin.h
	$(MAKE) -C $(appsdir)/tuxbox/plugins/tuxtxt all install

plugins-distclean plugins-clean:
	rm $(targetprefix)/usr/lib/pkgconfig/tuxbox-plugins.pc
	rm $(targetprefix)/usr/include/tuxbox/plugin.h
	$(MAKE) -C $(appsdir)/tuxbox/plugins distclean


# tuxbox/libs

# This file serves as a marker for tuxbox_libs
$(targetprefix)/usr/lib/pkgconfig/tuxbox-tuxtxt.pc:
	$(MAKE) tuxbox-libs

$(appsdir)/tuxbox/libs/config.status: bootstrap freetype-old libpng
	cd $(appsdir)/tuxbox/libs && $(CONFIGURE) \
		LDFLAGS="-L$(targetprefix)/usr/lib/freetype-old"

tuxbox-libs: $(appsdir)/tuxbox/libs/config.status
	$(MAKE) -C $(appsdir)/tuxbox/libs all install

tuxbox-libs-distclean tuxbox-libs-clean:
	rm $(targetprefix)/usr/lib/pkgconfig/tuxbox-tuxtxt.pc
	$(MAKE) -C $(appsdir)/tuxbox/libs distclean

.PHONY: tuxbox_libs

