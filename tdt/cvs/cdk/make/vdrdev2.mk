# vdr
VERSION_VDR := 1.7.22-1


$(DEPDIR)/vdrdev2.do_compile: bootstrap freetype libxml2 jpeg libz libpng fontconfig libcap

	cd $(appsdir)/vdr/vdr-1.7.22 && \
		$(BUILDENV) $(MAKE) all plugins install-bin install-conf install-plugins install-i18n \
		DESTDIR=$(targetprefix) \
		VIDEODIR=/hdd/movie \
		CONFDIR=/usr/local/share/vdr \
		PLUGINLIBDIR=/usr/lib/vdr
	touch $@

$(DEPDIR)/vdrdev2: vdrdev2.do_compile
	touch $@

vdrdev2-clean:
	-rm .deps/vdrdev2
	-rm .deps/vdrdev2.do_compile

vdrdev2-distclean:
	$(MAKE) -C $(appsdir)/vdr/vdr-1.7.22 clean clean-plugins
	-rm .deps/vdrdev2*
