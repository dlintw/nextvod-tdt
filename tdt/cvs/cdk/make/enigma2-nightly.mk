# tuxbox/enigma2 
$(appsdir)/enigma2-nightly/config.status: bootstrap freetype expat fontconfig libpng jpeg libgif libfribidi libid3tag libmad libsigc libreadline \
		libdvbsi++ python libxml2 libxslt elementtree zope-interface twisted pyopenssl lxml libxmlccwrap ncurses-dev alsa-lib alsa-lib-dev alsa-utils \
		alsaplayer alsaplayer-dev
	cd $(appsdir)/enigma2-nightly && \
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
			$(if $(HL101),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HL101 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-hl101) \
			$(if $(VIP2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip2) \
			$(if $(OCTAGON1008),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_OCTAGON1008 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")

$(DEPDIR)/enigma2-nightly.do_prepare:

	REVISION=""; \
	DIFF="0"; \
	rm -rf $(appsdir)/enigma2-nightly; \
	clear; \
	echo "Choose between the following revisions:"; \
	echo " 0) Newest (Can fail due to outdated patch)"; \
	echo "---- REVISIONS ----"; \
	echo "1) Mon, 21 Dec 2009 15:04 - bcd44b8a861159b638eadfd06954d1fcd7119d90"; \
	echo "2) Wed, 31 Mar 2010 21:53 - 5807686a79350632f38e4161c942ae59cf2f63ce"; \
	echo "3) current inactive... comming soon, here is the next stable (case 3 == DIFF=3), (case 4 == DIFF=4) this is better"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="0"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && REVISION="bcd44b8a861159b638eadfd06954d1fcd7119d90"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && REVISION="5807686a79350632f38e4161c942ae59cf2f63ce"; \
	echo "Revision: " $$REVISION; \
	[ -d "$(appsdir)/enigma2-nightly" ] && \
	git pull $(appsdir)/enigma2-nightly master;\
	[ -d "$(appsdir)/enigma2-nightly" ] || \
	git clone git://git.opendreambox.org/git/enigma2.git $(appsdir)/enigma2-nightly; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)"); \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.$$DIFF.diff"
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.tuxtxt.diff"
	$(if $(CUBEREVO),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-cuberevo.diff" )
	$(if $(CUBEREVO_MINI),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-cuberevo.diff" )
	$(if $(CUBEREVO_MINI2),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-cuberevo.diff" )
	$(if $(CUBEREVO_250HD),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-cuberevo.diff" )
	$(if $(CUBEREVO_2000HD),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-cuberevo.diff" )
	$(if $(CUBEREVO_9500HD),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-cuberevo.diff" )
	touch $@

$(DEPDIR)/enigma2-nightly.do_compile: $(appsdir)/enigma2-nightly/config.status
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2-nightly: enigma2-nightly.do_prepare enigma2-nightly.do_compile
	$(MAKE) -C $(appsdir)/enigma2-nightly install DESTDIR=$(targetprefix)
	$(target)-strip $(targetprefix)/usr/local/bin/enigma2
	touch $@

enigma2-nightly-clean enigma2-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-nightly
	rm -f $(DEPDIR)/enigma2-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-nightly.do_prepare
	rm -rf $(appsdir)/enigma2-nightly

