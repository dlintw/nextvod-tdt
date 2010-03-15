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
# GREP
#
GREP		:= xgrep
#GREP_VERSION	:= 2.5.1-5
GREP_VERSION	:= 2.5.1-7

RPMS/sh4/stlinux23-sh4-$(GREP)-$(GREP_VERSION).sh4.rpm: \
		Archive/stlinux23-target-$(GREP)-$(GREP_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(GREP).spec
#	( cd SPECS; patch -p1 stm-target-grep.spec < ../Patches/stm-target-grep.spec.diff ) && \
#

$(DEPDIR)/min-$(GREP) $(DEPDIR)/std-$(GREP) $(DEPDIR)/max-$(GREP) $(DEPDIR)/$(GREP): \
$(DEPDIR)/%$(GREP): RPMS/sh4/stlinux23-sh4-$(GREP)-$(GREP_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-xgrep: $(flashprefix)/root/bin/grep

$(flashprefix)/root/bin/grep: RPMS/sh4/stlinux23-sh4-$(GREP)-$(GREP_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@

#
# SYSVINIT/INITSCRIPTS
#
SYSVINIT	:= sysvinit
INITSCRIPTS	:= initscripts

if STM22
SYSVINIT_VERSION	:= 2.86-6
INITSCRIPTS_VERSION	:= 2.86-6

RPMS/sh4/$(STLINUX)-sh4-$(SYSVINIT)-$(SYSVINIT_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(INITSCRIPTS)-$(INITSCRIPTS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(SYSVINIT)-$(SYSVINIT_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-target-$(SYSVINIT).spec < ../Patches/stm-target-$(SYSVINIT).spec22.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(SYSVINIT).spec
else
SYSVINIT_VERSION := 2.86-9
INITSCRIPTS_VERSION	:= 2.86-9

RPMS/sh4/$(STLINUX)-sh4-$(SYSVINIT)-$(SYSVINIT_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(INITSCRIPTS)-$(INITSCRIPTS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(SYSVINIT)-$(SYSVINIT_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-target-$(SYSVINIT).spec < ../Patches/stm-target-$(SYSVINIT).spec23.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(SYSVINIT).spec
endif

$(DEPDIR)/min-$(SYSVINIT) $(DEPDIR)/std-$(SYSVINIT) $(DEPDIR)/max-$(SYSVINIT) \
$(DEPDIR)/$(SYSVINIT): \
$(DEPDIR)/%$(SYSVINIT): $(SYSVINIT_ADAPTED_ETC_FILES:%=root/etc/%) \
		RPMS/sh4/$(STLINUX)-sh4-$(SYSVINIT)-$(SYSVINIT_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc && for i in $(SYSVINIT_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done )
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-sysvinit: $(flashprefix)/root/etc/inittab

$(flashprefix)/root/etc/inittab: $(SYSVINIT_ADAPTED_ETC_FILES:%=root/etc/%) \
		RPMS/sh4/$(STLINUX)-sh4-$(SYSVINIT)-$(SYSVINIT_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	( cd root/etc && for i in $(SYSVINIT_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done )
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

$(DEPDIR)/min-$(INITSCRIPTS) $(DEPDIR)/std-$(INITSCRIPTS) $(DEPDIR)/max-$(INITSCRIPTS) \
$(DEPDIR)/$(INITSCRIPTS): \
$(DEPDIR)/%$(INITSCRIPTS): $(INITSCRIPTS_ADAPTED_ETC_FILES:%=root/etc/%) \
		RPMS/sh4/$(STLINUX)-sh4-$(INITSCRIPTS)-$(INITSCRIPTS_VERSION).sh4.rpm \
		| $(DEPDIR)/%filesystem
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --nopost -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
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
		RPMS/sh4/$(STLINUX)-sh4-$(INITSCRIPTS)-$(INITSCRIPTS_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts --nopost -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
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
endif

#
# NETBASE
#
#ftp://ftp.stlinux.com/pub/stlinux/2.3/SRPMS/stlinux23-target-netbase-4.07-5.src.rpm
NETBASE := netbase

if STM22
NETBASE_VERSION := 4.07-4

RPMS/sh4/$(STLINUX)-sh4-$(NETBASE)-$(NETBASE_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(NETBASE)-$(NETBASE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(NETBASE).spec
else
NETBASE_VERSION := 4.34-7

RPMS/sh4/$(STLINUX)-sh4-$(NETBASE)-$(NETBASE_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(NETBASE)-$(NETBASE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(NETBASE).spec
endif

$(DEPDIR)/min-$(NETBASE) $(DEPDIR)/std-$(NETBASE) $(DEPDIR)/max-$(NETBASE) \
$(DEPDIR)/$(NETBASE): \
$(DEPDIR)/%$(NETBASE): \
		RPMS/sh4/$(STLINUX)-sh4-$(NETBASE)-$(NETBASE_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --nopost -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc/network && $(INSTALL) interfaces_yaud $(prefix)/$*cdkroot/etc/network/interfaces || true ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in networking ; do \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ; done && rm *rpmsave 2>/dev/null || true ) && \
	( cd $(prefix)/$*cdkroot/etc/network && \
		for i in if-down.d if-post-down.d if-pre-up.d if-up.d run; do \
			$(INSTALL) -d $$i; done )
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-netbase: $(flashprefix)/root/etc/init.d/networking

$(flashprefix)/root/etc/init.d/networking: $(NETBASE_ADAPTED_ETC_FILES:%=root/etc/%) \
		RPMS/sh4/$(STLINUX)-sh4-$(NETBASE)-$(NETBASE_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	( cd root/etc && for i in $(NETBASE_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && cd $(flashprefix)/root/etc/init.d && \
		for s in networking ; do \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ; done && rm *rpmsave 2>/dev/null || true ) && \
	( cd $(flashprefix)/root/etc/network && \
		for i in if-down.d if-post-down.d if-pre-up.d if-up.d run; do \
			$(INSTALL) -d $$i; done )
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

#
# BC
#
#ftp://ftp.stlinux.com/pub/stlinux/2.3/SRPMS/stlinux23-target-bc-1.06-4.src.rpm
BC := bc

if STM22
BC_VERSION := 1.06-3

RPMS/sh4/$(STLINUX)-sh4-$(BC)-$(BC_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(BC)-$(BC_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(BC).spec
else
BC_VERSION := 1.06-4

RPMS/sh4/$(STLINUX)-sh4-$(BC)-$(BC_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(BC)-$(BC_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(BC).spec
endif

$(DEPDIR)/min-$(BC) $(DEPDIR)/std-$(BC) $(DEPDIR)/max-$(BC) \
$(DEPDIR)/$(BC): \
$(DEPDIR)/%$(BC): RPMS/sh4/$(STLINUX)-sh4-$(BC)-$(BC_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-bc: $(flashprefix)/root/usr/bin/bc

$(flashprefix)/root/usr/bin/bc: RPMS/sh4/$(STLINUX)-sh4-$(BC)-$(BC_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

#
# FINDUTILS
#
FINDUTILS := findutils
FINDUTILS_VERSION := 4.1.7-4

RPMS/sh4/stlinux20-sh4-$(FINDUTILS)-$(FINDUTILS_VERSION).sh4.rpm: \
		Archive/stlinux20-target-$(FINDUTILS)-$(FINDUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $< && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(FINDUTILS).spec

$(DEPDIR)/min-$(FINDUTILS) $(DEPDIR)/std-$(FINDUTILS) $(DEPDIR)/max-$(FINDUTILS) $(DEPDIR)/$(FINDUTILS): \
$(DEPDIR)/%$(FINDUTILS): RPMS/sh4/stlinux20-sh4-$(FINDUTILS)-$(FINDUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $<
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-findutils: $(flashprefix)/root/usr/bin/find

$(flashprefix)/root/usr/bin/find: RPMS/sh4/stlinux20-sh4-$(FINDUTILS)-$(FINDUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@

#
# DISTRIBUTIONUTILS
#
DISTRIBUTIONUTILS := distributionutils
DISTRIBUTIONUTILS_DOC := distributionutils-doc

if STM22
DISTRIBUTIONUTILS_VERSION := 2.17-6

RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS_DOC)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).src.rpm | $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(DISTRIBUTIONUTILS).spec < ../Patches/stm-target-$(DISTRIBUTIONUTILS).spec22.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(DISTRIBUTIONUTILS).spec
else
DISTRIBUTIONUTILS_VERSION := 2.17-7

RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS_DOC)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).src.rpm | $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(DISTRIBUTIONUTILS).spec < ../Patches/stm-target-$(DISTRIBUTIONUTILS).spec23.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(DISTRIBUTIONUTILS).spec
endif

$(DEPDIR)/min-$(DISTRIBUTIONUTILS) $(DEPDIR)/std-$(DISTRIBUTIONUTILS) $(DEPDIR)/max-$(DISTRIBUTIONUTILS) \
$(DEPDIR)/$(DISTRIBUTIONUTILS): \
$(DEPDIR)/%$(DISTRIBUTIONUTILS): $(DEPDIR)/%$(GLIBC) RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(DISTRIBUTIONUTILS_DOC) $(DEPDIR)/std-$(DISTRIBUTIONUTILS_DOC) $(DEPDIR)/max-$(DISTRIBUTIONUTILS_DOC) \
$(DEPDIR)/$(DISTRIBUTIONUTILS_DOC): \
$(DEPDIR)/%$(DISTRIBUTIONUTILS_DOC): RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS_DOC)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true

if TARGETRULESET_FLASH
flash-distributionutils: $(flashprefix)/root/usr/sbin/initdconfig

$(flashprefix)/root/usr/sbin/initdconfig: RPMS/sh4/$(STLINUX)-sh4-$(DISTRIBUTIONUTILS)-$(DISTRIBUTIONUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

#
# HOST-MTD-UTILS
#
MTD_UTILS		:= mtd-utils
MTD_UTILS_VERSION	:= 1.0.1-9

RPMS/sh4/$(STLINUX)-sh4-$(MTD_UTILS)-$(MTD_UTILS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(MTD_UTILS)-$(MTD_UTILS_VERSION).src.rpm libz
	rpm $(DRPM) --nosignature -Uhv $< && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/stm-target-$(MTD_UTILS).spec

$(DEPDIR)/min-$(MTD_UTILS) $(DEPDIR)/std-$(MTD_UTILS) $(DEPDIR)/max-$(MTD_UTILS) \
$(DEPDIR)/$(MTD_UTILS): \
$(DEPDIR)/%$(MTD_UTILS): RPMS/sh4/$(STLINUX)-sh4-$(MTD_UTILS)-$(MTD_UTILS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-mtd-utils: $(flashprefix)/root/usr/sbin/flash_info

$(flashprefix)/root/usr/sbin/flash_info: RPMS/sh4/$(STLINUX)-sh4-$(MTD_UTILS)-$(MTD_UTILS_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	rm -rf $(flashprefix)/root/usr/share && \
	rm $(flashprefix)/root/usr/sbin/{doc_loadbios,docfdisk,flash_otp_dump,flash_otp_info,ftl_check,ftl_format} && \
	rm $(flashprefix)/root/usr/sbin/{jffs2dump,mkfs.jffs,mkfs.jffs2,nanddump,nandwrite,nftl_format,nftldump,rfddump,rfdformat,sumtool}
#	rm $(flashprefix)/root/usr/sbin/{flash_erase,flash_eraseall,flash_info,flash_lock,flash_unlock,flashcp,mtd_debug}
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif


##################################################################################################

#
# BASH
#
BASH := bash
BASH_VERSION := 3.0-6
RPMS/sh4/$(STLINUX)-sh4-bash-3.0-6.sh4.rpm: \
		$(DEPDIR)/$(GLIBC_DEV) \
		$(DEPDIR)/$(LIBTERMCAP_DEV) \
		Archive/$(STLINUX)-target-$(BASH)-$(BASH_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(BASH).spec < ../Patches/stm-target-$(BASH).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(BASH).spec
$(DEPDIR)/min-$(BASH) $(DEPDIR)/std-$(BASH) $(DEPDIR)/max-$(BASH) $(DEPDIR)/$(BASH): \
$(DEPDIR)/%$(BASH): $(DEPDIR)/%$(GLIBC) $(DEPDIR)/%$(LIBTERMCAP) RPMS/sh4/$(STLINUX)-sh4-$(BASH)-$(BASH_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts --force -Uhvv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
#	export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && \
#	$(hostprefix)/bin/target-shellconfig --list || true && \
#	( $(hostprefix)/bin/target-shellconfig --add /bin/bash 1 ) &> /dev/null || echo "Unable to register shell" && \
#	$(hostprefix)/bin/target-shellconfig --list && \
#
min-$(BASH).do_clean std-$(BASH).do_clean max-$(BASH).do_clean $(BASH).do_clean: \
%$(BASH).do_clean:
	export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && \
	$(hostprefix)/bin/target-shellconfig --list || true && \
	( $(hostprefix)/bin/target-shellconfig --del /bin/bash ) &> /dev/null || echo "Unable to unregister shell" && \
	$(hostprefix)/bin/target-shellconfig --list && \
	rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) -ev --noscripts stlinux20-sh4-$(BASH) || true && \
	[ "x$*" = "x" ] && [ -f .deps/$(subst -clean,,$@) ] && rm .deps/$(subst -clean,,$@) || true


#
# COREUTILS
#
COREUTILS := coreutils
COREUTILS_VERSION := 5.2.1-9
RPMS/sh4/stlinux20-sh4-coreutils-5.2.1-9.sh4.rpm: \
		$(DEPDIR)/$(GLIBC_DEV) \
		Archive/stlinux22-target-$(COREUTILS)-$(COREUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(COREUTILS).spec < ../Patches/stm-target-$(COREUTILS).spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(COREUTILS).spec
$(DEPDIR)/min-$(COREUTILS) $(DEPDIR)/std-$(COREUTILS) $(DEPDIR)/max-$(COREUTILS) $(DEPDIR)/$(COREUTILS): \
$(DEPDIR)/%$(COREUTILS): $(DEPDIR)/%$(GLIBC) RPMS/sh4/stlinux20-sh4-$(COREUTILS)-$(COREUTILS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# NET-TOOLS
#
NET_TOOLS := net-tools
NET_TOOLS_VERSION := 1.60-4
RPMS/sh4/stlinux20-sh4-net-tools-1.60-4.sh4.rpm: \
		$(DEPDIR)/$(GLIBC_DEV) \
		Archive/stlinux20-target-$(NET_TOOLS)-$(NET_TOOLS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(NET_TOOLS).spec
$(DEPDIR)/min-$(NET_TOOLS) $(DEPDIR)/std-$(NET_TOOLS) $(DEPDIR)/max-$(NET_TOOLS) $(DEPDIR)/$(NET_TOOLS): \
$(DEPDIR)/%$(NET_TOOLS): $(DEPDIR)/%$(GLIBC) RPMS/sh4/stlinux20-sh4-$(NET_TOOLS)-$(NET_TOOLS_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# SED
#
SEDX := sed
SED_VERSION := 4.0.7-6
RPMS/sh4/stlinux20-sh4-sed-4.0.7-6.sh4.rpm: \
		$(DEPDIR)/$(GLIBC_DEV) \
		Archive/stlinux20-target-$(SEDX)-$(SED_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(SEDX).spec
$(DEPDIR)/min-$(SEDX) $(DEPDIR)/std-$(SEDX) $(DEPDIR)/max-$(SEDX) $(DEPDIR)/$(SEDX): \
$(DEPDIR)/%$(SEDX): $(DEPDIR)/%$(GLIBC) RPMS/sh4/stlinux20-sh4-$(SEDX)-$(SED_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# DIFF
#
DIFF := diff
DIFF_DOC := diff-doc
DIFF_VERSION := 2.7-3
RPMS/sh4/stlinux20-sh4-diff-2.7-3.sh4.rpm \
RPMS/sh4/stlinux20-sh4-diff-doc-2.7-3.sh4.rpm: \
		Archive/stlinux20-target-$(DIFF)-$(DIFF_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(DIFF).spec
$(DEPDIR)/min-$(DIFF) $(DEPDIR)/std-$(DIFF) $(DEPDIR)/max-$(DIFF) $(DEPDIR)/$(DIFF): \
$(DEPDIR)/%$(DIFF): RPMS/sh4/stlinux20-sh4-$(DIFF)-$(DIFF_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) .deps/$(notdir $@) || true
	@TUXBOX_YAUD_CUSTOMIZE@
$(DEPDIR)/min-$(DIFF_DOC) $(DEPDIR)/std-$(DIFF_DOC) $(DEPDIR)/max-$(DIFF_DOC) $(DEPDIR)/$(DIFF_DOC): \
$(DEPDIR)/%$(DIFF_DOC): RPMS/sh4/stlinux20-sh4-$(DIFF_DOC)-$(DIFF_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# FILE
#
FILE := file
FILE_VERSION := 4.17-3
RPMS/sh4/stlinux20-sh4-file-4.17-3.sh4.rpm: \
		Archive/stlinux22-target-$(FILE)-$(FILE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-file.spec < ../Patches/stm-target-file.spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(FILE).spec
$(DEPDIR)/min-$(FILE) $(DEPDIR)/std-$(FILE) $(DEPDIR)/max-$(FILE) $(DEPDIR)/$(FILE): \
$(DEPDIR)/%$(FILE): RPMS/sh4/stlinux20-sh4-$(FILE)-$(FILE_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# TAR
#
TAR := tar
TAR_VERSION := 1.16.1-7
RPMS/sh4/stlinux20-sh4-tar-1.16.1-7.sh4.rpm: \
		Archive/stlinux22-target-$(TAR)-$(TAR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-tar.spec < ../Patches/stm-target-tar.spec.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(TAR).spec
$(DEPDIR)/min-$(TAR) $(DEPDIR)/std-$(TAR) $(DEPDIR)/max-$(TAR) $(DEPDIR)/$(TAR): \
$(DEPDIR)/%$(TAR): RPMS/sh4/stlinux20-sh4-$(TAR)-$(TAR_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS/stlinux22-target-strace-4.5.14-10.src.rpm
#
# STRACE
#
STRACE := strace
STRACE_VERSION := 4.5.14-10
RPMS/sh4/$(STLINUX)-sh4-strace-4.5.14-10.sh4.rpm: \
		Archive/$(STLINUX)-target-$(STRACE)-$(STRACE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(STRACE).spec
$(DEPDIR)/min-$(STRACE) $(DEPDIR)/std-$(STRACE) $(DEPDIR)/max-$(STRACE) $(DEPDIR)/$(STRACE): \
$(DEPDIR)/%$(STRACE): RPMS/sh4/$(STLINUX)-sh4-$(STRACE)-$(STRACE_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  --force --noscripts -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-strace: $(flashprefix)/root/usr/bin/strace

$(flashprefix)/root/usr/bin/strace: RPMS/sh4/$(STLINUX)-sh4-$(STRACE)-$(STRACE_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --force --noscripts -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@

##################################################################################################


.PHONY: flash-tcp-wrappers
