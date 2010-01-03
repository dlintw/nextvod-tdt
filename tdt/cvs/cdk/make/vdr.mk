# vdr
VERSION_vdr	:= 0.0.2
DIR_vdr	:= ../apps/vdr

$(DEPDIR)/vdr.do_compile: bootstrap libstdc++-dev ncurses-dev jpeg libz libpng freetype stgfb-devnew expat fontconfig alsa-lib alsa-lib-dev alsa-utils libboost \
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
	mkdir -p $(prefix)/release_vdr/usr/include/boost/
	mkdir -p $(prefix)/release_vdr/usr/lib/vdr/
	mkdir -p $(prefix)/release_vdr/usr/local/bin/
	mkdir -p $(prefix)/release_vdr/usr/share/locale/
	mkdir -p $(prefix)/release_vdr/var/vdr
	cp -rd $(targetprefix)/usr/include/boost/shared_container_iterator.hpp $(prefix)/release_vdr/usr/include/boost/
	cp -rd $(targetprefix)/usr/lib/libfontconfi* $(prefix)/release_vdr/usr/lib/
	cp -rd $(targetprefix)/usr/lib/vdr/lib* $(prefix)/release_vdr/usr/lib/vdr/
#	cp -rd $(targetprefix)/usr/lib/vdr/libvdr-vfd.so.1.7.0 $(prefix)/release_vdr/usr/lib/vdr/
	cp -rd $(targetprefix)/usr/local/bin/vdr $(prefix)/release_vdr/usr/local/bin/
	cp -rd $(targetprefix)/usr/local/bin/runvdr $(prefix)/release_vdr/usr/local/bin/
	cp -rd $(targetprefix)/usr/share/locale/* $(prefix)/release_vdr/usr/share/locale
	cp -rd $(targetprefix)/var/vdr/remote.conf $(prefix)/release_vdr/var/vdr/
	cp -rd $(targetprefix)/var/vdr/sources.conf $(prefix)/release_vdr/var/vdr/
	cp -rd $(targetprefix)/var/vdr/channels.conf $(prefix)/release_vdr/var/vdr/
##########################################################################################
	mkdir -p $(prefix)/release_vdr/etc/init.d
	cp $(buildprefix)/root/release/rcS_vdr_ufs910 $(prefix)/release_vdr/etc/init.d/rcS
	chmod 755 $(prefix)/release_vdr/etc/init.d/rcS

vdr-clean:
	-rm .deps/vdr
	-rm .deps/vdr.do_compile

vdr-distclean:
	$(MAKE) -C $(DIR_vdr)/vdr-1.7.0b clean clean-plugins
	-rm .deps/vdr*
