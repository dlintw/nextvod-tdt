# vdr
VERSION_vdr	:= 0.0.2
DIR_vdr	:= ../apps/vdr

$(DEPDIR)/vdr.do_compile: bootstrap libstdc++-dev ncurses-dev jpeg libz libpng freetype stgfb-devnew expat fontconfig alsa-lib alsa-lib-dev alsa-utils \
		alsaplayer alsaplayer-dev
	cd $(DIR_vdr)/vdr-1.7.0b && \
		$(MAKE_OPTS) $(MAKE) vdr plugins prefix=$(targetprefix)

	touch $@

$(DEPDIR)/vdr: vdr.do_compile
	$(MAKE) -C $(DIR_vdr)/vdr-1.7.0b all install prefix=$(targetprefix)
	cp $(appsdir)/vdr/vdr-1.7.0b/PLUGINS/src/remote/misc/remote.conf $(targetprefix)/var/vdr
	cp $(appsdir)/vdr/vdr-1.7.0b/sources.conf $(targetprefix)/var/vdr
	cp $(appsdir)/vdr/vdr-1.7.0b/channels.conf $(targetprefix)/var/vdr
	cp -rd $(appsdir)/vdr/fonts $(targetprefix)/usr/share

vdr-clean:
	-rm .deps/vdr
	-rm .deps/vdr.do_compile

vdr-distclean:
	$(MAKE) -C $(DIR_vdr)/vdr-1.7.0b clean clean-plugins
	-rm .deps/vdr*
