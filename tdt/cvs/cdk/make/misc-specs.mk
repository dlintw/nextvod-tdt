#Trick: ich haue mal das kopieren von /boot mal hier rein. ist fuer m82 und m84
$(DEPDIR)/boot-elf:
	$(INSTALL_DIR) $(targetprefix)/boot
	for elf in video_7109.elf video_7100.elf video_7111.elf video_7105.elf audio.elf audio_7111.elf audio_7105.elf \
	;do \
		if [ -e $(buildprefix)/root/boot/$$elf ] ; then \
			cp $(buildprefix)/root/boot/$$elf $(targetprefix)/boot/ ; \
		else \
			touch $(targetprefix)/boot/$$elf; \
		fi; \
	done
	$(INSTALL_DIR) $(targetprefix)/lib/firmware
	cp $(buildprefix)/root/firmware/*.fw $(targetprefix)/lib/firmware/
	@[ "x$*" = "x" ] && touch $@ || true

if ENABLE_ADB_BOX
LIRCD_CONF := lircd_adb_box.conf
else !ENABLE_ADB_BOX
if ENABLE_SPARK
LIRCD_CONF := lircd_spark.conf
else !ENABLE_SPARK
if ENABLE_SPARK7162
LIRCD_CONF := lircd_spark7162.conf
else !ENABLE_SPARK7162
if ENABLE_HL101
LIRCD_CONF := lircd_hl101.conf
else !ENABLE_HL101
if ENABLE_VIP1_V2
LIRCD_CONF := lircd_vip1_v2.conf
else !ENABLE_VIP1_V2
if ENABLE_VIP2_V1
LIRCD_CONF := lircd_vip2_v1.conf
else !ENABLE_VIP2_V1
if ENABLE_HOMECAST5101
LIRCD_CONF := lircd_hs5101.conf
else !ENABLE_HOMECAST5101
LIRCD_CONF := lircd.conf
endif !ENABLE_HOMECAST5101
endif !ENABLE_VIP2_V1
endif !ENABLE_VIP1_V2
endif !ENABLE_HL101
endif !ENABLE_SPARK7162
endif !ENABLE_SPARK
endif !ENABLE_ADB_BOX

$(DEPDIR)/misc-cp:
	cp $(buildprefix)/root/sbin/hotplug $(targetprefix)/sbin
	cp $(buildprefix)/root/etc/$(LIRCD_CONF) $(targetprefix)/etc/lircd.conf
	cp -rd $(buildprefix)/root/etc/hotplug $(targetprefix)/etc
	cp -rd $(buildprefix)/root/etc/hotplug.d $(targetprefix)/etc
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/firstboot:
	$(INSTALL_DIR) $(targetprefix)/var/etc
	cp -rd $(buildprefix)/root/var/etc/.firstboot $(targetprefix)/var/etc/
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/remote:
	cp $(buildprefix)/root/etc/$(LIRCD_CONF) $(targetprefix)/etc/lircd.conf
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
SPLASHUTILS := splashutils
if STM22
SPLASHUTILS_VERSION := 1.5.3.2-4
SPLASHUTILS_SPEC := stm-target-$(SPLASHUTILS).spec
SPLASHUTILS_SPEC_PATCH := $(SPLASHUTILS_SPEC).diff
SPLASHUTILS_PATCHES :=
else !STM22
if STM23
SPLASHUTILS_VERSION := 1.5.3.2-4
SPLASHUTILS_SPEC := stm-target-$(SPLASHUTILS).spec
SPLASHUTILS_SPEC_PATCH := $(SPLASHUTILS_SPEC).diff
SPLASHUTILS_PATCHES :=
else !STM23
# if STM24
SPLASHUTILS_VERSION := 1.5.4.3-7
SPLASHUTILS_SPEC := stm-target-$(SPLASHUTILS).spec
SPLASHUTILS_SPEC_PATCH :=
SPLASHUTILS_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
SPLASHUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm

$(SPLASHUTILS_RPM): \
		$(if $(SPLASHUTILS_SPEC_PATCH),Patches/$(SPLASHUTILS_PATCH)) \
		$(if $(SPLASHUTILS_PATCHES),$(SPLASHUTILS_PATCHES:%=Patches/%)) \
		jpeg libmng freetype libpng \
		$(archivedir)/stlinux23-target-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(SPLASHUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(SPLASHUTILS_SPEC) < ../Patches/$(SPLASHUTILS_SPEC_PATCH) ) &&) \
	$(if $(SPLASHUTILS_PATCHES),cp $(SPLASHUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(SPLASHUTILS_SPEC)

$(DEPDIR)/min-$(SPLASHUTILS) $(DEPDIR)/std-$(SPLASHUTILS) $(DEPDIR)/max-$(SPLASHUTILS) $(DEPDIR)/$(SPLASHUTILS): \
$(DEPDIR)/%$(SPLASHUTILS): $(SPLASHUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	cp root/etc/splash/luxisri.ttf $(targetprefix)/etc/splash/ && \
	cp -rd root/etc/splash/{vdr,liquid,together}_theme $(targetprefix)/etc/splash/ && \
	$(LN_SF) liquid_theme $(targetprefix)/etc/splash/default && \
	$(INSTALL_DIR) $(targetprefix)/lib/lsb && \
	cp root/lib/lsb/splash-functions $(targetprefix)/lib/lsb/ && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-splashutils: $(flashprefix)/root/sbin/fbsplashd

$(flashprefix)/root/sbin/fbsplashd: $(SPLASHUTILS_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
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
BINUTILS_DEV := binutils-dev
if STM22
BINUTILS_VERSION := 2.17.50.0.4-14
BINUTILS_SPEC := stm-target-$(BINUTILS)-sh4processed.spec
BINUTILS_SPEC_PATCH :=
BINUTILS_PATCHES :=
else !STM22
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
BINUTILS_VERSION := 2.19.1-41
BINUTILS_SPEC := stm-target-$(BINUTILS).spec
BINUTILS_SPEC_PATCH :=
BINUTILS_PATCHES :=
else !STM23
# if STM24
BINUTILS_VERSION := 2.19.1-41
BINUTILS_SPEC := stm-target-$(BINUTILS).spec
BINUTILS_SPEC_PATCH :=
BINUTILS_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
BINUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS)-$(BINUTILS_VERSION).sh4.rpm
BINUTILS_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BINUTILS_DEV)-$(BINUTILS_VERSION).sh4.rpm

$(BINUTILS_RPM) $(BINUTILS_DEV_RPM): \
		$(if $(BINUTILS_SPEC_PATCH),Patches/$(BINUTILS_PATCH)) \
		$(if $(BINUTILS_PATCHES),$(BINUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX:%23=%24)-target-$(BINUTILS)-$(BINUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BINUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(BINUTILS_SPEC) < ../Patches/$(BINUTILS_SPEC_PATCH) ) &&) \
	$(if $(BINUTILS_PATCHES),cp $(BINUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BINUTILS_SPEC)

$(BINUTILS): $(BINUTILS_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(BINUTILS_DEV): $(BINUTILS_DEV_RPM)
	@rpm $(DRPM) --ignorearch --nodeps --noscripts -Uhv $< && \
	touch .deps/$(notdir $@)

#
# STSLAVE
#
STSLAVE := stslave
if STM22
STSLAVE_VERSION := 0.6-8
STSLAVE_SPEC := stm-target-$(STSLAVE).spec
STSLAVE_SPEC_PATCH :=
STSLAVE_PATCHES :=
else !STM22
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
STSLAVE_VERSION := 0.7-18
STSLAVE_SPEC := stm-target-$(STSLAVE).spec
STSLAVE_SPEC_PATCH :=
STSLAVE_PATCHES :=
else !STM23
# if STM24
STSLAVE_VERSION := 0.7-18
STSLAVE_SPEC := stm-target-$(STSLAVE).spec
STSLAVE_SPEC_PATCH :=
STSLAVE_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
STSLAVE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(STSLAVE)-$(STSLAVE_VERSION).sh4.rpm

$(STSLAVE_RPM): \
		$(if $(STSLAVE_SPEC_PATCH),Patches/$(STSLAVE_PATCH)) \
		$(if $(STSLAVE_PATCHES),$(STSLAVE_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX:%23=%24)-target-$(STSLAVE)-$(STSLAVE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(STSLAVE_SPEC_PATCH),( cd SPECS && patch -p1 $(STSLAVE_SPEC) < ../Patches/$(STSLAVE_SPEC_PATCH) ) &&) \
	$(if $(STSLAVE_PATCHES),cp $(STSLAVE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(STSLAVE_SPEC)

if STM22
$(DEPDIR)/min-$(STSLAVE) $(DEPDIR)/std-$(STSLAVE) $(DEPDIR)/max-$(STSLAVE) $(DEPDIR)/$(STSLAVE): \
$(DEPDIR)/%$(STSLAVE): $(STSLAVE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
else !STM22
$(DEPDIR)/min-$(STSLAVE) $(DEPDIR)/std-$(STSLAVE) $(DEPDIR)/max-$(STSLAVE) $(DEPDIR)/$(STSLAVE): \
$(DEPDIR)/%$(STSLAVE): linux-kernel-headers binutils-dev $(STSLAVE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
endif !STM22

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
OPENSSL_SPEC := stm-target-$(OPENSSL).spec
OPENSSL_SPEC_PATCH :=
OPENSSL_PATCHES :=
else !STM22
if STM23
OPENSSL_VERSION := 0.9.8h-11
OPENSSL_SPEC := stm-target-$(OPENSSL).spec
OPENSSL_SPEC_PATCH :=
OPENSSL_PATCHES :=
else !STM23
# if STM24
OPENSSL_VERSION := 0.9.8l-16
OPENSSL_SPEC := stm-target-$(OPENSSL).spec
OPENSSL_SPEC_PATCH :=
OPENSSL_PATCHES :=
# endif STM24
endif !STM23
endif !STM22

OPENSSL_RPM := RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL)-$(OPENSSL_VERSION).sh4.rpm
OPENSSL_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL_DEV)-$(OPENSSL_VERSION).sh4.rpm

$(OPENSSL_RPM) $(OPENSSL_DEV_RPM): \
		$(if $(OPENSSL_SPEC_PATCH),Patches/$(OPENSSL_PATCH)) \
		$(if $(OPENSSL_PATCHES),$(OPENSSL_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(OPENSSL)-$(OPENSSL_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(OPENSSL_SPEC_PATCH),( cd SPECS && patch -p1 $(OPENSSL_SPEC) < ../Patches/$(OPENSSL_SPEC_PATCH) ) &&) \
	$(if $(OPENSSL_PATCHES),cp $(OPENSSL_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(OPENSSL_SPEC)

$(DEPDIR)/min-$(OPENSSL) $(DEPDIR)/std-$(OPENSSL) $(DEPDIR)/max-$(OPENSSL) $(DEPDIR)/$(OPENSSL): \
$(DEPDIR)/%$(OPENSSL): $(OPENSSL_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(OPENSSL_DEV) $(DEPDIR)/std-$(OPENSSL_DEV) $(DEPDIR)/max-$(OPENSSL_DEV) $(DEPDIR)/$(OPENSSL_DEV): \
$(DEPDIR)/%$(OPENSSL_DEV): %$(OPENSSL) $(OPENSSL_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# ALSALIB
#
ALSALIB := alsa-lib
ALSALIB_DEV := alsa-lib-dev
if STM22
ALSALIB_VERSION := 1.0.12-9
ALSALIB_SPEC := stm-target-$(ALSALIB)-sh4processed.spec
ALSALIB_SPEC_PATCH := stm-target-$(ALSALIB).spec22.diff
ALSALIB_PATCHES :=
else !STM22
if STM23
ALSALIB_VERSION := $(if $(STABLE),1.0.16-16,1.0.21a-22)
ALSALIB_SPEC := stm-target-$(ALSALIB).spec
ALSALIB_SPEC_PATCH := $(ALSALIB_SPEC)23.diff
ALSALIB_PATCHES :=
else !STM23
# if STM24
ALSALIB_VERSION := 1.0.21a-23
ALSALIB_SPEC := stm-target-$(ALSALIB).spec
ALSALIB_SPEC_PATCH :=
ALSALIB_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
ALSALIB_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB)-$(ALSALIB_VERSION).sh4.rpm
ALSALIB_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB_DEV)-$(ALSALIB_VERSION).sh4.rpm

$(ALSALIB_RPM) $(ALSALIB_DEV_RPM): \
		$(if $(ALSALIB_SPEC_PATCH),Patches/$(ALSALIB_SPEC_PATCH)) \
		$(if $(ALSALIB_PATCHES),$(ALSALIB_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(ALSALIB)-$(ALSALIB_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSALIB_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSALIB_SPEC) < ../Patches/$(ALSALIB_SPEC_PATCH) ) &&) \
	$(if $(ALSALIB_PATCHES),cp $(ALSALIB_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(ALSALIB_SPEC)

$(DEPDIR)/min-$(ALSALIB) $(DEPDIR)/std-$(ALSALIB) $(DEPDIR)/max-$(ALSALIB) $(DEPDIR)/$(ALSALIB): \
$(DEPDIR)/%$(ALSALIB): $(ALSALIB_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(ALSALIB_DEV) $(DEPDIR)/std-$(ALSALIB_DEV) $(DEPDIR)/max-$(ALSALIB_DEV) $(DEPDIR)/$(ALSALIB_DEV): \
$(DEPDIR)/%$(ALSALIB_DEV): %$(ALSALIB) $(ALSALIB_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-alsa-lib: $(flashprefix)/root/usr/bin/aserver

$(flashprefix)/root/usr/bin/aserver: $(ALSALIB_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	touch $@ && \
	@FLASHROOTDIR_MODIFIED@

#
# ALSAUTILS
#
ALSAUTILS := alsa-utils
if STM22
ALSAUTILS_VERSION := 1.0.12-7
ALSAUTILS_SPEC := stm-target-$(ALSAUTILS).spec
ALSAUTILS_SPEC_PATCH :=
ALSAUTILS_PATCHES :=
else !STM22
if STM23
ALSAUTILS_VERSION := $(if $(STABLE),1.0.16-14,1.0.21-17)
ALSAUTILS_SPEC := stm-target-$(ALSAUTILS).spec
ALSAUTILS_SPEC_PATCH := $(if $(STABLE),,$(ALSAUTILS_SPEC)23.diff)
ALSAUTILS_PATCHES :=
else !STM23
# if STM24
ALSAUTILS_VERSION := 1.0.16-16
ALSAUTILS_SPEC := stm-target-$(ALSAUTILS).spec
ALSAUTILS_SPEC_PATCH :=
ALSAUTILS_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
ALSAUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAUTILS)-$(ALSAUTILS_VERSION).sh4.rpm

$(ALSAUTILS_RPM): \
		$(if $(ALSAUTILS_SPEC_PATCH),Patches/$(ALSAUTILS_PATCH)) \
		$(if $(ALSAUTILS_PATCHES),$(ALSAUTILS_PATCHES:%=Patches/%)) \
		$(NCURSES_DEV) $(ALSALIB_DEV) \
		$(archivedir)/$(STLINUX)-target-$(ALSAUTILS)-$(ALSAUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSAUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSAUTILS_SPEC) < ../Patches/$(ALSAUTILS_SPEC_PATCH) ) &&) \
	$(if $(ALSAUTILS_PATCHES),cp $(ALSAUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(ALSAUTILS_SPEC)

$(DEPDIR)/min-$(ALSAUTILS) $(DEPDIR)/std-$(ALSAUTILS) $(DEPDIR)/max-$(ALSAUTILS) $(DEPDIR)/$(ALSAUTILS): \
$(DEPDIR)/%$(ALSAUTILS): $(ALSAUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-alsa-utils: $(flashprefix)/root/usr/bin/amixer

$(flashprefix)/root/usr/bin/amixer: $(ALSAUTILS_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
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
ALSAPLAYER_SPEC := stm-target-$(ALSAPLAYER).spec
ALSAPLAYER_SPEC_PATCH :=
ALSAPLAYER_PATCHES :=
else !STM22
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
ALSAPLAYER_VERSION := 0.99.77-16
ALSAPLAYER_SPEC := stm-target-$(ALSAPLAYER).spec
ALSAPLAYER_SPEC_PATCH :=
ALSAPLAYER_PATCHES :=
else !STM23
# if STM24
ALSAPLAYER_VERSION := 0.99.77-15
ALSAPLAYER_SPEC := stm-target-$(ALSAPLAYER).spec
ALSAPLAYER_SPEC_PATCH :=
ALSAPLAYER_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
ALSAPLAYER_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).sh4.rpm
ALSAPLAYER_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER_DEV)-$(ALSAPLAYER_VERSION).sh4.rpm

$(ALSAPLAYER_RPM) $(ALSAPLAYER_DEV_RPM): \
		$(if $(ALSAPLAYER_SPEC_PATCH),Patches/$(ALSAPLAYER_PATCH)) \
		$(if $(ALSAPLAYER_PATCHES),$(ALSAPLAYER_PATCHES:%=Patches/%)) \
		libmad libid3tag \
		$(archivedir)/$(STLINUX:%23=%24)-target-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSAPLAYER_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSAPLAYER_SPEC) < ../Patches/$(ALSAPLAYER_SPEC_PATCH) ) &&) \
	$(if $(ALSAPLAYER_PATCHES),cp $(ALSAPLAYER_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/include/pkgconfig && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(ALSAPLAYER_SPEC)

$(DEPDIR)/min-$(ALSAPLAYER) $(DEPDIR)/std-$(ALSAPLAYER) $(DEPDIR)/max-$(ALSAPLAYER) $(DEPDIR)/$(ALSAPLAYER): \
$(DEPDIR)/%$(ALSAPLAYER): $(ALSAPLAYER_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(ALSAPLAYER_DEV) $(DEPDIR)/std-$(ALSAPLAYER_DEV) $(DEPDIR)/max-$(ALSAPLAYER_DEV) $(DEPDIR)/$(ALSAPLAYER_DEV): \
$(DEPDIR)/%$(ALSAPLAYER_DEV): $(ALSAPLAYER_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-alsaplayer: $(flashprefix)/root/usr/bin/alsaplayer

$(flashprefix)/root/usr/bin/alsaplayer: $(ALSAPLAYER_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	touch $@ && \
	@FLASHROOTDIR_MODIFIED@

