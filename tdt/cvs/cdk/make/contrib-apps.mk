#
# MODULE-INIT-TOOLS
#
$(DEPDIR)/module-init-tools.do_prepare: @DEPENDS_module_init_tools@
	@PREPARE_module_init_tools@
	touch $@

$(DEPDIR)/module-init-tools.do_compile: bootstrap $(DEPDIR)/module-init-tools.do_prepare
	cd @DIR_module_init_tools@  && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE)
	touch $@
#			--enable-zlib \
#

$(DEPDIR)/min-module-init-tools $(DEPDIR)/std-module-init-tools $(DEPDIR)/max-module-init-tools \
$(DEPDIR)/module-init-tools: \
$(DEPDIR)/%module-init-tools: $(DEPDIR)/%lsb $(MODULE_INIT_TOOLS:%=root/etc/%) $(DEPDIR)/module-init-tools.do_compile
	cd @DIR_module_init_tools@  && \
		@INSTALL_module_init_tools@
	$(call adapted-etc-files,$(MODULE_INIT_TOOLS_ADAPTED_ETC_FILES))
	$(call initdconfig,module-init-tools)
#	@DISTCLEANUP_module_init_tools@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-module-init-tools: $(flashprefix)/root/sbin/depmod

$(flashprefix)/root/sbin/depmod: flash-lsb $(MODULE_INIT_TOOLS:%=root/etc/%) $(DEPDIR)/module-init-tools.do_compile | $(flashprefix)/root
	cd @DIR_module_init_tools@  && \
		for i in depmod modinfo ; do \
			$(INSTALL) -m 755 $$i $(@D) ; done
	$(call adapted-etc-flashfiles,$(MODULE_INIT_TOOLS_ADAPTED_ETC_FILES))
	$(call initdconfig-flash,module-init-tools)
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# GREP
#
$(DEPDIR)/grep.do_prepare: @DEPENDS_grep@
	@PREPARE_grep@
	cd @DIR_grep@ && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch
	touch $@

$(DEPDIR)/grep.do_compile: bootstrap $(DEPDIR)/grep.do_prepare
	cd @DIR_grep@  && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--disable-nls \
			--disable-perl-regexp \
			--libdir=$(targetprefix)/usr/lib \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-grep $(DEPDIR)/std-grep $(DEPDIR)/max-grep \
$(DEPDIR)/grep: \
$(DEPDIR)/%grep: $(DEPDIR)/grep.do_compile
	cd @DIR_grep@  && \
		@INSTALL_grep@
#	@DISTCLEANUP_grep@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-grep: $(flashprefix)/root/usr/bin/grep

$(flashprefix)/root/usr/bin/grep: $(DEPDIR)/grep.do_compile | $(flashprefix)/root
	cd @DIR_grep@  && \
		for i in src/{grep,egrep,fgrep} ; do \
			$(INSTALL) -m 755 $$i $(@D) ; done
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# LSB
#
$(DEPDIR)/lsb.do_prepare: @DEPENDS_lsb@
	@PREPARE_lsb@
	touch $@

$(DEPDIR)/lsb.do_compile: bootstrap $(DEPDIR)/lsb.do_prepare
	touch $@

$(DEPDIR)/min-lsb $(DEPDIR)/std-lsb $(DEPDIR)/max-lsb \
$(DEPDIR)/lsb: \
$(DEPDIR)/%lsb: $(DEPDIR)/lsb.do_compile
	cd @DIR_lsb@  && \
		@INSTALL_lsb@
#	@DISTCLEANUP_lsb@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-lsb: $(flashprefix)/root/lib/lsb/init-functions

$(flashprefix)/root/lib/lsb/init-functions: $(DEPDIR)/lsb.do_compile | $(flashprefix)/root
	cd @DIR_lsb@  && \
		$(INSTALL) -d $(@D) && \
		$(INSTALL) -m 644 init-functions $@
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# PORTMAP
#
$(DEPDIR)/portmap.do_prepare: @DEPENDS_portmap@
	@PREPARE_portmap@
	cd @DIR_portmap@ && \
		gunzip -cd $(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch && \
		sed -e 's/### BEGIN INIT INFO/# chkconfig: S 41 10\n### BEGIN INIT INFO/g' -i debian/init.d
	touch $@

$(DEPDIR)/portmap.do_compile: bootstrap $(DEPDIR)/portmap.do_prepare
	cd @DIR_portmap@  && \
		$(BUILDENV) \
		$(MAKE)
	touch $@

$(DEPDIR)/min-portmap $(DEPDIR)/std-portmap $(DEPDIR)/max-portmap \
$(DEPDIR)/portmap: \
$(DEPDIR)/%portmap: $(DEPDIR)/%lsb $(PORTMAP_ADAPTED_ETC_FILES:%=root/etc/%) $(DEPDIR)/portmap.do_compile
	cd @DIR_portmap@  && \
		@INSTALL_portmap@
	$(call adapted-etc-files,$(PORTMAP_ADAPTED_ETC_FILES))
	$(call initdconfig,portmap)
#	@DISTCLEANUP_portmap@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-portmap: $(flashprefix)/root/sbin/portmap

$(flashprefix)/root/sbin/portmap: bootstrap flash-lsb $(DEPDIR)/portmap.do_compile \
		$(PORTMAP_ADAPTED_ETC_FILES:%=root/etc/%) | $(flashprefix)/root
	cd @DIR_portmap@  && \
		$(INSTALL) -m 0755 portmap $(flashprefix)/root/sbin && \
		$(INSTALL) -m 0755 pmap_dump $(flashprefix)/root/sbin && \
		$(INSTALL) -m 0755 pmap_set $(flashprefix)/root/sbin && \
		$(INSTALL) -m 755 debian/init.d $(flashprefix)/root/etc/init.d/portmap
	$(call adapted-etc-flashfiles,$(PORTMAP_ADAPTED_ETC_FILES))
	$(call initdconfig-flash,portmap)
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# OPENRDATE
#
$(DEPDIR)/openrdate.do_prepare: bootstrap @DEPENDS_openrdate@
	@PREPARE_openrdate@
	cd @DIR_openrdate@
	touch $@

$(DEPDIR)/openrdate.do_compile: $(DEPDIR)/openrdate.do_prepare
	cd @DIR_openrdate@  && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) 
	touch $@

$(DEPDIR)/min-openrdate $(DEPDIR)/std-openrdate $(DEPDIR)/max-openrdate \
$(DEPDIR)/openrdate: \
$(DEPDIR)/%openrdate: $(OPENRDATE_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(DEPDIR)/openrdate.do_compile
	cd @DIR_openrdate@  && \
		@INSTALL_openrdate@
	( cd root/etc && for i in $(OPENRDATE_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in rdate.sh ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
#	@DISTCLEANUP_openrdate@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-openrdate: $(flashprefix)/root/usr/bin/rdate

$(flashprefix)/root/usr/bin/rdate: bootstrap $(DEPDIR)/openrdate.do_compile \
		$(OPENRDATE_ADAPTED_ETC_FILES:%=root/etc/%) | $(flashprefix)/root
	cd @DIR_openrdate@  && \
		$(INSTALL) -m 755 src/rdate $@
	( cd root/etc && for i in $(OPENRDATE_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && cd $(flashprefix)/root/etc/init.d && \
		for s in rdate.sh ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	@touch $@
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif


#
# E2FSPROGS
#
$(DEPDIR)/e2fsprogs.do_prepare: bootstrap @DEPENDS_e2fsprogs@
	@PREPARE_e2fsprogs@
	touch $@

if STM24
$(DEPDIR)/e2fsprogs.do_compile: $(DEPDIR)/e2fsprogs.do_prepare | $(UTIL_LINUX)
	cd @DIR_e2fsprogs@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	cc=$(target)-gcc \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--target=$(target) \
		--with-linker=$(target)-ld \
		--enable-elf-shlibs \
		--with-root-prefix= \
		--enable-verbose-makecmds \
		--enable-symlink-install \
		--enable-compression \
		--disable-libblkid \
		--disable-libuuid \
		--disable-uuidd && \
	$(MAKE) all && \
	$(MAKE) -C e2fsck e2fsck.static
	touch $@
else !STM24
$(DEPDIR)/e2fsprogs.do_compile: $(DEPDIR)/e2fsprogs.do_prepare
	cd @DIR_e2fsprogs@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--target=$(target) \
		--with-linker=$(target)-ld \
		$(if $(STABLE), cc="$(target)-gcc") \
		--enable-htree \
		--disable-profile \
		--disable-e2initrd-helper \
		--disable-swapfs \
		--disable-debugfs \
		--disable-imager \
		--enable-resizer \
		--enable-dynamic-e2fsck \
		--enable-fsck \
		--with-gnu-ld \
		--disable-nls \
		--prefix=/usr \
		--enable-elf-shlibs \
		--enable-dynamic-e2fsck \
		--disable-evms \
		--with-root-prefix= && \
		$(MAKE) libs progs
	touch $@
endif !STM24

if STM24
$(DEPDIR)/e2fsprogs: $(DEPDIR)/e2fsprogs.do_compile
	cd @DIR_e2fsprogs@ && \
	$(BUILDENV) \
	$(MAKE) install install-libs \
		LDCONFIG=true \
		DESTDIR=$(targetprefix) && \
	$(INSTALL) e2fsck/e2fsck.static $(targetprefix)/sbin
	touch $@
	@TUXBOX_YAUD_CUSTOMIZE@
else !STM24
$(DEPDIR)/min-e2fsprogs $(DEPDIR)/std-e2fsprogs $(DEPDIR)/max-e2fsprogs $(DEPDIR)/ipk-e2fsprogs \
$(DEPDIR)/e2fsprogs: \
$(DEPDIR)/%e2fsprogs: $(DEPDIR)/e2fsprogs.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/ipk-cdkroot || true
	cd @DIR_e2fsprogs@ && \
		@INSTALL_e2fsprogs@
	[ "x$*" = "x" ] && ( cd @DIR_e2fsprogs@ && \
		$(MAKE) install -C lib/uuid DESTDIR=$(targetprefix) && \
		$(MAKE) install -C lib/blkid DESTDIR=$(targetprefix) ) || true
#       @DISTCLEANUP_e2fsprogs@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
endif !STM24

if TARGETRULESET_FLASH

flash-e2fsprogs: $(flashprefix)/root/sbin/mke2fs

$(flashprefix)/root/sbin/mke2fs: bootstrap $(DEPDIR)/e2fsprogs | $(flashprefix)
	cd @DIR_e2fsprogs@ && \
		for i in misc/chattr misc/lsattr misc/uuidgen; do \
			$(INSTALL) $$i $(flashprefix)/root/bin; done && \
		for i in e2fsck/e2fsck misc/fsck misc/mke2fs; do \
			$(INSTALL) $$i $(flashprefix)/root/sbin; done && \
		$(INSTALL) misc/mke2fs.conf $(flashprefix)/root/etc && \
		ln -sf e2fsck $(flashprefix)/root/sbin/fsck.ext2 && \
		ln -sf e2fsck $(flashprefix)/root/sbin/fsck.ext3 && \
		ln -sf mke2fs $(flashprefix)/root/sbin/mkfs.ext2 && \
		ln -sf mke2fs $(flashprefix)/root/sbin/mkfs.ext3 && \
		ln -sf tune2fs $(flashprefix)/root/sbin/e2label && \
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif
#		for i in e2fsck/e2fsck misc/fsck misc/mke2fs misc/tune2fs; do \
#

#
# XFSPROGS
#
$(DEPDIR)/xfsprogs.do_prepare: bootstrap @DEPENDS_xfsprogs@
	@PREPARE_xfsprogs@
	touch $@

$(DEPDIR)/xfsprogs.do_compile: $(DEPDIR)/e2fsprogs $(DEPDIR)/libreadline $(DEPDIR)/xfsprogs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_xfsprogs@ && \
		export DEBUG=-DNDEBUG && export OPTIMIZER=-O2 && \
		mv -f aclocal.m4 aclocal.m4.orig && mv Makefile Makefile.sgi || true && chmod 644 Makefile.sgi && \
		aclocal -I m4 -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix= \
			--enable-shared=yes \
			--enable-gettext=yes \
			--enable-readline=yes \
			--enable-editline=no \
			--enable-termcap=yes \
			--enable-shared-uuid=yes && \
		cp -p Makefile.sgi Makefile && export top_builddir=`pwd` && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-xfsprogs $(DEPDIR)/std-xfsprogs $(DEPDIR)/max-xfsprogs $(DEPDIR)/ipk-xfsprogs \
$(DEPDIR)/xfsprogs: \
$(DEPDIR)/%xfsprogs: $(DEPDIR)/xfsprogs.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/ipk-cdkroot || true
	cd @DIR_xfsprogs@ && \
		export top_builddir=`pwd` && \
		@INSTALL_xfsprogs@
#       @DISTCLEANUP_xfsprogs@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-xfsprogs: $(flashprefix)/root/sbin/mkfs.xfs 

$(flashprefix)/root/sbin/mkfs.xfs: bootstrap $(DEPDIR)/xfsprogs.do_compile
	cd @DIR_xfsprogs@ && \
		for i in mkfs/mkfs.xfs repair/xfs_repair; do \
			$(INSTALL) $$i $(flashprefix)/root/sbin; done && \
		$(INSTALL) fsck/xfs_fsck.sh $(flashprefix)/root/sbin/fsck.xfs && \
	touch $@
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

xfsprogs.build_ipk: $(DEPDIR)/ipk-xfsprogs
	cp -prd ipk-control/xfsprogs/* $(prefix)/ipk-cdkroot && make $(prefix)/ipk-cdkroot/strippy && \
	ipkg-build -o root -g root $(prefix)/ipk-cdkroot $(prefix)/ipk
#	-rm -rf  $(prefix)/ipk-cdkroot

#
# MC
#
$(DEPDIR)/mc.do_prepare: @DEPENDS_mc@
	@PREPARE_mc@
	touch $@

$(DEPDIR)/mc.do_compile: bootstrap glib2 $(DEPDIR)/mc.do_prepare | $(NCURSES_DEV) 
	cd @DIR_mc@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-gpm-mouse \
			--with-screen=ncurses \
			--without-x && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-mc $(DEPDIR)/std-mc $(DEPDIR)/max-mc \
$(DEPDIR)/mc: \
$(DEPDIR)/%mc: %glib2 $(DEPDIR)/mc.do_compile
	cd @DIR_mc@ && \
		@INSTALL_mc@
#		export top_builddir=`pwd` && \
#		$(MAKE) install DESTDIR=$(prefix)/$*cdkroot
#       @DISTCLEANUP_mc@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# Evaluate package mc
# call MacroName,Source Package,Package
$(eval $(call Package,mc,mc))

#
# SDPARM
#
$(DEPDIR)/sdparm.do_prepare: @DEPENDS_sdparm@
	@PREPARE_sdparm@
	touch $@

$(DEPDIR)/sdparm.do_compile: $(DEPDIR)/sdparm.do_prepare
	cd @DIR_sdparm@ && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) clean || true && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-sdparm $(DEPDIR)/std-sdparm $(DEPDIR)/max-sdparm $(DEPDIR)/ipk-sdparm $(DEPDIR)/sdparm: \
$(DEPDIR)/%sdparm: $(DEPDIR)/sdparm.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/ipk-cdkroot || true
	cd @DIR_sdparm@ && \
		export PATH=$(MAKE_PATH) && \
		@INSTALL_sdparm@
	@( cd $(prefix)/$*cdkroot/usr/share/man/man8 && \
		gzip -v9 sdparm.8 )
#       @CLEANUP_sdparm@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

sdparm.build_ipk: $(DEPDIR)/ipk-sdparm
	cp -prd ipk-control/sdparm/* $(prefix)/ipk-cdkroot && \
	make $(prefix)/ipk-cdkroot/strippy && \
	ipkg-build -o root -g root $(prefix)/ipk-cdkroot $(prefix)/ipk
	-rm -rf  $(prefix)/ipk-cdkroot

#
# SG3_UTILS
#
$(DEPDIR)/sg3_utils.do_prepare: bootstrap @DEPENDS_sg3_utils@
	@PREPARE_sg3_utils@
	touch $@

$(DEPDIR)/sg3_utils.do_compile: $(DEPDIR)/sg3_utils.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sg3_utils@ && \
		$(MAKE) clean || true && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		libtoolize && \
		automake --add-missing --foreign && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-sg3_utils $(DEPDIR)/std-sg3_utils $(DEPDIR)/max-sg3_utils $(DEPDIR)/ipk-sg3_utils \
$(DEPDIR)/sg3_utils: \
$(DEPDIR)/%sg3_utils: $(DEPDIR)/sg3_utils.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/ipk-cdkroot || true
	cd @DIR_sg3_utils@ && \
		export PATH=$(MAKE_PATH) && \
		@INSTALL_sg3_utils@
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/sbin && \
	( cd root/etc && for i in $(SG3_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	$(INSTALL) -m755 root/usr/sbin/sg_down.sh $(prefix)/$*cdkroot/usr/sbin && \
	[ "x$*" != "xipk-" ] && \
             ( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in sg_down ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
#       @DISTCLEANUP_sg3_utils@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

sg3_utils.build_ipk: $(DEPDIR)/ipk-sg3_utils
	cp -prd ipk-control/sg3_utils/* $(prefix)/ipk-cdkroot && \
	make $(prefix)/ipk-cdkroot/strippy && \
	ipkg-build -o root -g root $(prefix)/ipk-cdkroot $(prefix)/ipk
	-rm -rf  $(prefix)/ipk-cdkroot

if TARGETRULESET_FLASH

flash-sg3_utils: $(flashprefix)/root/sbin/sg_start

$(flashprefix)/root/sbin/sg_start: bootstrap $(SG3_UTILS_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(DEPDIR)/sg3_utils.do_compile
	cd @DIR_sg3_utils@ && \
		$(INSTALL) -m755 .libs/sg_start $@
	( cd root/etc && for i in $(SG3_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done ) && \
	$(INSTALL) -m755 root/usr/sbin/sg_down.sh $(flashprefix)/root/sbin && \
	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && cd $(flashprefix)/root/etc/init.d && \
		for s in sg_down ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true ) && \
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

#
# IPKG
#
$(DEPDIR)/ipkg.do_prepare: @DEPENDS_ipkg@
	@PREPARE_ipkg@
	touch $@

$(DEPDIR)/ipkg.do_compile: $(DEPDIR)/ipkg.do_prepare
	cd @DIR_ipkg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
#			--datadir=/usr/share && \
#
	touch $@

$(DEPDIR)/min-ipkg $(DEPDIR)/std-ipkg $(DEPDIR)/max-ipkg \
$(DEPDIR)/ipkg: \
$(DEPDIR)/%ipkg: $(DEPDIR)/ipkg.do_compile
	cd @DIR_ipkg@ && \
		@INSTALL_ipkg@
	ln -sf ipkg-cl $(prefix)/$*cdkroot/usr/bin/ipkg && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc && $(INSTALL) -m 644 root/etc/ipkg.conf $(prefix)/$*cdkroot/etc && \
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/ipkg
	$(INSTALL) -d $(prefix)/$*cdkroot/usr/lib/ipkg
	$(INSTALL) -m 644 root/usr/lib/ipkg/status.initial $(prefix)/$*cdkroot/usr/lib/ipkg/status
#	@DISTCLEANUP_ipkg@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-ipkg: $(flashprefix)/root/usr/bin/ipkg

$(flashprefix)/root/usr/bin/ipkg: $(DEPDIR)/ipkg.do_compile | $(flashprefix)/root
	cd @DIR_ipkg@ && \
		$(MAKE) install DESTDIR=$|
	$(LN_SF) ipkg-cl $|/usr/bin/ipkg
	rm -rf $|/include/libipkg 
	$(INSTALL) -d $|/etc && $(INSTALL) -m 644 root/etc/ipkg.conf $|/etc/
	$(INSTALL) -d $(flashprefix)/root/usr/lib/ipkg
	$(INSTALL) -m 644 root/usr/lib/ipkg/status.initial $(flashprefix)/root/usr/lib/ipkg/status
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# ZD1211
#
CONFIG_ZD1211B	:=
$(DEPDIR)/zd1211.do_prepare: @DEPENDS_zd1211@
	@PREPARE_zd1211@
	touch $@

$(DEPDIR)/zd1211.do_compile: $(DEPDIR)/zd1211.do_prepare
	cd @DIR_zd1211@ && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux \
			ZD1211B=$(ZD1211B) \
			CROSS_COMPILE=$(target)- ARCH=sh
	touch $@

#$(DEPDIR)/min-zd1211 $(DEPDIR)/std-zd1211 $(DEPDIR)/max-zd1211 \
#
$(DEPDIR)/zd1211: \
$(DEPDIR)/%zd1211: $(DEPDIR)/zd1211.do_compile
	cd @DIR_zd1211@ && \
		$(MAKE) KERNEL_LOCATION=$(buildprefix)/linux \
			BIN_DEST=$(targetprefix)/bin \
			INSTALL_MOD_PATH=$(targetprefix) \
			install
	$(DEPMOD) -ae -b $(targetprefix) -r $(KERNELVERSION)
#	@DISTCLEANUP_zd1211@
#	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-zd1211.cramfs flash-zd1211.squashfs flash-zd1211.jffs2: \
flash-zd1211.%: bootstrap zd1211.do_compile | $(flashprefix)/root
	$(MAKE) zd1211 targetprefix=$(flashprefix)/root-$*
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# NANO
#
$(DEPDIR)/nano.do_prepare: @DEPENDS_nano@
	@PREPARE_nano@
	touch $@

$(DEPDIR)/nano.do_compile: bootstrap ncurses ncurses-dev $(DEPDIR)/nano.do_prepare 
	cd @DIR_nano@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-nls \
			--enable-tiny \
			--enable-color && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-nano $(DEPDIR)/std-nano $(DEPDIR)/max-nano \
$(DEPDIR)/nano: \
$(DEPDIR)/%nano: $(DEPDIR)/nano.do_compile
	cd @DIR_nano@ && \
		@INSTALL_nano@
#	@DISTCLEANUP_nano@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# Evaluate package nano
# call MacroName,Source Package,Package
$(eval $(call Package,nano,nano))

#
# RSYNC
#
$(DEPDIR)/rsync.do_prepare: @DEPENDS_rsync@
	@PREPARE_rsync@
	touch $@

$(DEPDIR)/rsync.do_compile: bootstrap $(DEPDIR)/rsync.do_prepare 
	cd @DIR_rsync@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debug \
			--disable-locale && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-rsync $(DEPDIR)/std-rsync $(DEPDIR)/max-rsync \
$(DEPDIR)/rsync: \
$(DEPDIR)/%rsync: $(DEPDIR)/rsync.do_compile
	cd @DIR_rsync@ && \
		@INSTALL_rsync@
#	@DISTCLEANUP_rsync@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-rsync: $(flashprefix)/root/usr/bin/rsync

$(flashprefix)/root/usr/bin/rsync: $(DEPDIR)/rsync.do_compile | $(flashprefix)/root
	cd @DIR_rsync@  && \
		$(INSTALL) $(@F) $@
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# LM_SENSORS
#
$(DEPDIR)/lm_sensors.do_prepare: @DEPENDS_lm_sensors@
	@PREPARE_lm_sensors@
	touch $@

$(DEPDIR)/lm_sensors.do_compile: bootstrap $(DEPDIR)/lm_sensors.do_prepare 
	cd @DIR_lm_sensors@ && \
		$(MAKE) $(MAKE_OPTS) MACHINE=sh PREFIX=/usr user
	touch $@

$(DEPDIR)/min-lm_sensors $(DEPDIR)/std-lm_sensors $(DEPDIR)/max-lm_sensors \
$(DEPDIR)/lm_sensors: \
$(DEPDIR)/%lm_sensors: $(DEPDIR)/lm_sensors.do_compile
	cd @DIR_lm_sensors@ && \
		@INSTALL_lm_sensors@ && \
		rm $(prefix)/$*cdkroot/usr/bin/*.pl && \
		rm $(prefix)/$*cdkroot/usr/sbin/*.pl && \
		rm $(prefix)/$*cdkroot/usr/sbin/sensors-detect && \
		rm $(prefix)/$*cdkroot/usr/share/man/man8/sensors-detect.8 && \
		rm $(prefix)/$*cdkroot/usr/include/linux/i2c-dev.h && \
		rm $(prefix)/$*cdkroot/usr/bin/ddcmon
#	@DISTCLEANUP_lm_sensors@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-lm_sensors: $(flashprefix)/root/usr/sbin/i2cdetect

$(flashprefix)/root/usr/bin/i2cdetect: $(DEPDIR)/lm_sensors.do_compile | $(flashprefix)/root
	cd @DIR_lm_sensors@  && \
		for i in prog/dump/{i2cset,i2cdump} detect/i2cdetect; do \
			$(INSTALL) $$i $(flashprefix)/root/usr/sbin; done
#	/usr/bin/sensors needs libsensors.so.3 -> if needed:
#$(flashprefix)/root/usr/bin/i2cdetect: $(DEPDIR)/lm_sensors | $(flashprefix)/root
#...		prog/sensors/sensors
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# FUSE
#
$(DEPDIR)/fuse.do_prepare: @DEPENDS_fuse@
	@PREPARE_fuse@
	touch $@

$(DEPDIR)/fuse.do_compile: bootstrap curl glib2 $(DEPDIR)/fuse.do_prepare
	cd @DIR_fuse@  && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -I$(buildprefix)/linux/arch/sh" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--with-kernel=$(buildprefix)/$(KERNEL_DIR) \
			--disable-kernel-module \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-fuse $(DEPDIR)/std-fuse $(DEPDIR)/max-fuse \
$(DEPDIR)/fuse: \
$(DEPDIR)/%fuse: %curl %glib2 $(DEPDIR)/fuse.do_compile
	cd @DIR_fuse@  && \
		@INSTALL_fuse@
	-rm $(prefix)/$*cdkroot/etc/udev/rules.d/99-fuse.rules
	-rmdir $(prefix)/$*cdkroot/etc/udev/rules.d
	-rmdir $(prefix)/$*cdkroot/etc/udev
	$(LN_SF) sh4-linux-fusermount $(prefix)/$*cdkroot/usr/bin/fusermount
	$(LN_SF) sh4-linux-ulockmgr_server $(prefix)/$*cdkroot/usr/bin/ulockmgr_server
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in fuse ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
#	@DISTCLEANUP_fuse@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# Evaluate package libfuse
# call MacroName,Source Package,Package
$(eval $(call Package,fuse,libfuse))

# Evaluate package fuse-utils
# call MacroName,Source Package,Package
$(eval $(call Package,fuse,fuse-utils))

#
# CURLFTPFS
#
$(DEPDIR)/curlftpfs.do_prepare: @DEPENDS_curlftpfs@
	@PREPARE_curlftpfs@
	touch $@

$(DEPDIR)/curlftpfs.do_compile: fuse bootstrap $(DEPDIR)/curlftpfs.do_prepare
	cd @DIR_curlftpfs@ && \
		export ac_cv_func_malloc_0_nonnull=yes && \
		export ac_cv_func_realloc_0_nonnull=yes && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) 
	touch $@

$(DEPDIR)/min-curlftpfs $(DEPDIR)/std-curlftpfs $(DEPDIR)/max-curlftpfs \
$(DEPDIR)/curlftpfs: \
$(DEPDIR)/%curlftpfs: %fuse $(DEPDIR)/curlftpfs.do_compile
	cd @DIR_curlftpfs@  && \
		@INSTALL_curlftpfs@
#	@DISTCLEANUP_curlftpfs@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# Evaluate package curlftpfs
# call MacroName,Source Package,Package
$(eval $(call Package,curlftpfs,curlftpfs))

#
# FBSET
#
$(DEPDIR)/fbset.do_prepare: @DEPENDS_fbset@
	@PREPARE_fbset@
	touch $@

$(DEPDIR)/fbset.do_compile: bootstrap fbset.do_prepare
	cd @DIR_fbset@ && \
		make CC="$(target)-gcc -Wall -O2 -I."
	touch $@

$(DEPDIR)/min-fbset $(DEPDIR)/std-fbset $(DEPDIR)/max-fbset \
$(DEPDIR)/fbset: \
$(DEPDIR)/%fbset: fbset.do_compile
	cd @DIR_fbset@  && \
		@INSTALL_fbset@
#	@DISTCLEANUP_fbset@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# PNGQUANT
#
$(DEPDIR)/pngquant.do_prepare: @DEPENDS_pngquant@
	@PREPARE_pngquant@
	touch $@

$(DEPDIR)/pngquant.do_compile: bootstrap libz libpng pngquant.do_prepare 
	cd @DIR_pngquant@ && \
		$(target)-gcc -O3 -Wall -I. -funroll-loops -fomit-frame-pointer -o pngquant pngquant.c rwpng.c -lpng -lz -lm
	touch $@

$(DEPDIR)/min-pngquant $(DEPDIR)/std-pngquant $(DEPDIR)/max-pngquant \
$(DEPDIR)/pngquant: \
$(DEPDIR)/%pngquant: $(DEPDIR)/pngquant.do_compile
	cd @DIR_pngquant@ && \
		@INSTALL_pngquant@
#	@DISTCLEANUP_pngquant@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# MPLAYER
#
$(DEPDIR)/mplayer.do_prepare: @DEPENDS_mplayer@
	@PREPARE_mplayer@
	touch $@

$(DEPDIR)/mplayer.do_compile: bootstrap mplayer.do_prepare 
	cd @DIR_mplayer@ && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-mencoder  && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/min-mplayer $(DEPDIR)/std-mplayer $(DEPDIR)/max-mplayer \
$(DEPDIR)/mplayer: \
$(DEPDIR)/%mplayer: $(DEPDIR)/mplayer.do_compile
	cd @DIR_mplayer@ && \
		@INSTALL_mplayer@
#	@DISTCLEANUP_mplayer@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# MENCODER
#
#$(DEPDIR)/mencoder.do_prepare: @DEPENDS_mplayer@
#	@PREPARE_mplayer@
#	touch $@

$(DEPDIR)/mencoder.do_compile: bootstrap mplayer.do_prepare 
	cd @DIR_mencoder@ && \
		$(BUILDENV) \
		./configure \
			--cc=$(target)-gcc \
			--target=$(target) \
			--host-cc=gcc \
			--prefix=/usr \
			--disable-dvdnav \
			--disable-dvdread \
			--disable-dvdread-internal \
			--disable-libdvdcss-internal \
			--disable-libvorbis \
			--disable-mp3lib \
			--disable-liba52 \
			--disable-mad \
			--disable-vcd \
			--disable-ftp \
			--disable-pvr \
			--disable-tv-v4l2 \
			--disable-tv-v4l1 \
			--disable-tv \
			--disable-network \
			--disable-real \
			--disable-xanim \
			--disable-faad-internal \
			--disable-tremor-internal \
			--disable-pnm \
			--disable-ossaudio \
			--disable-tga \
			--disable-v4l2 \
			--disable-fbdev \
			--disable-dvb \
			--disable-mplayer && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/min-mencoder $(DEPDIR)/std-mencoder $(DEPDIR)/max-mencoder \
$(DEPDIR)/mencoder: \
$(DEPDIR)/%mencoder: $(DEPDIR)/mencoder.do_compile
	cd @DIR_mencoder@ && \
		@INSTALL_mencoder@
#	@DISTCLEANUP_mencoder@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# UTIL-LINUX
#
if STM24
# for stm24, look in contrib-apps-specs.mk 
else !STM24
$(DEPDIR)/util-linux.do_prepare: @DEPENDS_util_linux@
	@PREPARE_util_linux@
	cd @DIR_util_linux@ && \
		for p in `grep -v "^#" debian/patches/00list` ; do \
			patch -p1 < debian/patches/$$p.dpatch; \
		done; \
		patch -p1 < ../Patches/util-linux-stm.diff
	touch $@

$(DEPDIR)/util-linux.do_compile: bootstrap util-linux.do_prepare
	cd @DIR_util_linux@ && \
		sed -e 's/\ && .\/conftest//g' < configure > configure.new && \
		chmod +x configure.new && mv configure.new configure && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure && \
		sed 's/CURSESFLAGS=.*/CURSESFLAGS=-DNCH=1/' make_include > make_include.new && \
		mv make_include make_include.bak && \
		mv make_include.new make_include && \
		$(MAKE) ARCH=sh4 HAVE_SLANG=no HAVE_SHADOW=yes HAVE_PAM=no
	touch $@

$(DEPDIR)/min-util-linux $(DEPDIR)/std-util-linux $(DEPDIR)/max-util-linux \
$(DEPDIR)/util-linux: \
$(DEPDIR)/%util-linux: util-linux.do_compile
	cd @DIR_util_linux@  && \
		install -d $(targetprefix)/sbin && \
		install -m 755 fdisk/sfdisk $(targetprefix)/sbin/
#		$(MAKE) ARCH=sh4 HAVE_SLANG=no HAVE_SHADOW=yes HAVE_PAM=no \
#		USE_TTY_GROUP=no INSTALLSUID='$(INSTALL) -m $(SUIDMODE)' \
#		DESTDIR=$(targetprefix) install && \
#		ln -s agetty $(targetprefix)/sbin/getty && \
#		ln -s agetty.8.gz $(targetprefix)/usr/man/man8/getty.8.gz && \
#		install -m 755 debian/hwclock.sh $(targetprefix)/etc/init.d/hwclock.sh && \
#		( cd po && make install DESTDIR=$(targetprefix) )
#		@INSTALL_util_linux@
#	@DISTCLEANUP_util_linux@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
endif !STM24

#
# jfsutils
#
$(DEPDIR)/jfsutils.do_prepare: @DEPENDS_jfsutils@
	@PREPARE_jfsutils@
	touch $@

$(DEPDIR)/jfsutils.do_compile: bootstrap jfsutils.do_prepare 
	cd @DIR_jfsutils@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--host=gcc \
			--target=$(target) \
			--prefix= && \
		$(MAKE) CC="$(target)-gcc"
	touch $@

$(DEPDIR)/min-jfsutils $(DEPDIR)/std-jfsutils $(DEPDIR)/max-jfsutils \
$(DEPDIR)/jfsutils: \
$(DEPDIR)/%jfsutils: $(DEPDIR)/jfsutils.do_compile
	cd @DIR_jfsutils@ && \
		@INSTALL_jfsutils@
#	@DISTCLEANUP_jfsutils@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@


#
# opkg
#
$(DEPDIR)/opkg.do_prepare: @DEPENDS_opkg@
	@PREPARE_opkg@
	touch $@

$(DEPDIR)/opkg.do_compile: bootstrap opkg.do_prepare 
	cd @DIR_opkg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-curl \
			--disable-gpg \
			--with-opkglibdir=/var && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-opkg $(DEPDIR)/std-opkg $(DEPDIR)/max-opkg \
$(DEPDIR)/opkg: \
$(DEPDIR)/%opkg: $(DEPDIR)/opkg.do_compile
	cd @DIR_opkg@ && \
		@INSTALL_opkg@
#	@DISTCLEANUP_jfsutils@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

