
if STM22
if P0040
KERNEL_DEPENDS = @DEPENDS_linuxp0040@
KERNEL_DIR = @DIR_linuxp0040@
KERNEL_PREPARE = @PREPARE_linuxp0040@
else
if P0041
KERNEL_DEPENDS = @DEPENDS_linuxp0041@
KERNEL_DIR = @DIR_linuxp0041@
KERNEL_PREPARE = @PREPARE_linuxp0041@
else
KERNEL_DEPENDS = @DEPENDS_linux@
KERNEL_DIR = @DIR_linux@
KERNEL_PREPARE = @PREPARE_linux@
#endof P0040/41
endif
endif
else
if P0119
KERNEL_DEPENDS = @DEPENDS_linux23@
KERNEL_DIR = @DIR_linuxp0119@
KERNEL_PREPARE = @PREPARE_linux23@
else
if P0123
KERNEL_DEPENDS = @DEPENDS_linux23@
KERNEL_DIR = @DIR_linuxp0123@
KERNEL_PREPARE = @PREPARE_linux23@
else
KERNEL_DEPENDS = @DEPENDS_linux23@
KERNEL_DIR = @DIR_linux23@
KERNEL_PREPARE = @PREPARE_linux23@
#endof P0119/123
endif
endif
#endof STM22
endif


#
# BOOTSTRAP-HOST
#

#
# CCACHE
#
$(hostprefix)/ccache-bin:
	$(INSTALL) -d $@
	$(INSTALL) -d $(hostprefix)/bin

ccache: | $(hostprefix)/ccache-bin/gcc
	touch .deps/$(notdir $@)

$(hostprefix)/ccache-bin/gcc: | $(CCACHE)
	make $(hostprefix)/ccache-bin
	ln -sf $| $@
	ln -sf $| $(@D)/g++
	ln -sf $| $(@D)/$(target)-gcc
	ln -sf $| $(@D)/$(target)-g++
	ln -sf $| $(hostprefix)/bin/$(target)-gcc
	ln -sf $| $(hostprefix)/bin/$(target)-g++

#
# HOST-RPMCONFIG
#
HOST_RPMCONFIG		:= host-rpmconfig

if STM22
HOST_RPMCONFIG_VERSION	:= 2.2-10

RPMS/noarch/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).noarch.rpm: \
		Archive/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-$(HOST_RPMCONFIG)-2.2.spec < ../Patches/stm-$(HOST_RPMCONFIG).spec22.diff ) && \
	( cd SOURCES; cp ../Patches/stm-host-rpmconfig-compress_man-allways-true.patch . ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_RPMCONFIG)-2.2.spec

$(HOST_RPMCONFIG): RPMS/noarch/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).noarch.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate /opt/STM/STLinux-2.2=$(prefix) $< && \
	touch .deps/$(notdir $@)
else
HOST_RPMCONFIG_VERSION	:= 2.3-16

RPMS/noarch/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).noarch.rpm: \
		Archive/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_RPMCONFIG).spec

$(HOST_RPMCONFIG): RPMS/noarch/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).noarch.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate /opt/STM/STLinux-2.3=$(prefix) $< && \
	touch .deps/$(notdir $@)
endif

#
# HOST-BASE-PASSWD
#
HOST_BASE_PASSWD		:= host-base-passwd

if STM22
HOST_BASE_PASSWD_VERSION	:= 3.5.9-3

RPMS/sh4/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-$(HOST_BASE_PASSWD).spec < ../Patches/stm-$(HOST_BASE_PASSWD).spec22.diff ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_BASE_PASSWD).spec
else
HOST_BASE_PASSWD_VERSION	:= 3.5.9-6

RPMS/sh4/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_BASE_PASSWD).spec
endif

$(HOST_BASE_PASSWD): RPMS/sh4/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).sh4.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#
# HOST-DISTRIBUTIONUTILS
#
HOST_DISTRIBUTIONUTILS		:= host-distributionutils
HOST_DISTRIBUTIONUTILS_VERSION	:= 2.8.4-4

RPMS/${host_arch}/$(STLINUX)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).${host_arch}.rpm: \
		Archive/$(STM_SRC)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_DISTRIBUTIONUTILS).spec

$(HOST_DISTRIBUTIONUTILS): RPMS/${host_arch}/$(STLINUX)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#
# HOST-FILESYSTEM
#

host-filesystem:
	$(INSTALL) -d $(prefix)
	$(INSTALL) -d $(configprefix)
	$(INSTALL) -d $(devkitprefix)
	$(INSTALL) -d $(devkitprefix)/sources
	$(INSTALL) -d $(devkitprefix)/sources/kernel
	$(INSTALL) -d $(hostprefix)
	$(INSTALL) -d $(hostprefix)/{bin,doc,etc,include,info,lib,man,share,var}
	$(INSTALL) -d $(hostprefix)/man/man{1,2,3,4,5,6,7,8,9}
	touch .deps/$@

#
# HOST AUTOTOOLS
#
HOST_AUTOTOOLS		:= host-autotools

if STM22
HOST_AUTOTOOLS_VERSION	:= 2.0-8

RPMS/sh4/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_AUTOTOOLS).spec
else
HOST_AUTOTOOLS_VERSION	:= 2.0-14

RPMS/sh4/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_AUTOTOOLS).spec
endif

$(HOST_AUTOTOOLS): RPMS/sh4/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).sh4.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)


if STM22
#
# HOST-MTD-UTILS
#
HOST_MTD_UTILS		:= host-mtd-utils
HOST_MTD_UTILS_VERSION	:= 1.0.1-8
#HOST_MTD_UTILS_VERSION	:= 1.0.1-9
#stlinux23-host-liblzo is needed by stlinux23-host-mtd-utils-1.2.0-9.sh4

RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm: \
		Archive/$(STM_SRC)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_MTD_UTILS).spec

$(HOST_MTD_UTILS): RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#
# BOOTSTRAP-HOST
#
$(DEPDIR)/bootstrap-host: | \
		$(CCACHE_BIN) host-rpmconfig host-base-passwd host-distributionutils host-filesystem host-autotools host-mtd-utils host-python
	[ "x$*" = "x" ] && touch -r RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm $@ || true


else
#
# HOST-LIBLZO
#
##HOST_LIBLZO		:= host-liblzo
##HOST_LIBLZO_VERSION	:= 2.03-1

##RPMS/sh4/$(STLINUX)-$(HOST_LIBLZO)-$(HOST_LIBLZO_VERSION).sh4.rpm: \
##		Archive/$(STM_SRC)-$(HOST_LIBLZO)-$(HOST_LIBLZO_VERSION).src.rpm
##	rpm  $(DRPM) --nosignature -Uhv $< && \
##	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_LIBLZO).spec

##$(HOST_LIBLZO): RPMS/sh4/$(STLINUX)-$(HOST_LIBLZO)-$(HOST_LIBLZO_VERSION).sh4.rpm
##	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
##	touch .deps/$(notdir $@)

#
# HOST-MTD-UTILS
#
HOST_MTD_UTILS		:= host-mtd-utils
HOST_MTD_UTILS_VERSION	:= 1.0.1-8
#stlinux23-host-liblzo is needed by stlinux23-host-mtd-utils-1.2.0-9.sh4

RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm: \
		Archive/$(STM_SRC)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_MTD_UTILS).spec

$(HOST_MTD_UTILS): RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#
# BOOTSTRAP-HOST
#
$(DEPDIR)/bootstrap-host: | \
		$(CCACHE_BIN) host-rpmconfig host-base-passwd host-distributionutils host-filesystem host-autotools host-mtd-utils host-python
	[ "x$*" = "x" ] && touch -r RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm $@ || true


endif
#
# BOOTSTRAP-CROSS
#

#
# CROSS_FILESYSTEM
#
CROSS_FILESYSTEM		:= cross-sh4-filesystem

cross-sh4-filesystem:
	$(INSTALL) -d $(targetprefix)
	$(INSTALL) -d $(crossprefix)
	$(INSTALL) -d $(crossprefix)/{bin,doc,etc,include,lib,man,sh4-linux,share,var}
	$(INSTALL) -d $(crossprefix)/man/man{1,2,3,4,5,6,7,8,9}
	$(INSTALL) -d $(crossprefix)/sh4-linux/{bin,include,lib}
	touch .deps/$@

#
# CROSS_DISTRIBUTIONUTILS
#
CROSS_DISTRIBUTIONUTILS		:= cross-sh4-distributionutils

if STM22
CROSS_DISTRIBUTIONUTILS_VERSION	:= 1.14-3

RPMS/${host_arch}/$(STLINUX)-$(CROSS_DISTRIBUTIONUTILS)-$(CROSS_DISTRIBUTIONUTILS_VERSION).${host_arch}.rpm: \
		Archive/$(STLINUX)-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS))-$(CROSS_DISTRIBUTIONUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec < ../Patches/stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec22.diff ) && \
	( cd SOURCES; cp ../Patches/hardhatutils-srcdir.diff . ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec

$(CROSS_DISTRIBUTIONUTILS): RPMS/${host_arch}/$(STLINUX)-$(CROSS_DISTRIBUTIONUTILS)-$(CROSS_DISTRIBUTIONUTILS_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	$(LN_SF) $(hostprefix)/bin/target-initdconfig $(crossprefix)/bin/target-initdconfig
	touch .deps/$(notdir $@)
else
CROSS_DISTRIBUTIONUTILS_VERSION	:= 1.14-5

RPMS/${host_arch}/$(STLINUX)-$(CROSS_DISTRIBUTIONUTILS)-$(CROSS_DISTRIBUTIONUTILS_VERSION).${host_arch}.rpm: \
		Archive/$(STLINUX)-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS))-$(CROSS_DISTRIBUTIONUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec

$(CROSS_DISTRIBUTIONUTILS): RPMS/${host_arch}/$(STLINUX)-$(CROSS_DISTRIBUTIONUTILS)-$(CROSS_DISTRIBUTIONUTILS_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)
endif

#
# CROSS BINUTILS
#
CROSS_BINUTILS		:= cross-sh4-binutils
CROSS_BINUTILS_DEV	:= cross-sh4-binutils-dev

if STM22
CROSS_BINUTILS_VERSION	:= 2.17.50.0.4-13

RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS_DEV)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm: \
		Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_BINUTILS))-$(CROSS_BINUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS))-sh4processed.spec < ../Patches/stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS))-sh4processed.spec22.diff ) && \
	( cd SOURCES; cp ../Patches/cross-binutils.diff . ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS))-sh4processed.spec
else
#CROSS_BINUTILS_VERSION	:= 2.18.50.0.8-33
CROSS_BINUTILS_VERSION	:= 2.18.50.0.8-34
#stlinux23-cross-binutils-2.18-33.src.rpm

RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS_DEV)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm: \
		Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_BINUTILS))-$(CROSS_BINUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec < ../Patches/stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec23.diff ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec
endif

$(CROSS_BINUTILS): RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(CROSS_BINUTILS_DEV): RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS_DEV)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps --noscripts -Uhv $< && \
	touch .deps/$(notdir $@)

#
# KERNEL-HEADERS
#
$(DEPDIR)/kernel-headers: linux-kernel.do_prepare
	cd $(KERNEL_DIR) && \
		$(INSTALL) -d $(targetprefix)/usr/include && \
		cp -a include/linux $(targetprefix)/usr/include && \
		cp -a include/asm-sh $(targetprefix)/usr/include/asm && \
		cp -a include/asm-generic $(targetprefix)/usr/include && \
		cp -a include/mtd $(targetprefix)/usr/include
	touch $@

#
# CROSS GCC
#
CROSS_GCC		:= cross-sh4-gcc
CROSS_CPP		:= cross-sh4-cpp
CROSS_G++		:= cross-sh4-g++
CROSS_PROTOIZE		:= cross-sh4-protoize
CROSS_LIBGCC		:= cross-sh4-libgcc

if STM22
CROSS_GCC_VERSION	:= 4.1.1-23
CROSS_GCC_RAWVERSION	:= 4.1.1

RPMS/${host_arch}/$(STLINUX)-$(CROSS_GCC)-$(CROSS_GCC_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_CPP)-$(CROSS_GCC_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_G++)-$(CROSS_GCC_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_PROTOIZE)-$(CROSS_GCC_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_LIBGCC)-$(CROSS_GCC_VERSION).${host_arch}.rpm: \
		Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_GCC))-$(CROSS_GCC_VERSION).src.rpm \
		| Archive/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm \
		Archive/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm \
		kernel-headers
	rpm  $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--relocate /opt/STM/STLinux-2.2/devkit/sh4/target=$(targetprefix) $(word 1,$|) && \
	rpm  $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--relocate /opt/STM/STLinux-2.2/devkit/sh4/target=$(targetprefix) $(word 2,$|)
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-$(subst cross-sh4-,cross-,$(CROSS_GCC))-sh4processed.spec < ../Patches/stm-$(subst cross-sh4-,cross-,$(CROSS_GCC))-sh4processed.spec22.diff ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(subst cross-sh4-,cross-,$(CROSS_GCC))-sh4processed.spec
	rpm  $(DRPM) -ev $(STLINUX)-sh4-$(GLIBC_DEV) && \
	rpm  $(DRPM) -ev $(STLINUX)-sh4-$(GLIBC)
else
#CROSS_GCC_VERSION	:= 4.2.4-48
CROSS_GCC_VERSION	:= 4.2.4-49
CROSS_GCC_RAWVERSION	:= 4.2.4

RPMS/${host_arch}/$(STLINUX)-$(CROSS_GCC)-$(CROSS_GCC_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_CPP)-$(CROSS_GCC_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_G++)-$(CROSS_GCC_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_PROTOIZE)-$(CROSS_GCC_VERSION).${host_arch}.rpm \
RPMS/${host_arch}/$(STLINUX)-$(CROSS_LIBGCC)-$(CROSS_GCC_VERSION).${host_arch}.rpm: \
		Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_GCC))-$(CROSS_GCC_VERSION).src.rpm \
		| Archive/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm \
		Archive/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm \
		kernel-headers
	rpm  $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(targetprefix) $(word 1,$|) && \
	rpm  $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(targetprefix) $(word 2,$|)
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( cd SPECS; patch -p1 stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec < ../Patches/stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec23.diff ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec
	rpm  $(DRPM) -ev $(STLINUX)-sh4-$(GLIBC_DEV) && \
	rpm  $(DRPM) -ev $(STLINUX)-sh4-$(GLIBC)
endif

$(CROSS_GCC): RPMS/${host_arch}/$(STLINUX)-$(CROSS_GCC)-$(CROSS_GCC_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	sh4-linux-objcopy -v --redefine-sym __ic_invalidate_syscall=__ic_invalidate $(prefix)/devkit/sh4/lib/gcc/sh4-linux/$(CROSS_GCC_RAWVERSION)/libgcc.a && \
	touch .deps/$(notdir $@)

$(CROSS_CPP): RPMS/${host_arch}/$(STLINUX)-$(CROSS_CPP)-$(CROSS_GCC_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(CROSS_G++): RPMS/${host_arch}/$(STLINUX)-$(CROSS_G++)-$(CROSS_GCC_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(DEPDIR)/min-$(CROSS_LIBGCC) $(DEPDIR)/std-$(CROSS_LIBGCC) $(DEPDIR)/max-$(CROSS_LIBGCC) \
$(DEPDIR)/$(CROSS_LIBGCC): \
$(DEPDIR)/%$(CROSS_LIBGCC): RPMS/${host_arch}/$(STLINUX)-$(CROSS_LIBGCC)-$(CROSS_GCC_VERSION).${host_arch}.rpm | $(DEPDIR)/%$(GLIBC)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb  $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(CROSS_PROTOIZE): RPMS/${host_arch}/$(STLINUX)-$(CROSS_PROTOIZE)-$(CROSS_GCC_VERSION).${host_arch}.rpm
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#flash-cross-sh4-libgcc: $(flashprefix)/root/lib/libgcc_s-$(CROSS_GCC_RAWVERSION).so.1
#
#$(flashprefix)/root/lib/libgcc_s-$(CROSS_GCC_RAWVERSION).so.1: RPMS/${host_arch}/stlinux20-$(CROSS_LIBGCC)-$(CROSS_GCC_VERSION).${host_arch}.rpm
#	@rpm --dbpath $(flashprefix)-rpmdb  $(DRPM) --ignorearch --nodeps  -Uhv \
#		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $<
#	touch $@
#	@FLASHROOTDIR_MODIFIED@

#
# BOOTSTRAP-CROSS
#
$(DEPDIR)/bootstrap-cross: | \
		bootstrap-host cross-sh4-distributionutils cross-sh4-filesystem cross-sh4-binutils cross-sh4-binutils-dev \
		cross-sh4-cpp cross-sh4-gcc cross-sh4-g++
	[ "x$*" = "x" ] && touch -r RPMS/${host_arch}/$(STLINUX)-$(CROSS_G++)-$(CROSS_GCC_VERSION).${host_arch}.rpm $@ || true

$(DEPDIR)/setup-cross-doc: \
	cross-binutils-doc cross-sh4-cpp-doc cross-sh4-gcc-doc cross-sh4-g++-doc

$(DEPDIR)/setup-cross-optional: \
	cross-sh4-protoize


