#
# CONSOLE_DATA
#
$(DEPDIR)/console_data: bootstrap @DEPENDS_console_data@
	@PREPARE_console_data@
	cd @DIR_console_data@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=$(targetprefix) \
			--with-main_compressor=gzip && \
		@INSTALL_console_data@
#	@CLEANUP_console_data@
	touch $@

#
# SYSVINIT/INITSCRIPTS
#
SYSVINIT := sysvinit
INITSCRIPTS := initscripts
if STM22
SYSVINIT_VERSION := 2.86-6
SYSVINIT_SPEC := stm-target-$(SYSVINIT).spec
SYSVINIT_SPEC_PATCH :=
SYSVINIT_PATCHES :=
else !STM22
if STM23
SYSVINIT_VERSION := 2.86-9
SYSVINIT_SPEC := stm-target-$(SYSVINIT).spec
SYSVINIT_SPEC_PATCH :=
SYSVINIT_PATCHES :=
else !STM23
# if STM24
SYSVINIT_VERSION := 2.86-10
SYSVINIT_SPEC := stm-target-$(SYSVINIT).spec
SYSVINIT_SPEC_PATCH :=
SYSVINIT_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
SYSVINIT_RPM := RPMS/sh4/$(STLINUX)-sh4-$(SYSVINIT)-$(SYSVINIT_VERSION).sh4.rpm
INITSCRIPTS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(INITSCRIPTS)-$(SYSVINIT_VERSION).sh4.rpm

$(SYSVINIT_RPM) $(INITSCRIPTS_RPM): \
		$(if $(SYSVINIT_SPEC_PATCH),Patches/$(SYSVINIT_SPEC_PATCH)) \
		$(if $(SYSVINIT_PATCHES),$(SYSVINIT_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(SYSVINIT)-$(SYSVINIT_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(SYSVINIT_SPEC_PATCH),( cd SPECS && patch -p1 $(SYSVINIT_SPEC) < ../Patches/$(SYSVINIT_SPEC_PATCH) ) &&) \
	$(if $(SYSVINIT_PATCHES),cp $(SYSVINIT_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(SYSVINIT_SPEC)

$(DEPDIR)/min-$(SYSVINIT) $(DEPDIR)/std-$(SYSVINIT) $(DEPDIR)/max-$(SYSVINIT) \
$(DEPDIR)/$(SYSVINIT): \
$(DEPDIR)/%$(SYSVINIT): $(SYSVINIT_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(SYSVINIT_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc && for i in $(SYSVINIT_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done )
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-sysvinit: $(flashprefix)/root/etc/inittab

$(flashprefix)/root/etc/inittab: $(SYSVINIT_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(SYSVINIT_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	( cd root/etc && for i in $(SYSVINIT_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done )
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif TARGETRULESET_FLASH

$(DEPDIR)/min-$(INITSCRIPTS) $(DEPDIR)/std-$(INITSCRIPTS) $(DEPDIR)/max-$(INITSCRIPTS) \
$(DEPDIR)/$(INITSCRIPTS): \
$(DEPDIR)/%$(INITSCRIPTS): $(INITSCRIPTS_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(INITSCRIPTS_RPM) \
		| $(DEPDIR)/%filesystem
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --nopost -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd $(prefix)/$*cdkroot/etc/init.d/ && \
		sed -e "s|-uid 0 ||g" -i bootclean.sh && \
		sed -e "s|-empty ||g" -i bootclean.sh && \
		sed -e "s/chmod \-f/chmod/g" -i bootmisc.sh && \
		sed -e "s/chown \-f/chown/g" -i bootmisc.sh && \
		sed -e "s|/etc/nologin|/var/tmp/nologin|g" -i bootmisc.sh && \
		sed -e "s|PATH=/lib/init:/bin:/sbin|PATH=/lib/init:/bin:/sbin:/usr/bin:/usr/sbin|g" -i checkroot.sh && \
		sed -e "s/hostname \-\-file/hostname \-F/g" -i hostname.sh && \
		sed -e "s|PATH=/lib/init:/sbin:/bin|PATH=/lib/init:/bin:/sbin:/usr/bin:/usr/sbin|g" -i rmnologin && \
		sed -e "s|# chkconfig: 2345 99 0|# chkconfig: 2345 69 0|" -i rmnologin && \
		sed -e "s|readlink -f /etc/nologin|readlink -f /var/tmp/nologin|g" -i rmnologin ) 
	( cd $(prefix)/$*cdkroot/etc/default/ && \
		sed -e "s|EDITMOTD=yes|EDITMOTD=no|g" -i rcS )
	( cd root/etc && for i in $(INITSCRIPTS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) || true 
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in init.d/mountvirtfs bootlogd checkroot.sh checkfs.sh mountall.sh \
		hostname.sh mountnfs.sh bootmisc.sh urandom \
		sendsigs umountnfs.sh umountfs halt reboot \
		rmnologin single stop-bootlogd ; do \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ; done && rm *rpmsave *.orig 2>/dev/null || true )
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-initscripts: $(flashprefix)/root/etc/init.d/rc

$(flashprefix)/root/etc/init.d/rc: $(INITSCRIPTS_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(INITSCRIPTS_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts --nopost -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	( cd $(flashprefix)/root/etc/init.d/ && \
		sed -e "s|-uid 0 ||g" -i bootclean.sh && \
		sed -e "s|-empty ||g" -i bootclean.sh && \
		sed -e "s/chmod \-f/chmod/g" -i bootmisc.sh && \
		sed -e "s/chown \-f/chown/g" -i bootmisc.sh && \
		sed -e "s|/etc/nologin|/var/tmp/nologin|g" -i bootmisc.sh && \
		sed -e "s|PATH=/lib/init:/bin:/sbin|PATH=/lib/init:/bin:/sbin:/usr/bin:/usr/sbin|g" -i checkroot.sh && \
		sed -e "s/hostname \-\-file/hostname \-F/g" -i hostname.sh && \
		sed -e "s|PATH=/lib/init:/sbin:/bin|PATH=/lib/init:/bin:/sbin:/usr/bin:/usr/sbin|g" -i rmnologin && \
		sed -e "s|# chkconfig: 2345 99 0|# chkconfig: 2345 69 0|" -i rmnologin && \
		sed -e "s|readlink -f /etc/nologin|readlink -f /var/tmp/nologin|g" -i rmnologin ) 
	( cd $(flashprefix)/root/etc/default/ && \
		sed -e "s|EDITMOTD=yes|EDITMOTD=no|g" -i rcS )
	( cd root/etc && for i in $(INITSCRIPTS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && cd $(flashprefix)/root/etc/init.d && \
		for s in mountvirtfs bootlogd checkroot.sh checkfs.sh mountall.sh \
		hostname.sh mountnfs.sh bootmisc.sh urandom \
		sendsigs umountnfs.sh umountfs halt reboot \
		rmnologin single stop-bootlogd ; do \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ; done && rm *rpmsave *.orig 2>/dev/null || true )
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif TARGETRULESET_FLASH

#
# NETBASE
#
#ftp://ftp.stlinux.com/pub/stlinux/2.3/SRPMS/stlinux23-target-netbase-4.07-5.src.rpm
NETBASE := netbase
if STM22
NETBASE_VERSION := 4.07-4
NETBASE_SPEC := stm-target-$(NETBASE).spec
NETBASE_SPEC_PATCHES :=
NETBASE_PATCHES :=
else !STM22
if STM23
NETBASE_VERSION := 4.34-7
NETBASE_SPEC := stm-target-$(NETBASE).spec
NETBASE_SPEC_PATCHES :=
NETBASE_PATCHES :=
else !STM23
# if STM24
NETBASE_VERSION := 4.34-8
NETBASE_SPEC := stm-target-$(NETBASE).spec
NETBASE_SPEC_PATCHES :=
NETBASE_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
NETBASE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(NETBASE)-$(NETBASE_VERSION).sh4.rpm

$(NETBASE_RPM): \
		$(if $(NETBASE_SPEC_PATCH),Patches/$(NETBASE_SPEC_PATCH)) \
		$(if $(NETBASE_PATCHES),$(NETBASE_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(NETBASE)-$(NETBASE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	$(if $(NETBASE_SPEC_PATCH),( cd SPECS && patch -p1 $(NETBASE_SPEC) < ../Patches/$(NETBASE_PATCH) ) &&) \
	$(if $(NETBASE_PATCHES),cp $(NETBASE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(NETBASE).spec

$(DEPDIR)/min-$(NETBASE) $(DEPDIR)/std-$(NETBASE) $(DEPDIR)/max-$(NETBASE) \
$(DEPDIR)/$(NETBASE): \
$(DEPDIR)/%$(NETBASE): \
		$(NETBASE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --nopost -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc/network && $(INSTALL) interfaces $(prefix)/$*cdkroot/etc/network/interfaces || true ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in networking ; do \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ; \
		done && rm *rpmsave 2>/dev/null || true ) && \
	( cd $(prefix)/$*cdkroot/etc/network && \
		for i in if-down.d if-post-down.d if-pre-up.d if-up.d run; do \
			$(INSTALL) -d $$i; \
		done )
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-netbase: $(flashprefix)/root/etc/init.d/networking

$(flashprefix)/root/etc/init.d/networking: $(NETBASE_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(NETBASE_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	( cd root/etc && for i in $(NETBASE_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && cd $(flashprefix)/root/etc/init.d && \
		for s in networking ; do \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ; \
		done && rm *rpmsave 2>/dev/null || true ) && \
	( cd $(flashprefix)/root/etc/network && \
		for i in if-down.d if-post-down.d if-pre-up.d if-up.d run; do \
			$(INSTALL) -d $$i; \
		done )
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif TARGETRULESET_FLASH

#
# BC
#
#ftp://ftp.stlinux.com/pub/stlinux/2.3/SRPMS/stlinux23-target-bc-1.06-4.src.rpm
BC := bc
if STM22
BC_VERSION := 1.06-3
BC_SPEC := stm-target-$(BC).spec
BC_SPEC_PATCH :=
BC_PATCHES :=
else !STM22
if STM23
BC_VERSION := 1.06-4
BC_SPEC := stm-target-$(BC).spec
BC_SPEC_PATCH :=
BC_PATCHES :=
else !STM23
# if STM24
BC_VERSION := 1.06-5
BC_SPEC := stm-target-$(BC).spec
BC_SPEC_PATCH :=
BC_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
BC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BC)-$(BC_VERSION).sh4.rpm

$(BC_RPM): \
		$(if $(BC_SPEC_PATCH),Patches/$(BC_SPEC_PATCH)) \
		$(if $(BC_PATCHES),$(BC_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(BC)-$(BC_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BC_SPEC_PATCH),( cd SPECS && patch -p1 $(BC_SPEC) < ../Patches/$(BC_PATCH) ) &&) \
	$(if $(BC_PATCHES),cp $(BC_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BC_SPEC)

$(DEPDIR)/min-$(BC) $(DEPDIR)/std-$(BC) $(DEPDIR)/max-$(BC) \
$(DEPDIR)/$(BC): \
$(DEPDIR)/%$(BC): $(BC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-bc: $(flashprefix)/root/usr/bin/bc

$(flashprefix)/root/usr/bin/bc: $(BC_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif TARGETRULESET_FLASH

#
# FINDUTILS
#
FINDUTILS := findutils
if STM22
FINDUTILS_VERSION := 4.1.7-4
FINDUTILS_SPEC := stm-target-$(FINDUTILS).spec
FINDUTILS_SPEC_PATCH :=
FINDUTILS_PATCHES := 
else !STM22
if STM23
FINDUTILS_VERSION := 4.1.7-4
FINDUTILS_SPEC := stm-target-$(FINDUTILS).spec
FINDUTILS_SPEC_PATCH :=
FINDUTILS_PATCHES := 
else !STM23
# if STM24
FINDUTILS_VERSION := 4.1.20-13
FINDUTILS_SPEC := stm-target-$(FINDUTILS).spec
FINDUTILS_SPEC_PATCH :=
FINDUTILS_PATCHES := 
# endif STM24
endif !STM23
endif !STM22
FINDUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(FINDUTILS)-$(FINDUTILS_VERSION).sh4.rpm

$(FINDUTILS_RPM): \
		$(if $(FINDUTILS_SPEC_PATCH),Patches/$(FINDUTILS_SPEC_PATCH)) \
		$(if $(FINDUTILS_PATCHES),$(FINDUTILS_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(FINDUTILS)-$(FINDUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(FINDUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(FINDUTILS_SPEC) < ../Patches/$(FINDUTILS_PATCH) ) &&) \
	$(if $(FINDUTILS_PATCHES),cp $(FINDUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(FINDUTILS_SPEC)

$(DEPDIR)/min-$(FINDUTILS) $(DEPDIR)/std-$(FINDUTILS) $(DEPDIR)/max-$(FINDUTILS) $(DEPDIR)/$(FINDUTILS): \
$(DEPDIR)/%$(FINDUTILS): $(FINDUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $<
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-findutils: $(flashprefix)/root/usr/bin/find

$(flashprefix)/root/usr/bin/find: RPMS/sh4/$(STLINUX)-sh4-$(FINDUTILS)-$(FINDUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@

#
# DISTRIBUTIONUTILS
#
DISTRIBUTIONUTILS := distributionutils
DISTRIBUTIONUTILS_DOC := distributionutils-doc
if STM22
DISTRIBUTIONUTILS_VERSION := 2.17-6
DISTRIBUTIONUTILS_SPEC := stm-target-$(DISTRIBUTIONUTILS).spec
DISTRIBUTIONUTILS_SPEC_PATCH := $(DISTRIBUTIONUTILS_SPEC)22.diff
DISTRIBUTIONUTILS_PATCHES :=
else !STM22
if STM23
DISTRIBUTIONUTILS_VERSION := 2.17-7
DISTRIBUTIONUTILS_SPEC := stm-target-$(DISTRIBUTIONUTILS).spec
DISTRIBUTIONUTILS_SPEC_PATCH := $(DISTRIBUTIONUTILS_SPEC)23.diff
DISTRIBUTIONUTILS_PATCHES :=
else !STM23
# if STM24
DISTRIBUTIONUTILS_VERSION := 3.2.1-9
DISTRIBUTIONUTILS_SPEC := stm-target-$(DISTRIBUTIONUTILS).spec
DISTRIBUTIONUTILS_SPEC_PATCH :=
DISTRIBUTIONUTILS_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
DISTRIBUTIONUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm
DISTRIBUTIONUTILS_DOC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS_DOC)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm


$(DISTRIBUTIONUTILS_RPM) $(DISTRIBUTIONUTILS_DOC_RPM): \
		$(if $(DISTRIBUTIONUTILS_SPEC_PATCH),Patches/$(DISTRIBUTIONUTILS_SPEC_PATCH)) \
		$(if $(DISTRIBUTIONUTILS_PATCHES),$(DISTRIBUTIONUTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).src.rpm \
		| $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(DISTRIBUTIONUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(DISTRIBUTIONUTILS_SPEC) < ../Patches/$(DISTRIBUTIONUTILS_SPEC_PATCH) ) &&) \
	$(if $(DISTRIBUTIONUTILS_PATCHES),cp $(DISTRIBUTIONUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(DISTRIBUTIONUTILS_SPEC)

$(DEPDIR)/min-$(DISTRIBUTIONUTILS) $(DEPDIR)/std-$(DISTRIBUTIONUTILS) $(DEPDIR)/max-$(DISTRIBUTIONUTILS) \
$(DEPDIR)/$(DISTRIBUTIONUTILS): \
$(DEPDIR)/%$(DISTRIBUTIONUTILS): $(DISTRIBUTIONUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(DISTRIBUTIONUTILS_DOC) $(DEPDIR)/std-$(DISTRIBUTIONUTILS_DOC) $(DEPDIR)/max-$(DISTRIBUTIONUTILS_DOC) \
$(DEPDIR)/$(DISTRIBUTIONUTILS_DOC): \
$(DEPDIR)/%$(DISTRIBUTIONUTILS_DOC): $(DISTRIBUTIONUTILS_DOC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true

if TARGETRULESET_FLASH
flash-distributionutils: $(flashprefix)/root/usr/sbin/initdconfig

$(flashprefix)/root/usr/sbin/initdconfig: $(DISTRIBUTIONUTILS_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif TARGETRULESET_FLASH

#
# HOST-MTD-UTILS
#
MTD_UTILS := mtd-utils
if STM22
MTD_UTILS_VERSION := 1.0.1-9
MTD_UTILS_SPEC := stm-target-$(MTD_UTILS).spec
MTD_UTILS_SPEC_PATCH :=
MTD_UTILS_PATCHES :=
else !STM22
if STM23
MTD_UTILS_VERSION := 1.0.1-9
MTD_UTILS_SPEC := stm-target-$(MTD_UTILS).spec
MTD_UTILS_SPEC_PATCH :=
MTD_UTILS_PATCHES :=
else !STM23
# if STM24
MTD_UTILS_VERSION := TODO
MTD_UTILS_SPEC := stm-target-$(MTD_UTILS).spec
MTD_UTILS_SPEC_PATCH :=
MTD_UTILS_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
MTD_UTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(MTD_UTILS)-$(MTD_UTILS_VERSION).sh4.rpm

$(MTD_UTILS_RPM): \
		$(if $(MTD_UTILS_SPEC_PATCH),Patches/$(MTD_UTILS_SPEC_PATCH)) \
		$(if $(MTD_UTILS_PATCHES),$(MTD_UTILS_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(MTD_UTILS)-$(MTD_UTILS_VERSION).src.rpm libz
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(MTD_UTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(MTD_UTILS_SPEC) < ../Patches/$(MTD_UTILS_PATCH) ) &&) \
	$(if $(MTD_UTILS_PATCHES),cp $(MTD_UTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(MTD_UTILS_SPEC)

$(DEPDIR)/min-$(MTD_UTILS) $(DEPDIR)/std-$(MTD_UTILS) $(DEPDIR)/max-$(MTD_UTILS) \
$(DEPDIR)/$(MTD_UTILS): \
$(DEPDIR)/%$(MTD_UTILS): $(MTD_UTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-mtd-utils: $(flashprefix)/root/usr/sbin/flash_info

$(flashprefix)/root/usr/sbin/flash_info: $(MTD_UTILS_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	rm -rf $(flashprefix)/root/usr/share && \
	rm $(flashprefix)/root/usr/sbin/{doc_loadbios,docfdisk,flash_otp_dump,flash_otp_info,ftl_check,ftl_format} && \
	rm $(flashprefix)/root/usr/sbin/{jffs2dump,mkfs.jffs,mkfs.jffs2,nanddump,nandwrite,nftl_format,nftldump,rfddump,rfdformat,sumtool}
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif TARGETRULESET_FLASH


##################################################################################################

#
# BASH
#
BASH := bash
if STM22
BASH_VERSION := 3.0-6
BASH_SPEC := stm-target-$(BASH).spec
BASH_SPEC_PATCH := $(BASH_SPEC).diff
BASH_PATCHES :=
else !STM22
if STM23
BASH_VERSION := 3.0-6
BASH_SPEC := stm-target-$(BASH).spec
BASH_SPEC_PATCH := $(BASH_SPEC).diff
BASH_PATCHES :=
else !STM23
# if STM24
BASH_VERSION := 3.0-16
BASH_SPEC := stm-target-$(BASH).spec
BASH_SPEC_PATCH :=
BASH_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
BASH_RPM := RPMS/sh4/$(STLINUX)-sh4-$(BASH)-$(BASH_VERSION).sh4.rpm

$(BASH_RPM): \
		$(if $(BASH_SPEC_PATCH),Patches/$(BASH_SPEC_PATCH)) \
		$(if $(BASH_PATCHES),$(BASH_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(DEPDIR)/$(LIBTERMCAP_DEV) \
		$(archivedir)/$(STLINUX)-target-$(BASH)-$(BASH_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(BASH_SPEC_PATCH),( cd SPECS && patch -p1 $(BASH_SPEC) < ../Patches/$(BASH_PATCH) ) &&) \
	$(if $(BASH_PATCHES),cp $(BASH_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(BASH_SPEC)

$(DEPDIR)/min-$(BASH) $(DEPDIR)/std-$(BASH) $(DEPDIR)/max-$(BASH) $(DEPDIR)/$(BASH): \
$(DEPDIR)/%$(BASH): $(DEPDIR)/%$(GLIBC) $(DEPDIR)/%$(LIBTERMCAP) $(BASH_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts --force -Uhvv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

min-$(BASH).do_clean std-$(BASH).do_clean max-$(BASH).do_clean $(BASH).do_clean: \
%$(BASH).do_clean:
	export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && \
	$(hostprefix)/bin/target-shellconfig --list || true && \
	( $(hostprefix)/bin/target-shellconfig --del /bin/bash ) &> /dev/null || echo "Unable to unregister shell" && \
	$(hostprefix)/bin/target-shellconfig --list && \
	rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) -ev --noscripts $(STLINUX)-sh4-$(BASH) || true && \
	[ "x$*" = "x" ] && [ -f .deps/$(subst -clean,,$@) ] && rm .deps/$(subst -clean,,$@) || true

#
# COREUTILS
#
COREUTILS := coreutils
if STM22
COREUTILS_VERSION := 5.2.1-9
COREUTILS_SPEC := stm-target-$(COREUTILS).spec 
COREUTILS_SPEC_PATCH := $(COREUTILS_SPEC).diff
COREUTILS_PATCHES := 
else !STM22
if STM23
COREUTILS_VERSION := 5.2.1-9
COREUTILS_SPEC := stm-target-$(COREUTILS).spec 
COREUTILS_SPEC_PATCH := $(COREUTILS_SPEC).diff
COREUTILS_PATCHES := 
else !STM23
# if STM24
COREUTILS_VERSION := 5.2.1-14
COREUTILS_SPEC := stm-target-$(COREUTILS).spec 
COREUTILS_SPEC_PATCH :=
COREUTILS_PATCHES := 
# endif STM24
endif !STM23
endif !STM22
COREUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(COREUTILS)-$(COREUTILS_VERSION).sh4.rpm

$(COREUTILS_RPM): \
		$(if $(COREUTILS_SPEC_PATCH),Patches/$(COREUTILS_SPEC_PATCH)) \
		$(if $(COREUTILS_PATCHES),$(COREUTILS_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(COREUTILS)-$(COREUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(COREUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(COREUTILS_SPEC) < ../Patches/$(COREUTILS_PATCH) ) &&) \
	$(if $(COREUTILS_PATCHES),cp $(COREUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(COREUTILS_SPEC)

$(DEPDIR)/min-$(COREUTILS) $(DEPDIR)/std-$(COREUTILS) $(DEPDIR)/max-$(COREUTILS) $(DEPDIR)/$(COREUTILS): \
$(DEPDIR)/%$(COREUTILS): $(DEPDIR)/%$(GLIBC) $(COREUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# NET-TOOLS
#
NET_TOOLS := net-tools
if STM22
NET_TOOLS_VERSION := 1.60-4
NET_TOOLS_SPEC := stm-target-$(NET_TOOLS).spec
NET_TOOLS_SPEC_PATCH :=
NET_TOOLS_PATCHES :=
else !STM22
if STM23
NET_TOOLS_VERSION := 1.60-4
NET_TOOLS_SPEC := stm-target-$(NET_TOOLS).spec
NET_TOOLS_SPEC_PATCH :=
NET_TOOLS_PATCHES :=
else !STM23
# if STM24
NET_TOOLS_VERSION := 1.60-9
NET_TOOLS_SPEC := stm-target-$(NET_TOOLS).spec
NET_TOOLS_SPEC_PATCH :=
NET_TOOLS_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
NET_TOOLS_RPM = RPMS/sh4/$(STLINUX)-sh4-$(NET_TOOLS)-$(NET_TOOLS_VERSION).sh4.rpm

$(NET_TOOLS_RPM): \
		$(if $(NET_TOOLS_SPEC_PATCH),Patches/$(NET_TOOLS_SPEC_PATCH)) \
		$(if $(NET_TOOLS_PATCHES),$(NET_TOOLS_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(NET_TOOLS)-$(NET_TOOLS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(NET_TOOLS_SPEC_PATCH),( cd SPECS && patch -p1 $(NET_TOOLS_SPEC) < ../Patches/$(NET_TOOLS_PATCH) ) &&) \
	$(if $(NET_TOOLS_PATCHES),cp $(NET_TOOLS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(NET_TOOLS_SPEC)

$(DEPDIR)/min-$(NET_TOOLS) $(DEPDIR)/std-$(NET_TOOLS) $(DEPDIR)/max-$(NET_TOOLS) $(DEPDIR)/$(NET_TOOLS): \
$(DEPDIR)/%$(NET_TOOLS): $(DEPDIR)/%$(GLIBC) $(NET_TOOLS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# SED
#
SEDX := sed
if STM22
SED_VERSION := 4.0.7-6
SED_SPEC := stm-target-$(SEDX).spec
SED_SPEC_PATCH :=
SED_PATCHES :=
else !STM22
if STM23
SED_VERSION := 4.0.7-6
SED_SPEC := stm-target-$(SEDX).spec
SED_SPEC_PATCH :=
SED_PATCHES :=
else !STM23
# if STM24
SED_VERSION := 4.1.5-13
SED_SPEC := stm-target-$(SEDX).spec
SED_SPEC_PATCH :=
SED_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
SED_RPM = RPMS/sh4/$(STLINUX)-sh4-$(SEDX)-$(SED_VERSION).sh4.rpm

$(SED_RPM): \
		$(if $(SED_SPEC_PATCH),Patches/$(SED_SPEC_PATCH)) \
		$(if $(SED_PATCHES),$(SED_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(SEDX)-$(SED_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(SED_SPEC_PATCH),( cd SPECS && patch -p1 $(SED_SPEC) < ../Patches/$(SED_PATCH) ) &&) \
	$(if $(SED_PATCHES),cp $(SED_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(SED_SPEC)

$(DEPDIR)/min-$(SEDX) $(DEPDIR)/std-$(SEDX) $(DEPDIR)/max-$(SEDX) $(DEPDIR)/$(SEDX): \
$(DEPDIR)/%$(SEDX): $(DEPDIR)/%$(GLIBC) $(SED_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# DIFF
#
DIFF := diff
DIFF_DOC := diff-doc
if STM22
DIFF_VERSION := 2.7-3
DIFF_SPEC := stm-target-$(DIFF).spec
DIFF_SPEC_PATCH :=
DIFF_PATCHES :=
else !STM22
if STM23
DIFF_VERSION := 2.7-3
DIFF_SPEC := stm-target-$(DIFF).spec
DIFF_SPEC_PATCH :=
DIFF_PATCHES :=
else !STM23
# if STM24
DIFF_VERSION := 2.8.1-10
DIFF_SPEC := stm-target-$(DIFF).spec
DIFF_SPEC_PATCH :=
DIFF_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
DIFF_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DIFF)-$(DIFF_VERSION).sh4.rpm
DIFF_DOC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(DIFF)-doc-$(SED_VERSION).sh4.rpm

$(DIFF_RPM) $(DIFF_DOC_RPM): \
		$(if $(DIFF_SPEC_PATCH),Patches/$(DIFF_SPEC_PATCH)) \
		$(if $(DIFF_PATCHES),$(DIFF_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(DIFF)-$(DIFF_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(DIFF_SPEC_PATCH),( cd SPECS && patch -p1 $(DIFF_SPEC) < ../Patches/$(DIFF_PATCH) ) &&) \
	$(if $(DIFF_PATCHES),cp $(DIFF_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(DIFF_SPEC)

$(DEPDIR)/min-$(DIFF) $(DEPDIR)/std-$(DIFF) $(DEPDIR)/max-$(DIFF) $(DEPDIR)/$(DIFF): \
$(DEPDIR)/%$(DIFF): $(DEPDIR)/%$(GLIBC) $(DIFF_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) .deps/$(notdir $@) || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(DIFF_DOC) $(DEPDIR)/std-$(DIFF_DOC) $(DEPDIR)/max-$(DIFF_DOC) $(DEPDIR)/$(DIFF_DOC): \
$(DEPDIR)/%$(DIFF_DOC): $(DIFF_DOC_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# FILE
#
FILE := file
if STM22
FILE_VERSION := 4.17-3
FILE_SPEC := stm-target-$(FILE).spec
FILE_SPEC_PATCH := $(FILE_SPEC).diff
FILE_PATCHES :=
else !STM22
if STM23
FILE_VERSION := 4.17-3
FILE_SPEC := stm-target-$(FILE).spec
FILE_SPEC_PATCH := $(FILE_SPEC).diff
FILE_PATCHES :=
else !STM23
# if STM24
FILE_VERSION := 4.17-7
FILE_SPEC := stm-target-$(FILE).spec
FILE_SPEC_PATCH :=
FILE_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
FILE_RPM := RPMS/sh4/stlinux20-sh4-file-4.17-3.sh4.rpm

$(FILE_RPM): \
		$(if $(FILE_SPEC_PATCH),Patches/$(FILE_SPEC_PATCH)) \
		$(if $(FILE_PATCHES),$(FILE_PATCHES:%=Patches/%)) \
		$(archivedir)/stlinux22-target-$(FILE)-$(FILE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(FILE_SPEC_PATCH),( cd SPECS && patch -p1 $(FILE_SPEC) < ../Patches/$(FILE_PATCH) ) &&) \
	$(if $(FILE_PATCHES),cp $(FILE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(FILE_SPEC)

$(DEPDIR)/min-$(FILE) $(DEPDIR)/std-$(FILE) $(DEPDIR)/max-$(FILE) $(DEPDIR)/$(FILE): \
$(DEPDIR)/%$(FILE): $(FILE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# TAR
#
TAR := tar
if STM22
TAR_VERSION := 1.16.1-7
TAR_SPEC := stm-target-$(TAR).spec
TAR_SPEC_PATCH := $(TAR_SPEC).diff
TAR_PATCHES :=
else !STM22
if STM23
TAR_VERSION := 1.16.1-7
TAR_SPEC := stm-target-$(TAR).spec
TAR_SPEC_PATCH := $(TAR_SPEC).diff
TAR_PATCHES :=
else !STM23
# if STM24
TAR_VERSION := 1.18-11
TAR_SPEC := stm-target-$(TAR).spec
TAR_SPEC_PATCH :=
TAR_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
TAR_RPM := RPMS/sh4/$(STLINUX)-sh4-$(TAR)-$(TAR_VERSION).sh4.rpm

$(TAR_RPM): \
		$(if $(TAR_SPEC_PATCH),Patches/$(TAR_SPEC_PATCH)) \
		$(if $(TAR_PATCHES),$(TAR_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(TAR)-$(TAR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(TAR_SPEC_PATCH),( cd SPECS && patch -p1 $(TAR_SPEC) < ../Patches/$(TAR_PATCH) ) &&) \
	$(if $(TAR_PATCHES),cp $(TAR_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(TAR_SPEC)

$(DEPDIR)/min-$(TAR) $(DEPDIR)/std-$(TAR) $(DEPDIR)/max-$(TAR) $(DEPDIR)/$(TAR): \
$(DEPDIR)/%$(TAR): $(DEPDIR)/%$(GLIBC) $(TAR_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# STRACE
#
STRACE := strace
if STM22
STRACE_VERSION := 4.5.14-10
STRACE_SPEC := stm-target-$(STRACE).spec
STRACE_SPEC_PATCH :=
STRACE_PATCHES :=
else !STM22
if STM23
STRACE_VERSION := 4.5.14-10
STRACE_SPEC := stm-target-$(STRACE).spec
STRACE_SPEC_PATCH :=
STRACE_PATCHES :=
else !STM23
# if STM24
STRACE_VERSION := 4.5.16-21
STRACE_SPEC := stm-target-$(STRACE).spec
STRACE_SPEC_PATCH :=
STRACE_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
STRACE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(STRACE)-$(STRACE_VERSION).sh4.rpm

$(STRACE_RPM): \
		$(if $(STRACE_SPEC_PATCH),Patches/$(STRACE_SPEC_PATCH)) \
		$(if $(STRACE_PATCHES),$(STRACE_PATCHES:%=Patches/%)) \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(archivedir)/$(STLINUX)-target-$(STRACE)-$(STRACE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(STRACE_SPEC_PATCH),( cd SPECS && patch -p1 $(STRACE_SPEC) < ../Patches/$(STRACE_PATCH) ) &&) \
	$(if $(STRACE_PATCHES),cp $(STRACE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(STRACE_SPEC)

$(DEPDIR)/min-$(STRACE) $(DEPDIR)/std-$(STRACE) $(DEPDIR)/max-$(STRACE) $(DEPDIR)/$(STRACE): \
$(DEPDIR)/%$(STRACE): $(DEPDIR)/%$(GLIBC) $(STRACE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force --noscripts -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-strace: $(flashprefix)/root/usr/bin/strace

$(flashprefix)/root/usr/bin/strace: $(STRACE_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@

#
# UTIL LINUX
# 
if STM24
UTIL_LINUX = util-linux
UTIL_LINUX_VERSION = 2.16.1-22
UTIL_LINUX_SPEC = stm-target-$(UTIL_LINUX).spec
UTIL_LINUX_SPEC_PATCH =
UTIL_LINUX_PATCHES =
UTIL_LINUX_RPM := RPMS/sh4/$(STLINUX)-sh4-$(UTIL_LINUX)-$(UTIL_LINUX_VERSION).sh4.rpm

$(UTIL_LINUX_RPM): \
		$(if $(UTIL_LINUX_SPEC_PATCH),Patches/$(UTIL_LINUX_SPEC_PATCH)) \
		$(if $(UTIL_LINUX_PATCHES),$(UTIL_LINUX_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(UTIL_LINUX)-$(UTIL_LINUX_VERSION).src.rpm \
		| $(NCURSES_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(UTIL_LINUX_SPEC_PATCH),( cd SPECS && patch -p1 $(UTIL_LINUX_SPEC) < ../Patches/$(UTIL_LINUX_SPEC_PATCH) ) &&) \
	$(if $(UTIL_LINUX_PATCHES),cp $(UTIL_LINUX_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(UTIL_LINUX_SPEC)

$(DEPDIR)/$(UTIL_LINUX): $(UTIL_LINUX_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	$(REWRITE_PKGCONF) $(PKG_CONFIG_PATH)/uuid.pc
	$(REWRITE_PKGCONF) $(PKG_CONFIG_PATH)/blkid.pc
	$(REWRITE_LIBDEP)/lib{blkid,uuid}.la
	$(REWRITE_LIBDIR)/lib{blkid,uuid}.la
	@TUXBOX_YAUD_CUSTOMIZE@
endif STM24

##################################################################################################


.PHONY: flash-tcp-wrappers
