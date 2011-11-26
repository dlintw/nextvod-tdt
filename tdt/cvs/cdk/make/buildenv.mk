export CFLAGS
export CXXFLAGS

export DRPM
export DRPMBUILD

AUTOMAKE_OPTIONS = -Wno-portability

if ENABLE_CCACHE
PATH := $(hostprefix)/ccache-bin:$(crossprefix)/bin:$(PATH):/usr/sbin
else
PATH := $(crossprefix)/bin:$(PATH):/usr/sbin
endif

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

if STM22
STLINUX := stlinux22
STM_SRC := stlinux23
else !STM22
if STM23
STLINUX := stlinux23
STM_SRC := $(STLINUX)
else !STM23
# STM24
STLINUX := stlinux24
STM_SRC := $(STLINUX)
endif !STM23
endif !STM22

if BLEEDING_EDGE
STABLE =
else !BLEEDING_EDGE
STABLE = YES
endif !BLEEDING_EDGE
export STABLE

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
#	PKG_CONFIG_PATH="$(targetprefix)/lib/pkgconfig:$(targetprefix)/usr/lib/pkgconfig"

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

if TARGETRULESET_FLASH
CONFIGURE_OPTS += --without-debug
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
	$(top_srcdir)/rules-install $(top_srcdir)/rules-install-flash \
	$(top_srcdir)/rules-make$(if $(STABLE),,.latest) \
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
