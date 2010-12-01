#
# STGFB
#
DEPMOD          = /sbin/depmod

STGFB_DIR := stgfb-2.0_stm22_0006
HOST_STGFB := host-stgfb-source
HOST_STGFB_VERSION := 2.0_stm22_0006-22

RPMS/noarch/$(STLINUX)-$(HOST_STGFB)-$(HOST_STGFB_VERSION).noarch.rpm: \
		Archive/$(STLINUX)-$(HOST_STGFB)-$(HOST_STGFB_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(subst -source,,$(HOST_STGFB)).spec

$(DEPDIR)/$(HOST_STGFB): RPMS/noarch/$(STLINUX)-$(HOST_STGFB)-$(HOST_STGFB_VERSION).noarch.rpm
	@rpm $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(buildprefix)/stgfb=$(buildprefix) --nodeps --noscripts $<
	touch $@

$(DEPDIR)/stgfb.do_prepare: linux-kernel.do_compile $(HOST_STGFB)
	touch $@

$(DEPDIR)/stgfb.do_compile: \
		$(DEPDIR)/stgfb.do_prepare
	$(MAKE) -C $(STGFB_DIR)/Linux KERNELDIR=$(buildprefix)/linux CONFIG_STG_DEBUG=y CONFIG_STG_HD=n $(MAKE_OPTS)
#	For HD pipeline change to
#	$(MAKE) -C $(STGFB_DIR)/Linux KERNELDIR=$(kernelprefix)/linux-sh4 CONFIG_STG_DEBUG=y CONFIG_STG_HD=y $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-stgfb $(DEPDIR)/std-stgfb $(DEPDIR)/max-stgfb \
$(DEPDIR)/stgfb: \
$(DEPDIR)/%stgfb: $(DEPDIR)/stgfb.do_compile
	cd $(STGFB_DIR) && \
		$(MAKE) KERNELDIR=$(buildprefix)/linux \
			INSTALL_MOD_PATH=$(prefix)/$*cdkroot \
			INSTALL_MOD_DIR=stgfb \
			$(MAKE_OPTS) modules_install && \
		$(DEPMOD) -ae -F $(buildprefix)/linux/System.map -b $(prefix)/$*cdkroot -r $(KERNELVERSION)
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/stgfb-dev: stgfb
	cp $(STGFB_DIR)/Linux/video/stmfb.h $(targetprefix)/usr/include/linux
	@[ "x$*" = "x" ] && touch $@ || true

stgfb.do_clean:
	rm .deps/$(subst do_clean,do_prepare,$@) || true
	rm .deps/$(subst do_clean,do_compile,$@) || true
	rm .deps/$(subst .do_clean,,$@) || true

#ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS/stlinux22-target-console-data-1999.08.29-4.src.rpm
#ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS/stlinux22-target-console-tools-0.2.3-6.src.rpm
#
# CONSOLE-DATA
#
CONSOLE_DATAA := console-data
CONSOLE_DATA_VERSION := 1999.08.29-4

RPMS/sh4/stlinux20-sh4-console-data-1999.08.29-4.sh4.rpm: \
		Archive/stlinux22-target-$(CONSOLE_DATAA)-$(CONSOLE_DATA_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(CONSOLE_DATAA).spec < ../Patches/stm-target-$(CONSOLE_DATAA).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(CONSOLE_DATAA).spec

$(DEPDIR)/min-$(CONSOLE_DATAA) $(DEPDIR)/std-$(CONSOLE_DATAA) $(DEPDIR)/max-$(CONSOLE_DATAA) $(DEPDIR)/$(CONSOLE_DATAA): \
$(DEPDIR)/%$(CONSOLE_DATAA): RPMS/sh4/stlinux20-sh4-$(CONSOLE_DATAA)-$(CONSOLE_DATA_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# CONSOLE-TOOLS
#
CONSOLE_TOOLS := console-tools
CONSOLE_TOOLS_VERSION := 0.2.3-6

RPMS/sh4/stlinux20-sh4-console-tools-0.2.3-6.sh4.rpm: \
		Archive/stlinux22-target-$(CONSOLE_TOOLS)-$(CONSOLE_TOOLS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(CONSOLE_TOOLS).spec < ../Patches/stm-target-$(CONSOLE_TOOLS).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(CONSOLE_TOOLS).spec

$(DEPDIR)/min-$(CONSOLE_TOOLS) $(DEPDIR)/std-$(CONSOLE_TOOLS) $(DEPDIR)/max-$(CONSOLE_TOOLS) $(DEPDIR)/$(CONSOLE_TOOLS): \
$(DEPDIR)/%$(CONSOLE_TOOLS): RPMS/sh4/stlinux20-sh4-$(CONSOLE_TOOLS)-$(CONSOLE_TOOLS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

########################################

#
# ICE
#
ICE := ICE
ICE_VERSION := 6.8.1-2
RPMS/sh4/stlinux20-sh4-ICE-6.8.1-2.sh4.rpm: \
		Archive/stlinux20-target-$(ICE)-$(ICE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(ICE).spec < ../Patches/stm-target-$(ICE).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(ICE).spec
$(DEPDIR)/min-$(ICE) $(DEPDIR)/std-$(ICE) $(DEPDIR)/max-$(ICE) $(DEPDIR)/$(ICE): \
$(DEPDIR)/%$(ICE): RPMS/sh4/stlinux20-sh4-$(ICE)-$(ICE_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# SM
#
SM := SM
SM_VERSION := 6.8.1-2
RPMS/sh4/stlinux20-sh4-SM-6.8.1-2.sh4.rpm: \
		Archive/stlinux20-target-$(SM)-$(SM_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(SM).spec < ../Patches/stm-target-$(SM).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(SM).spec
$(DEPDIR)/min-$(SM) $(DEPDIR)/std-$(SM) $(DEPDIR)/max-$(SM) $(DEPDIR)/$(SM): \
$(DEPDIR)/%$(SM): RPMS/sh4/stlinux20-sh4-$(SM)-$(SM_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# XPROTO
#
XPROTO := Xproto
XPROTO_VERSION := 6.8.1-2
RPMS/sh4/stlinux20-sh4-Xproto-6.8.1-2.sh4.rpm: \
		Archive/stlinux20-target-$(XPROTO)-$(XPROTO_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(XPROTO).spec < ../Patches/stm-target-$(XPROTO).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(XPROTO).spec
$(DEPDIR)/min-$(XPROTO) $(DEPDIR)/std-$(XPROTO) $(DEPDIR)/max-$(XPROTO) $(DEPDIR)/$(XPROTO): \
$(DEPDIR)/%$(XPROTO): RPMS/sh4/stlinux20-sh4-$(XPROTO)-$(XPROTO_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# XEXTENSIONS
#
XEXTENSIONS := XExtensions
XEXTENSIONS_VERSION := 6.8.1-2
RPMS/sh4/stlinux20-sh4-XExtensions-6.8.1-2.sh4.rpm: \
		Archive/stlinux20-target-$(XEXTENSIONS)-$(XEXTENSIONS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(XEXTENSIONS).spec < ../Patches/stm-target-$(XEXTENSIONS).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(XEXTENSIONS).spec
$(DEPDIR)/min-$(XEXTENSIONS) $(DEPDIR)/std-$(XEXTENSIONS) $(DEPDIR)/max-$(XEXTENSIONS) $(DEPDIR)/$(XEXTENSIONS): \
$(DEPDIR)/%$(XEXTENSIONS): RPMS/sh4/stlinux20-sh4-$(XEXTENSIONS)-$(XEXTENSIONS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# XT
#
XT := Xt
XT_VERSION := 6.8.1-2
RPMS/sh4/stlinux20-sh4-Xt-6.8.1-2.sh4.rpm: \
		$(DEPDIR)/$(SM) \
		Archive/stlinux20-target-$(XT)-$(XT_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(XT).spec < ../Patches/stm-target-$(XT).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(XT).spec
$(DEPDIR)/min-$(XT) $(DEPDIR)/std-$(XT) $(DEPDIR)/max-$(XT) $(DEPDIR)/$(XT): \
$(DEPDIR)/%$(XT): RPMS/sh4/stlinux20-sh4-$(XT)-$(XT_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# XTRANS
#
XTRANS := xtrans
XTRANS_VERSION := 6.8.1-2
RPMS/sh4/stlinux20-sh4-xtrans-6.8.1-2.sh4.rpm: \
		Archive/stlinux20-target-$(XTRANS)-$(XTRANS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(XTRANS).spec < ../Patches/stm-target-$(XTRANS).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(XTRANS).spec
$(DEPDIR)/min-$(XTRANS) $(DEPDIR)/std-$(XTRANS) $(DEPDIR)/max-$(XTRANS) $(DEPDIR)/$(XTRANS): \
$(DEPDIR)/%$(XTRANS): RPMS/sh4/stlinux20-sh4-$(XTRANS)-$(XTRANS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# XAU
#
XAU := Xau
XAU_VERSION := 6.8.1-2
RPMS/sh4/stlinux20-sh4-Xau-6.8.1-2.sh4.rpm: \
		$(DEPDIR)/$(XPROTO) \
		Archive/stlinux20-target-$(XAU)-$(XAU_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(XAU).spec < ../Patches/stm-target-$(XAU).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(XAU).spec
$(DEPDIR)/min-$(XAU) $(DEPDIR)/std-$(XAU) $(DEPDIR)/max-$(XAU) $(DEPDIR)/$(XAU): \
$(DEPDIR)/%$(XAU): $(DEPDIR)/%$(XPROTO) RPMS/sh4/stlinux20-sh4-$(XAU)-$(XAU_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# X11
#
X11 := X11
X11_VERSION := 6.8.1-4
RPMS/sh4/stlinux20-sh4-X11-6.8.1-4.sh4.rpm: \
		$(DEPDIR)/$(XAU) \
		$(DEPDIR)/$(XEXTENSIONS) \
		$(DEPDIR)/$(XTRANS) \
		Archive/stlinux20-target-$(X11)-$(X11_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(X11).spec < ../Patches/stm-target-$(X11).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(X11).spec
$(DEPDIR)/min-$(X11) $(DEPDIR)/std-$(X11) $(DEPDIR)/max-$(X11) $(DEPDIR)/$(X11): \
$(DEPDIR)/%$(X11): $(DEPDIR)/%$(XAU) RPMS/sh4/stlinux20-sh4-$(X11)-$(X11_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

########################################

#
# LIRC-APPS
#
LIRC_APPS := lirc-apps
LIRC_APPS_VERSION := 0.7.2pre1-7
RPMS/sh4/stlinux20-sh4-lirc-apps-0.7.2pre1-7.sh4.rpm: \
		Archive/stlinux20-target-$(LIRC_APPS)-$(LIRC_APPS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(LIRC_APPS).spec
$(DEPDIR)/min-$(LIRC_APPS) $(DEPDIR)/std-$(LIRC_APPS) $(DEPDIR)/max-$(LIRC_APPS) $(DEPDIR)/$(LIRC_APPS): \
$(DEPDIR)/%$(LIRC_APPS): $(DEPDIR)/%$(X11) RPMS/sh4/stlinux20-sh4-$(LIRC_APPS)-$(LIRC_APPS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@


########################################

$(DEPDIR)/stgfb-devnew:
	cp $(driverdir)/stgfb/stmfb/Linux/video/stmfb.h $(targetprefix)/usr/include/linux
	cp $(driverdir)/stgfb/stmfb/Linux/stm/coredisplay/stmhdmi.h $(targetprefix)/usr/include/linux
	@[ "x$*" = "x" ] && touch $@ || true
#
# DIRECTFB
#
#stlinux22-target-directfb-1.0.0-18.src.rpm
#ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/SRPMS/stlinux22-target-directfb-1.0.0-19.src.rpm

DIRECTFB := directfbx
DIRECTFB_DEV := directfb-dev
DIRECTFB_VERSION := 1.0.0-19

RPMS/sh4/$(STLINUX)-sh4-$(DIRECTFB)-$(DIRECTFB_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(DIRECTFB_DEV)-$(DIRECTFB_VERSION).sh4.rpm: \
		freetype \
		Archive/$(STLINUX)-target-$(DIRECTFB)-$(DIRECTFB_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(DIRECTFB).spec < ../Patches/stm-target-$(DIRECTFB).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(DIRECTFB).spec

$(DEPDIR)/min-$(DIRECTFB) $(DEPDIR)/std-$(DIRECTFB) $(DEPDIR)/max-$(DIRECTFB) $(DEPDIR)/$(DIRECTFB): \
$(DEPDIR)/%$(DIRECTFB):  %freetype %jpeg RPMS/sh4/$(STLINUX)-sh4-$(DIRECTFB)-$(DIRECTFB_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(DIRECTFB_DEV) $(DEPDIR)/std-$(DIRECTFB_DEV) $(DEPDIR)/max-$(DIRECTFB_DEV) $(DEPDIR)/$(DIRECTFB_DEV): \
$(DEPDIR)/%$(DIRECTFB_DEV): $(DEPDIR)/%$(DIRECTFB) RPMS/sh4/$(STLINUX)-sh4-$(DIRECTFB_DEV)-$(DIRECTFB_VERSION).sh4.rpm
	rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	perl -pi -e "s,^libdir=.*\$$,libdir='$(targetprefix)/usr/lib'," $(targetprefix)/usr/lib/libdirectfb.la && \
	perl -pi -e "s,^prefix=.*\$$,prefix=$(targetprefix)/usr," $(targetprefix)/usr/lib/pkgconfig/directfb.pc && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# DIRECTFB-EXAMPLES
#
DIRECTFB_EXAMPLES := directfb-examples
DIRECTFB_EXAMPLES_VERSION := 0.9.22_stcvs20050810-7

RPMS/sh4/stlinux20-sh4-directfb-examples-0.9.22_stcvs20050810-7.sh4.rpm: \
		$(FREETYPE_DEV) \
		$(DIRECTFB_DEV) \
		Archive/stlinux20-target-directfb-examples-0.9.22_stcvs20050810-7.src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(DIRECTFB_EXAMPLES).spec

$(DEPDIR)/min-$(DIRECTFB_EXAMPLES) $(DEPDIR)/std-$(DIRECTFB_EXAMPLES) $(DEPDIR)/max-$(DIRECTFB_EXAMPLES) $(DEPDIR)/$(DIRECTFB_EXAMPLES): \
$(DEPDIR)/%$(DIRECTFB_EXAMPLES): $(DEPDIR)/%$(FREETYPE) RPMS/sh4/stlinux20-sh4-$(DIRECTFB_EXAMPLES)-$(DIRECTFB_EXAMPLES_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

########################################

$(X11).do_clean:
	for i in $(X11) $(XTRANS) $(XEXTENSIONS) $(XAU) $(XPROTO); do \
		rpm $(DRPM) -ev stlinux20-sh4-$$i || true && \
		[ -f .deps/$$i ] && rm .deps/$$i || true; \
	done

$(DIRECTFB).do_clean:
	for i in $(DIRECTFB) $(FREETYPE); do \
		rpm $(DRPM) -ev stlinux20-sh4-$$i || true && \
		[ -f .deps/$$i ] && rm .deps/$$i || true; \
	done
