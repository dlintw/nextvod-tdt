
if STM22
if P0040
KERNEL_DEPENDS = @DEPENDS_linuxp0040@
KERNEL_DIR = @DIR_linuxp0040@
KERNEL_PREPARE = @PREPARE_linuxp0040@
else !P0040
if P0041
KERNEL_DEPENDS = @DEPENDS_linuxp0041@
KERNEL_DIR = @DIR_linuxp0041@
KERNEL_PREPARE = @PREPARE_linuxp0041@
else !P0041
KERNEL_DEPENDS = @DEPENDS_linux@
KERNEL_DIR = @DIR_linux@
KERNEL_PREPARE = @PREPARE_linux@
endif !P0041
endif !P0040
STM_RELOCATE := /opt/STM/STLinux-2.2
else !STM22
if STM23
if ENABLE_P0119
KERNEL_DEPENDS = @DEPENDS_linux23@
KERNEL_DIR = @DIR_linuxp0119@
KERNEL_PREPARE = @PREPARE_linux23@
else !ENABLE_P0119
if ENABLE_P0123
KERNEL_DEPENDS = @DEPENDS_linux23@
KERNEL_DIR = @DIR_linuxp0123@
KERNEL_PREPARE = @PREPARE_linux23@
else !ENABLE_P0123
KERNEL_DEPENDS = @DEPENDS_linux23@
KERNEL_DIR = @DIR_linux23@
KERNEL_PREPARE = @PREPARE_linux23@
endif !ENABLE_P0123
endif !ENABLE_P0119
STM_RELOCATE := /opt/STM/STLinux-2.3
else !STM23
#if STM24
if ENABLE_P0201
KERNEL_DEPENDS = @DEPENDS_linux24@
KERNEL_DIR = @DIR_linuxp0201@
KERNEL_PREPARE = @PREPARE_linux24@
else !ENABLE_P0201
KERNEL_DEPENDS = @DEPENDS_linux24@
KERNEL_DIR = @DIR_linux24@
KERNEL_PREPARE = @PREPARE_linux24@
endif !ENABLE_P0201
STM_RELOCATE := /opt/STM/STLinux-2.4
#endif !STM24
endif !STM23
endif !STM22


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
HOST_RPMCONFIG := host-rpmconfig
if STM22
HOST_RPMCONFIG_VERSION := 2.2-10
HOST_RPMCONFIG_SPEC := stm-$(HOST_RPMCONFIG)-2.2.spec
HOST_RPMCONFIG_SPEC_PATCH := stm-$(HOST_RPMCONFIG).spec22.diff
HOST_RPMCONFIG_PATCHES := stm-host-rpmconfig-compress_man-allways-true.patch
else !STM22
if STM23
HOST_RPMCONFIG_VERSION := 2.3-16
HOST_RPMCONFIG_SPEC := stm-$(HOST_RPMCONFIG).spec
HOST_RPMCONFIG_SPEC_PATCH := 
HOST_RPMCONFIG_PATCHES := 
else !STM23
# STM24
HOST_RPMCONFIG_VERSION := 2.4-21
HOST_RPMCONFIG_SPEC := stm-$(HOST_RPMCONFIG).spec
HOST_RPMCONFIG_SPEC_PATCH := stm-$(HOST_RPMCONFIG).spec24.diff
HOST_RPMCONFIG_PATCHES := stm-host-rpmconfig-skip-cvs.patch
endif !STM23
endif !STM22
HOST_RPMCONFIG_RPM := RPMS/noarch/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).noarch.rpm

$(HOST_RPMCONFIG_RPM): Archive/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).src.rpm \
		$(if $(HOST_RPMCONFIG_SPEC_PATCH),Patches/$(HOST_RPMCONFIG_SPEC_PATCH)) \
		$(if $(HOST_RPMCONFIG_PATCHES),$(patsubst %,Patches/%,$(HOST_RPMCONFIG_PATCHES))) \
		$(HOST_FILESYSTEM)
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(HOST_RPMCONFIG_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(HOST_RPMCONFIG_SPEC) < "../Patches/$(HOST_RPMCONFIG_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(HOST_RPMCONFIG_PATCHES)" ] && cp $(HOST_RPMCONFIG_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_RPMCONFIG_SPEC)

$(HOST_RPMCONFIG): $(HOST_RPMCONFIG_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(STM_RELOCATE)=$(prefix) $< && \
	touch .deps/$(notdir $@)

#
# HOST-BASE-PASSWD
#
HOST_BASE_PASSWD := host-base-passwd
if STM22
HOST_BASE_PASSWD_VERSION := 3.5.9-3
HOST_BASE_PASSWD_SPEC := stm-$(HOST_BASE_PASSWD).spec
HOST_BASE_PASSWD_SPEC_PATCH := stm-$(HOST_BASE_PASSWD).spec22.diff
HOST_BASE_PASSWD_PATCHES := 
else !STM22
if STM23
HOST_BASE_PASSWD_VERSION := 3.5.9-6
HOST_BASE_PASSWD_SPEC := stm-$(HOST_BASE_PASSWD).spec
HOST_BASE_PASSWD_SPEC_PATCH :=
HOST_BASE_PASSWD_PATCHES :=
else !STM23
# STM24
HOST_BASE_PASSWD_VERSION := 3.5.9-7
HOST_BASE_PASSWD_SPEC := stm-$(HOST_BASE_PASSWD).spec
HOST_BASE_PASSWD_SPEC_PATCH :=
HOST_BASE_PASSWD_PATCHES :=
endif !STM23
endif !STM22
HOST_BASE_PASSWD_RPM := RPMS/sh4/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).sh4.rpm

$(HOST_BASE_PASSWD_RPM) : Archive/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).src.rpm \
		$(if $(HOST_BASE_PASSWD_SPEC_PATCH),Patches/$(HOST_BASE_PASSWD_SPEC_PATCH)) \
		$(if $(HOST_BASE_PASSWD_PATCHES),$(patsubst %,Patches/%,$(HOST_BASE_PASSWD_PATCHES)))
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(HOST_BASE_PASSWD_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(HOST_BASE_PASSWD_SPEC) < "../Patches/$(HOST_BASE_PASSWD_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(HOST_BASE_PASSWD_PATCHES)" ] && cp $(HOST_BASE_PASSWD_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_BASE_PASSWD_SPEC)

$(HOST_BASE_PASSWD): $(HOST_BASE_PASSWD_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#
# HOST-DISTRIBUTIONUTILS
#
HOST_DISTRIBUTIONUTILS := host-distributionutils
if STM22
HOST_DISTRIBUTIONUTILS_VERSION := 2.8.4-4
HOST_DISTRIBUTIONUTILS_SPEC := stm-$(HOST_DISTRIBUTIONUTILS).spec
HOST_DISTRIBUTIONUTILS_SPEC_PATCH := 
HOST_DISTRIBUTIONUTILS_PATCHES := 
else !STM22
if STM23
HOST_DISTRIBUTIONUTILS_VERSION := 2.8.4-4
HOST_DISTRIBUTIONUTILS_SPEC := stm-$(HOST_DISTRIBUTIONUTILS).spec
HOST_DISTRIBUTIONUTILS_SPEC_PATCH := 
HOST_DISTRIBUTIONUTILS_PATCHES := 
else !STM23
# STM24
HOST_DISTRIBUTIONUTILS_VERSION := 2.8.4-5
HOST_DISTRIBUTIONUTILS_SPEC := stm-$(HOST_DISTRIBUTIONUTILS).spec
HOST_DISTRIBUTIONUTILS_SPEC_PATCH := 
HOST_DISTRIBUTIONUTILS_PATCHES := 
endif !STM23
endif !STM22
HOST_DISTRIBUTIONUTILS_RPM := RPMS/$(host_arch)/$(STLINUX)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).$(host_arch).rpm

$(HOST_DISTRIBUTIONUTILS_RPM): Archive/$(STM_SRC)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).src.rpm \
		$(if $(HOST_DISTRIBUTIONUTILS_SPEC_PATCH),Patches/$(HOST_DISTRIBUTIONUTILS_SPEC_PATCH)) \
		$(if $(HOST_DISTRIBUTIONUTILS_PATCHES),$(patsubst %,Patches/%,$(HOST_DISTRIBUTIONUTILS_PATCHES)))
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(HOST_DISTRIBUTIONUTILS_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(HOST_DISTRIBUTIONUTILS_SPEC) < "../Patches/$(HOST_DISTRIBUTIONUTILS_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(HOST_DISTRIBUTIONUTILS_PATCHES)" ] && cp $(HOST_DISTRIBUTIONUTILS_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_DISTRIBUTIONUTILS_SPEC) 

$(HOST_DISTRIBUTIONUTILS): $(HOST_DISTRIBUTIONUTILS_RPM) 
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#
# HOST-FILESYSTEM
#
HOST_FILESYSTEM := host-filesystem
# if STM24
# HOST_FILESYSTEM_VERSION := 1.0-7
# HOST_FILESYSTEM_SPEC := stm-$(HOST_FILESYSTEM).spec
# HOST_FILESYSTEM_SPEC_PATCH := 
# HOST_FILESYSTEM_PATCHES := 
# HOST_FILESYSTEM_RPM := RPMS/sh4/$(STLINUX)-$(HOST_FILESYSTEM)-$(HOST_FILESYSTEM_VERSION).sh4.rpm
# 
# $(HOST_FILESYSTEM_RPM): Archive/$(STLINUX)-$(HOST_FILESYSTEM)-$(HOST_FILESYSTEM_VERSION).src.rpm \
#		$(if $(HOST_FILESYSTEM_SPEC_PATCH),Patches/$(HOST_FILESYSTEM_SPEC_PATCH)) \
#		$(if $(HOST_FILESYSTEM_PATCHES),$(patsubst %,Patches/%,$(HOST_FILESYSTEM_PATCHES)))
# 	rpm  $(DRPM) --nosignature -Uhv $< && \
# 	( [ ! -z "$(HOST_FILESYSTEM_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(HOST_FILESYSTEM_SPEC) < "../Patches/$(HOST_FILESYSTEM_SPEC_PATCH)" || true ) && \
# 	( [ ! -z "$(HOST_FILESYSTEM_PASSWD_PATCHES)" ] && cp $(HOST_FILESYSTEM_PATCHES) SOURCES/ || true ) && \
# 	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_FILESYSTEM_SPEC)
# 
# $(HOST_FILESYSTEM): $(HOST_FILESYSTEM_RPM)
# 	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
# 	touch .deps/$(notdir $@)
# else !STM24
$(HOST_FILESYSTEM):
	$(INSTALL) -d $(prefix)
	$(INSTALL) -d $(configprefix)
	$(INSTALL) -d $(devkitprefix)
	$(INSTALL) -d $(devkitprefix)/sources
	$(INSTALL) -d $(devkitprefix)/sources/kernel
	$(INSTALL) -d $(hostprefix)
	$(INSTALL) -d $(hostprefix)/{bin,doc,etc,include,info,lib,man,share,var}
	$(INSTALL) -d $(hostprefix)/man/man{1,2,3,4,5,6,7,8,9}
	touch .deps/$@
# endif !STM24

#
# HOST AUTOTOOLS
#
HOST_AUTOTOOLS := host-autotools
if STM22
HOST_AUTOTOOLS_VERSION := 2.0-8
HOST_AUTOTOOLS_SPEC := stm-$(HOST_AUTOTOOLS).spec
HOST_AUTOTOOLS_SPEC_PATCH := 
HOST_AUTOTOOLS_PATCHES := 
else !STM22
if STM23
HOST_AUTOTOOLS_VERSION := 2.0-14
HOST_AUTOTOOLS_SPEC := stm-$(HOST_AUTOTOOLS).spec
HOST_AUTOTOOLS_SPEC_PATCH := 
HOST_AUTOTOOLS_PATCHES := 
else !STM23
# STM24
HOST_AUTOTOOLS_VERSION := dev-20091012-2
HOST_AUTOTOOLS_SPEC := stm-$(HOST_AUTOTOOLS)-dev.spec
HOST_AUTOTOOLS_SPEC_PATCH := 
HOST_AUTOTOOLS_PATCHES := 
endif !STM23
endif !STM22
HOST_AUTOTOOLS_RPM := RPMS/sh4/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).sh4.rpm

$(HOST_AUTOTOOLS_RPM): Archive/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).src.rpm \
		$(if $(HOST_AUTOTOOLS_SPEC_PATCH),Patches/$(HOST_AUTOTOOLS_SPEC_PATCH)) \
		$(if $(HOST_AUTOTOOLS_PATCHES),$(patsubst %,Patches/%,$(HOST_AUTOTOOLS_PATCHES)))
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(HOST_AUTOTOOLS_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(HOST_AUTOTOOLS_SPEC) < "../Patches/$(HOST_AUTOTOOLS_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(HOST_AUTOTOOLS_PASSWD_PATCHES)" ] && cp $(HOST_AUTOTOOLS_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_AUTOTOOLS_SPEC)

$(HOST_AUTOTOOLS): $(HOST_AUTOTOOLS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)


if !STM24
#
# HOST-MTD-UTILS
#
HOST_MTD_UTILS := host-mtd-utils
if STM22
HOST_MTD_UTILS_VERSION := 1.0.1-8
HOST_MTD_UTILS_SPEC := stm-$(HOST_MTD_UTILS).spec
HOST_MTD_UTILS_SPEC_PATCH := 
HOST_MTD_UTILS_PATCHES := 
else !STM22
if STM23
HOST_MTD_UTILS_VERSION	:= 1.0.1-8
HOST_MTD_UTILS_SPEC := stm-$(HOST_MTD_UTILS).spec
HOST_MTD_UTILS_SPEC_PATCH := 
HOST_MTD_UTILS_PATCHES := 
else !STM23
# STM24
endif !STM23
endif !STM22
HOST_MTD_UTILS_RPM := RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm

$(HOST_MTD_UTILS_RPM): Archive/$(STM_SRC)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).src.rpm \
		$(if $(HOST_MTD_UTILS_SPEC_PATCH),Patches/$(HOST_MTD_UTILS_SPEC_PATCH)) \
		$(if $(HOST_MTD_UTILS_PATCHES),$(patsubst %,Patches/%,Patches/$(HOST_MTD_UTILS_PATCHES)))
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(HOST_MTD_UTILS_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(HOST_MTD_UTILS_SPEC) < "../Patches/$(HOST_MTD_UTILS_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(HOST_MTD_UTILS_PATCHES)" ] && cp $(HOST_MTD_UTILS_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_MTD_UTILS_SPEC)

$(HOST_MTD_UTILS): $(HOST_MTD_UTILS_RPM) 
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

endif !STM24

if STM23
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
endif

#
# BOOTSTRAP-HOST
#
if STM24
.PHONY: $(DEPDIR)/bootstrap-host

$(DEPDIR)/bootstrap-host: | \
		$(CCACHE_BIN) $(HOST_RPMCONFIG) $(HOST_BASE_PASSWD) $(HOST_DISTRIBUTIONUTILS) $(HOST_FILESYSTEM) $(HOST_AUTOTOOLS) host-python
else !STM24
$(DEPDIR)/bootstrap-host: | \
		$(CCACHE_BIN) $(HOST_RPMCONFIG) $(HOST_BASE_PASSWD) $(HOST_DISTRIBUTIONUTILS) $(HOST_FILESYSTEM) $(HOST_AUTOTOOLS) $(HOST_MTD_UTILS) host-python
	[ "x$*" = "x" ] && touch -r $(HOST_MTD_UTILS_RPM) $@ || true
endif !STM24

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
CROSS_DISTRIBUTIONUTILS := cross-sh4-distributionutils
if STM22
CROSS_DISTRIBUTIONUTILS_VERSION	:= 1.14-3
CROSS_DISTRIBUTIONUTILS_SPEC := stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec
CROSS_DISTRIBUTIONUTILS_SPEC_PATCH := stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec22.diff
CROSS_DISTRIBUTIONUTILS_PATCHES := hardhatutils-srcdir.diff
else !STM22
if STM23
CROSS_DISTRIBUTIONUTILS_VERSION	:= 1.14-5
CROSS_DISTRIBUTIONUTILS_SPEC := stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec
CROSS_DISTRIBUTIONUTILS_SPEC_PATCH :=
CROSS_DISTRIBUTIONUTILS_PATCHES :=
else !STM23
# STM24
CROSS_DISTRIBUTIONUTILS_VERSION	:= 1.14-6
CROSS_DISTRIBUTIONUTILS_SPEC := stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec
CROSS_DISTRIBUTIONUTILS_SPEC_PATCH :=
CROSS_DISTRIBUTIONUTILS_PATCHES :=
endif !STM23
endif !STM22
CROSS_DISTRIBUTIONUTILS_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_DISTRIBUTIONUTILS)-$(CROSS_DISTRIBUTIONUTILS_VERSION).$(host_arch).rpm 

$(CROSS_DISTRIBUTIONUTILS_RPM): Archive/$(STLINUX)-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS))-$(CROSS_DISTRIBUTIONUTILS_VERSION).src.rpm \
		$(if $(HOST_DISTRIBUTIONUTILS_SPEC_PATCH),Patches/$(HOST_DISTRIBUTIONUTILS_SPEC_PATCH)) \
		$(if $(HOST_DISTRIBUTIONUTILS_PATCHES),$(patsubst %,Patches/%,$(HOST_DISTRIBUTIONUTILS_PATCHES)))
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(CROSS_DISTRIBUTIONUTILS_SPEC) < "../Patches/$(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(CROSS_DISTRIBUTIONUTILS_PATCHES)" ] && cp $(CROSS_DISTRIBUTIONUTILS_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_DISTRIBUTIONUTILS_SPEC)

if STM22
$(CROSS_DISTRIBUTIONUTILS): $(CROSS_DISTRIBUTIONUTILS_RPM) 
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	$(LN_SF) $(hostprefix)/bin/target-initdconfig $(crossprefix)/bin/target-initdconfig
	touch .deps/$(notdir $@)
else !STM22
$(CROSS_DISTRIBUTIONUTILS): $(CROSS_DISTRIBUTIONUTILS_RPM) 
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)
endif !STM22

#
# CROSS BINUTILS
#
CROSS_BINUTILS := cross-sh4-binutils
CROSS_BINUTILS_DEV := $(CROSS_BINUTILS)-dev
if STM22
CROSS_BINUTILS_VERSION := 2.17.50.0.4-13
CROSS_BINUTILS_SPEC := stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS))-sh4processed.spec
CROSS_BINUTILS_SPEC_PATCH := stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS))-sh4processed.spec22.diff
CROSS_BINUTILS_PATCHES := cross-binutils.diff
else !STM22
if STM23
CROSS_BINUTILS_VERSION := 2.18.50.0.8-34
CROSS_BINUTILS_SPEC := stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec
CROSS_BINUTILS_SPEC_PATCH := stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec23.diff
CROSS_BINUTILS_PATCHES := 
else !STM23
# STM24
CROSS_BINUTILS_VERSION := 2.19.1-41
CROSS_BINUTILS_SPEC := stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec
CROSS_BINUTILS_SPEC_PATCH :=
CROSS_BINUTILS_PATCHES := 
endif !STM23
endif !STM22
CROSS_BINUTILS_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_BINUTILS)-$(CROSS_BINUTILS_VERSION).$(host_arch).rpm
CROSS_BINUTILS_DEV_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_BINUTILS_DEV)-$(CROSS_BINUTILS_VERSION).$(host_arch).rpm

$(CROSS_BINUTILS_RPM) $(CROSS_BINUTILS_DEV_RPM): \
		Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_BINUTILS))-$(CROSS_BINUTILS_VERSION).src.rpm \
		$(if $(CROSS_BINUTILS_SPEC_PATCH),Patches/$(CROSS_BINUTILS_SPEC_PATCH)) \
		$(if $(CROSS_BINUTILS_PATCHES),$(patsubst %,Patches/%,$(CROSS_BINUTILS_PATCHES)))
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(CROSS_BINUTILS_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(CROSS_BINUTILS_SPEC) < "../Patches/$(CROSS_BINUTILS_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(CROSS_BINUTILS_PATCHES)" ] && cp $(CROSS_BINUTILS_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_BINUTILS_SPEC)

$(CROSS_BINUTILS): $(CROSS_BINUTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(CROSS_BINUTILS_DEV): $(CROSS_BINUTILS_DEV_RPM)
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
# CROSS GMP
#
if STM24
CROSS_GMP := cross-sh4-gmp
CROSS_GMP_VERSION := 4.3.2-4
CROSS_GMP_SPEC := stm-$(subst cross-sh4,cross,$(CROSS_GMP)).spec
CROSS_GMP_SPEC_PATCH :=
CROSS_GMP_PATCHES :=
CROSS_GMP_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_GMP)-$(CROSS_GMP_VERSION).$(host_arch).rpm

$(CROSS_GMP_RPM) $(CROSS_GMP_DEV_RPM): \
		Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_GMP))-$(CROSS_GMP_VERSION).src.rpm \
		$(if $(CROSS_GMP_SPEC_PATCH),Patches/$(CROSS_GMP_SPEC_PATCH)) \
		$(if $(CROSS_GMP_PATCHES),$(patsubst %,Patches/%,$(CROSS_GMP_PATCHES)))
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(CROSS_GMP_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(CROSS_GMP_SPEC) < "../Patches/$(CROSS_GMP_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(CROSS_GMP_PATCHES)" ] && cp $(CROSS_GMP_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --target=sh4-linux SPECS/$(CROSS_GMP_SPEC)

$(CROSS_GMP): $(CROSS_GMP_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)
endif STM24

#
# CROSS MPFR
#
if STM24
CROSS_MPFR := cross-sh4-mpfr
CROSS_MPFR_VERSION := 2.4.2-4
CROSS_MPFR_SPEC := stm-$(subst cross-sh4,cross,$(CROSS_MPFR)).spec
CROSS_MPFR_SPEC_PATCH := stm-cross-mpfr.spec24.diff
CROSS_MPFR_PATCHES :=
CROSS_MPFR_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_MPFR)-$(CROSS_MPFR_VERSION).$(host_arch).rpm

$(CROSS_MPFR_RPM): Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_MPFR))-$(CROSS_MPFR_VERSION).src.rpm \
		$(if $(CROSS_MPFR_SPEC_PATCH),Patches/$(CROSS_MPFR_SPEC_PATCH)) \
		$(if $(CROSS_MPFR_PATCHES),$(patsubst %,Patches/%,$(CROSS_MPFR_PATCHES)))
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(CROSS_MPFR_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(CROSS_MPFR_SPEC) < "../Patches/$(CROSS_MPFR_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(CROSS_MPFR_PATCHES)" ] && cp $(CROSS_MPFR_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_MPFR_SPEC)

$(CROSS_MPFR): $(CROSS_GMP) $(CROSS_MPFR_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	touch .deps/$(notdir $@)
endif STM24

#
# CROSS GCC
#
CROSS_GCC := cross-sh4-gcc
CROSS_CPP := cross-sh4-cpp
CROSS_G++ := cross-sh4-g++
CROSS_PROTOIZE := cross-sh4-protoize
CROSS_LIBGCC := cross-sh4-libgcc
if STM22
CROSS_GCC_VERSION := 4.1.1-23
CROSS_GCC_RAWVERSION := 4.1.1
CROSS_GCC_SPEC := stm-$(subst cross-sh4-,cross-,$(CROSS_GCC))-sh4processed.spec
CROSS_GCC_SPEC_PATCH := stm-$(subst cross-sh4-,cross-,$(CROSS_GCC))-sh4processed.spec22.diff
CROSS_GCC_PATCHES := 
else !STM22
if STM23
CROSS_GCC_VERSION := 4.2.4-49
CROSS_GCC_RAWVERSION := 4.2.4
CROSS_GCC_SPEC := stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec
CROSS_GCC_SPEC_PATCH := stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec23.diff
CROSS_GCC_PATCHES := 
else !STM23
# STM24
CROSS_GCC_VERSION := 4.3.4-63
CROSS_GCC_RAWVERSION := 4.3.4
CROSS_GCC_SPEC := stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec
CROSS_GCC_SPEC_PATCH := stm-cross-gcc.spec24.diff
CROSS_GCC_PATCHES := 
endif !STM23
endif !STM22
CROSS_GCC_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_GCC)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_CPP_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_CPP)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_G++_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_G++)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_PROTOIZE_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_PROTOIZE)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_LIBGCC_RPM := RPMS/$(host_arch)/$(STLINUX)-$(CROSS_LIBGCC)-$(CROSS_GCC_VERSION).$(host_arch).rpm

$(CROSS_GCC_RPM) $(CROSS_CPP_RPM) $(CROSS_G++_RPM) $(CROSS_PROTOIZE_RPM) $(CROSS_LIBGCC_RPM): \
		Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_GCC))-$(CROSS_GCC_VERSION).src.rpm \
		| Archive/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm \
		Archive/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm \
		kernel-headers \
		$(if $(CROSS_GCC_SPEC_PATCH),Patches/$(CROSS_GCC_SPEC_PATCH)) \
		$(if $(CROSS_GCC_PATCHES),$(patsubst %,Patches/%,$(CROSS_GCC_PATCHES)))
	rpm  $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--relocate $(STM_RELOCATE)/devkit/sh4/target=$(targetprefix) $(word 1,$|) && \
	rpm  $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--relocate $(STM_RELOCATE)/devkit/sh4/target=$(targetprefix) $(word 2,$|)
	rpm  $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(CROSS_GCC_SPEC_PATCH)" ] && cd SPECS && patch -p1 $(CROSS_GCC_SPEC) < "../Patches/$(CROSS_GCC_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(CROSS_GCC_PATCHES)" ] && cp $(CROSS_GCC_PATCHES) SOURCES/ || true ) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_GCC_SPEC) 
	rpm $(DRPM) -ev $(STLINUX)-sh4-$(GLIBC_DEV) && \
	rpm $(DRPM) -ev $(STLINUX)-sh4-$(GLIBC)

if STM24
$(CROSS_GCC): $(CROSS_MPFR) $(CROSS_GCC_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	touch .deps/$(notdir $@)
else !STM24
$(CROSS_GCC): $(CROSS_GCC_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	sh4-linux-objcopy -v --redefine-sym __ic_invalidate_syscall=__ic_invalidate $(prefix)/devkit/sh4/lib/gcc/sh4-linux/$(CROSS_GCC_RAWVERSION)/libgcc.a && \
	touch .deps/$(notdir $@)
endif !STM24

$(CROSS_CPP): $(CROSS_CPP_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(CROSS_G++): $(CROSS_G++_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(DEPDIR)/min-$(CROSS_LIBGCC) $(DEPDIR)/std-$(CROSS_LIBGCC) $(DEPDIR)/max-$(CROSS_LIBGCC) \
$(DEPDIR)/$(CROSS_LIBGCC): \
$(DEPDIR)/%$(CROSS_LIBGCC): $(CROSS_LIBGCC_RPM) $(CROSS_GMP_DEV) $(CROSS_MPFR) | $(DEPDIR)/%$(GLIBC)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb  $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(CROSS_LIBGCC_RPM) && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(CROSS_PROTOIZE): $(CROSS_PROTOIZE_RPM)
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
		bootstrap-host $(CROSS_DISTRIBUTIONUTILS) cross-sh4-filesystem $(CROSS_BINUTILS) $(CROSS_BINUTILS_DEV) \
		$(CROSS_GMP) $(CROSS_MPFR) $(CROSS_CPP) $(CROSS_GCC) $(CROSS_G++)
	[ "x$*" = "x" ] && touch -r $(CROSS_G++_RPM) $@ || true

$(DEPDIR)/setup-cross-doc: \
	cross-binutils-doc cross-sh4-cpp-doc cross-sh4-gcc-doc cross-sh4-g++-doc

$(DEPDIR)/setup-cross-optional: \
	$(CROSS_PROTOIZE)

