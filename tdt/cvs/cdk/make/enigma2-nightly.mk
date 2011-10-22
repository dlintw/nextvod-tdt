# tuxbox/enigma2

#if ENABLE_MEDIAFWGSTREAMER
#MEDIAFW = gstreamer
#else
#MEDIAFW = eplayer4
#endif

$(DEPDIR)/enigma2-nightly.do_prepare:
	REVISION=""; \
	DIFF="0"; \
	rm -rf $(appsdir)/enigma2-nightly; \
	rm -rf $(appsdir)/enigma2-nightly.org; \
	rm -rf $(appsdir)/enigma2-nightly.newest; \
	rm -rf $(appsdir)/enigma2-nightly.patched; \
	clear; \
	echo "Media Framwork: $(MEDIAFW)"; \
	echo "Choose between the following revisions:"; \
	echo " 0) Newest (Can fail due to outdated patch)"; \
	echo "---- REVISIONS ----"; \
	echo "1) Sat, 29 Mar 2011 13:49 - E2 V3.0 e013d09af0e010f15e225a12dcc217abc052ee19"; \
	echo "2) inactive"; \
	echo "3) inactive"; \
	echo "4) inactive"; \
	echo "5) Fri,  5 Nov 2010 00:16 - E2 V2.4 libplayer3 7fd4241a1d7b8d7c36385860b24882636517473b"; \
	echo "6) Wed,  6 Jul 2011 11:17 - E2 V3.1 gstreamer  388dcd814d4e99720cb9a6c769611be4951e4ad4"; \
	echo "7) current inactive... comming soon, here is the next stable (case 7 == DIFF=7)"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="0" && HEAD="experimental"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && HEAD="experimental" && REVISION="e013d09af0e010f15e225a12dcc217abc052ee19"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && HEAD="experimental" && REVISION=""; \
	[ "$$REPLY" == "3" ] && DIFF="3" && HEAD="experimental" && REVISION=""; \
	[ "$$REPLY" == "4" ] && DIFF="4" && HEAD="master" && REVISION="be8ccc9f63c4cd79f8dba84087c7348c23657865"; \
	[ "$$REPLY" == "5" ] && DIFF="5" && HEAD="master" && REVISION="7fd4241a1d7b8d7c36385860b24882636517473b"; \
	[ "$$REPLY" == "6" ] && DIFF="6" && HEAD="experimental" && REVISION="388dcd814d4e99720cb9a6c769611be4951e4ad4"; \
	echo "Revision: " $$REVISION; \
	[ -d "$(appsdir)/enigma2-nightly" ] && \
	git pull $(appsdir)/enigma2-nightly $$HEAD;\
	[ -d "$(appsdir)/enigma2-nightly" ] || \
	git clone -b $$HEAD git://git.opendreambox.org/git/enigma2.git $(appsdir)/enigma2-nightly; \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.newest; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.org; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.$$DIFF.diff"; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.$$DIFF.$(MEDIAFW).diff"; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-nightly.tuxtxt.diff"
	$(if $(IPBOX9900),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-ipbox.diff" )
	$(if $(IPBOX99),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-ipbox.diff" )
	$(if $(IPBOX55),cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-ipbox.diff" )
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.patched
	touch $@

$(appsdir)/enigma2-nightly/config.status: bootstrap freetype expat fontconfig libpng jpeg libgif libfribidi libid3tag libmad libsigc libreadline \
		libdvbsi++ python libxml2 libxslt elementtree zope-interface twisted pyopenssl lxml libxmlccwrap ncurses-dev $(MEDIAFW_DEP)
	cd $(appsdir)/enigma2-nightly && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(crossprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--host=$(target) \
			--without-libsdl \
			--with-datadir=/usr/local/share \
			--with-libdir=/usr/lib \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			--prefix=/usr \
			--datadir=/usr/local/share \
			--sysconfdir=/etc \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
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
			$(if $(HS7810A),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HS7810A -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(HL101),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HL101 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-hl101) \
			$(if $(VIP1_V2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP1_V2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip1_v2) \
			$(if $(VIP2_V1),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP2_V1 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip2_v1) \
			$(if $(OCTAGON1008),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_OCTAGON1008 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(UFS912),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS912 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(SPARK),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_SPARK -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")  \
			$(if $(SPARK7162),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_SPARK7162 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(ADB_BOX),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ADB_BOX -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-adb_box) \
			$(if $(IPBOX9900),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX9900 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(IPBOX99),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX99 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
			$(if $(IPBOX55),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX55 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")

$(DEPDIR)/enigma2-nightly.do_compile: $(appsdir)/enigma2-nightly/config.status
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2-nightly: enigma2-nightly.do_prepare enigma2-nightly.do_compile
	$(MAKE) -C $(appsdir)/enigma2-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
	fi
	touch $@

enigma2-nightly-clean enigma2-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-nightly
	rm -f $(DEPDIR)/enigma2-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-nightly.do_prepare
	rm -rf $(appsdir)/enigma2-nightly
	rm -rf $(appsdir)/enigma2-nightly.newest
	rm -rf $(appsdir)/enigma2-nightly.org
	rm -rf $(appsdir)/enigma2-nightly.patched

