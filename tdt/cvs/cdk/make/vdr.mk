# vdr
VERSION_vdr	:= 0.0.2
DIR_vdr	:= ../apps/vdr
#VDR = 1.7.16
VDR = 1.7.14

$(DEPDIR)/vdr.do_compile: bootstrap libstdc++-dev ncurses-dev jpeg libz libpng freetype stgfb-devnew expat fontconfig alsa-lib alsa-lib-dev alsa-utils libboost \
		alsaplayer alsaplayer-dev
if ENABLE_VDR1711
	cd $(DIR_vdr)/vdr-1.7.11 && \
		$(MAKE_OPTS) $(MAKE) vdr plugins prefix=$(targetprefix)
	touch $@
else
	if [ ! -e $(buildprefix)/Archive/vdr-$(VDR)_mod.bz2 ]; then \
		cd $(buildprefix)/Archive/; \
		wget http://kathif.vs120005.hl-users.com/test/vdr-$(VDR)_mod.bz2 ; \
	fi; 
	cd $(DIR_vdr) && \
	tar jxf $(buildprefix)/Archive/vdr-$(VDR)_mod.bz2
	cd $(DIR_vdr)/vdr-$(VDR) && \
		$(MAKE_OPTS) $(MAKE) vdr plugins prefix=$(targetprefix)
	touch $@
endif

$(DEPDIR)/vdr: vdr.do_compile
if ENABLE_VDR1711
	$(MAKE) -C $(DIR_vdr)/vdr-1.7.11 all install prefix=$(targetprefix)
	cp $(appsdir)/vdr/vdr-1.7.11/PLUGINS/src/remote/misc/remote.conf $(targetprefix)/var/vdr
	cp $(appsdir)/vdr/vdr-1.7.11/sources.conf $(targetprefix)/var/vdr
	cp $(appsdir)/vdr/vdr-1.7.11/channels.conf $(targetprefix)/var/vdr
	cp $(appsdir)/vdr/vdr-1.7.11/keymacros.conf $(targetprefix)/var/vdr
else
	$(MAKE) -C $(DIR_vdr)/vdr-$(VDR) all install install-plugins prefix=$(targetprefix) DESTDIR=$(targetprefix)
	cp $(appsdir)/vdr/vdr-$(VDR)/PLUGINS/src/remote/misc/remote.conf $(targetprefix)/var/vdr
	mkdir -p $(targetprefix)/usr/lib/vdr
	mkdir -p $(targetprefix)/usr/local/bin
	cp $(appsdir)/vdr/vdr-$(VDR)/PLUGINS/lib/libvdr*$(VDR) $(targetprefix)/usr/lib/vdr
#	cp $(appsdir)/vdr/vdr-$(VDR)/sources.conf $(targetprefix)/var/vdr
#	cp $(appsdir)/vdr/vdr-$(VDR)/channels.conf $(targetprefix)/var/vdr
#	cp $(appsdir)/vdr/vdr-$(VDR)/keymacros.conf $(targetprefix)/var/vdr
endif
	cp -rd $(appsdir)/vdr/fonts $(targetprefix)/usr/share
	cp -rd $(appsdir)/vdr/vdr-$(VDR)/vdr $(targetprefix)/usr/local/bin
	mkdir -p $(prefix)/release_vdr/usr/include/boost/
	mkdir -p $(prefix)/release_vdr/usr/lib/vdr/
	mkdir -p $(prefix)/release_vdr/usr/local/bin/
	mkdir -p $(prefix)/release_vdr/usr/share/locale/
	mkdir -p $(prefix)/release_vdr/var/vdr
	mkdir -p $(prefix)/release_vdr/bin
	cp -rd $(targetprefix)/bin/fp_control $(prefix)/release_vdr/bin/
	cp -rd $(targetprefix)/usr/include/boost/shared_container_iterator.hpp $(prefix)/release_vdr/usr/include/boost/
	cp -rd $(targetprefix)/usr/lib/libfontconfi* $(prefix)/release_vdr/usr/lib/
	cp -rd $(targetprefix)/usr/lib/vdr/lib* $(prefix)/release_vdr/usr/lib/vdr/
#	cp -rd $(targetprefix)/usr/lib/vdr/libvdr-vfd.so.$(VDR) $(prefix)/release_vdr/usr/lib/vdr/
	cp -rd $(targetprefix)/usr/local/bin/vdr $(prefix)/release_vdr/usr/local/bin/
	cp -rd $(targetprefix)/usr/share/locale/* $(prefix)/release_vdr/usr/share/locale
#	cp -rd $(targetprefix)/var/vdr/remote.conf $(prefix)/release_vdr/var/vdr/
#	cp -rd $(targetprefix)/var/vdr/sources.conf $(prefix)/release_vdr/var/vdr/
#	cp -rd $(targetprefix)/var/vdr/channels.conf $(prefix)/release_vdr/var/vdr/
#	cp -rd $(targetprefix)/var/vdr/keymacros.conf $(prefix)/release_vdr/var/vdr/
##########################################################################################
	mkdir -p $(prefix)/release_vdr/media/video
	mkdir -p $(prefix)/release_vdr/etc/init.d
	cp $(buildprefix)/root/release/rcS_vdr_ufs910 $(prefix)/release_vdr/etc/init.d/rcS
	cp $(buildprefix)/root/usr/local/bin/runvdr $(prefix)/release_vdr/usr/local/bin
	cp -d $(buildprefix)/root/usr/local/bin/runVDR $(prefix)/release_vdr/usr/local/bin
	cp $(buildprefix)/root/usr/bin/runVDR $(prefix)/release_vdr/usr/bin
	cp $(buildprefix)/root/usr/local/bin/vdrshutdown $(prefix)/release_vdr/usr/local/bin
	cp -rd $(buildprefix)/root/var/vdr $(prefix)/release_vdr/var
#	cp $(buildprefix)/root/release/rcS_vdr_ufs910 $(prefix)/release_vdr/etc/init.d/rcS
	cp $(buildprefix)/root/release/rcS_vdr_$(VDR)_ufs910 $(prefix)/release_vdr/etc/init.d/rcS
	chmod 755 $(prefix)/release_vdr/etc/init.d/rcS

vdr-clean:
	-rm .deps/vdr
	-rm .deps/vdr.do_compile

vdr-distclean:
if ENABLE_VDR1711
	$(MAKE) -C $(DIR_vdr)/vdr-1.7.11 clean clean-plugins
else
	$(MAKE) -C $(DIR_vdr)/vdr-$(VDR) clean clean-plugins
endif
	-rm .deps/vdr*
