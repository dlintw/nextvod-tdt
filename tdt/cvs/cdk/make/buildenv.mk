#######################################      #########################################

export CFLAGS
export CXXFLAGS

export DRPM
export DRPMBUILD

AUTOMAKE_OPTIONS = -Wno-portability

#######################################      #########################################

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
if ENABLE_P0207
KERNEL_DIR = @DIR_linuxp0207@
else
if ENABLE_P0209
KERNEL_DIR = @DIR_linuxp0209@
else
if ENABLE_P0210
KERNEL_DIR = @DIR_linuxp0210@
else
if ENABLE_P0211
KERNEL_DIR = @DIR_linuxp0211@
else
KERNEL_DIR = @DIR_linuxp0302@
endif
endif
endif
endif
endif
endif
endif
KERNEL_PREPARE = @PREPARE_linux24@
# endif STM24
endif !STM23
endif !STM22

#######################################      #########################################

if STM22
STLINUX := stlinux22
STM_SRC := stlinux23
STM_RELOCATE := /opt/STM/STLinux-2.2
else !STM22
if STM23
STLINUX := stlinux23
STM_SRC := $(STLINUX)
STM_RELOCATE := /opt/STM/STLinux-2.3
else !STM23
# if STM24
STLINUX := stlinux24
STM_SRC := $(STLINUX)
STM_RELOCATE := /opt/STM/STLinux-2.4
# endif STM24
endif !STM23
endif !STM22

#######################################      #########################################

if ENABLE_CCACHE
PATH := $(hostprefix)/ccache-bin:$(crossprefix)/bin:$(PATH):/usr/sbin
else
PATH := $(crossprefix)/bin:$(PATH):/usr/sbin
endif

DEPMOD = /sbin/depmod
SOCKSIFY=
CMD_CVS=$(SOCKSIFY) $(shell which cvs)
WGET=$(SOCKSIFY) wget

INSTALL_DIR=$(INSTALL) -d
INSTALL_BIN=$(INSTALL) -m 755
INSTALL_FILE=$(INSTALL) -m 644
LN_SF=$(shell which ln) -sf
CP_D=$(shell which cp) -d
CP_P=$(shell which cp) -p
CP_RD=$(shell which cp) -rd
SED=$(shell which sed)

MAKE_PATH := $(hostprefix)/bin:$(crossprefix)/bin:$(PATH)

ADAPTED_ETC_FILES =
ETC_RW_FILES =

# rpm helper-"functions":
TARGETLIB = $(targetprefix)/usr/lib
PKG_CONFIG_PATH = $(targetprefix)/usr/lib/pkgconfig
REWRITE_LIBDIR = sed -i "s,^libdir=.*,libdir='$(targetprefix)/usr/lib'," $(targetprefix)/usr/lib
REWRITE_LIBDEP = sed -i -e "s,\(^dependency_libs='\| \|-L\|^dependency_libs='\)/usr/lib,\$(targetprefix)/usr/lib," $(targetprefix)/usr/lib
REWRITE_PKGCONF = sed -i "s,^prefix=.*,prefix='$(targetprefix)/usr',"

BUILDENV := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s" \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	PKG_CONFIG_PATH="$(targetprefix)/usr/lib/pkgconfig"

MAKE_OPTS := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s" \
	ARCH=sh \
	CROSS_COMPILE=$(target)-

MAKE_ARGS := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s"

PLATFORM_CPPFLAGS := \
	$(if $(CUBEREVO),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
	$(if $(CUBEREVO_MINI),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
	$(if $(CUBEREVO_MINI2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
	$(if $(CUBEREVO_MINI_FTA),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI_FTA -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
	$(if $(CUBEREVO_250HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_250HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
	$(if $(CUBEREVO_2000HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_2000HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
	$(if $(CUBEREVO_9500HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_9500HD -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-cuberevo) \
	$(if $(UFS910),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS910 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(UFS922),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS922 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(TF7700),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_TF7700 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-tf7700) \
	$(if $(FORTIS_HDBOX),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_FORTIS_HDBOX -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(ATEVIO7500),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ATEVIO7500 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(HS7810A),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HS7810A -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(HS7110),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HS7110 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(ATEMIO520),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ATEMIO520 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(ATEMIO530),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ATEMIO530 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(HL101),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_HL101 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-hl101) \
	$(if $(VIP1_V2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP1_V2 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip1_v2) \
	$(if $(VIP2_V1),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VIP2_V1 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-vip2_v1) \
	$(if $(OCTAGON1008),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_OCTAGON1008 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(UFS912),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS912 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(UFS913),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS913 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(SPARK),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_SPARK -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(SPARK7162),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_SPARK7162 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(ADB_BOX),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ADB_BOX -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include" --enable-adb_box) \
	$(if $(IPBOX9900),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX9900 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(IPBOX99),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX99 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(IPBOX55),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_IPBOX55 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include") \
	$(if $(VITAMIN_HD5000),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_VITAMIN_HD5000 -I$(driverdir)/include -I $(buildprefix)/$(KERNEL_DIR)/include")

DEPDIR = .deps

VPATH = $(DEPDIR)

CONFIGURE_OPTS = \
	--build=$(build) \
	--host=$(target) \
	--prefix=$(targetprefix)/usr \
	--with-driver=$(driverdir) \
	--with-dvbincludes=$(driverdir)/include \
	--with-target=cdk

if ENABLE_CCACHE
CONFIGURE_OPTS += --enable-ccache 
endif

if MAINTAINER_MODE
CONFIGURE_OPTS += --enable-maintainer-mode
endif

CONFIGURE = \
	./autogen.sh && \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	CFLAGS="-Wall $(TARGET_CFLAGS)" \
	CXXFLAGS="-Wall $(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	./configure $(CONFIGURE_OPTS)

ACLOCAL_AMFLAGS = -I .

CONFIG_STATUS_DEPENDENCIES = \
	$(top_srcdir)/rules.pl \
	$(top_srcdir)/rules-install \
	$(top_srcdir)/rules-make \
	Makefile-archive

min-query std-query max-query query: \
%query:
	rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) -qa

query-%:
	@for i in sh4 noarch ${host_arch} ; do \
		FOUND=`ls RPMS/$$i | grep $*` || true && \
		( for j in $$FOUND ; do \
			echo "RPMS/$$i/$$j:" && \
			rpm $(DRPM) -qplv --scripts RPMS/$$i/$$j || true; echo;done ) || true ; done
