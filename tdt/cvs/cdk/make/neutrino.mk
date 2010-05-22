# tuxbox/neutrino 

#
#NIGHLY
#

$(appsdir)/neutrino-nightly/config.status: bootstrap freetype libpng libid3tag openssl curl libmad libboost
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-nightly && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--without-libsdl \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(if $(CUBEREVO),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_MINI),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_MINI -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_MINI2),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_MINI2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_MINI_FTA),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_MINI_FTA -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_250HD),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_250HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_2000HD),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_2000HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_9500HD),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_9500HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS910),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_UFS910 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS912),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_UFS912 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS922),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_UFS922 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(TF7700),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_TF7700 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(FORTIS_HDBOX),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_FORTIS_HDBOX -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(OCTAGON1008),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_OCTAGON1008 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(HL101),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_HL101 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(VIP2),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_VIP2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")

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
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
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
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(if $(CUBEREVO),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_MINI),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_MINI -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_MINI2),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_MINI2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_MINI_FTA),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_MINI_FTA -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_250HD),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_250HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_2000HD),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_2000HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(CUBEREVO_9500HD),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_CUBEREVO_9500HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS910),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_UFS910 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS912),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_UFS912 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS922),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_UFS922 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(TF7700),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_TF7700 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(FORTIS_HDBOX),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_FORTIS_HDBOX -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(HL101),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_HL101 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(VIP2),CPPFLAGS="$(CPPFLAGS) -D__KERNEL_STRICT_NAMES -DPLATFORM_VIP2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")
			

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
