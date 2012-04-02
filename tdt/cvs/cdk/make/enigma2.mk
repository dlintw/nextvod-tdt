# tuxbox/enigma2 
$(appsdir)/enigma2/config.status: bootstrap freetype expat fontconfig libpng jpeg libgif libfribidi libid3tag libmad libsigc libreadline \
		libdvbsi++ python libxml2 libxslt elementtree zope_interface twisted pyopenssl lxml libxmlccwrap ncurses-dev libdreamdvd
	cd $(appsdir)/enigma2 && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--host=$(target) \
			--without-libsdl \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/enigma2.do_prepare:
if ENABLE_ADB_BOX
	cd $(appsdir)/enigma2 && patch -p1 < ../../cdk/Patches/e2_api5.patch
endif
if ENABLE_HL101
	cd $(appsdir)/enigma2 && patch -p1 < ../../cdk/Patches/e2_api5.patch
endif
if ENABLE_VIP2_V1
	cd $(appsdir)/enigma2 && patch -p1 < ../../cdk/Patches/e2_api5.patch
endif
if ENABLE_VIP1_V2
	cd $(appsdir)/enigma2 && patch -p1 < ../../cdk/Patches/e2_api5.patch
endif
	touch $@

$(DEPDIR)/enigma2.do_compile: $(appsdir)/enigma2/config.status
	cd $(appsdir)/enigma2 && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2: enigma2.do_prepare enigma2.do_compile
	$(MAKE) -C $(appsdir)/enigma2 install DESTDIR=$(targetprefix)
	$(target)-strip $(targetprefix)/usr/local/bin/enigma2
	touch $@

$(DEPDIR)/enigma2-misc:
#	workarounds to allow rebuild
	find $(targetprefix)/usr/local/share/enigma2/ -name .svn |xargs rm -fr
	rm -f $(targetprefix)/usr/local/etc

	$(INSTALL_DIR) $(targetprefix)/usr/bin && \
	$(INSTALL_DIR) $(targetprefix)/usr/share && \
	$(LN_SF) /usr/local/share/enigma2 $(targetprefix)/usr/share/enigma2 && \
	$(INSTALL_DIR) $(targetprefix)/usr/share/etc && \
	$(LN_SF) /usr/local/share/enigma2 $(targetprefix)/usr/share/etc/enigma2 && \
	cp -rd root/usr/local/share/enigma2/* $(targetprefix)/usr/local/share/enigma2/ && \
	$(INSTALL_DIR) $(targetprefix)/usr/share/fonts && \
	cp -rd root/usr/share/fonts/* $(targetprefix)/usr/share/fonts/ && \
	$(INSTALL_DIR) $(targetprefix)/etc && \
	$(INSTALL_DIR) $(targetprefix)/etc/enigma2 && \
	$(LN_SF) /etc $(targetprefix)/usr/local/etc && \
	cp -rd root/etc/enigma2/* $(targetprefix)/etc/enigma2/ && \
	$(INSTALL_FILE) root/etc/videomode $(targetprefix)/etc/ && \
	$(INSTALL_FILE) root/etc/lircd.conf $(targetprefix)/etc/ && \
	$(INSTALL_FILE) root/etc/inetd.conf $(targetprefix)/etc/ && \
	$(INSTALL_FILE) root/etc/image-version $(targetprefix)/etc/ && \
	$(INSTALL_DIR) $(targetprefix)/etc/tuxbox && \
	$(INSTALL_FILE) root/etc/tuxbox/satellites.xml $(targetprefix)/etc/tuxbox/ && \
	$(INSTALL_FILE) root/etc/tuxbox/tuxtxt2.conf $(targetprefix)/etc/tuxbox/ && \
	$(INSTALL_FILE) root/etc/tuxbox/cables.xml $(targetprefix)/etc/tuxbox/ && \
	$(INSTALL_FILE) root/etc/tuxbox/terrestrial.xml $(targetprefix)/etc/tuxbox/ && \
	$(INSTALL_FILE) root/etc/tuxbox/timezone.xml $(targetprefix)/etc/ && \
	$(INSTALL_DIR) $(targetprefix)/boot && \
	$(INSTALL_FILE) root/bootscreen/bootlogo.mvi $(targetprefix)/boot/ && \
	$(INSTALL_DIR) $(targetprefix)/media/{hdd,dvd} && \
	$(INSTALL_DIR) $(targetprefix)/hdd/{music,picture,movie} && \
	$(INSTALL_DIR) $(targetprefix)/usr/tuxtxt && \
	$(INSTALL_FILE) root/usr/tuxtxt/tuxtxt2.conf $(targetprefix)/usr/tuxtxt/
if ENABLE_TF7700
	cd $(targetprefix)/usr/local/share/enigma2/ && mv -f keymap_tf7700.xml keymap.xml
else
	rm -f $(targetprefix)/usr/local/share/enigma2/keymap_tf7700.xml
endif
	touch $@

enigma2-clean enigma2-distclean:
	rm -f $(DEPDIR)/enigma2
	rm -f $(DEPDIR)/enigma2.do_prepare
	rm -f $(DEPDIR)/enigma2.do_compile
	cd $(appsdir)/enigma2 && \
		$(MAKE) distclean
