#Trick: ich haue mal das kopieren von /boot mal hier rein. ist fuer m82 und m84
$(DEPDIR)/boot-elf:
	$(INSTALL_DIR) $(targetprefix)/boot
	cp $(buildprefix)/root/boot/audio.elf $(targetprefix)/boot
	cp $(buildprefix)/root/boot/video_7100.elf $(targetprefix)/boot
	cp $(buildprefix)/root/boot/video_7109.elf $(targetprefix)/boot
	$(INSTALL_DIR) $(targetprefix)/lib/firmware
	cp $(buildprefix)/root/firmware/dvb-fe-cx24116.fw $(targetprefix)/lib/firmware/
	cp $(buildprefix)/root/firmware/dvb-fe-cx21143.fw $(targetprefix)/lib/firmware/
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/misc-cp:
	cp $(buildprefix)/root/sbin/hotplug $(targetprefix)/sbin
if ENABLE_HL101
	cp $(buildprefix)/root/etc/lircd_hl101.conf $(targetprefix)/etc/lircd.conf
else
if ENABLE_VIP2
	cp $(buildprefix)/root/etc/lircd_vip2.conf $(targetprefix)/etc/lircd.conf
else
	cp $(buildprefix)/root/etc/lircd.conf $(targetprefix)/etc
endif
endif

	cp -rd $(buildprefix)/root/etc/hotplug $(targetprefix)/etc
	cp -rd $(buildprefix)/root/etc/hotplug.d $(targetprefix)/etc
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/firstboot:
	$(INSTALL_DIR) $(targetprefix)/var/etc
	cp -rd $(buildprefix)/root/var/etc/.firstboot $(targetprefix)/var/etc/
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/remote:
if ENABLE_HL101
	cp $(buildprefix)/root/etc/lircd_hl101.conf $(targetprefix)/etc/lircd.conf
else
if ENABLE_VIP2
	cp $(buildprefix)/root/etc/lircd_vip2.conf $(targetprefix)/etc/lircd.conf
else
	cp $(buildprefix)/root/etc/lircd.conf $(targetprefix)/etc/
endif
endif
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/misc-e2:
	$(INSTALL_DIR) $(targetprefix)/media/hdd
	$(INSTALL_DIR) $(targetprefix)/media/dvd
	$(INSTALL_DIR) $(targetprefix)/hdd
	$(INSTALL_DIR) $(targetprefix)/hdd/music
	$(INSTALL_DIR) $(targetprefix)/hdd/picture
	$(INSTALL_DIR) $(targetprefix)/hdd/movie
	@[ "x$*" = "x" ] && touch $@ || true

#
# SPLASHUTILS
#
#SPLASHUTILS := splashutils
#SPLASHUTILS_VERSION := 1.3-3
#RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm: \
#		jpeg libmng Archive/$(STLINUX)-target-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).src.rpm
#	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
#	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(SPLASHUTILS).spec
#$(DEPDIR)/min-$(SPLASHUTILS) $(DEPDIR)/std-$(SPLASHUTILS) $(DEPDIR)/max-$(SPLASHUTILS) $(DEPDIR)/$(SPLASHUTILS): \
#$(DEPDIR)/%$(SPLASHUTILS): RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm
#	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
#		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
#	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
#	@TUXBOX_YAUD_CUSTOMIZE@
#
#flash-splashutils: $(flashprefix)/root/sbin/splash_util.static
#
#$(flashprefix)/root/sbin/splash_util.static: RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm
#	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
#		--relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
#	cp root/etc/splash/luxisri.ttf $(flashprefix)/root/etc/splash/ && \
#	touch $@ && \
#	@FLASHROOTDIR_MODIFIED@

#RPMS/sh4/stlinux22-sh4-splashutils-1.5.3.2-4.sh4.rpm
#stlinux23-target-splashutils-1.5.3.2-4.src.rpm
SPLASHUTILS := splashutils
SPLASHUTILS_VERSION := 1.5.3.2-4
RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm: \
		jpeg libmng freetype libpng Archive/stlinux23-target-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).src.rpm
	export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(SPLASHUTILS).spec < ../Patches/stm-target-$(SPLASHUTILS).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/stm-target-$(SPLASHUTILS).spec

$(DEPDIR)/min-$(SPLASHUTILS) $(DEPDIR)/std-$(SPLASHUTILS) $(DEPDIR)/max-$(SPLASHUTILS) $(DEPDIR)/$(SPLASHUTILS): \
$(DEPDIR)/%$(SPLASHUTILS): RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	cp root/etc/splash/luxisri.ttf $(targetprefix)/etc/splash/ && \
	cp -rd root/etc/splash/{vdr,liquid,together}_theme $(targetprefix)/etc/splash/ && \
	$(LN_SF) liquid_theme $(targetprefix)/etc/splash/default && \
	$(INSTALL_DIR) $(targetprefix)/lib/lsb && \
	cp root/lib/lsb/splash-functions $(targetprefix)/lib/lsb/ && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-splashutils: $(flashprefix)/root/sbin/fbsplashd

$(flashprefix)/root/sbin/fbsplashd: RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	cp root/etc/splash/luxisri.ttf $(flashprefix)/root/etc/splash/ && \
	cp -rd root/etc/splash/{vdr,liquid,together}_theme $(flashprefix)/root/etc/splash/ && \
	$(LN_SF) liquid_theme $(flashprefix)/root/etc/splash/default && \
	rm -rf $(flashprefix)/root/etc/splash/st_theme && \
	$(INSTALL_DIR) $(flashprefix)/root/lib/lsb && \
	cp root/lib/lsb/splash-functions $(flashprefix)/root/lib/lsb/ && \
	rm $(flashprefix)/root/sbin/{fbsplashd.static,splash-functions.sh} && \
	rm $(flashprefix)/root/usr/bin/{bootsplash2fbsplash,splash_geninitramfs,splash_manager,splash_resize} && \
	touch $@ && \
	@FLASHROOTDIR_MODIFIED@


#
# BINUTILS
#
BINUTILS := binutils
BINUTILS_DEV      := binutils-dev

#BINUTILS_VERSION  := 2.18.50.0.8-34
#BINUTILS_VERSION  := 2.18-34
BINUTILS_VERSION  := 2.18.50.0.8-38
#http://www.stlinux.com/pub/stlinux/2.3/updates/SRPMS/stlinux23-target-binutils-2.18-34.src.rpm

RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS)-$(BINUTILS_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS_DEV)-$(BINUTILS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(BINUTILS)-$(BINUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	export PATH=$(hostprefix)/bin:$(PATH) &&  \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(BINUTILS).spec

$(BINUTILS): RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS)-$(BINUTILS_VERSION).sh4.rpm
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(BINUTILS_DEV): RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS_DEV)-$(BINUTILS_VERSION).sh4.rpm
	@rpm $(DRPM) --ignorearch --nodeps --noscripts -Uhv $< && \
	touch .deps/$(notdir $@)


#
# STSLAVE
#
STSLAVE := stslave
if STM22
STSLAVE_VERSION := 0.6-8

RPMS/sh4/$(STLINUX)-sh4-$(STSLAVE)-$(STSLAVE_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(STSLAVE)-$(STSLAVE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(STSLAVE).spec

$(DEPDIR)/min-$(STSLAVE) $(DEPDIR)/std-$(STSLAVE) $(DEPDIR)/max-$(STSLAVE) $(DEPDIR)/$(STSLAVE): \
$(DEPDIR)/%$(STSLAVE): RPMS/sh4/$(STLINUX)-sh4-$(STSLAVE)-$(STSLAVE_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
else
STSLAVE_VERSION := 0.7-16

RPMS/sh4/$(STLINUX)-sh4-$(STSLAVE)-$(STSLAVE_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(STSLAVE)-$(STSLAVE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(STSLAVE).spec

$(DEPDIR)/min-$(STSLAVE) $(DEPDIR)/std-$(STSLAVE) $(DEPDIR)/max-$(STSLAVE) $(DEPDIR)/$(STSLAVE): \
$(DEPDIR)/%$(STSLAVE): linux-kernel-headers binutils-dev RPMS/sh4/$(STLINUX)-sh4-$(STSLAVE)-$(STSLAVE_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
endif

flash-stslave: $(flashprefix)/root/bin/stslave

$(flashprefix)/root/bin/stslave: $(STSLAVE)
	$(INSTALL_DIR) $(dir $@) && \
	$(CP_D) $(targetprefix)/bin/stslave $@ && \
	touch $@ && \
	@FLASHROOTDIR_MODIFIED@

#
# OPENSSL
#
OPENSSL := openssl
OPENSSL_DEV := openssl-dev
if STM22
OPENSSL_VERSION := 0.9.8-6
else
OPENSSL_VERSION := 0.9.8h-11
endif

RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL)-$(OPENSSL_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL_DEV)-$(OPENSSL_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(OPENSSL)-$(OPENSSL_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(OPENSSL).spec

$(DEPDIR)/min-$(OPENSSL) $(DEPDIR)/std-$(OPENSSL) $(DEPDIR)/max-$(OPENSSL) $(DEPDIR)/$(OPENSSL): \
$(DEPDIR)/%$(OPENSSL): RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL)-$(OPENSSL_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(OPENSSL_DEV) $(DEPDIR)/std-$(OPENSSL_DEV) $(DEPDIR)/max-$(OPENSSL_DEV) $(DEPDIR)/$(OPENSSL_DEV): \
$(DEPDIR)/%$(OPENSSL_DEV): %$(OPENSSL) RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL_DEV)-$(OPENSSL_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# ALSALIB
#
ALSALIB := alsa-lib
ALSALIB_DEV := alsa-lib-dev
if STM22
ALSALIB_VERSION := 1.0.12-9
ALSALIB_OPT := -sh4processed
RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB)-$(ALSALIB_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB_DEV)-$(ALSALIB_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(ALSALIB)-$(ALSALIB_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(ALSALIB)$(ALSALIB_OPT).spec < ../Patches/stm-target-$(ALSALIB).spec22.diff ) && \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(ALSALIB)$(ALSALIB_OPT).spec
else
ALSALIB_VERSION := 1.0.16-16
ALSALIB_OPT :=
RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB)-$(ALSALIB_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB_DEV)-$(ALSALIB_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(ALSALIB)-$(ALSALIB_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(ALSALIB)$(ALSALIB_OPT).spec < ../Patches/stm-target-$(ALSALIB).spec23.diff ) && \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(ALSALIB)$(ALSALIB_OPT).spec
endif

$(DEPDIR)/min-$(ALSALIB) $(DEPDIR)/std-$(ALSALIB) $(DEPDIR)/max-$(ALSALIB) $(DEPDIR)/$(ALSALIB): \
$(DEPDIR)/%$(ALSALIB): RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB)-$(ALSALIB_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(ALSALIB_DEV) $(DEPDIR)/std-$(ALSALIB_DEV) $(DEPDIR)/max-$(ALSALIB_DEV) $(DEPDIR)/$(ALSALIB_DEV): \
$(DEPDIR)/%$(ALSALIB_DEV): %$(ALSALIB) RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB_DEV)-$(ALSALIB_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-alsa-lib: $(flashprefix)/root/usr/bin/aserver

$(flashprefix)/root/usr/bin/aserver: RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB)-$(ALSALIB_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	touch $@ && \
	@FLASHROOTDIR_MODIFIED@
#
# ALSAUTILS
#
ALSAUTILS := alsa-utils
if STM22
ALSAUTILS_VERSION := 1.0.12-7
else
ALSAUTILS_VERSION := 1.0.16-14
endif

RPMS/sh4/$(STLINUX)-sh4-$(ALSAUTILS)-$(ALSAUTILS_VERSION).sh4.rpm: \
		$(NCURSES_DEV) $(ALSALIB_DEV) Archive/$(STLINUX)-target-$(ALSAUTILS)-$(ALSAUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/stm-target-$(ALSAUTILS).spec

$(DEPDIR)/min-$(ALSAUTILS) $(DEPDIR)/std-$(ALSAUTILS) $(DEPDIR)/max-$(ALSAUTILS) $(DEPDIR)/$(ALSAUTILS): \
$(DEPDIR)/%$(ALSAUTILS): RPMS/sh4/$(STLINUX)-sh4-$(ALSAUTILS)-$(ALSAUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
#-/usr/share/sounds/alsa/

flash-alsa-utils: $(flashprefix)/root/usr/bin/amixer

$(flashprefix)/root/usr/bin/amixer: RPMS/sh4/$(STLINUX)-sh4-$(ALSAUTILS)-$(ALSAUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	rm -rf $(flashprefix)/root/usr/share/sounds/alsa && \
	rmdir $(flashprefix)/root/usr/share/sounds && \
	touch $@ && \
	@FLASHROOTDIR_MODIFIED@

#
# ALSAPLAYER
#
ALSAPLAYER := alsaplayer
ALSAPLAYER_DEV := alsaplayer-dev
if STM22
ALSAPLAYER_VERSION := 0.99.76-5
else
ALSAPLAYER_VERSION := 0.99.77-10
endif

RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER_DEV)-$(ALSAPLAYER_VERSION).sh4.rpm: \
		libmad libid3tag Archive/$(STLINUX)-target-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/include/pkgconfig && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(ALSAPLAYER).spec

$(DEPDIR)/min-$(ALSAPLAYER) $(DEPDIR)/std-$(ALSAPLAYER) $(DEPDIR)/max-$(ALSAPLAYER) $(DEPDIR)/$(ALSAPLAYER): \
$(DEPDIR)/%$(ALSAPLAYER): RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(ALSAPLAYER_DEV) $(DEPDIR)/std-$(ALSAPLAYER_DEV) $(DEPDIR)/max-$(ALSAPLAYER_DEV) $(DEPDIR)/$(ALSAPLAYER_DEV): \
$(DEPDIR)/%$(ALSAPLAYER_DEV): RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER_DEV)-$(ALSAPLAYER_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#+/usr/lib/alsaplayer/
flash-alsaplayer: $(flashprefix)/root/usr/bin/alsaplayer

$(flashprefix)/root/usr/bin/alsaplayer: RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	touch $@ && \
	@FLASHROOTDIR_MODIFIED@
