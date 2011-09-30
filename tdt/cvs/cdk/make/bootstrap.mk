
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
else !STM23
# if STM24

KERNEL_DEPENDS = @DEPENDS_linux24@
if ENABLE_P0201
KERNEL_DIR = @DIR_linuxp0201@
else
if ENABLE_P0205
KERNEL_DIR = @DIR_linuxp0205@
else
if ENABLE_P0206
KERNEL_DIR = @DIR_linuxp0206@
else
KERNEL_DIR = @DIR_linuxp0207@
endif
endif
endif

KERNEL_PREPARE = @PREPARE_linux24@
# endif STM24
endif !STM23
endif !STM22

if STM22
STM_RELOCATE := /opt/STM/STLinux-2.2
else !STM22
if STM23
STM_RELOCATE := /opt/STM/STLinux-2.3
else !STM23
# if STM24
STM_RELOCATE := /opt/STM/STLinux-2.4
# endif STM24
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
HOST_RPMCONFIG = host-rpmconfig
if STM22
HOST_RPMCONFIG_VERSION = 2.2-10
HOST_RPMCONFIG_SPEC = stm-$(HOST_RPMCONFIG)-2.2.spec
HOST_RPMCONFIG_SPEC_PATCH = stm-$(HOST_RPMCONFIG).spec22.diff
HOST_RPMCONFIG_PATCHES = stm-$(HOST_RPMCONFIG)-compress_man-allways-true.patch \
			 stm-$(HOST_RPMCONFIG)-autoreconf-add-libtool-macros22.patch
else !STM22
if STM23
HOST_RPMCONFIG_VERSION = 2.3-16
HOST_RPMCONFIG_SPEC = stm-$(HOST_RPMCONFIG).spec
HOST_RPMCONFIG_SPEC_PATCH = stm-$(HOST_RPMCONFIG).spec23.diff
HOST_RPMCONFIG_PATCHES = stm-$(HOST_RPMCONFIG)-autoreconf-add-libtool-macros23.patch \
			 stm-$(HOST_RPMCONFIG)-config_sub-dir.patch

else !STM23
# if STM24
HOST_RPMCONFIG_VERSION = 2.4-21
HOST_RPMCONFIG_SPEC = stm-$(HOST_RPMCONFIG).spec
HOST_RPMCONFIG_SPEC_PATCH = $(HOST_RPMCONFIG_SPEC)24.diff
HOST_RPMCONFIG_PATCHES = stm-$(HOST_RPMCONFIG)-ignore-skip-cvs-errors.patch \
			 stm-$(HOST_RPMCONFIG)-autoreconf-add-libtool-macros24.patch
# endif STM24
endif !STM23
endif !STM22
HOST_RPMCONFIG_RPM = RPMS/noarch/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).noarch.rpm

$(HOST_RPMCONFIG_RPM): \
		$(if $(HOST_RPMCONFIG_SPEC_PATCH),Patches/$(HOST_RPMCONFIG_SPEC_PATCH)) \
		$(if $(HOST_RPMCONFIG_PATCHES),$(HOST_RPMCONFIG_PATCHES:%=Patches/%)) \
 		Archive/$(STLINUX)-$(HOST_RPMCONFIG)-$(HOST_RPMCONFIG_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_RPMCONFIG_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_RPMCONFIG_SPEC) < ../Patches/$(HOST_RPMCONFIG_SPEC_PATCH) ) &&) \
	$(if $(HOST_RPMCONFIG_PATCHES),cp $(HOST_RPMCONFIG_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_RPMCONFIG_SPEC)

$(HOST_RPMCONFIG): $(HOST_RPMCONFIG_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(STM_RELOCATE)=$(prefix) $< && \
	touch .deps/$(notdir $@)

#
# HOST-BASE-PASSWD
#
HOST_BASE_PASSWD = host-base-passwd
if STM22
HOST_BASE_PASSWD_VERSION = 3.5.9-3
HOST_BASE_PASSWD_SPEC = stm-$(HOST_BASE_PASSWD).spec
HOST_BASE_PASSWD_SPEC_PATCH = $(HOST_BASE_PASSWD_SPEC)22.diff
HOST_BASE_PASSWD_PATCHES =
else !STM22
if STM23
HOST_BASE_PASSWD_VERSION = 3.5.9-6
HOST_BASE_PASSWD_SPEC = stm-$(HOST_BASE_PASSWD).spec
HOST_BASE_PASSWD_SPEC_PATCH =
HOST_BASE_PASSWD_PATCHES =
else !STM23
# if STM24
HOST_BASE_PASSWD_VERSION = 3.5.9-7
HOST_BASE_PASSWD_SPEC = stm-$(HOST_BASE_PASSWD).spec
HOST_BASE_PASSWD_SPEC_PATCH =
HOST_BASE_PASSWD_PATCHES =
# endif STM24
endif !STM23
endif !STM22
HOST_BASE_PASSWD_RPM = RPMS/sh4/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).sh4.rpm

$(HOST_BASE_PASSWD_RPM): \
		$(if $(HOST_BASE_PASSWD_SPEC_PATCH),Patches/$(HOST_BASE_PASSWD_SPEC_PATCH)) \
		$(if $(HOST_BASE_PASSWD_PATCHES),$(HOST_BASE_PASSWD_PATCHES:%=Patches/%)) \
		Archive/$(STLINUX)-$(HOST_BASE_PASSWD)-$(HOST_BASE_PASSWD_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_BASE_PASSWD_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_BASE_PASSWD_SPEC) < ../Patches/$(HOST_BASE_PASSWD_SPEC_PATCH) ) &&) \
	$(if $(HOST_BASE_PASSWD_PATCHES),cp $(HOST_BASE_PASSWD_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_BASE_PASSWD_SPEC)

$(HOST_BASE_PASSWD): $(HOST_BASE_PASSWD_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#
# HOST-DISTRIBUTIONUTILS
#
HOST_DISTRIBUTIONUTILS = host-distributionutils
if STM22
HOST_DISTRIBUTIONUTILS_VERSION = 2.8.4-4
HOST_DISTRIBUTIONUTILS_SPEC = stm-$(HOST_DISTRIBUTIONUTILS).spec
HOST_DISTRIBUTIONUTILS_SPEC_PATCH =
HOST_DISTRIBUTIONUTILS_PATCHES =
else !STM22
if STM23
HOST_DISTRIBUTIONUTILS_VERSION = 2.8.4-4
HOST_DISTRIBUTIONUTILS_SPEC = stm-$(HOST_DISTRIBUTIONUTILS).spec
HOST_DISTRIBUTIONUTILS_SPEC_PATCH =
HOST_DISTRIBUTIONUTILS_PATCHES =
else !STM23
# if STM24
HOST_DISTRIBUTIONUTILS_VERSION = 2.8.4-5
HOST_DISTRIBUTIONUTILS_SPEC = stm-$(HOST_DISTRIBUTIONUTILS).spec
HOST_DISTRIBUTIONUTILS_SPEC_PATCH =
HOST_DISTRIBUTIONUTILS_PATCHES =
# endif STM24
endif !STM23
endif !STM22
HOST_DISTRIBUTIONUTILS_RPM = RPMS/$(host_arch)/$(STLINUX)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).$(host_arch).rpm

$(HOST_DISTRIBUTIONUTILS_RPM): \
		$(if $(HOST_DISTRIBUTIONUTILS_SPEC_PATCH),Patches/$(HOST_DISTRIBUTIONUTILS_SPEC_PATCH)) \
		$(if $(HOST_DISTRIBUTIONUTILS_PATCHES),$(HOST_DISTRIBUTIONUTILS_PATCHES:%=Patches/%)) \
		Archive/$(STM_SRC)-$(HOST_DISTRIBUTIONUTILS)-$(HOST_DISTRIBUTIONUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_DISTRIBUTIONUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_DISTRIBUTIONUTILS_SPEC) < ../Patches/$(HOST_DISTRIBUTIONUTILS_SPEC_PATCH) ) &&) \
	$(if $(HOST_DISTRIBUTIONUTILS_PATCHES),cp $(HOST_DISTRIBUTIONUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_DISTRIBUTIONUTILS_SPEC)

$(HOST_DISTRIBUTIONUTILS): $(HOST_DISTRIBUTIONUTILS_RPM)
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
HOST_AUTOTOOLS = host-autotools
if STM22
HOST_AUTOTOOLS_VERSION = 2.0-8
HOST_AUTOTOOLS_SPEC = stm-$(HOST_AUTOTOOLS).spec
HOST_AUTOTOOLS_SPEC_PATCH = $(HOST_AUTOTOOLS_SPEC)22.diff
HOST_AUTOTOOLS_PATCHES =
else !STM22
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
HOST_AUTOTOOLS_VERSION = dev-20091012-2
HOST_AUTOTOOLS_SPEC = stm-$(HOST_AUTOTOOLS)-dev.spec
HOST_AUTOTOOLS_SPEC_PATCH =
HOST_AUTOTOOLS_PATCHES =
else !STM23
# if STM24
HOST_AUTOTOOLS_VERSION = dev-20091012-2
HOST_AUTOTOOLS_SPEC = stm-$(HOST_AUTOTOOLS)-dev.spec
HOST_AUTOTOOLS_SPEC_PATCH =
HOST_AUTOTOOLS_PATCHES =
# endif STM24
endif !STM23
endif !STM22
HOST_AUTOTOOLS_RPM = RPMS/sh4/$(STLINUX)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).sh4.rpm

$(HOST_AUTOTOOLS_RPM): \
		$(addprefix Patches/,$(HOST_AUTOTOOLS_SPEC_PATCH) $(HOST_AUTOTOOLS_PATCHES)) \
		Archive/$(STLINUX:%23=%24)-$(HOST_AUTOTOOLS)-$(HOST_AUTOTOOLS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_AUTOTOOLS_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_AUTOTOOLS_SPEC) < ../Patches/$(HOST_AUTOTOOLS_SPEC_PATCH) ) &&) \
	$(if $(HOST_AUTOTOOLS_PATCHES),cp $(addprefix Patches/,$(HOST_AUTOTOOLS_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_AUTOTOOLS_SPEC)

$(DEPDIR)/$(HOST_AUTOTOOLS): $(HOST_AUTOTOOLS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

#
# HOST AUTOMAKE
#
if !STM22
HOST_AUTOMAKE = host-automake
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
HOST_AUTOMAKE_VERSION = 1.11-2
HOST_AUTOMAKE_SPEC = stm-$(HOST_AUTOMAKE).spec
HOST_AUTOMAKE_SPEC_PATCH =
HOST_AUTOMAKE_PATCHES =
else !STM23
# if STM24
HOST_AUTOMAKE_VERSION = 1.11-2
HOST_AUTOMAKE_SPEC = stm-$(HOST_AUTOMAKE).spec
HOST_AUTOMAKE_SPEC_PATCH =
HOST_AUTOMAKE_PATCHES =
# endif STM24
endif !STM23
HOST_AUTOMAKE_RPM = RPMS/sh4/$(STLINUX)-$(HOST_AUTOMAKE)-$(HOST_AUTOMAKE_VERSION).sh4.rpm

$(HOST_AUTOMAKE_RPM): \
		$(addprefix Patches/,$(HOST_AUTOMAKE_SPEC_PATCH) $(HOST_AUTOMAKE_PATCHES)) \
		Archive/$(STLINUX:%23=%24)-$(HOST_AUTOMAKE)-$(HOST_AUTOMAKE_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_AUTOMAKE_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_AUTOMAKE_SPEC) < ../Patches/$(HOST_AUTOMAKE_SPEC_PATCH) ) &&) \
	$(if $(HOST_AUTOMAKE_PATCHES),cp $(addprefix Patches/,$(HOST_AUTOMAKE_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_AUTOMAKE_SPEC)

$(DEPDIR)/$(HOST_AUTOMAKE): $(HOST_AUTOMAKE_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@
endif !STM22

#
# HOST AUTOCONF
#
if !STM22
HOST_AUTOCONF = host-autoconf
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
HOST_AUTOCONF_VERSION = 2.64-4
HOST_AUTOCONF_SPEC = stm-$(HOST_AUTOCONF).spec
HOST_AUTOCONF_SPEC_PATCH =
HOST_AUTOCONF_PATCHES =
else !STM23
# if STM24
HOST_AUTOCONF_VERSION = 2.64-4
HOST_AUTOCONF_SPEC = stm-$(HOST_AUTOCONF).spec
HOST_AUTOCONF_SPEC_PATCH = stm-$(HOST_AUTOCONF).$(HOST_AUTOCONF_VERSION).spec.diff
HOST_AUTOCONF_PATCHES = stm-$(HOST_AUTOCONF).$(HOST_AUTOCONF_VERSION).diff
# endif STM24
endif !STM23
HOST_AUTOCONF_RPM = RPMS/sh4/$(STLINUX)-$(HOST_AUTOCONF)-$(HOST_AUTOCONF_VERSION).sh4.rpm

$(HOST_AUTOCONF_RPM): \
		$(addprefix Patches/,$(HOST_AUTOCONF_SPEC_PATCH) $(HOST_AUTOCONF_PATCHES)) \
		Archive/$(STLINUX:%23=%24)-$(HOST_AUTOCONF)-$(HOST_AUTOCONF_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_AUTOCONF_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_AUTOCONF_SPEC) < ../Patches/$(HOST_AUTOCONF_SPEC_PATCH) ) &&) \
	$(if $(HOST_AUTOCONF_PATCHES),cp $(addprefix Patches/,$(HOST_AUTOCONF_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_AUTOCONF_SPEC)

$(DEPDIR)/$(HOST_AUTOCONF): $(HOST_AUTOCONF_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@
endif !STM22

#
# HOST PKGCONFIG
#
if !STM22
HOST_PKGCONFIG = host-pkg-config
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
HOST_PKGCONFIG_VERSION = 0.23-2
HOST_PKGCONFIG_SPEC = stm-$(HOST_PKGCONFIG).spec
HOST_PKGCONFIG_SPEC_PATCH =
HOST_PKGCONFIG_PATCHES =
else !STM23
# if STM24
HOST_PKGCONFIG_VERSION = 0.23-2
HOST_PKGCONFIG_SPEC = stm-$(HOST_PKGCONFIG).spec
HOST_PKGCONFIG_SPEC_PATCH =
HOST_PKGCONFIG_PATCHES =
# endif STM24
endif !STM23
HOST_PKGCONFIG_RPM = RPMS/sh4/$(STLINUX)-$(HOST_PKGCONFIG)-$(HOST_PKGCONFIG_VERSION).sh4.rpm

$(HOST_PKGCONFIG_RPM): \
		$(addprefix Patches/,$(HOST_PKGCONFIG_SPEC_PATCH) $(HOST_PKGCONFIG_PATCHES)) \
		Archive/$(STLINUX:%23=%24)-$(HOST_PKGCONFIG)-$(HOST_PKGCONFIG_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_PKGCONFIG_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_PKGCONFIG_SPEC) < ../Patches/$(HOST_PKGCONFIG_SPEC_PATCH) ) &&) \
	$(if $(HOST_PKGCONFIG_PATCHES),cp $(addprefix Patches/,$(HOST_PKGCONFIG_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_PKGCONFIG_SPEC)

$(DEPDIR)/$(HOST_PKGCONFIG): $(HOST_PKGCONFIG_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@
endif !STM22

if STM22
else !STM22
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
endif !STM22

#
# HOST-MTD-UTILS
#
HOST_MTD_UTILS = host-mtd-utils
if STM22
HOST_MTD_UTILS_VERSION = 1.0.1-8
HOST_MTD_UTILS_SPEC = stm-$(HOST_MTD_UTILS).spec
HOST_MTD_UTILS_SPEC_PATCH =
HOST_MTD_UTILS_PATCHES =
else !STM22
if STM23
HOST_MTD_UTILS_VERSION = 1.0.1-8
HOST_MTD_UTILS_SPEC = stm-$(HOST_MTD_UTILS).spec
HOST_MTD_UTILS_SPEC_PATCH =
HOST_MTD_UTILS_PATCHES =
else !STM23
# if STM24
HOST_MTD_UTILS_VERSION = 1.0.1-8
HOST_MTD_UTILS_SPEC = stm-$(HOST_MTD_UTILS).spec
HOST_MTD_UTILS_SPEC_PATCH =
HOST_MTD_UTILS_PATCHES =
# endif STM24
endif !STM23
endif !STM22
HOST_MTD_UTILS_RPM = RPMS/sh4/$(STLINUX)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).sh4.rpm


# Workaround for stm24, where is the host-lzo package available?
if STM24
$(HOST_MTD_UTILS_RPM): \
		$(if $(HOST_MTD_UTILS_SPEC_PATCH),Patches/$(HOST_MTD_UTILS_SPEC_PATCH)) \
		$(if $(HOST_MTD_UTILS_PATCHES),$(HOST_MTD_UTILS_PATCHES:%=Patches/%)) \
		Archive/stlinux23-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_MTD_UTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_MTD_UTILS_SPEC) < ../Patches/$(HOST_MTD_UTILS_SPEC_PATCH) ) &&) \
	$(if $(HOST_MTD_UTILS_PATCHES),cp $(HOST_MTD_UTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_MTD_UTILS_SPEC)
else !STM24
$(HOST_MTD_UTILS_RPM): \
		$(if $(HOST_MTD_UTILS_SPEC_PATCH),Patches/$(HOST_MTD_UTILS_SPEC_PATCH)) \
		$(if $(HOST_MTD_UTILS_PATCHES),$(HOST_MTD_UTILS_PATCHES:%=Patches/%)) \
		Archive/$(STM_SRC)-$(HOST_MTD_UTILS)-$(HOST_MTD_UTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_MTD_UTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_MTD_UTILS_SPEC) < ../Patches/$(HOST_MTD_UTILS_SPEC_PATCH) ) &&) \
	$(if $(HOST_MTD_UTILS_PATCHES),cp $(HOST_MTD_UTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_MTD_UTILS_SPEC)
endif !STM24

$(HOST_MTD_UTILS): $(HOST_MTD_UTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#
# BOOTSTRAP-HOST
#
$(DEPDIR)/bootstrap-host: | \
		$(CCACHE_BIN) host-rpmconfig host-base-passwd host-distributionutils \
		host-filesystem host-autotools $(HOST_AUTOMAKE) $(HOST_AUTOCONF) $(HOST_PKGCONFIG) \
		$(HOST_MTD_UTILS)
	$(if $(HOST_MTD_UTILS_RPM),[ "x$*" = "x" ] && touch -r $(HOST_MTD_UTILS_RPM) $@ || true)

#
# BOOTSTRAP-CROSS
#

#
# CROSS_FILESYSTEM
#
CROSS_FILESYSTEM = cross-sh4-filesystem

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
CROSS_DISTRIBUTIONUTILS = cross-sh4-distributionutils
if STM22
CROSS_DISTRIBUTIONUTILS_VERSION = 1.14-3
CROSS_DISTRIBUTIONUTILS_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec
CROSS_DISTRIBUTIONUTILS_SPEC_PATCH = $(CROSS_DISTRIBUTIONUTILS_SPEC)22.diff
CROSS_DISTRIBUTIONUTILS_PATCHES = hardhatutils-srcdir.diff
else !STM22
if STM23
CROSS_DISTRIBUTIONUTILS_VERSION = 1.14-5
CROSS_DISTRIBUTIONUTILS_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec
CROSS_DISTRIBUTIONUTILS_SPEC_PATCH =
CROSS_DISTRIBUTIONUTILS_PATCHES =
else !STM23
# if STM24
CROSS_DISTRIBUTIONUTILS_VERSION = 1.14-6
CROSS_DISTRIBUTIONUTILS_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS)).spec
CROSS_DISTRIBUTIONUTILS_SPEC_PATCH =
CROSS_DISTRIBUTIONUTILS_PATCHES =
# endif STM24
endif !STM23
endif !STM22
CROSS_DISTRIBUTIONUTILS_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_DISTRIBUTIONUTILS)-$(CROSS_DISTRIBUTIONUTILS_VERSION).$(host_arch).rpm

$(CROSS_DISTRIBUTIONUTILS_RPM): \
		$(if $(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH),Patches/$(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH)) \
		$(if $(CROSS_DISTRIBUTIONUTILS_PATCHES),$(CROSS_DISTRIBUTIONUTILS_PATCHES:%=Patches/%)) \
		Archive/$(STLINUX)-$(subst cross-sh4,cross,$(CROSS_DISTRIBUTIONUTILS))-$(CROSS_DISTRIBUTIONUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_DISTRIBUTIONUTILS_SPEC) < ../Patches/$(CROSS_DISTRIBUTIONUTILS_SPEC_PATCH) ) &&) \
	$(if $(CROSS_DISTRIBUTIONUTILS_PATCHES),cp $(CROSS_DISTRIBUTIONUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_DISTRIBUTIONUTILS_SPEC)

if STM22
$(CROSS_DISTRIBUTIONUTILS): $(CROSS_DISTRIBUTIONUTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	$(LN_SF) $(hostprefix)/bin/target-initdconfig $(crossprefix)/bin/target-initdconfig
	touch .deps/$(notdir $@)
else
$(CROSS_DISTRIBUTIONUTILS): $(CROSS_DISTRIBUTIONUTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)
endif

#
# CROSS BINUTILS
#
CROSS_BINUTILS = cross-sh4-binutils
CROSS_BINUTILS_DEV = cross-sh4-binutils-dev
if STM22
CROSS_BINUTILS_VERSION = 2.17.50.0.4-13
CROSS_BINUTILS_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS))-sh4processed.spec
CROSS_BINUTILS_SPEC_PATCH = $(CROSS_BINUTILS_SPEC)22.diff
CROSS_BINUTILS_PATCHES = cross-binutils.diff
else !STM22
if STM23
CROSS_BINUTILS_VERSION = $(if $(STABLE),2.18.50.0.8-34,2.18.50.0.8-38)
CROSS_BINUTILS_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec
CROSS_BINUTILS_SPEC_PATCH = $(CROSS_BINUTILS_SPEC)23.diff
CROSS_BINUTILS_PATCHES = cross-binutils.diff
else !STM23
# if STM24
CROSS_BINUTILS_VERSION = 2.19.1-41
CROSS_BINUTILS_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_BINUTILS)).spec
CROSS_BINUTILS_SPEC_PATCH =
CROSS_BINUTILS_PATCHES =
# endif STM24
endif !STM23
endif !STM22
CROSS_BINUTILS_RPM = RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm
CROSS_BINUTILS_DEV_RPM = RPMS/${host_arch}/$(STLINUX)-$(CROSS_BINUTILS_DEV)-$(CROSS_BINUTILS_VERSION).${host_arch}.rpm

$(CROSS_BINUTILS_RPM) $(CROSS_BINUTILS_DEV_RPM) : \
		$(if $(CROSS_BINUTILS_SPEC_PATCH),Patches/$(CROSS_BINUTILS_SPEC_PATCH)) \
		$(if $(CROSS_BINUTILS_PATCHES),$(CROSS_BINUTILS_PATCHES:%=Patches/%)) \
		Archive/$(STLINUX)-$(subst cross-sh4-,cross-,$(CROSS_BINUTILS))-$(CROSS_BINUTILS_VERSION).src.rpm
	rpm  $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_BINUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_BINUTILS_SPEC) < ../Patches/$(CROSS_BINUTILS_SPEC_PATCH) ) &&) \
	$(if $(CROSS_BINUTILS_PATCHES),cp $(CROSS_BINUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_BINUTILS_SPEC)

$(CROSS_BINUTILS): $(CROSS_BINUTILS_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(CROSS_BINUTILS_DEV): $(CROSS_BINUTILS_DEV_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps --noscripts -Uhv $< && \
	touch .deps/$(notdir $@)

#
# CROSS GMP
#
if !STM22
if STM23
CROSS_GMP = cross-sh4-gmp
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
CROSS_GMP_VERSION = 4.3.2-6
CROSS_GMP_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_GMP)).spec
CROSS_GMP_SPEC_PATCH =
CROSS_GMP_PATCHES =
CROSS_GMP_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_GMP)-$(CROSS_GMP_VERSION).$(host_arch).rpm
else !STM23
# if STM24
CROSS_GMP = cross-sh4-gmp
CROSS_GMP_VERSION = 5.0.1-9
CROSS_GMP_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_GMP)).spec
CROSS_GMP_SPEC_PATCH = $(CROSS_GMP_SPEC).$(CROSS_GMP_VERSION).diff
CROSS_GMP_PATCHES =
CROSS_GMP_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_GMP)-$(CROSS_GMP_VERSION).$(host_arch).rpm
# endif STM24
endif !STM23

$(CROSS_GMP_RPM): \
		$(addprefix Patches/,$(CROSS_GMP_SPEC_PATCH) $(CROSS_GMP_PATCHES)) \
		Archive/$(STLINUX:%23=%24)-$(subst cross-sh4-,cross-,$(CROSS_GMP))-$(CROSS_GMP_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_GMP_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_GMP_SPEC) < ../Patches/$(CROSS_GMP_SPEC_PATCH) ) &&) \
	$(if $(CROSS_GMP_PATCHES),cp $(addprefix Patches/,$(CROSS_GMP_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --target=sh4-linux SPECS/$(CROSS_GMP_SPEC)

$(DEPDIR)/$(CROSS_GMP): $(CROSS_GMP_RPM)
	@rpm $(DRPM) --nodeps -Uhv $(lastword $^) && \
	touch $@
endif !STM22

#
# CROSS MPFR
#
if !STM22
CROSS_MPFR = cross-sh4-mpfr
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
CROSS_MPFR_VERSION = 2.4.2-6
CROSS_MPFR_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_MPFR)).spec
CROSS_MPFR_SPEC_PATCH = $(CROSS_MPFR_SPEC)24.diff
CROSS_MPFR_PATCHES =
else !STM23
# if STM24
CROSS_MPFR_VERSION = 2.4.2-6
CROSS_MPFR_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_MPFR)).spec
CROSS_MPFR_SPEC_PATCH = $(CROSS_MPFR_SPEC)24.diff
CROSS_MPFR_PATCHES =
# endif STM24
endif !STM23
CROSS_MPFR_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_MPFR)-$(CROSS_MPFR_VERSION).$(host_arch).rpm

$(CROSS_MPFR_RPM): \
		$(CROSS_GMP_RPM) \
		$(addprefix Patches/,$(CROSS_MPFR_SPEC_PATCH) $(CROSS_MPFR_PATCHES)) \
		Archive/$(STLINUX:%23=%24)-$(subst cross-sh4-,cross-,$(CROSS_MPFR))-$(CROSS_MPFR_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_MPFR_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_MPFR_SPEC) < ../Patches/$(CROSS_MPFR_SPEC_PATCH) ) &&) \
	$(if $(CROSS_MPFR_PATCHES),cp $(addprefix Patches/,$(CROSS_MPFR_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_MPFR_SPEC)

$(DEPDIR)/$(CROSS_MPFR): $(CROSS_GMP) $(CROSS_MPFR_RPM)
	@rpm $(DRPM) --nodeps -Uhv $(lastword $^) && \
	touch $@
endif !STM22

#
# CROSS MPC
#
if STM24
CROSS_MPC = cross-sh4-mpc
CROSS_MPC_VERSION = 0.8.2-3
CROSS_MPC_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_MPC)).spec
CROSS_MPC_SPEC_PATCH =
CROSS_MPC_PATCHES =
CROSS_MPC_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_MPC)-$(CROSS_MPC_VERSION).$(host_arch).rpm


$(CROSS_MPC_RPM): \
		$(addprefix Patches/,$(CROSS_MPC_SPEC_PATCH) $(CROSS_MPC_PATCHES)) \
		Archive/$(STLINUX:%23=%24)-$(subst cross-sh4-,cross-,$(CROSS_MPC))-$(CROSS_MPC_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_MPC_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_MPC_SPEC) < ../Patches/$(CROSS_MPC_SPEC_PATCH) ) &&) \
	$(if $(CROSS_MPC_PATCHES),cp $(addprefix Patches/,$(CROSS_MPC_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --target=sh4-linux SPECS/$(CROSS_MPC_SPEC)

$(DEPDIR)/$(CROSS_MPC): $(CROSS_MPC_RPM)
	@rpm $(DRPM) --nodeps -Uhv $(lastword $^) && \
	touch $@
endif STM24

#
# CROSS LIBELF
#
if STM24
CROSS_LIBELF = cross-sh4-libelf
CROSS_LIBELF_VERSION = 0.8.13-1
CROSS_LIBELF_SPEC = stm-$(subst cross-sh4,cross,$(CROSS_LIBELF)).spec
CROSS_LIBELF_SPEC_PATCH =
CROSS_LIBELF_PATCHES =
CROSS_LIBELF_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_LIBELF)-$(CROSS_LIBELF_VERSION).$(host_arch).rpm


$(CROSS_LIBELF_RPM): \
		$(addprefix Patches/,$(CROSS_LIBELF_SPEC_PATCH) $(CROSS_LIBELF_PATCHES)) \
		Archive/$(STLINUX:%23=%24)-$(subst cross-sh4-,cross-,$(CROSS_LIBELF))-$(CROSS_LIBELF_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_LIBELF_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_LIBELF_SPEC) < ../Patches/$(CROSS_LIBELF_SPEC_PATCH) ) &&) \
	$(if $(CROSS_LIBELF_PATCHES),cp $(addprefix Patches/,$(CROSS_LIBELF_PATCHES)) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --target=sh4-linux SPECS/$(CROSS_LIBELF_SPEC)

$(DEPDIR)/$(CROSS_LIBELF): $(CROSS_LIBELF_RPM)
	@rpm $(DRPM) --nodeps -Uhv $(lastword $^) && \
	touch $@
endif STM24

#
# CROSS GCC
#
CROSS_GCC		= cross-sh4-gcc
CROSS_CPP		= cross-sh4-cpp
CROSS_G++		= cross-sh4-g++
CROSS_PROTOIZE		= cross-sh4-protoize
CROSS_LIBGCC		= cross-sh4-libgcc
if STM22
CROSS_GCC_VERSION = 4.1.1-23
CROSS_GCC_RAWVERSION = $(firstword $(subst -, ,$(CROSS_GCC_VERSION)))
CROSS_GCC_SPEC = stm-$(subst cross-sh4-,cross-,$(CROSS_GCC))-sh4processed.spec
CROSS_GCC_SPEC_PATCH = $(CROSS_GCC_SPEC)22.diff
CROSS_GCC_PATCHES =
CROSS_GCC_KERNELHEADERS = kernel-headers
CROSS_GCC_INVALIDATE = YES
else !STM22
if STM23
# Due to libtool errors of target-gcc, the stm24 version is used instead of stm23
CROSS_GCC_VERSION = 4.3.4-63
CROSS_GCC_RAWVERSION = $(firstword $(subst -, ,$(CROSS_GCC_VERSION)))
CROSS_GCC_SPEC = stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec
CROSS_GCC_SPEC_PATCH = $(CROSS_GCC_SPEC)23.diff
CROSS_GCC_PATCHES =
CROSS_GCC_KERNELHEADERS = linux-kernel-headers
CROSS_GCC_INVALIDATE =
else !STM23
# if STM24
CROSS_GCC_VERSION = 4.5.2-78
CROSS_GCC_RAWVERSION = $(firstword $(subst -, ,$(CROSS_GCC_VERSION)))
CROSS_GCC_SPEC = stm-$(subst cross-sh4-,cross-,$(CROSS_GCC)).spec
CROSS_GCC_SPEC_PATCH = $(CROSS_GCC_SPEC).$(CROSS_GCC_VERSION).diff
CROSS_GCC_PATCHES =
CROSS_GCC_KERNELHEADERS = linux-kernel-headers
CROSS_GCC_INVALIDATE =
# endif STM24
endif !STM23
endif !STM22
CROSS_GCC_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_GCC)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_CPP_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_CPP)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_G++_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_G++)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_PROTOIZE_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_PROTOIZE)-$(CROSS_GCC_VERSION).$(host_arch).rpm
CROSS_LIBGCC_RPM = RPMS/$(host_arch)/$(STLINUX)-$(CROSS_LIBGCC)-$(CROSS_GCC_VERSION).$(host_arch).rpm

$(CROSS_GCC_RPM) $(CROSS_CPP_RPM) $(CROSS_G++_RPM) $(CROSS_PROTOIZE_RPM) $(CROSS_LIBGCC_RPM): \
		$(if $(CROSS_GCC_SPEC_PATCH),Patches/$(CROSS_GCC_SPEC_PATCH)) \
		$(if $(CROSS_GCC_PATCHES),$(CROSS_GCC_PATCHES:%=Patches/%)) \
		Archive/$(STLINUX:%23=%24)-$(subst cross-sh4-,cross-,$(CROSS_GCC))-$(CROSS_GCC_VERSION).src.rpm \
		| Archive/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm \
		Archive/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm \
		$(if $(CROSS_MPFR),$(CROSS_MPFR)) \
		$(if $(CROSS_MPC),$(CROSS_MPC)) \
		$(if $(CROSS_LIBELF),$(CROSS_LIBELF)) \
		$(if $(KERNELHEADERS),$(KERNELHEADERS)) \
		kernel-headers
	rpm $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(STM_RELOCATE)/devkit/sh4/target=$(targetprefix) $(word 1,$|) && \
	rpm $(DRPM) --nosignature --ignorearch --nodeps --force -Uhv \
		--badreloc --relocate $(STM_RELOCATE)/devkit/sh4/target=$(targetprefix) $(word 2,$|)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(CROSS_GCC_SPEC_PATCH),( cd SPECS && patch -p1 $(CROSS_GCC_SPEC) < ../Patches/$(CROSS_GCC_SPEC_PATCH) ) &&) \
	$(if $(CROSS_GCC_PATCHES),cp $(CROSS_GCC_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild  $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(CROSS_GCC_SPEC)
	rpm $(DRPM) --nodeps -ev $(STLINUX)-sh4-$(GLIBC_DEV) && \
	rpm $(DRPM) --nodeps -ev $(STLINUX)-sh4-$(GLIBC)

$(CROSS_GCC): $(CROSS_GCC_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	$(if $(CROSS_GCC_INVALIDATE),sh4-linux-objcopy -v --redefine-sym __ic_invalidate_syscall=__ic_invalidate $(prefix)/devkit/sh4/lib/gcc/sh4-linux/$(CROSS_GCC_RAWVERSION)/libgcc.a &&) \
	touch .deps/$(notdir $@)

$(CROSS_CPP): $(CROSS_CPP_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(CROSS_G++): $(CROSS_G++_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

$(DEPDIR)/min-$(CROSS_LIBGCC) $(DEPDIR)/std-$(CROSS_LIBGCC) $(DEPDIR)/max-$(CROSS_LIBGCC) \
$(DEPDIR)/$(CROSS_LIBGCC): \
$(DEPDIR)/%$(CROSS_LIBGCC): $(CROSS_LIBGCC_RPM) | $(DEPDIR)/%$(GLIBC)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb  $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(CROSS_PROTOIZE): $(CROSS_PROTOIZE_RPM)
	@rpm  $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)

#flash-cross-sh4-libgcc: $(flashprefix)/root/lib/libgcc_s-$(CROSS_GCC_RAWVERSION).so.1
#
#$(flashprefix)/root/lib/libgcc_s-$(CROSS_GCC_RAWVERSION).so.1: $(CROSS_LIBGCC_RPM)
#	@rpm --dbpath $(flashprefix)-rpmdb  $(DRPM) --ignorearch --nodeps  -Uhv \
#		--replacepkgs --badreloc --relocate $(targetprefix)=$(flashprefix)/root $<
#	touch $@
#	@FLASHROOTDIR_MODIFIED@

#
# BOOTSTRAP-CROSS
#
$(DEPDIR)/bootstrap-cross: | \
		bootstrap-host cross-sh4-distributionutils cross-sh4-filesystem cross-sh4-binutils cross-sh4-binutils-dev \
		cross-sh4-cpp cross-sh4-gcc cross-sh4-g++ cross-sh4-libgcc
	[ "x$*" = "x" ] && touch -r $(CROSS_G++_RPM) $@ || true

$(DEPDIR)/setup-cross-doc: \
	cross-binutils-doc cross-sh4-cpp-doc cross-sh4-gcc-doc cross-sh4-g++-doc

$(DEPDIR)/setup-cross-optional: \
	cross-sh4-protoize

#
# LIBTOOL
#
$(DEPDIR)/libtool.do_prepare: @DEPENDS_libtool@
	@PREPARE_libtool@
	touch $@

$(DEPDIR)/libtool.do_compile: $(DEPDIR)/libtool.do_prepare
	cd @DIR_libtool@ && \
	./configure --prefix=$(hostprefix) && \
	$(MAKE)
	touch $@

$(DEPDIR)/libtool: $(DEPDIR)/libtool.do_compile
	cd @DIR_libtool@ && \
	@INSTALL_libtool@
	touch $@

