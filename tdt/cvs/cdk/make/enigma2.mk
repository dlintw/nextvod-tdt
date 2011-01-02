# tuxbox/enigma2 
$(appsdir)/enigma2/config.status: bootstrap freetype expat fontconfig libpng jpeg libgif libfribidi libid3tag libmad libsigc libreadline \
		libdvbsi++ python libxml2 libxslt elementtree zope-interface twisted pyopenssl lxml libxmlccwrap ncurses-dev
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
			$(if $(CUBEREVO),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_MINI),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_MINI2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_MINI_FTA),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI_FTA -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_250HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_250HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_2000HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_2000HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(CUBEREVO_9500HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_9500HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
			$(if $(UFS910),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS910 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS922),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS922 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(TF7700),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_TF7700 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-tf7700) \
			$(if $(FLASH_UFS910),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_FLASH_UFS910 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(FORTIS_HDBOX),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_FORTIS_HDBOX -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(ATEVIO7500),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ATEVIO7500 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(HL101),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HL101 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-hl101) \
			$(if $(VIP1_V2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP1_V2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip1_v2) \
			$(if $(VIP2_V1),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP2_V1 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip2_v1) \
			$(if $(HOMECAST5101),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HS5101 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(OCTAGON1008),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_OCTAGON1008 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")

$(DEPDIR)/enigma2.do_prepare:
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
	$(INSTALL_FILE) root/etc/tuxbox/timezone.xml $(targetprefix)/etc/tuxbox/ && \
	$(INSTALL_DIR) $(targetprefix)/boot && \
	$(INSTALL_FILE) root/bootscreen/bootlogo.mvi $(targetprefix)/boot/ && \
	$(INSTALL_DIR) $(targetprefix)/media/{hdd,dvd} && \
	$(INSTALL_DIR) $(targetprefix)/hdd/{music,picture,movie} && \
	$(INSTALL_DIR) $(targetprefix)/usr/tuxtxt && \
	chmod 755 $(targetprefix)/usr/bin/tuxtxt && \
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

flash-enigma2: $(flashprefix)/root-enigma2

$(flashprefix)/root-enigma2: \
		bootstrap $(wildcard root-enigma2-local.sh) \
		$(ENIGMA2_GUI_ADAPTED_ETC_FILES:%=root/etc/%) \
		enigma2.do_compile
	$(MAKE) flash-python-enigma2 && \
	$(MAKE) flash-libxml2-enigma2 && \
	$(MAKE) flash-libxslt-enigma2 && \
	$(MAKE) flash-elementtree-enigma2 && \
	$(MAKE) flash-zope-interface-enigma2 && \
	$(MAKE) flash-twisted-enigma2 && \
	$(MAKE) flash-libxmlccwrap-enigma2 && \
	$(MAKE) -C $(appsdir)/enigma2 install DESTDIR=$@ && \
	$(MAKE) enigma2-misc targetprefix=$@ && \
	$(INSTALL_DIR) $@/etc/init.d && \
	$(INSTALL_BIN) root/etc/init.d/{player,enigma2} $@/etc/init.d && \
	$(INSTALL_DIR) $@/etc/rc.d/rc{S,0,1,2,3,4,5,6}.d && \
	$(LN_SF) ../init.d $@/etc/rc.d/init.d && \
	( export HHL_CROSS_TARGET_DIR=$@ && cd $@/etc/init.d && \
		for s in player enigma2 ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true ) && \
	$(INSTALL_BIN) root/etc/init.d/rcS_flash $@/etc/init.d/rcS && \
	$(INSTALL_BIN) root/etc/init.d/rc $@/etc/init.d/ && \
	touch $@
	@TUXBOX_CUSTOMIZE@

#
# dvb/libdvbsi++
#
$(appsdir)/dvb/libdvbsi++/config.status: bootstrap
	cd $(appsdir)/dvb/libdvbsi++ && $(CONFIGURE) CPPFLAGS="$(CPPFLAGS) -I$(driverdir)/dvb/include"

$(DEPDIR)/libdvbsi++: $(appsdir)/dvb/libdvbsi++/config.status
	$(MAKE) -C $(appsdir)/dvb/libdvbsi++ all install
	touch $@

