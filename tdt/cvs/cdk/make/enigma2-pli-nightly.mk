# tuxbox/enigma2

$(DEPDIR)/enigma2-pli-nightly.do_prepare:
	REVISION=""; \
	HEAD="master"; \
	DIFF="0"; \
	REPO="git://gitorious.org/open-duckbox-project-sh4/guigit.git"; \
	rm -rf $(appsdir)/enigma2-nightly; \
	rm -rf $(appsdir)/enigma2-nightly.org; \
	rm -rf $(appsdir)/enigma2-nightly.newest; \
	rm -rf $(appsdir)/enigma2-nightly.patched; \
	clear; \
	echo "Media Framwork: $(MEDIAFW)"; \
	echo "Choose between the following revisions:"; \
	echo " 0) Newest (Can fail due to outdated patch)"; \
	echo "---- REVISIONS ----"; \
	echo "1) Sat, 17 Mar 2012 19:51 - E2 OpenPli 945aeb939308b3652b56bc6c577853369d54a537"; \
	echo "2) Sat, 18 May 2012 15:26  - E2 OpenPli 839e96b79600aba73f743fd39628f32bc1628f4c"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "0" ] && DIFF="0" && HEAD="experimental"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && REVISION="945aeb939308b3652b56bc6c577853369d54a537" && REPO="git://openpli.git.sourceforge.net/gitroot/openpli/enigma2"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && REVISION="839e96b79600aba73f743fd39628f32bc1628f4c" && REPO="git://openpli.git.sourceforge.net/gitroot/openpli/enigma2"; \
	echo "Revision: " $$REVISION; \
	[ -d "$(archivedir)/enigma2-pli-nightly.git" ] && \
	(cd $(archivedir)/enigma2-pli-nightly.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/enigma2-pli-nightly.git" ] || \
	git clone -b $$HEAD $$REPO $(archivedir)/enigma2-pli-nightly.git; \
	cp -ra $(archivedir)/enigma2-pli-nightly.git $(appsdir)/enigma2-nightly.newest; \
	cp -ra $(archivedir)/enigma2-pli-nightly.git $(appsdir)/enigma2-nightly; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	rm -rf $(appsdir)/enigma2-nightly/.git; \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.org; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-pli-nightly.$$DIFF.diff"; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-pli-nightly.$$DIFF.$(MEDIAFW).diff"; \
	[ "$(EXTERNALLCD_DEP)" == "" ] || (cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-pli-nightly.$$DIFF.graphlcd.diff" ); \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.patched
	touch $@

$(appsdir)/enigma2-pli-nightly/config.status: bootstrap freetype expat fontconfig libpng jpeg libgif libfribidi libid3tag libmad libsigc libreadline \
		libdvbsipp python libxml2 libxslt elementtree zope_interface twisted pyopenssl pythonwifi lxml libxmlccwrap ncurses-dev libdreamdvd2 tuxtxt32bpp sdparm hotplug_e2 $(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
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
			$(PLATFORM_CPPFLAGS)


$(DEPDIR)/enigma2-pli-nightly.do_compile: $(appsdir)/enigma2-pli-nightly/config.status
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2-pli-nightly: enigma2-pli-nightly.do_prepare enigma2-pli-nightly.do_compile
	$(MAKE) -C $(appsdir)/enigma2-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
	fi
	touch $@

enigma2-pli-nightly-clean enigma2-pli-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-pli-nightly
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_prepare
	rm -rf $(appsdir)/enigma2-nightly
	rm -rf $(appsdir)/enigma2-nightly.newest
	rm -rf $(appsdir)/enigma2-nightly.org
	rm -rf $(appsdir)/enigma2-nightly.patched

